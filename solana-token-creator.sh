#! /bin/bash

#This script is only for Mac and Linux
#Ez a kód kizárólag Mac és Linux rendszereken működik

# © Tatár Márton 2023

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

echo "Do you want to install the needed software? (y/n):"
read doInstall

if [[ $doInstall == "y" ]]; then
	echo "Downloading tools this will take some time..."
	echo ""
	sleep 4

	echo "Installing solana cli..."
	echo ""
	sh -c "$(curl -sSfL https://release.solana.com/v1.16.9/install)"
	sleep 1

	echo ""
	echo "Installing Rust..."
	echo ""
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	sleep 1

	echo ""
	echo "Installing spl-token..."
	echo ""
	cargo install spl-token-cli
	sleep 1

	echo ""
	echo "Installing Metaboss..."
	echo ""
	bash <(curl -sSf https://raw.githubusercontent.com/samuelvanderwaal/metaboss/main/scripts/install.sh)
	sleep 1

	echo ""
	echo "Cloning repository..."
	echo ""
	git clone https://github.com/tm01013/how-to-make-your-own-crypto.git

	echo "Tools sucesessfully downloaded"
	echo "Please restart your Terminal (close/reopen)!!"
	echo "Then use the same command as before to countinue"
	exit
else
	cd ~/how-to-make-your-own-crypto/
fi
#Create wallet

echo ""
echo "Do you vant to create a new file system wallet? This will remove your existing one! (y/n): "

read doCreateWallet
if [[ $doCreateWallet == "y" ]]; then
	solana-keygen new --force	#Create wallet
fi

wallet=$( solana address )

#Set network

echo ""
echo "Witch network do you want to use Mainnet or Devnet (m/d):"

read network
if [[ $network == "m" ]]; then
	solana config set --url https://api.mainnet-beta.solana.com
	echo "Please send 0,5 SOL to this ($wallet) wallet!"
	sleep 10
	echo "Press Enter to countinue..."
	read
elif [[ $network == "d" ]]; then
	solana config set --url https://api.devnet.solana.com
	sleep 1
	solana airdrop 4
fi

#Create token

echo ""
echo "Creating token..."

tokenRaw=$( spl-token create-token )	#Create token

token=$( echo $tokenRaw  | awk '{print $3}')

echo "Token ID: $token"

#Create token account
spl-token create-account $token

echo ""
echo "How many token do you want to mint? (0-18446744070):"

read tokenAmount

#Mint token
spl-token mint $token $(( $tokenAmount + 1 ))

##Metadata

if [[ -d ~/Desktop/Solana-token-creator ]]; then
	rm ~/Desktop/Solana-token-creator/.tmp/*
	rm ~/Desktop/Solana-token-creator/*

	rmdir ~/Desktop/Solana-token-creator/.tmp
	rmdir ~/Desktop/Solana-token-creator/
	mkdir ~/Desktop/Solana-token-creator
	mkdir ~/Desktop/Solana-token-creator/.tmp
else
	mkdir ~/Desktop/Solana-token-creator
	mkdir ~/Desktop/Solana-token-creator/.tmp
fi

#cp ~/how-to-make-your-own-crypto/token_metadata.json ~/Desktop/Solana-token-creator/token_metadata.json
#cp ~/how-to-make-your-own-crypto/token_metadata_github.json ~/Desktop/Solana-token-creator/token_metadata_github.json

#Replace wallet address to correct one
sed  's/7ztU9iXBwNLBswajozYtKBXqTTTsdxwfaCEa17xPiVaY/'"$wallet"'/g' ~/how-to-make-your-own-crypto/token_metadata.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata1.json			#sima1

echo ""
echo "How to name your token?:"
read tokenName

echo "What symbol do you want?:"
read tokenSymbol

#Replace names to correct one
sed 's/Piros pont/'"$tokenName"'/g' ~/Desktop/Solana-token-creator/.tmp/token_metadata1.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata2.json									#sima2
sed 's/Piros pont/'"$tokenName"'/g' ~/how-to-make-your-own-crypto/token_metadata_github.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata_github1.json								#github1
#Replace symbols to correct one

sed 's/PP/'"$tokenSymbol"'/g' ~/Desktop/Solana-token-creator/.tmp/token_metadata2.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata3.json											#sima3
sed 's/PP/'"$tokenSymbol"'/g' ~/Desktop/Solana-token-creator/.tmp/token_metadata_github1.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata_github2.json							#github2

echo "How to describe your token? (description):"
read tokenDescription

#Replace description to correct one
sed 's/Legpirosabb piros pont :)/'"$tokenDescription"'/g' ~/Desktop/Solana-token-creator/.tmp/token_metadata_github2.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata_github3.json	#github3


echo ""
echo "Uplad the token icon to GitHub"
sleep 4
echo "If you done paste here the link of the token icon:"
read iconLink

sed 's#https://raw.githubusercontent.com/tm01013/token-image/main/token-image.png#'"$iconLink"'#g' ~/Desktop/Solana-token-creator/.tmp/token_metadata_github3.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata_github4.json		#github4
sed 's#// .*# #g' ~/Desktop/Solana-token-creator/.tmp/token_metadata_github4.json >> ~/Desktop/Solana-token-creator/token_metadata_github.json

echo ""
echo "Uplad the 'token_metadata_github.json' file(Desktop/Solana-token-creator/) to GitHub"
echo "Follow step IV/3 in my repo (https://github.com/tm01013/how-to-make-your-own-crypto)"
sleep 4

echo "If you done paste here the link of the 'token_metadata_github.json' file:"
read metadataLink

#Replace metadata link to the correct one

sed 's#https://raw.githubusercontent.com/tm01013/token-metadata/main/token_metedata_github.json#'"$metadataLink"'#g' ~/Desktop/Solana-token-creator/.tmp/token_metadata3.json >> ~/Desktop/Solana-token-creator/.tmp/token_metadata4.json	#sima4

sed 's#// .*# #g' ~/Desktop/Solana-token-creator/.tmp/token_metadata4.json >> ~/Desktop/Solana-token-creator/token_metadata.json

#Remove temporary files
rm ~/Desktop/Solana-token-creator/.tmp/*

metaboss create metadata -a $token -m ~/Desktop/Solana-token-creator/token_metadata.json

echo ""
echo "Your token is done!!"

echo ""
echo "Enter your wallet address to transfer $tokenAmount $tokenSymbol to your wallet:"
read destinationWallet

if [[ $network == "m" ]]; then
	solana transfer $destinationWallet 0.2 --allow-unfunded-recipient
else
	solana transfer $destinationWallet 3 --allow-unfunded-recipient
fi 

spl-token transfer $token $tokenAmount $destinationWallet --fund-recipient --allow-unfunded-recipient

echo ""
echo "You're done!! 🎉 Congratulations you've created a crypo!! 🎉"