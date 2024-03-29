#! /bin/bash

#This script is only for Mac and Linux
#Ez a kód kizárólag Mac és Linux rendszereken működik

# ©Tatár Márton 2023

echo "                              
                              
       .------------------.
     .*@@@@@@@@@@@@@@@@@#:
   .*@@@@@@@@@@@@@@@@@#:
                                 #######           #                                                                     #
   .+*****************=             #              #                                                                     #
     =@@@@@@@@@@@@@@@@@@=           #      #####   #   ##    #####   # ####         #####    # ###    #####    ######  ######    #####    # ###
       =******************.         #     #     #  #  #     #     #  ##    #       #         ##      #     #  #     #    #      #     #   ##
                                    #     #     #  ###      #######  #     #       #         #       #######  #     #    #      #     #   #
      :#@@@@@@@@@@@@@@@@@*.         #     #     #  #  #     #        #     #       #         #       #        #    ##    #      #     #   #
    :#@@@@@@@@@@@@@@@@@*.           #      #####   #   ##    #####   #     #        #####    #        #####    #### #     ###    #####    #
   .------------------.
 
			By Márton Tatár
"


# Define check if fail function
isSucesess ()
{
	if [[ ! $? -eq 0 ]]; then
		echo "An error occurred. Quitting..."
		exit
	fi
}

# Check if os is supported
case "$OSTYPE" in
    solaris*) echo "Unsupported operating system: 'Solaris'"
			  exit;;

    darwin*)  ;; 
    linux*)   ;;

    bsd*)     echo "Unsupported operating system: 'BSD'"
			  exit;;

    msys*)    echo "Unsupported operating system: 'Windows'"
			  exit;;

    cygwin*)  echo "Unsupported operating system: 'Windows'"
			  exit;;

    *)        echo "Unsupported operating system: '$OSTYPE'"
			  exit;;
esac

# Check if cargo is installed
cargo --version
if [[ ! $? -eq 0 ]]; then
	echo ""
	echo "Rust and cargo not installed. Please install with 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh' and 'apt install cargo' (on linux)."
	echo "Then restart your Terminal"
	exit
fi

isAllInstalled="y"
isSolanaInstalled="y"
isSplInstalled="y"
isMetabossInstalled="y"

# Check if solana is installed
PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
solana --version
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isSolanaInstalled="n"
fi

# Check if spl-token is installed
spl-token --version
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isSplInstalled="n"
fi

# Check if metaboss is installed
metaboss --version
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isMetabossInstalled="n"
fi

# If something is not installed install everithing
if [[ $isAllInstalled == "n" ]]; then
	echo "Installation required, do you want to countinue? (y/n):"
	read doInstall

	if [[ $doInstall == "n" ]]; then
		exit
	fi

	if [[ $doInstall == "y" ]]; then

		echo "Downloading tools this will take some time..."
		echo ""
		sleep 4

		if [[ $isSplInstalled == "n" ]]; then
			echo ""
			echo "Installing spl-token..."
			echo ""
			rm -rf /tmp/cargo-install*/
			cargo install spl-token-cli
			if [[ ! $? -eq 0 ]]; then
				echo "Error installing 'spl-token-cli' try to restart terminal and installation"
				exit
			fi
			sleep 1
		fi

		if [[ $isSolanaInstalled == "n" ]]; then
			echo ""
			echo "Installing solana cli..."
			echo ""
			sh -c "$(curl -sSfL https://release.solana.com/v1.16.9/install)"
			isSucesess
			PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
			sleep 1
		fi
		
		if [[ $isMetabossInstalled == "n" ]]; then
			echo ""
			echo "Installing Metaboss..."
			echo ""
			bash <(curl -sSf https://raw.githubusercontent.com/samuelvanderwaal/metaboss/main/scripts/install.sh)
			isSucesess
			sleep 1
		fi

		echo ""
		echo "Tools sucesessfully downloaded"
		echo "Please restart your Terminal (close/reopen)!!"
		echo "Then use the same command as before to countinue"
		exit
	fi
fi

#Create wallet

echo ""
echo "Do you vant to create a new file system wallet? This will remove your existing one! (y/n): "

read doCreateWallet
if [[ $doCreateWallet == "y" ]]; then
	solana address > /dev/null 2>&1
	if [[  $? -eq 0 ]]; then
		echo "Warning! You have an existing wallet, creating a new one will delete the exising one!"
		echo "Do you still want to countinue? (y/n):"
		read doOverwriteWallet
		if [[ $doOverwriteWallet == "y" ]]; then
			echo ""
			solana-keygen new --force	#Create wallet
			isSucesess
		fi
	else
		echo ""
		solana-keygen new --force	#Create wallet
		isSucesess
	fi
fi

wallet=$( solana address )
isSucesess

#Set network

echo ""
echo "Witch network do you want to use Mainnet(paid) or Devnet(free) (m/d):"

read network
if [[ $network == "m" ]]; then
	solana config set --url https://api.mainnet-beta.solana.com
	isSucesess
	echo "Please send 0,5 SOL to this ($wallet) wallet!"
	sleep 4
	echo "Press Enter to countinue..."
	read
elif [[ $network == "d" ]]; then
	solana config set --url https://api.devnet.solana.com
	isSucesess
	sleep 1
	solana airdrop 4
fi

#Create token

echo ""
echo "Creating token..."

tokenRaw=$( spl-token create-token )	#Create token
isSucesess

token=$( echo $tokenRaw  | awk '{print $3}')

echo "Token ID: $token"

#Create token account
accountRaw=$( spl-token create-account $token )
isSucesess
account=$( echo $accountRaw  | awk '{print $3}' )

echo "Token account ID: $account"

echo ""
echo "How many token do you want to mint? (0-18446744070):"

read tokenAmount

if [[ $tokenAmount > 18446744070 ]]; then
	echo "The enterd amount is invalid!"
	echo "Countinueing with 18000000000 tokens."
	tokenAmount=18000000000
fi	

#Mint token
echo "Minting token..."
spl-token mint $token $(( $tokenAmount + 1 )) > /dev/null 2>&1
isSucesess

##Metadata

if [[ ! -d $HOME/Solana-token-creator ]]; then
	mkdir $HOME/Solana-token-creator
	isSucesess
else
	rm -rf $HOME/Solana-token-creator
	isSucesess
	mkdir $HOME/Solana-token-creator
	isSucesess
fi

echo ""
echo "How to name your token?:"
read tokenName

echo "What symbol do you want?:"
read tokenSymbol

echo "Enter a description for your token:"
read tokenDescription

echo ""
echo "Uplad the token icon to GitHub or any other service"
sleep 4
echo "If you done paste here the link of the token icon:"
read iconLink

OffChainMetadata="{ \"name\": \"$tokenName\", \"symbol\": \"$tokenSymbol\", \"description\": \"$tokenDescription\", \"image\": \"$iconLink\", \"attributes\": [], \"properties\": { \"files\": [ { \"uri\": \"$iconLink\", \"type\": \"image/png\" } ] } }"

echo "$OffChainMetadata" >> $HOME/Solana-token-creator/off-chain_token_metadata.json

echo ""
echo "Uplad the 'off-chain_token_metadata.json' file($HOME/Solana-token-creator/) to Npoint.io (or Github)"
echo "To get help follow step IV/5 in my repo (https://github.com/tm01013/how-to-make-your-own-crypto)"
sleep 4

echo "If you done paste here the link of the file:"
read metadataLink

OnChainMetadata="{ \"name\": \"$tokenName\", \"symbol\": \"$tokenSymbol\", \"uri\": \"$metadataLink\", \"seller_fee_basis_points\": 100, \"creators\": [ { \"address\": \"$wallet\", \"verified\": false, \"share\": 100 } ] }"

echo "$OnChainMetadata" >> $HOME/Solana-token-creator/on-chain_token_metadata.json

metaboss create metadata -a $token -m $HOME/Solana-token-creator/on-chain_token_metadata.json
isSucesess

echo ""
echo "Your token is done!!"

echo ""
echo "Enter your wallet address to transfer $tokenAmount$tokenSymbol to your wallet:"
read destinationWallet

if [[ $network == "d" ]]; then
	solana transfer $destinationWallet 3 --allow-unfunded-recipient > /dev/null 2>&1
fi 

echo "Transferring tokens..."
spl-token transfer $token $tokenAmount $destinationWallet --fund-recipient --allow-unfunded-recipient > /dev/null 2>&1
isSucesess

echo ""
echo "Don't worry if you see your token as "Unrecognised Token" just wait 2-4 minutes to let the network process the changes"

echo ""
echo "Do you want to disable mint? (y/n):"
echo "It's required for every token to function correctly."
read doDisableMint

if [[ $doDisableMint == "y" ]]; then
	echo "|------------------------!!WARNING!!-------------------------|"
	echo "| If you disable mint you cannot get any more of your token! |"
	echo "| And you cannot update the metadata!                        |"
	echo "| Please check everithing is correct before countinue!       |"
	echo "|------------------------------------------------------------|"
	sleep 3
	echo ""
	echo "Do you want to countinue? (y/n):"
	read doCountinue

	if [[ $doCountinue == "y" ]]; then
		spl-token authorize $token mint --disable
		isSucesess
		spl-token burn $account 1 > /dev/null 2>&1 # Remove the extra token generated becouse for some vierd reason solana doesn't allow sending all tokens
		isSucesess
	fi
fi

echo ""
echo "You're done!! 🎉 Congratulations you've created a crypo!! 🎉"

if [[ $network == "m" ]]; then
	echo ""
	echo "View on solscan: https://solscan.io/token/$token"
else
	echo ""
	echo "View on solscan: https://solscan.io/token/$token?cluster=devnet"
fi
