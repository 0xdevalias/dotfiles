# Generate SSH keyfiles

* **Command:** `ssh-keygen -t rsa -b 4096 -f servername_user_rsa`
* Enter passphrase (recommended)
* Confirm passphrase
* **NB:** Ensure permissions set correctly: `chmod 600 filename`

# Add public key to server

* Copy the public key
  * Eg. (OSX) `cat ~/.ssh/my_key_rsa.pub|pbcopy`
* SSH/connect to your server.
* Edit ~/.ssh/authorized_keys2
  * Eg. `vi ~/.ssh/authorized_keys2`
* Paste the contents of the public key into the file

# Create easy SSH aliases

* **File:** ~/.ssh/config
* **Purpose:** Add 'easy names' for each host

```
Host easy-name
Hostname full.server.name.net
User my-username
IdentityFile ~/.ssh/my_private_key_rsa
ForwardAgent yes
```