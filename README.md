# Dotfiles init with Chezmoi
```
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply $GITHUB_USERNAME
```

# OpenPGP

## Export

### Export PUBLIC keys

    gpg --armor --export > pgp-public-keys.asc

### Export PRIVATE keys

    gpg --armor --export-secret-keys > pgp-private-keys.asc

### Export PRIVATE SUB keys

    gpg --armor --export-secret-subkeys > pgp-private-subkeys.asc

### Export TRUST

    gpg --export-ownertrust > pgp-ownertrust.asc

### Create revocation token

    gpg --armor --gen-revoke $KEYID > pgp-revocation.asc

#### Upload public key to server

    gpg --keyserver keys.openpgp.org --send-keys $KEYID
    gpg --export your_address@example.net | curl -T - https://keys.openpgp.org 

## Import

### Import PUBLIC keys

    gpg --import pgp-public-keys.asc

### Import PRIVATE keys

    gpg --import pgp-private-keys.asc

### Import TRUST

    gpg --import-ownertrust pgp-ownertrust.asc

## Reset YubiKey using GPG 

To check the PIN/Admin PIN reset status, enter the GPG command: `gpg --card-status`
Run `gpg-connect-agent --hex`
If PIN retry counter from step 2 is greater than 0, enter the command: `scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40`
Repeat the above command until one of the following occurs:
  YubiKey 4/5 Series device reports "**D[0000]  69 83**"

If Admin PIN retry counter is greater than 0, enter the GPG command: `scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40`
Repeat the above command until one of the following occurs:
  YubiKey 4/5 Series device reports "**D[0000]  69 83**"

To terminate card, run the GPG command: `scd apdu 00 e6 00 00` You should see "**D[0000]  90 00**"
  (if already terminated, you should receive "**D[0000]  69 85**").

To reactive card, run the GPG command: `scd apdu 00 44 00 00` You should see "**D[0000]  90 00**"
  (if card hasn't been terminated, you should receive "**D[0000]  69 85**").

Close or exit the command prompt or terminal window, and then remove and re-inser the YubiKey device.
Terminate gpg-agent and gpg-connect-agent processes (or restart), then run the GPG command: `gpg --card-status`
Confirm the PIN Retry counter is as follows:
  "**3  0  3**" on a a YubiKey 4/5 Series device

## Import key to YubiKey

Enter the GPG command: `gpg --edit-key $KEYID`

Enter the command: `toggle`

Enter the command: `keytocard`

When prompted if you really want to move your primary key, enter y (yes).

When prompted where to store the key, select 1. This will move the signature subkey to the PGP signature slot of the YubiKey.

Enter the command: `key 1`

Enter the command: `keytocard`

When prompted where to store the key, select 2. This will move the encryption subkey to the YubiKey.

Enter the command: `key 1`

Enter the command: `key 2`

Enter the command: `keytocard`

When prompted where to store the key, select 3. This will move the authentication subkey to the YubiKey.

Enter the command: `quit`

When prompted to save your changes, enter y (yes). You have now saved your keyring to your YubiKey.
