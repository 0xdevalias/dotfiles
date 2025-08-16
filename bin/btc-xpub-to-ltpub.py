#!/usr/bin/env python3
import sys
import hashlib

# Ref: https://chatgpt.com/c/68233e6e-eb5c-8008-b992-f05e4414e975
#   An xpub (Extended Public Key for Bitcoin mainnet) and an ltpub (Litecoin's equivalent for extended public keys) are functionally the same format, but with different version bytes to indicate the network and coin.
#
#   To convert an xpub to an ltpub, you only need to:
#     Change the version bytes
#       Bitcoin mainnet xpub version: 0x0488B21E
#       Litecoin mainnet ltpub version: 0x019da462
#
#   Steps to convert xpub → ltpub
#     Base58Check-decode the xpub to get the raw bytes.
#     Replace the first 4 bytes (version) with 0x019da462.
#     Base58Check-encode it again to get the ltpub.

# Base58 alphabet used in Bitcoin
BASE58_ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

def show_help():
    script_name = sys.argv[0].split('/')[-1]
    print(f"Usage: {script_name} [XPUB]...")
    print("")
    print("Converts one or more Bitcoin xpub keys to Litecoin-compatible ltpub format.")
    print("")
    print("Reads from arguments or stdin.")
    print("")
    print("Example:")
    print(f"  echo xpub6CUGRUonZSQ... | {script_name}")
    print("")
    print("See Also:")
    print("  https://github.com/satoshilabs/slips/blob/master/slip-0132.md")
    print("  https://learnmeabitcoin.com/technical/base58/")
    print("")

def base58_decode(s):
    num = 0
    for char in s:
        num *= 58
        num += BASE58_ALPHABET.index(char)
    return num.to_bytes((num.bit_length() + 7) // 8, 'big')

def base58check_decode(s):
    decoded = base58_decode(s)
    payload, checksum = decoded[:-4], decoded[-4:]
    computed = hashlib.sha256(hashlib.sha256(payload).digest()).digest()[:4]
    if checksum != computed:
        raise ValueError("Invalid base58check checksum")
    return payload

def base58check_encode(payload):
    checksum = hashlib.sha256(hashlib.sha256(payload).digest()).digest()[:4]
    data = payload + checksum
    num = int.from_bytes(data, 'big')

    chars = []
    while num > 0:
        num, rem = divmod(num, 58)
        chars.append(BASE58_ALPHABET[rem])

    pad = 0
    for byte in data:
        if byte == 0:
            pad += 1
        else:
            break

    return '1' * pad + ''.join(reversed(chars))

def convert_xpub_to_ltpub(xpub):
    payload = base58check_decode(xpub)

    found_prefix = payload[:4].hex()
    if found_prefix.lower() != '0488b21e':
        raise ValueError(f"Unexpected prefix '{found_prefix}'. Not a Bitcoin mainnet xpub (expected prefix 0488b21e)")

    ltpub_prefix = bytes.fromhex('019da462')  # Litecoin mainnet prefix
    new_payload = ltpub_prefix + payload[4:]
    return base58check_encode(new_payload)

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] in ('-h', '--help'):
        show_help()
        sys.exit(0)

    xpubs = sys.argv[1:] if len(sys.argv) > 1 else [line.strip() for line in sys.stdin if line.strip()]

    for xpub in xpubs:
        xpub_short = f"{xpub[:4]}...{xpub[-4:]}"
        try:
            ltpub = convert_xpub_to_ltpub(xpub)
            print(f"xpub ID:   {xpub_short}")
            print(f"ltpub:     {ltpub}")
            print("")
        except Exception as e:
            print(f"Error processing {xpub_short}: {e}", file=sys.stderr)
