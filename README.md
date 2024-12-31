# How to create your own cryptocurrency for free?

To create cryptocurrency, you will need the following :

- A computer or even a tablet
- Basic skills for using the Terminal.
- Basic knowledge to write json code
- Internet connection

> It has been tested on:
>
> - Mac os Big Sur
> - Ubuntu 20.14 LTS
> - Google cloud

   ```
      ┌─────────────────────────[DISCLAIMER]─────────────────────────┐
      │ Only do crypto relaited stuff if it's legal in your country! │
      │              Use this script only at your risk!              │ 
      │             I DO NOT ASSUME ANY RESPONSIBILITY!              │
      │ Note:         This is not a financial advice!                │
      └──────────────────────────────────────────────────────────────┘
   ```

### How does this work?

We aren't creating a _" cryriptocurrency "_ (what??), but we are creating a _Token_. <br>

Read more about their differences [here](https://bitpay.com/blog/coins-vs-tokens/)

- Tokens don't have their own blockchain and network, they uses a network of an existing cryptocurrency (in our case, Solana's).
- Creating a _"cryptocurrency"_ requires a **_very high_** level of programming skills and a **lot** of resources and time.
- However, creating a token is very easy and can function complitly same as that a cryptocurrency, and tokens can do mutch more!

- In essence, you will create **_your own cryptocurrency_** without **_your own blockchain_**. <br>

---

# `Token creator` - The easy way

With '_solana-token-creator_' you can create a crypto within 2 minutes with just 1 command!

> The token creator is not compatible with Windows! <br>
> But if you are a windows user you can use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install), Google cloud or a VM to use the script

1. Download this repo
   ```bash
   git clone https://github.com/tm01013/how-to-make-your-own-crypto.git
   cd how-to-make-your-own-crypto
   ```
2. Open Terminal then enter the following command:
   ```bash
   bash solana-token-creator.sh
   ```
3. The program will ask you if you want to install the needed software. You will need to say "y" at the first time (or when you want to update)

   > Then close and reopen Terminal (it's necessery to work correctly)

4. Can you make your crypto within 2 minutes? :)

<details>

  <summary><h3>Command line arguments</h3></summary>

  | command line option          | details |
  | ---------------------------- | -------- |
  | --advanced                   | gives you some extra options |
  | -r --recipient               | recipient's wallet|
  | -d --decimals                | token decimals [1-10]|
  | -e --extensions              | extensions (separated by commas) <details><summary>Details</summary>- no extension -> n / 0 / noextension <br>- non transfarable -> nt / 1 / nontransfarable <br>- confidential transfer -> ct / 2 / confidentialtransfer<br>- transfer fee -> tf / 3 / transferfee<br>- transfer hook -> th / 4 / transferhook<br>- permanent delegate -> pd / 5 / permanentdelegate<br>- mint close -> mc / 6 / mintclose<br>- intrest bearing -> ib / 7 / intrestbearing<br>- default account state -> das / 8 / defaultaccountstate<br>- freeze -> f / 9 / freeze<br>- group config -> gc / 10 / groupconfig<br>- member config -> mc / 11 / memberconfig</details>|
  | -th --transfer-hook          | transfer hook program id|
  | -tf --transfer-fee           | transfer fee in percentage|
  | -mf --max-fee 		         | max fee in tokens|
  | -ir --intrest-rate           | intrest rate|
  | -das --default-account-state | default account state, initialized(i) or frozen(f)|
  | -gc --group-config 		      | group config (address / max amount of tokens that can belong to the newly initialized group)|
  | -mc --member-config		      | member config (address / leave empty to initialize a new)|
  | -na --name					      | token name|
  | -s --symbol					   | token symbol|
  | -ds --description			   | token description|
  | -i --icon-url				      | icon url|
  | -m --offchain-metadata	      | off-chain metadata url|
  | -k --keypair					   | token keypair (location of the keypair file)|
  | -a --amount					   | token amount (in tokens)|
  | -n --network					   | network, mainnet(m) / devnet(d) / not change(n) / custom rpc url|

   > Don't use empty strings in cli arguments, it will brake the script!

</details>

### On-chain updater mode

With this mode you can update the on-chain metadata, extension settings and the authoritys of your token:

``` bash
bash solana-token-creator.sh --updater-mode
```

### Cheat sheat

Yes, this program has a builtin cheat sheat for the most used solana and spl commands!

``` bash
bash solana-token-creator.sh --cheat
```
   > If you have other suggestions what to put in the cheat sheat create an issue with the 'cheat sheat' label, or open a PR.

### Tools

With this feature you can do unregular solana stuff easyly!
``` bash
bash solana-token-creator.sh --tools
```

---

## `Manual way` - Learn things in the harder way

## I. Installation of tools

**Mac (Terminal), Linux (Terminal), Google Cloud console :**

```bash
sh -c "$( curl -sSfL https://release.solana.com/stable/install)"
```

Then restart Terminal to work everithing fine and enter the following command:

```bash
PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
```

**Windows (cmd):**

```bash
cmd /c "curl https://release.solana.com/stable/solana-install-init-x86_64-pc-windows-msvc.exe --output C:\solana-install-tmp\solana-install-init.exe --create-dirs"

C:\solana-install-tmp\solana-install-init.exe v1.16.9
```

> Then restart cmd to work everithin fine

## II. Token creation

1. Create a new solana wallet

   ```bash
   solana-keygen new
   ```

   > **Warning this will remove your existing wallet!!** <br>
   > This creates a new Solana key pair that will function as a file system wallet.<br>
   > Before generating the key pair, it will ask for a _BIP39 Passphrase_, which serves as extra protection, but we don't need it .<br>
   > Save the public key, we need it later!

2. Check Solana configuration

   ```bash
   solana config get
   ```

   If you do not see api.devnet.solana.com in the RPC line, you are not on the developer network, then you have to pay for the creation of the token (+ for the transactions), _nothing on the developer network has a real monetary value._<br>

   Solana has 3 main networks:<br>

   - **_Mainnet_**: _real_ money, transactions have _real_ fees, RPC: https://api.mainnet-beta.solana.com
   - **_Devnet_**: _not real_ money, transactions have _simulated_ fees , RPC: https://api.devnet.solana.com
   - **_Testnet_**: similar to devnet , but its purpose is to test the solana network, RPC: https://api.testnet.solana.com <br>

3. If you want to create a token for free , you can "enter" the developer network with this command.
   ```bash
   solana config set --url https://api.devnet.solana.com
   ```
4. You have to transfer Solana to your account, with this command you get 4 test SOLs.

   ```bash
   solana airdrop 4
   ```

   > If you are not on the developer network, you have to transfer some SOL from your own account here.

   > Salana is needed because you have to pay for token creation + subsequent transactions<br>
   > These 4 SOLs are enough for more than 800000 transfers on the **dev network**.

5. Create a token

   ```bash
   spl-token create-token -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb --enable-metadata <optional flags>
   ```

   When creatin a token you can configure the following things:

   1. `--decimals <DECIMALS>` Number of base 10 digits to the right of the decimal place [default: 9], minimum is 1 (for fungible tokens)
   2. `--mint-authority <ADDRESS>` Specify the mint authority address. Default is the client's address.
   3. Token Extensions, see the my [Token Extensions guide](Token_Extensions.md) and the [offical docs](https://spl.solana.com/token-2022/extensions)
      <br><br>

   > Save the token address, we need it later! <br><br>
   > You can create several different tokens with one wallet.
   > So if you are not satisfied with one token, you have to repeat the process from this step :)

6. Creating an account for our token

   ```bash
   spl-token create-account -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb <token>
   ```

   > This will not create a new wallet but an _account_ within the wallet for the token <br>
   > For all tokens you need an account to store them, and these accounts are inside the wallet. <br>
   > There is a fee to create an account (less than 0.00001 SOL) <br>

7. You can generate a certain amount of token with this command

   ```bash
   spl-token mint <token> <amount>
   ```

   > Only the mint authority (the wallet that created the token) can mint tokens

8. Use this command to check how many tokens you have
   ```bash
   spl-token accounts
   ```
9. Use this command to disable the generation of additional tokens
   ```bash
   spl-token authorize -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb  <token> mint --disable
   ```
   > <picture>
   > <source media ="(prefers-color-scheme:light)" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
   > <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
   > </picture>
   > Do not perform this step until you have added metadata to your token!!

## IV. Add metadata to the token

Without metadata the token will apear as “_Unknown Token_”, and it won't have an icon and symbol (eg:BTC).
<br>

1. Chose a name (Example Token), a symbol (ET) and a description (Best token!)
2. Upload your icon (in png format) to IPFS ([pinata](https://pinata.cloud/)) ar any other site and get it's raw link (ending with .png)
3. Create a off-chain json metadata file like this:
   ```json
   {
     "name": "Example Token",
     "symbol": "ET",
     "description": "Best Token :)",
     "image": "https://example.com/image.png",
     "attributes": [],
     "properties": {
       "files": [
         {
           "uri": "https://example.com/image.png",
           "type": "image/png"
         }
       ]
     }
   }
   ```
4. Upload the metadata file to IPFS ([pinata](https://pinata.cloud/)), and get it's referance link
5. Add the on-chain metadata
   ```bash
   spl-token initialize-metadata <token> <token name (in quotation marks)> <token symbol (in quotation marks)> <off-chain metadata referance link> -v -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb
   ```
6. Check the metadata on [Solscan](https://solscan.io/), [Solscan for devnet](https://solscan.io/?cluster=devnet)

   > Search with the token's address

   Don't worry if you see your token as _"Unrecognised Token"_ just wait 2-4 minutes to let the network process the changes

7. Your token is **_DONE_** :)

## V. Use the Token

1. Create a wallet suitable for storing Solana, for example, in the Phantom app (Android , IOS , Chrome extension).
2. If you created the token on the developer network, you must switch the network from "Mainnet" to "Devnet" in the wallet app.

   - Phantom : "Settings" => "Developer settings" => turn "Testnet mode" on => select devnet
     > After this you should see a yellow stripe at the top of the screen (after restarting)
   - Solflare : Settings => "General" => "Network" => "Devnet"

   - **Not All applications are compatible with the developer network!**

3. Send the test SOL retrieved in the "Create Token " section to your new wallet ( you will need it for the transfers 1SOl = >200000 transfers).

   > If you are not using the test network, you have to transfer SOL to your new account in another way.

   ```bash
   solana transfer <wallet Solana address> <amount (some must remain to fund the transaction)>
   ```

   > You can only transfer to SOL with this command .

4. Send the completed tokens to your wallet and at the same time create an account for the token there (`--fund-recipient`).

   ```bash
   spl-token transfer <token> <amount> <address of the destination wallet> --fund-recipient
   ```

   Don't worry if you see your token as _"Unrecognised Token"_ just wait 2-4 minutes to let the network process the changes

   > Don't forget that you will always need SOL for transactions (if you use the test network and run out, complete steps II/4 and V/3)

<br><br>

© **_Márton Tatár 2024_**