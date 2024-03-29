#! /bin/bash

#This script is only for Mac and Linux
#Ez a kód kizárólag Mac és Linux rendszereken működik

# Copyright: Márton Tatár 2024

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

updateMetadataMode()
{
	echo ""
	echo "Enter the token's mint address:"
	read tokenMintAddr

	echo "Select what you want to update from the following list: (1-6)"
	echo "  (1) Token name"
	echo "  (2) Token symbol"
	echo "  (3) Off-chain metadata uri"
	echo "  (4) Add a custom field"
	echo "  (5) Edit a custom field"
	echo "  (6) Remove a custom field"
	read option

	case $option in

		1) 	echo "Enter the new name for the token:"
			read newName
			spl-token update-metadata -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb $tokenMintAddr "name" "$newName" > /dev/null
			echo "This only changed the ON-CHAIN metadata!"
			echo "To make the token's name displayed as \"$newName\" you also need to change or create a new off-chain metadata"
			exit;;

		2)	echo "Enter the new symbol for the token:"
			read newSymbol
			spl-token update-metadata -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb $tokenMintAddr "symbol" "$newSymbol" > /dev/null
			echo "This only changed the ON-CHAIN metadata!"
			echo "To make the token's symbol displayed as \"$newSymbol\" you also need to change or create a new off-chain metadata"
			exit;;

		3)	echo "Enter the new off-chain metadata uri for the token:"
			read newUri
			spl-token update-metadata -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb $tokenMintAddr "uri" $newUri > /dev/null
			exit;;

		4)	echo "Enter the field's name:"
			read field
			echo "Enter the field's data:"
			read fieldData
			spl-token update-metadata -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb $tokenMintAddr "$field" "$fieldData"
			exit;;
		
		5)	echo "Enter the field's name:"
			read field
			echo "Enter the field's new data:"
			read fieldData
			spl-token update-metadata -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb $tokenMintAddr "$field" "$fieldData"
			exit;;
		
		6)	echo "Enter the field's name:"
			read field
			spl-token update-metadata -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb  $tokenMintAddr "$field" --remove
			exit;;

		*) echo "The selected option is invalid!"
			exit;;
	esac
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

isAllInstalled="y"
isSolanaInstalled="y"

# Check if solana is installed
PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
solana --version
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isSolanaInstalled="n"

else
	solanaVersion=$( solana --version | awk '{print $2}' )
	if [[ "$(printf "%s\n" "1.18.4" "$solanaVersion" | sort -V | head -n 1)" != "1.18.4" ]]; then
    	echo "The installed version of Solana is outdated, update required"
		isAllInstalled="n"
		isSolanaInstalled="n"
	fi
fi

# Check if spl-token is installed
spl-token --version
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isSolanaInstalled="n"
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

		if [[ $isSolanaInstalled == "n" ]]; then
			echo ""
			echo "Installing solana cli..."
			echo ""
			sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
			isSucesess
			PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
			sleep 1
		fi

		echo ""
		echo "Tools sucesessfully downloaded"
		echo "Please restart your Terminal (close/reopen)!!"
		echo "Then use the same command as before to countinue"
		exit
	fi
fi

if [[ $1 == "--edit-metadata-mode" ]]; then
	updateMetadataMode
	exit
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
	solana config set --url https://api.mainnet-beta.solana.com > /dev/null 2>&1
	isSucesess
	echo "Please send 0,5 SOL to this ($wallet) wallet!"
	sleep 4
	echo "Press Enter to countinue..."
	read
elif [[ $network == "d" ]]; then
	solana config set --url https://api.devnet.solana.com > /dev/null 2>&1
	isSucesess
	sleep 1
	solana airdrop 4
fi

#Create token

echo ""
echo "How many decimals do you want? (1-10):"
read tokenDecimals

echo ""
echo "Select a token extensions from the following list, separated by commas: (0-8)"
echo "Details in the solana docs: https://solana.com/developers/guides/token-extensions/getting-started"
echo "  (0) No extensions, just a simple token"
echo "  (1) Non transfarable"
echo "  (2) Confidential transfer"
echo "  (3) Transfer fees"
echo "  (4) Transfer Hook"
echo "  (5) Permanent Delegate"
echo "  (6) Mint Close Authority"
echo "  (7) Interest-Bearing"
echo "  (8) Default Account State"
read tokenExtensionId

echo ""
tokenExtensionParsed=""
accountFlagsParsed=""
recipientWallet=""
isTokenTransfarable=true

isOption1Used=false
isOption2Used=false
isOption3Used=false
isOption4Used=false
isOption5Used=false
isOption6Used=false
isOption7Used=false
isOption8Used=false
isOption9Used=false

IFS=',' read -ra elements <<< "$tokenExtensionId"

for element in "${elements[@]}"
do
	case "$element" in
		0) 	tokenExtensionParsed=""
			break;;

		1)	if [[ $isOption1Used == false ]];then
				isOption1Used=true				
				isTokenTransfarable=false
				tokenExtensionParsed="${tokenExtensionParsed} --enable-non-transferable"

			fi;;

		2) 	if [[ $isOption2Used == false ]];then
				isOption2Used=true
				echo "[2] Before be able to use your confidetial token you need read the docs! (https://spl.solana.com/confidential-token/quickstart)"
				tokenExtensionParsed="${tokenExtensionParsed} --enable-confidential-transfers auto"
			fi;;

		3) 	if [[ $isOption3Used == false ]];then
				isOption3Used=true
				echo "[3] Enter transfer fee in percentage: (without the % sign)"
				read transferFee
				echo "[3] Enter the maximum transfer fee in tokens:"
				read maxTransferFee
				tokenExtensionParsed="${tokenExtensionParsed} --transfer-fee $(($transferFee * 100)) $maxTransferFee"
			fi;;

		4) 	if [[ $isOption4Used == false ]];then
				isOption4Used=true
				echo "[4] Enter the hook program id:"
				read hookProgramId
				tokenExtensionParsed="${tokenExtensionParsed} --transfer-hook $hookProgramId"
			fi;;

		5)	if [[ $isOption5Used == false ]];then
				isOption5Used=true
				tokenExtensionParsed="${tokenExtensionParsed} --enable-permanent-delegate"
			fi;;

		6) 	if [[ $isOption6Used == false ]];then
				isOption6Used=true
				tokenExtensionParsed="${tokenExtensionParsed} --enable-close"
			fi;;

		7)	if [[ $isOption7Used == false ]];then
				isOption7Used=true
				echo "[7] Enter the intrest rate in basis points:"
				read intrestRate
				tokenExtensionParsed="${tokenExtensionParsed} --interest-rate $intrestRate"
			fi;;
	
		8)	if [[ $isOption8Used == false ]];then
				isOption8Used=true
				echo "[8] Select the default account state: (initialized/frozen)"
				read defaultAccountState
				tokenExtensionParsed="${tokenExtensionParsed} --default-account-state $defaultAccountState --enable-freeze"
			fi;;

		*) echo "Option $element is invalid, skipping it"
	esac
done

echo "Enter the recipient wallet address: (empty for your own)"
read recipientWallet
if [[ $recipientWallet == "" ]]; then
	recipientWallet=$wallet
fi

echo ""
echo "Creating token..."

tokenRaw=$( spl-token create-token -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb --enable-metadata --decimals $tokenDecimals $tokenExtensionParsed )	#Create token
isSucesess

token=$( echo $tokenRaw  | awk '{print $3}')

echo "Token ID: $token"

#Create token account
accountRaw=$( spl-token create-account -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb --owner $recipientWallet --fee-payer $HOME/.config/solana/id.json $token )
isSucesess
account=$( echo $accountRaw  | awk '{print $3}' )

echo "Token account ID: $account"

echo ""
echo "How many token do you want to mint? (0-18446744070):"

read tokenAmount

#Mint token
echo "Minting token..."
spl-token mint $token $tokenAmount $account > /dev/null 2>&1
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
echo "Uplad the 'off-chain_token_metadata.json' file($HOME/Solana-token-creator/) to npoint.io (or Github)"
echo "To get help follow step IV/4 in my repo (https://github.com/tm01013/how-to-make-your-own-crypto)"
sleep 4

echo "If you done paste here the link of the file:"
read metadataLink

spl-token initialize-metadata $token "$tokenName" "$tokenSymbol" "$metadataLink" -v -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb > /dev/null
isSucesess

echo ""
echo "Your token is done!!"

if [[ $network == "d" ]]; then
	solana transfer $destinationWallet 3 --allow-unfunded-recipient > /dev/null 2>&1
fi 

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
		spl-token authorize -p TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb $token mint --disable
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
