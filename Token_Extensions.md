# This is a guide to how to use different token extensions

This is not a full guide, read the offical docs first! <br>

- https://solana.com/developers/guides/token-extensions/getting-started
- https://spl.solana.com/token-2022/extensions

## 1. `Permanent Delegate` Extension

- Cli flag: `--enable-permanent-delegate`
- **A Permanent Delegate has the ability to transfer or burn any amount of token from any user's wallet.**
- Can be useful for stable coins to stop inflation by burning tokens
- Can be useful when some token has been stolen to have the ability to transfer them back

  ### Change Permanent Delegate authtority

  ```bash
  spl-token authorize <token address> permanent-delegate <new permanent delegate authority>
  ```

  ### Transfer tokens

  ```bash
  spl-token transfer --from <from ACCOUNT address> <token address> <amount in tokens> <destination WALLET> --allow-unfunded-recipient --fund-recipient
  ```

  > The from account address can be any account, not just yours!

  ### Burn tokens

  ```bash
  spl-token transfer <from ACCOUNT address> <amount in tokens>
  ```

  > The from account address can be any account, not just yours!

## 2. `Non Transferable` Extension

- Cli flag: `--enable-non-transferable`
- **This type of token cannot be transfered.**
- It's useful for identification.
- Use these extended commads to place the tokens to the recipient's wallet:

  - When creating an account:

    ```bash
    spl-token create-account -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb --owner <recipient wallet address> --fee-payer $HOME/.config/solana/id.json <token address>
    ```

  - When minting tokens:

    ```bash
    spl-token mint <token address> <amount> <recipient token ACCOUNT address>
    ```

## 3. `Confidential transfer` Extension

- Cli flag: `--enable-confidential-transfers auto`
- **When transferring tokens with this extension the transfered amount will be hidden in the transaction, only visible to the recipient**
- Read the [docs](https://spl.solana.com/confidential-token/quickstart) for more details

## 4. `Transfer fees` Extension

> This extension doesn't have full cli support by the time I writeing this

- Cli flag: `--transfer-fee <FEE_IN_BASIS_POINTS> <MAXIMUM_FEE>`
- FEE_IN_BASIS_POINTS: fee percentage x 100 = basis points (eg: 5% = 500 basis points)
- MAXIMUM_FEE: The maximum fee above witch any additional fee is ignored, given in tokens
  > Example: max fee = 5, fee in basis points = 5000 (50%) add we want to transfer 15 tokens the 50% of 15 tokens is 7.5 tokens but it's more than 5 so the enforced fee will be 5 tokens
- Read the [docs](https://spl.solana.com/token-2022/extensions#transfer-fees) for more details

## 5. `Transfer Hook` Extension

- Cli flag: `--transfer-hook <TRANSFER_HOOK_PROGRAM_ID>`
- Enables a solana program to handle custom logic on transfer
- Read the [docs](https://spl.solana.com/token-2022/extensions#transfer-hook) for more details

## 6. `Interest-Bearing` Extension

- Cli flag: `--interest-rate <RATE_BPS>`
- Read the [docs](https://spl.solana.com/token-2022/extensions#interest-bearing-tokens) for details

## 7. `Defult Account State` Extension

- Cli flag: `--enable-freeze --default-account-state <state: initialized/frozen>`
- With this extension you can set if newly created accounts will start frozen by default
- Read the [docs](https://spl.solana.com/token-2022/extensions#interest-bearing-tokens) for details
