# How to create your own cryptocurrency for free?

> **_Magyar verzióért kattints [ide](./README.hu.md)_**

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

### How does this work?

We aren't creating a _" cryriptocurrency "_ (what??), but we are creating a _Token_. <br>

- Tokens don't have their own blockchain and network, they uses a network of an existing cryptocurrency (in our case, Solana's).
- Creating a _" cryptocurrency "_ requires a **_very high_** level of programming skills and a **lot** of resources and time.
- However, creating a token is very easy and the function of the completed token is almost **_THE SAME_** as that of a cryptocurrency ( ok, only 99% ).

- In essence, you will create **_your own cryptocurrency_** without **_your own blockchain_**. <br>

---

# Token creator

With '_solana-token-creator_' you can create a crypto within 2 minutes with just 1 command!

1. Download this repo (green _Code_ button on the main page => _Download Zip_)
2. Open Terminal (this isn't compatible with Windows jet) then enter the following command:
   ```bash
   bash <location of 'solana-token-creator.sh' script>
   ```
3. The program will ask you if you want to install the needed software. You will need to say "y" at the first time (or when you want to update)

   > Then close and reopen Terminal (it's necessery to work correctly)

4. Can you make your crypto within 2 minutes? :)

---

## `Manual way`

## I. Installation of tools

**Mac (Terminal), Linux (Terminal), Google Cloud console :**

```bash
sh -c "$( curl -sSfL https://release.solana.com/v1.16.9/install)"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install spl-token-cli
```

> Then restart Terminal to work everithin fine <br>

**Windows (cmd):**

```bash
cmd /c "curl https://release.solana.com/v1.16.9/solana-install-init-x86_64-pc-windows-msvc.exe --output C:\solana-install-tmp\solana-install-init.exe --create-dirs"

C:\solana-install-tmp\solana-install-init.exe v1.16.9

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install spl-token-cli
```

> Then restart cmd to work everithin fine

## II. Token creation

1. Create a new solana account

   ```bash
   solana-keygen new
   ```

   > **Warning this will remove your existing wallet!!** <br>
   > This creates a new Solana key pair that will function as a [_file system wallet_](https://docs.solana.com/wallet-guide/file-system-wallet).<br>
   > Before generating the key pair, it will ask for a _BIP39 Passphrase_, which serves as extra protection , but we don't need it .<br>
   > Save the public key!!

2. Check Solana configuration

   ```bash
   solana config get
   ```

   If you do not see api.devnet.solana.com in the RPC line, you are not on the developer network, then you have to pay for the creation of the token (+ for the transactions), _nothing on the developer network has a real monetary value._<br>

   > Solana has 3 _main_ networks:<br> > **_Mainnet_**: _real_ money, transactions have _real_ fees, RPC: https://api.mainnet-beta.solana.com <br> > **_Devnet_**: _not real_ money, transactions have _simulated_ fees , RPC: https://api.devnet.solana.com <br> > **_Testnet_**: similar to devnet , but its purpose is to test the solana network, RPC: https://api.testnet.solana.com <br>

3. If you want to create a token for free , you can "enter" the developer network with this command.
   ```bash
   solana config set --url https://api.devnet.solana.com
   ```
4. You have to transfer Solana to your account, with this command you get 4 test SOLs.

   ```bash
   solana airdrop 4
   ```

   > If you are not on the developer network, you must transfer 0.5 SOL from your own account here.

   > Salana is needed because you have to pay for token creation + subsequent transactions<br>
   > These 4 SOLs are enough for more than 800000 transfers on the **dev network**.

5. Create a token (write down the "address" of the token !)

   ```bash
   spl-token create-token
   ```

   > You can create several different tokens with one wallet.
   > So if you are not satisfied with one token, you have to repeat the process from this step :)

6. Creating an account for our token (without this you wouldn't be able to use it)

   ```bash
   spl-token create-account <token>
   ```

   > This will not create a new wallet but an _account_ within the wallet for the token <br>
   > For all cryptocurrencies you need an account to store them, and these accounts are inside the wallet. <br>
   > There is a fee to create an account (less than 0.00001 SOL) <br>

7. You can generate a certain amount of token with this command. The tokens will be transferred to the account created in step 1 ( one account can have a maximum of 10 trillion).

   ```bash
   spl-token mint <token> <amount>
   ```

   > To be able to generate from your token you need that _file system wallet_ with which you created the token!

8. Use this command to check how many tokens you have
   ```bash
   spl-token accounts
   ```
9. Use this command to disable the generation of additional tokens
   ```bash
   spl-token authorize <token> mint --disable
   ```
   > <picture>
   > <source media ="(prefers-color-scheme:light)" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
   > <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
   > </picture>
   > Do not perform this step until you have added metadata to your token!!

## IV. Add metadata to the token

Without metadata the token will apear as “_Unknown Token_”, and it won't have an icon and symbol (eg:BTC).

1. Install Metaboss
   ```bash
   bash <(curl -sSf https://raw.githubusercontent.com/samuelvanderwaal/metaboss/main/scripts/install.sh)
   ```
2. Create two .json file based on the samples, and an png icon
   > **Important!** Remove my comments (starting with `//`) form the json files before countinue!
3. First upload the token image to GitHub or any other public service and get is's raw link
4. Replace the image link in the _token_metadata_offchain.json_ file to the previously copied one
5. Upload this file to [Npoint.io](https://www.npoint.io/) (or Github), get it's referance link (on Npoint.io it's on the bottom).
6. Replace the off-chain metadata link in the _token_metadata_onchain.json_ file to the preveriously copied.
7. Add metadata to the token
   ```bash
   metaboss create metadata -a <token> -m <token_metadata_onchain.json file>
   ```

> Don't worry if you see your token as _"Unrecognised Token"_ just wait 2-4 minutes to let the network process the changes

8. Your token is **_DONE_** :)

## V. Use the Token

1. Create a wallet suitable for storing Solana, for example, in the app Phantom app (Android , IOS , Chrome extension).
2. If you created the token on the developer network, you must switch the network from "Mainnet" to "Devnet" in the wallet app.

   - Phantom : " Settings " => " Developer settings " => "Testnet mode " after this you should see a yellow stripe at the top of the screen (after restarting)
   - Solflare : Settings => "General" => "Network" => " Devnet "

   - **Not All applications are compatible with the developer network!**

3. Send the test SOL retrieved in the "Create Token " section to your new wallet ( you will need it for the transfers 1SOl = >200000 transfers).

   > If you are not using the test network, you must transfer SOL to your new account in another way.

   ```bash
   solana transfer <wallet Solana address> <amount (cannot send all)>
   ```

   > You can only transfer to SOL with this command .

4. Send the completed tokens to your wallet and at the same time create an account for the token there (`--fund-recipient`). After that, you don't have to use the Terminal :).

   ```bash
   spl-transfer <token> <amount (some must remain)> <wallet Solana address> --fund-recipient
   ```

   > Don't worry if you see your token as _"Unrecognised Token"_ just wait 2-4 minutes to let the network process the changes

   > Don't forget that you will always need SOL for transactions (if you use the test network and run out, complete steps II/4 and V/3)

<br><br>

© **_Márton Tatár 2023_**

> <picture>
> <source media ="(prefers-color-scheme:light )" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
> <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
> </picture>
> Attention, the creators of the repository DO NOT ASSUME ANY RESPONSIBILITY
