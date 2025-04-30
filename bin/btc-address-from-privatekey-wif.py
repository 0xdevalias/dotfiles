#!/usr/bin/env python3
import sys
import hashlib

# Base58 alphabet used in Bitcoin
BASE58_ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

def show_help():
    script_name = sys.argv[0].split('/')[-1]
    print(f"Usage: {script_name} [WIF_KEY [CREATED_AT]]...")
    print("")
    print("Reads one or more WIF private keys (from args or stdin), and outputs:")
    print("- Compressed public key")
    print("- Corresponding Bitcoin address")
    print("- Truncated WIF preview for safe identification")
    print("")
    print("Example:")
    print(f"  pbpaste | {script_name}")
    print("")
    print("See Also:")
    print("  https://learnmeabitcoin.com/technical/keys/private-key/wif/")
    print("  https://learnmeabitcoin.com/technical/keys/address/#p2pkh")
    print("  https://learnmeabitcoin.com/technical/keys/base58/#base58check")
    print("  https://learnmeabitcoin.com/technical/script/p2pkh/")

def base58_decode(s):
    num = 0
    for char in s:
        num *= 58
        num += BASE58_ALPHABET.index(char)
    combined = num.to_bytes(38, byteorder='big')
    return combined

def base58check_decode(s):
    decoded = base58_decode(s)
    payload, checksum = decoded[:-4], decoded[-4:]
    computed_checksum = hashlib.sha256(hashlib.sha256(payload).digest()).digest()[:4]
    if checksum != computed_checksum:
        raise ValueError('Invalid WIF checksum')
    return payload

def wif_to_private_key(wif):
    payload = base58check_decode(wif)
    if payload[0] != 0x80:
        raise ValueError('Not a Bitcoin mainnet WIF private key')
    if len(payload) == 34 and payload[-1] == 0x01:
        # Compressed WIF
        return payload[1:-1], True
    elif len(payload) == 33:
        # Uncompressed WIF
        return payload[1:], False
    else:
        raise ValueError('Invalid WIF length')

def private_to_public_key(privkey_bytes, compressed):
    from ecdsa import SigningKey, SECP256k1
    sk = SigningKey.from_string(privkey_bytes, curve=SECP256k1)
    vk = sk.verifying_key
    if compressed:
        x = vk.pubkey.point.x()
        prefix = b'\x02' if vk.pubkey.point.y() % 2 == 0 else b'\x03'
        return prefix + x.to_bytes(32, 'big')
    else:
        return b'\x04' + vk.to_string()

def public_key_to_p2pkh_address(public_key_bytes):
    sha256 = hashlib.sha256(public_key_bytes).digest()
    ripemd160 = hashlib.new('ripemd160', sha256).digest()
    payload = b'\x00' + ripemd160  # 0x00 for mainnet
    checksum = hashlib.sha256(hashlib.sha256(payload).digest()).digest()[:4]
    address_bytes = payload + checksum
    return base58_encode_bitcoin_address(address_bytes)

def base58_encode_bitcoin_address(b):
    n = int.from_bytes(b, 'big')
    chars = []
    while n > 0:
        n, rem = divmod(n, 58)
        chars.append(BASE58_ALPHABET[rem])
    pad = 0
    for byte in b:
        if byte == 0:
            pad += 1
        else:
            break
    return '1' * pad + ''.join(reversed(chars))

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] in ('-h', '--help'):
        show_help()
        sys.exit(0)

    for line in sys.stdin:
        if not line.strip():
            continue

        parts = line.strip().split()

        wif = parts[0]
        wif_short = f"{wif[:4]}...{wif[-4:]}"  # first 4 chars and last 4 chars

        created_at = parts[1] if len(parts) > 1 else None

        try:
            privkey_bytes, compressed = wif_to_private_key(wif)
            public_key_bytes = private_to_public_key(privkey_bytes, compressed)
            address_p2pkh = public_key_to_p2pkh_address(public_key_bytes)

            print(f"WIF ID:          {wif_short}")
            print(f"Public Key:      {public_key_bytes.hex()}")
            print(f"Address (P2PKH): {address_p2pkh}")
            if created_at:
                print(f"Created At: {created_at}")
            print("")
        except Exception as e:
            print(f"Error processing {wif_short}: {e}", file=sys.stderr)
