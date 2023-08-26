# How to create your own cryptocurrency for free?

To create cryptocurrency, you will need the following :
- A computer or even a tablet
- A free GitHub account
- Basic skills for using the Terminal (or cmd).
- Basic knowledge to write json code
  
> It has been tested on Mac, Linux and Google cloud systems.

### How does this work?
We aren't creating a *" cryriptocurrency "* (what??), but we are creating a  *Token*. <br>
> Tokens don't have their own blockchain and network, they uses a network of an existing cryptocurrency (in our case, Solana's). <br>
> Creating a *" cryptocurrency "* requires a ***very high*** level of programming skills and a **lot** of resources and time. <br>
> However, creating a token is very easy and the function of the completed token is almost ***THE SAME*** as that of a cryptocurrency ( ok, only 95% ). <br><br>
> In essence, you will create ***your own cryptocurrency*** without ***your own*** blockchain. <br>


## I. Installation of tools
 
**Mac (Terminal), Linux (Terminal), Google Cloud console :**
``` bash
sh -c "$( curl -sSfL https://release.solana.com/v1.16.9/install)"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install spl-token-cli
```	
**Windows (cmd):**
``` bash
cmd /c "curl https://release.solana.com/v1.16.9/solana-install-init-x86_64-pc-windows-msvc.exe --output C:\solana-install-tmp\solana-install-init.exe --create-dirs"

C:\solana-install-tmp\solana-install-init.exe v1.16.9

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install spl-token-cli
```

## II. Token creation

1. Create a new solana account
	``` bash
	solana-keygen new
	```
   
   	> This creates a new Solana key pair that will function as a [*file system wallet*]( https://docs.solana.com/wallet-guide/file-system-wallet ).<br>
  	> Before generating the key pair, it will ask for a *BIP39 Passphrase*, which serves as extra protection , but we don't need it .<br>
  	> Save the public key!!

2. Check Solana configuration
	``` bash
	solana config get
	```

	If you do not see api.devnet.solana.com in the WebSocket line , you are not on the developer network, then you have to pay for the creation of the token (+ for the transactions), *nothing on the developer network has a real monetary value.*<br>

	> Solana has 3 *main* networks:<br>
 	> ***Mainnet***: *real* money, transactions have *real* fees, lots of wallets app available <br>
 	> ***Devnet***: *not real* money, transactions have *simulated* dia , RPC: https://api.devnet.solana.com <br>
 	> ***Testnet***: similar to devnet , but its purpose is to test the mega network, RPC: https://api.testnet.solana.com <br>

4. If you want to create a token for free , you can "enter" the test network with this command.
 	```bash  
  	solana config set --url https://api.devnet.solana.com
	```
5. You have to transfer Solana to your account, with this command you get 4 test SOLs.
	```bash   
  	solana airdrop 4
	```
	> If you are not on the developer network, you must transfer 0.5 SOL from your own account here.

	> Salana is needed because you have to pay for token creation + subsequent transactions<br>
	> These 4 SOLs are enough for more than 800000 transfers on the **dev network**.

6. Create a token (write down the "address" of the token !)
	``` bash
	spl-token create-token
	```
 	> You can create several different tokens with one wallet.
  	> So if you are not satisfied with one token, you have to repeat the process from this step :)
  
7. Creating an account for our token (without this you wouldn't be able to use it)
	``` bash  
	spl-token create-account <token>
	```
 	> This will not create a new wallet but an *account* within the wallet for the token <br>
  	> For all cryptocurrencies you need an account to store them, and these accounts are inside the wallet. <br>
  	> There is a fee to create an account (less than 0.00001 SOL) <br>
  
8. You can generate a certain amount of token with this command. The tokens will be transferred to the account created in step 1 ( one account can have a maximum of 10 trillion).
	``` bash   
	spl-token mint <token> <amount>
	```
 	> To be able to generate from your token you need that *file system wallet* with which you created the token!

9. Use this command to check how many tokens you have
	``` bash   
	spl-token accounts
	```
10. Use this command to disable the generation of additional tokens
	``` bash   
	spl-token authorize <token> mint --disable
	```
	> <picture>
	> <source media ="(prefers-color-scheme:light)" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
	> <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
	> </picture>
 	> Do not perform this step until you have added metadata to your token!!


## IV. Add metadata to the token
Without metadata the token will apear as “*Unknown Token*”, and it won't have an icon and symbol (eg:BTC).

1. Install Metaboss
	``` bash   
	bash <(curl -sSf https://raw.githubusercontent.com/samuelvanderwaal/metaboss/main/scripts/install.sh)
	```
2. Create two .json file based on the attached samples, plus an icon ( png recommended)
3. [Follow these instructions](/.how-to-upload-to-github/upload_to_github.md)
5. Add metadata to the token
	``` bash   
	metaboss create metadata -a <token> -m <token_ metadata.json file (not the github one)>
	```
6. Your token is ***DONE*** :)

## V. Use the Token

1. Create a wallet suitable for storing Solana, for example, in the app Phantom app (Android , IOS , Chrome extension).
2. If you created the token on the developer network, you must switch the network from "Mainnet" to "Devnet" in the wallet app.
	- Phantom : " Settings " => " Developer settings " => "Testnet mode " after this you should see a yellow stripe at the top of the screen (after restarting)
	- Solflare : Settings => "General" => "Network" => " Devnet "
     
	- **Not All applications are compatible with the developer network!**

3. Send the test SOL retrieved in the "Create Token " section to your new wallet ( you will need it for the transfers 1SOl = >200000 transfers).

	> If you are not using the test network, you must transfer SOL to your new account in another way.
	``` bash   
	solana transfer <wallet Solana address> <amount (cannot send all)>
	```
 	> You can only transfer to SOL with this command .
  
4. Send the completed tokens to your wallet and at the same time create an account for the token there (`--fund-recipient`). After that, you don't have to use the Terminal :).
	``` bash
	spl-transfer <token> <amount (some must remain)> <wallet Solana address> --fund-recipient
	```
	> Don't forget that you will always need SOL for transactions (if you use the test network and run out, complete steps II/4 and V/3)
   
<br><br>


© ***Márton Tatár 2023***

> <picture>
> <source media ="(prefers-color-scheme:light )" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
> <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
> </picture>
> Attention, the creators of the repository DO NOT ASSUME ANY RESPONSIBILITY
