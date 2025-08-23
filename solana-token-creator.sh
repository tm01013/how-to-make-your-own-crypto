#! /bin/bash

# This script is only for Mac and Linux

# ┌─────────────────────────[DISCLAIMER]─────────────────────────┐
# │ Only do crypto relaited stuff if it's legal in your country! │
# │              Use this script only at your risk!              │ 
# │             I DO NOT ASSUME ANY RESPONSIBILITY!              │
# │ Note:         This is not a financial advice!                │
# └──────────────────────────────────────────────────────────────┘

# Copyright: Márton Tatár 2024
# License: MIT

if [[ $1 != "--cheat" ]]; then
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
fi

# Define check if fail function
isSucesess ()
{
	if [[ ! $? -eq 0 ]]; then
		echo "────────────────[ERROR]────────────────"
		exit
	fi
}

function find_string() 
{
  local searchString="$1"
  local stringToSearchIn="$2"

  if grep -qF "$searchString" <<< "$stringToSearchIn"; then
    return 0
  else
    return 1
  fi
}

updaterMode()
{
	echo ""
	echo "Enter the token's mint address:"
	read tokenMintAddr

	echo "Select what you want to update from the following list: "
	echo " Matadata:"
	echo "  (1) Token name"
	echo "  (2) Token symbol"
	echo "  (3) Off-chain metadata uri"
	echo "  (4) Add or edit a custom metadata field"
	echo "  (5) Remove a custom metadata field"
	echo " Extension settings:"
	echo "  (10) Transfer hook program id"
	echo "  (11) Transfer fee"
	echo "  (12) UI amount multiplier"
	echo "  (13) Intrest rate"
	echo "  (14) Default account state"
	echo "  (15) Confidential trnasfer approve policy"
	echo "  (16) Group address"
	echo "  (17) Member address"
	echo " Authoritys:"
	echo "  (20) Disable mint"
	echo "  (21) Mint authority"
	echo "  (22) Permanent delegate"
	echo "  (23) Pause authority"
	echo "  (24) Freeze authority"
	echo "  (25) Transfer fee withraw authority"
	echo "  (26) Mint close authority"
	echo "  (27) Intrest rate update authority"
	read option

	case $option in

		# metadata
		1) 	echo "Enter the new name for the token:"
			read newName
			spl-token update-metadata --program-2022 $tokenMintAddr "name" "$newName" > /dev/null
			echo "This only changed the ON-CHAIN metadata!"
			echo "To make the token's name displayed as \"$newName\" you also need to change or create a new off-chain metadata"
			exit;;

		2)	echo "Enter the new symbol for the token:"
			read newSymbol
			spl-token update-metadata --program-2022 $tokenMintAddr "symbol" "$newSymbol" > /dev/null
			echo "This only changed the ON-CHAIN metadata!"
			echo "To make the token's symbol displayed as \"$newSymbol\" you also need to change or create a new off-chain metadata"
			exit;;

		3)	echo "Enter the new off-chain metadata uri for the token:"
			read newUri
			spl-token update-metadata --program-2022 $tokenMintAddr "uri" $newUri > /dev/null
			exit;;

		4)	echo "Enter the field's name:"
			read field
			echo "Enter the field's data:"
			read fieldData
			spl-token update-metadata --program-2022 $tokenMintAddr "$field" "$fieldData"
			exit;;
		
		5)	echo "Enter the field's name:"
			read field
			spl-token update-metadata --program-2022  $tokenMintAddr "$field" --remove
			exit;;

		# Extension settings:
		10)	echo "Enter the new transfer hook address:"
			read newHook
			spl-token set-transfer-hook --program-2022 $tokenMintAddr $newHook;;

		11)	echo "Enter the new fee in percentage (without the % sign):"
			read percentage
			echo "Enter the max fee in tokens: (intager grather than 0)"
			read maxFee
			spl-token set-transfer-fee --program-2022 $tokenMintAddr $(( $percentage * 100 )) $( bc <<< \"$maxFee*10^$tokenDecimals\");;
		12)	echo "Enter the UI amount multiplier:"
			read multiplier
			spl-token update-ui-amount-multiplier --program-2022 $tokenMintAddr $multiplier;;
		13)	echo "Enter the new interest rate in percentage (without the % sign):"
			read percentage
			spl-token set-interest-rate --program-2022 $tokenMintAddr $(( $percentage * 100 ));;

		14)	echo "Enter the new default account state initialized(i) or frozen(f) : (i/f)"
			read newPolicy
			if [[ $newPolicy == "i" ]];then
				spl-token update-default-account-state --program-2022 $tokenMintAddr initialized
			elif [[ $newPolicy == "f" ]]; then
				spl-token update-default-account-state --program-2022 $tokenMintAddr frozen
			fi
			if [[ $newPolicy != "i" && $newPolicy != "f" ]]; then
				echo "[Error] The only possible choices are 'i' and 'f'!"
			fi;;

		15)	echo "Enter the new approve policy manual(m) or auto(a) : (m/a)"
			read newPolicy
			if [[ $newPolicy == "m" ]];then
				spl-token update-confidential-transfer-settings --program-2022 --approve-policy manual $tokenMintAddr
			elif [[ $newPolicy == "a" ]]; then
				spl-token update-confidential-transfer-settings --program-2022 --approve-policy auto $tokenMintAddr
			else
				echo "[Error] The only possible choices are 'a' and 'm'!"
			fi;;

		16)	echo "Enter the new group address:"
			read newGroup
			spl-token update-group-address --program-2022 $tokenMintAddr $newGroup;;

		17)	echo "Enter the new member address:"
			read newMember
			spl-token update-member-address --program-2022 $tokenMintAddr $newMember;;

		#Authoritys:
		20) echo "┌─────────────────────────!!WARNING!!─────────────────────────┐"
			echo "│ If you disable mint you cannot get any more of your token!  │"
			echo "│ This operation cannot be undone!                            │"
			echo "│ Please check everithing is correct before countinue!        │"
			echo "└─────────────────────────────────────────────────────────────┘"
			echo "Do you want to countinue? (y/n):"
			read countinue
			if [[ $continue == "y" ]];then
				spl-token authorize --program-2022 $tokenMintAddr mint --disable
			fi;;

		21)	echo "Enter the new mint authority address:"
			read newAuthority
			spl-token authorize --program-2022 $tokenMintAddr mint $newAuthority;;

		22)	echo "Enter the new permanent delegate authority address:"
			read newAuthority
			spl-token authorize --program-2022 $tokenMintAddr permanent-delegate $newAuthority;;
		23)	echo "Enter the new Pause authority address:"
			read newAuthority
			spl-token authorize --program-2022 $tokenMintAddr pause $newAuthority;;
		24)	echo "Enter the new freeze authority address or 'disable' to disable freezing:"
			read newAuthority
			if [[ $newAuthority != "disable" ]]; then
				spl-token authorize --program-2022 $tokenMintAddr freeze $newAuthority
			else
			echo "┌───────────────────────────────!!WARNING!!──────────────────────────────┐"
			echo "│ If you disable freezing all frozen accounts will stay frozen forever!  │"
			echo "│ This operation cannot be undone!                                       │"
			echo "│ Please check everithing is correct before countinue!                   │"
			echo "└────────────────────────────────────────────────────────────────────────┘"
			echo "Do you want to countinue? (y/n):"
			read countinue
				if [[ $continue == "y" ]];then
					spl-token authorize --program-2022 $tokenMintAddr freeze --disable
				fi
			fi;;

		
		25)	echo "Enter the new transfer fee withraw authority address:"
			read newAuthority
			spl-token authorize --program-2022 $tokenMintAddr withheld-withdraw $newAuthority;;

		26)	echo "Enter the new mint close authority address or 'disable' to disable closeing the mint:"
			read newAuthority
			if [[ $newAuthority != "disable" ]]; then
				spl-token authorize --program-2022 $tokenMintAddr close-mint $newAuthority
			else
			echo "WARNIG! THIS OPERATION CANNOT BE UNDONE!!"
			echo "Do you want to countinue? (y/n):"
			read countinue
				if [[ $continue == "y" ]];then
					spl-token authorize --program-2022 $tokenMintAddr close-mint --disable
				fi
			fi;;


		27)	echo "Enter the new intrest rate update authority address:"
			read newAuthority
			spl-token authorize --program-2022 $tokenMintAddr interest-rate $newAuthority;;
		
		*) echo "The selected option is invalid!"
			exit;;
	esac
}

cheatSheat()
{
	echo "────────────────────────SPL cli cheat sheat────────────────────────"
	echo "New token program addr: TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb"
	echo ""
	echo "Token transfer:"
	echo "  spl-token transfer <token> <amount> <recipient>"
	echo "Token creation all in one:"
	echo "  spl-token create-token --program-2022"
	echo "  spl-token create-account <token>"
	echo "  spl-token mint <token> <amount>"
	echo "Max token that can hold on a single account or created in a single instruction ="
	echo "  (2^64 - 1) / (10^token decimals)"
	echo ""
	echo "Destroy tokens:"
	echo "  spl-token burn <ACCOUNT> <amount>"
	echo ""
	echo "Check balance:"
	echo "  SOL: solana balance"
	echo "  token: spl-token accounts"
	echo "Airdrop devnet sol:" 
	echo "  solana airdrop 4"
	echo ""
	echo "Change network:"
	echo "  solana config -u <rpc addr>"
	echo " Mainnet: https://api.mainnet-beta.solana.com"
	echo " Devnet: https://api.devnet.solana.com"
	echo ""
	echo "Grind special address for tokens, wallets or accounts:"
	echo "  solana-keygen grind --starts-with <phrase>:2 --ignore-case"
	echo "  solana-keygen grind --starts-and-ends-with <start phrase>:<end phrase>:2 --ignore-case"
	echo "  solana-keygen grind --ends-with <phrase>:2 --ignore-case"
	echo " Avarage time to grind:"
	echo "  1-3 letters: within 1 - 5 minutes"
	echo "  4 letters: 10 - 30 minutes (depandeing on your computer)"
	echo "  5 letters: 1 - 2 hours (can slower on weaker computer)"
	echo "  6 letters: 12 - 24 hours (can slower on weaker computer)"
	echo ""
}

tools()
{
	echo "Select a tool: (1-6)"
	echo "  (1) Transfer tokens as delegate"
	echo "  (2) Burn tokens as delegate"
	echo "  (3) Collect transfer fee from token account"
	echo "  (-) Collect all transfer fees"
	echo "  (4) Freeze token account"
	echo "  (5) Unfreeze(thaw) token account"
	echo "  (6) Mint tokens"
	read option

	case $option in

		1) 	echo "Enter the token mint:"
			read token
			echo "Enter the from account address:"
			read from
			echo "Enter amount in tokens:"
			read amount
			echo "Enter reciver wallet address:"
			read to
			spl-token transfer --from $from $token $amount $to --allow-unfunded-recipient --fund-recipient;;
		2)  echo "Enter the account to burn from:"
			read burnFromAccount
			echo "Enter the amount to burn in tokens:"
			read amount
			spl-token burn $burnFromAccount $amount;;
		3) 	echo "Enter the account to recive fees or leave empty for your own:"
			read reciver
			echo "Enter the token account(s) to withraw from, separated by spaces:"
			read fromAccounts
			spl-token withdraw-withheld-tokens --program-2022 $reciver $fromAccounts;;
		-)  echo "This feature is currently not supported by the cli."
			echo "When it get supported i will add it here";;
		4)	echo "Enter an account to freeze:"
			echo freezeAccount
			spl-token freeze --program-2022 $freezeAccount;;
		5)  echo "Enter an account to unfreeze:"
			echo unfreezeAccount
			spl-token thaw --program-2022  $unfreezeAccount;;

		6)	echo "Enter the token's mint address:"
			read token
			json=$( curl http://$(solana config get | grep -o 'RPC URL: .*' | grep -o '[^/]*$') -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0","id": 1,"method": "getAccountInfo","params": ["'$token'",{"encoding": "jsonParsed"}]}g' )
			tokenDecimals=$( echo $json | grep -o 'decimals:[^,]*' | grep -o '[^:]*$g' )
			maxAmountInAbsolute=18446744073709551615
			maxAmountInTokens=$( bc <<< $maxAmountInAbsolute/10^$tokenDecimals )
			isSucesess
			echo "How many tokens you want to mint? (1-$maxAmountInTokens)"
			read tokenAmount
			if [[ $(bc <<< "$tokenAmount>$maxAmountInTokens") == "1" ]]; then
				echo ""
				echo "The entered amount is too big!"
				echo "Maximum amount is $maxAmountInTokens tokens!"
				echo ""
				echo "Enter a new amount (1-$maxAmountInTokens):"
				read tokenAmount
			fi
			if [[ $(bc <<< "$tokenAmount>$maxAmountInTokens") == "1" ]]; then
				echo ""
				echo "The entered amount is too big!"
				echo "Maximum amount is $maxAmountInTokens tokens!"
				echo ""
				echo "Enter a new amount (1-$maxAmountInTokens):"
				read tokenAmount
			fi
			echo "Enter the recipients wallet address or leave empty for your own:"
			read destinationWallet
			if [[ $destinationWallet == "" ]]; then
				destinationWallet=$(solana address)
			fi
			accountRaw=$( spl-token create-account --program-2022 --owner $destinationWallet --fee-payer $HOME/.config/solana/id.json $token )
			account=$( echo $accountRaw  | awk '{print $3}g' )
			spl-token mint --program-2022 $token $tokenAmount $account;;


		*) echo "[ERR] The selected option is invalid!";;
	esac

	exit
}

parseArguments()
{
	# -r --recipient				recipient
	# -d --decimals 				decimals
	# -e --extensions 				extensions
	# -th --transfer-hook 			transfer hook program id
	# -tf --transfer-fee 			trnasfer fee in percentage
	# -mf --max-fee 				max fee in tokens
	# -ir --intrest-rate 			intrest rate
	# -das --default-account-state 	default account state
	# -gc --group-config 			group config (addr/max amount of tokens)
	# -mc --member-config			member config
	# -na --name						token name
	# -s --symbol					token symbol
	# -ds --description				token description
	# -i --icon-url					icon url
	# -m --offchain-metadata		off-chain metadata url
	# -k --keypair					token keypair
	# -a --amount					token amount
	# -n --network					network

	local recipient="null"
	local decimals="null"
	local extensions="null"
	local transferHook="null"
	local transferFee="null"
	local maxFee="null"
	local intrestRate="null"
	local defaultAccountState="null"
	local groupConfigAddr="null"
	local maxTokensInGroup="null"
	local memberConfigAddr="null"
	local doCreateNewMemberConfig=false
	local tokenName="null"
	local tokenSymbol="null"
	local tokenDescription="null"
	local tokenIcon="null"
	local OffChainMetadata="null"
	local tokenKeypair="null"
	local amount="null"
	local network="null"

	while [[ $# -gt 0 ]]; do
    	key="$1"

    	case $key in
			--advanced) shift;;
			--quick) shift;;
			--tools) shift;;
    	    -r|--recipient)
    	        recipient="$2"
				shift
    	        shift
    	        ;;
    	    -d|--decimals)
    	        decimals=$2
				shift
    	        shift
    	        ;;
    	    -e|--extensions)
    	        if [[ $2 =~ '-.*' ]]; then
					extensions=""
					shift
				else
    	        	extensions="$2"
    	        	shift
    	        	shift
				fi
    	        ;;

    	    -th|--transfer-hook)
    	        transferHook="$2"
    	        shift
    	        shift
    	        ;;
    	    -tf|--transfer-fee)
    	        transferFee=$2
    	        shift
    	        shift
    	        ;;
    	    -mf|--max-fee)
    	        maxFee=$2
    	        shift
    	        shift
    	        ;;
    	    -ir|--intrest-rate)
    	        intrestRate=$2
    	        shift
    	        shift
    	        ;;
    	    -das|--default-account-state)
    	        if [[ $2 == "i" || $2 == "initialized" ]];then
					defaultAccountState="initialized"
				elif [[ $2 == "f" || $2 == "frozen" ]]; then
					defaultAccountState="frozen"
				fi
    	        shift
    	        shift
    	        ;;
    	    -gc|--group-config) 
				if ! [[ $2 =~ '^[0-9]+' ]]; then 
					groupConfigAddr="$2"
				else
					maxTokensInGroup=$2
					groupConfigAddr=""
				fi
    	        shift
    	        shift
    	        ;;
    	    -mc|--member-config)
    	        if [[ $2 =~ '^-.*' ]]; then
					doCreateNewMemberConfig=true
					memberConfigAddr=""
					shift
				else
					memberConfigAddr="$2"
					shift
					shift
				fi
    	        ;;
    	    -na|--name)
    	        if [[ $2 =~ '-.*' ]]; then
					tokenName=""
					shift
				else
    	        	tokenName="$2"
    	        	shift
    	        	shift
				fi
    	        ;;
    	    -s|--symbol)
    	        if [[ $2 =~ '-.*' ]]; then
					tokenSymbol=""
					shift
				else
    	        	tokenSymbol="$2"
    	        	shift
    	        	shift
				fi
    	        ;;
    	    -ds|--description)
				tokenDescription="$2"
    	        shift
				shift
    	        ;;
    	    -i|--icon-url)
    	        tokenIcon="$2"
    	        shift
    	        shift
    	        ;;
    	    -m|--offchain-metadata)
    	        OffChainMetadata="$2"
    	        shift
				shift
    	        ;;
    	    -k|--keypair)
				if [[ $2 =~ '-.*' ]]; then
					tokenKeypair=""
					shift
				else
    	        	tokenKeypair="$2"
    	        	shift
    	        	shift
				fi
    	        ;;
    	    -a|--amount)
    	        amount=$2
    	        shift
    	        shift
    	        ;;
    	    -n|--network)
    	        network="$2"
    	        shift
    	        shift
    	        ;;
    	    " ")  shift;;
			*)
    	        echo "Unknown option: $1"
    	        exit 1
    	        ;;
    	esac
	done

	# n	 noextension 			-> 0
	# nt nontransfarable		-> 1
	# ct confidentialtransfer	-> 2
	# tf transferfee			-> 3
	# th transferhook			-> 4
	# pd permanentdelegate		-> 5
	# mc mintclose				-> 6
	# ib intrestbearing			-> 7
	# das defaultaccountstate	-> 8
	# f freeze					-> 9
	# gc groupconfig			-> 10
	# pd memberconfig			-> 11

		extensions=",$extensions,"
		extensions=$( echo "$extensions" | sed 's/,n,/,0,/g' )
		extensions=$( echo "$extensions" | sed 's/,nt,/,1,/g' )
		extensions=$( echo "$extensions" | sed 's/,ct,/,2,/g' )
		extensions=$( echo "$extensions" | sed 's/,tf,/,3,/g' )
		extensions=$( echo "$extensions" | sed 's/,th,/,4,/g' )
		extensions=$( echo "$extensions" | sed 's/,pd,/,5,/g' )
		extensions=$( echo "$extensions" | sed 's/,mc,/,6,/g' )
		extensions=$( echo "$extensions" | sed 's/,ib,/,7,/g' )
		extensions=$( echo "$extensions" | sed 's/,das,/,8,/g' )
		extensions=$( echo "$extensions" | sed 's/,f,/,9,/g' )
		extensions=$( echo "$extensions" | sed 's/,gc,/,10,/g' )
		extensions=$( echo "$extensions" | sed 's/,pd,/,11,/g' )

		extensions=$( echo "$extensions" | sed 's/,noextension,/,0,/g' )
		extensions=$( echo "$extensions" | sed 's/,nontransfarable,/,1,/g' )
		extensions=$( echo "$extensions" | sed 's/,confidentialtransfer,/,2,/g' )
		extensions=$( echo "$extensions" | sed 's/,transferfee,/,3,/g' )
		extensions=$( echo "$extensions" | sed 's/,transferhook,/,4,/g' )
		extensions=$( echo "$extensions" | sed 's/,permanentdelegate,/,5,/g' )
		extensions=$( echo "$extensions" | sed 's/,mintclose,/,6,/g' )
		extensions=$( echo "$extensions" | sed 's/,intrestbearing,/,7,/g' )
		extensions=$( echo "$extensions" | sed 's/,defaultaccountstate,/,8,/g' )
		extensions=$( echo "$extensions" | sed 's/,freeze,/,9,/g' )
		extensions=$( echo "$extensions" | sed 's/,groupconfig,/,10,/g' )
		extensions=$( echo "$extensions" | sed 's/,memberconfig,/,11,/g' )

		extensions=$( echo "$extensions" | sed 's/^,//g' )
		extensions=$( echo "$extensions" | sed 's/,$//g' )

	if [[ $transferHook != "null" ]]; then
		if ! [[ $extensions =~ '4' ]]; then extensions="${extensions},4"; fi
	fi
	if [[ $transferFee != "null" ]]; then
		if ! [[ $extensions =~ '3' ]]; then extensions="${extensions},3"; fi
	fi
	if [[ $maxFee != "null" ]]; then
		if ! [[ $extensions =~ '3' ]]; then extensions="${extensions},3"; fi
	fi
	if [[ $intrestRate != "null" ]]; then
		if ! [[ $extensions =~ '7' ]]; then extensions="${extensions},7"; fi
	fi
	if [[ $defaultAccountState != "null" ]]; then
		if ! [[ $extensions =~ '8' ]]; then extensions="${extensions},8"; fi
	fi
	if [[ $groupConfigAddr != "null" ]]; then
		if ! [[ $extensions =~ '10' ]]; then extensions="${extensions},10"; fi
	fi
	if [[ $maxTokensInGroup != "null" ]]; then
		if ! [[ $extensions =~ '10' ]]; then extensions="${extensions},10"; fi
	fi
	if [[ $memberConfigAddr != "null" ]]; then
		if ! [[ $extensions =~ '11' ]]; then extensions="${extensions},11"; fi
	fi
	if [[ $doCreateNewMemberConfig != false ]]; then
		if ! [[ $extensions =~ '11' ]]; then extensions="${extensions},11"; fi
	fi
	
	echo "\"$network\"|\"$tokenName\"|\"$tokenSymbol\"|\"$tokenDescription\"|\"$tokenIcon\"|\"$OffChainMetadata\"|\"$recipient\"|\"$decimals\"|\"$tokenKeypair\"|\"$amount\"|\"$extensions\"|\"$transferHook\"|\"$transferFee\"|\"$maxFee\"|\"$intrestRate\"|\"$defaultAccountState\"|\"$groupConfigAddr\"|\"$maxTokensInGroup\"|\"$memberConfigAddr\"|\"$doCreateNewMemberConfig\""
}

OS=""
# Check if os is supported
case "$OSTYPE" in
    solaris*) echo "Unsupported operating system: 'Solaris'"
			  exit;;

    darwin*)  OS="mac";; 
    linux*)   OS="linux";;

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
isBcInstalled="y"

# Check if solana is installed
PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
solana --version > /dev/null
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isSolanaInstalled="n"

else
	solanaVersion=$( solana --version | awk '{print $2}g' )
	if [[ "$(printf "%s\n" "2.3.8" "$solanaVersion" | sort -V | head -n 1)" != "2.3.8" ]]; then
    	echo "The installed version of Solana is outdated, update required"
		isAllInstalled="n"
		isSolanaInstalled="n"
	fi
fi

# Check if spl-token is installed
spl-token --version > /dev/null
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isSolanaInstalled="n"
fi

# check if bc is installed
bc --version > /dev/null
if [[ ! $? -eq 0 ]]; then
	isAllInstalled="n"
	isBcInstalled="n"
fi

# If something is not installed install everithing
if [[ $isAllInstalled == "n" ]]; then
	echo "[!] Installation required, do you want to countinue? (y/n):"
	read doInstall

	if [[ $doInstall == "n" ]]; then
		exit
	fi

	if [[ $doInstall == "y" ]]; then

		echo "Downloading tools this will take some time..."
		sleep 4

		if [[ $isSolanaInstalled == "n" ]]; then
			echo ""
			echo "Installing solana cli..."
			echo ""
			sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
			isSucesess
			PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
			sleep 1
		fi

		if [[ $isBcInstalled == "n" ]]; then
			echo ""
			echo "Installing bc..."
			echo ""
			if [[ $OS == "linux" ]]; then
				if [[ $(whoami) != "root" ]]; then
					echo "[ERROR] To proceed installation you nee to be root!"
					exit
				fi
				sudo apt update | apt install -y bc
			fi
			if [[ $OS == "mac" ]]; then
				brew --version
				if [[ ! $? -eq 0 ]]; then
					echo "[ERROR] Install Homebrew before countinuing!"
					exit
				fi
				brew install bc
			fi
		fi

		echo ""
		echo "Tools sucesessfully downloaded"
		echo "Add this line to your .bashrc file: export PATH=\"\$HOME/.local/share/solana/install/active_release/bin:\$PATH\""
		echo "Than close and reopen your terminal and start again!"
		exit
	fi
fi

if [[ $1 == "--updater-mode" ]]; then
	updaterMode
	exit
fi

if [[ $1 == "--cheat" ]]; then
	cheatSheat
	exit
fi

if [[ $1 == "--tools" ]]; then
	tools
	exit
fi

isAdvanced=false
if [[ $1 == "--advanced" ]]; then
	isAdvanced=true
fi

#Create wallet
solana address > /dev/null
if [[ ! $? -eq 0 ]]; then
	echo ""
	echo "[?] Do you vant to create a new file system wallet? (y/n): "
	read doCreateWallet
	if [[ $doCreateWallet == "y" ]]; then
		solana-keygen new --force	#Create wallet
		isSucesess
	else
		exit
	fi
fi

wallet=$( solana address )
isSucesess
echo ""
echo "Wallet address: $wallet"


# Collectively initialize all variables
parsedArguments="$(parseArguments $*)"
if [[ ! $? -eq 0 ]]; then
	echo "────────────────[ERROR]────────────────"
	echo $parsedArguments
	exit
fi
counter=1
IFS='|' read -ra elements <<< "$parsedArguments"
for element in "${elements[@]}"
do
	#echo "$counter - $element"
	element=${element//\"/}
	case $counter in
		1) network=$element;;
		2) tokenName=$element;;
		3) tokenSymbol=$element;;
		4) tokenDescription=$element;;
		5) iconLink=$element;;
		6) metadataLink=$element;;
		7) recipientWallet=$element;;
		8) tokenDecimals=$element;;
		9) keypair=$element;;
		10) tokenAmount=$element;;
		11) tokenExtensionId=$element;;
		12) hookProgramId=$element;;
		13) transferFee=$element;;
		14) maxTransferFee=$element;;
		15) intrestRate=$element;;
		16) defaultAccountState=$element;;
		17) groupConfigAddr=$element;;
		18) maxInGroup=$element;;
		19) memberConfigAddr=$element;;
		20) isMemberNeedToBeInitialized=$element;;
	esac
	counter=$(( $counter + 1 ))
done
#Set network
setNetModeIsQuiet=true
if [[ $network == "null" ]]; then
	setNetModeIsQuiet=false
	echo ""
	echo "[?] Witch network do you want to use Mainnet(m) / Devnet(d) / custom(rpc address) or not change(n):"
	read network
fi

if [[ $network == "m" ]]; then
	solana config set --url https://api.mainnet-beta.solana.com #> /dev/null
	isSucesess
	if [[ $setNetModeIsQuiet == false ]]; then
		echo "[!] Please send 0,5 SOL to this ($wallet) wallet!"
		sleep 4
		echo "[»] Press Enter to countinue..."
		read
	fi
fi
if [[ $network == "d" ]]; then
	solana config set --url https://api.devnet.solana.com > /dev/null
	isSucesess
	sleep 1
	solana airdrop 4
fi
if [[ $network != "n" && $network != "d" && $network != "m" ]]; then
	solana config set --url $network > /dev/null
	isSucesess
	sleep 1
	solana airdrop 4 > /dev/null
fi

#Create token
if [[ $tokenDecimals == "null" ]];then
	echo ""
	echo "[?] How many decimals do you want? (1-10):"
	read tokenDecimals
fi

if [[ $tokenExtensionId == "null" ]]; then
echo ""
if [[ isAdvanced == true ]]; then
	echo "[?] Select a token extensions and other settings from the following list, separated by commas: (0-13)"
else
	echo "[?] Select a token extensions and other settings from the following list, separated by commas: (0-11)"
fi
echo "    Details in the solana docs: https://www.solana-program.com/docs/token-2022/extensions"
echo "  (0) No extensions, just a simple token"
echo "  (1) Non transfarable"
echo "  (2) Confidential transfer"
echo "  (3) Transfer fees"
echo "  (4) Transfer Hook"
echo "  (5) Pause"
echo "  (6) Permanent Delegate"
echo "  (7) Mint Close Authority"
echo "  (8) Scaled UI Amount"
echo "  (9) Interest-Bearing"
echo "  (10) Default Account State"
echo "  (11) Enable freeze"
if [[ isAdvanced == true ]]; then
echo "  (12) Group configuration"
echo "  (13) Member configuration"
fi
read tokenExtensionId
fi

echo ""
tokenExtensionsParsed=""
accountFlagsParsed=""

isOption1Used=false
isOption2Used=false
isOption3Used=false
isOption4Used=false
isOption5Used=false
isOption6Used=false
isOption7Used=false
isOption8Used=false
isOption9Used=false
isOption10Used=false
isOption11Used=false
isOption12Used=false
isOption13Used=false

isGroupNeedToBeInitialized=false

IFS=',' read -ra elements <<< "$tokenExtensionId"

for element in "${elements[@]}"
do
	case "$element" in
		0) 	tokenExtensionsParsed=""
			break;;

		1)	if [[ $isOption1Used == false ]];then
				isOption1Used=true				
				tokenExtensionsParsed="${tokenExtensionsParsed} --enable-non-transferable"

			fi;;

		2) 	if [[ $isOption2Used == false ]];then
				isOption2Used=true
				echo "[2] Before be able to use your confidetial token you need read the docs! (https://spl.solana.com/confidential-token/quickstart)"
				tokenExtensionsParsed="${tokenExtensionsParsed} --enable-confidential-transfers auto"
			fi;;

		3) 	if [[ $isOption3Used == false ]];then
				isOption3Used=true
				if [[ $transferFee == "null" ]];then
					echo "[3] Enter transfer fee in percentage: (without the % sign)"
					read transferFee
				fi
				if [[ $maxTransferFee == "null" ]]; then
					echo "[3] Enter the maximum transfer fee in tokens: (intager grather than 0)"
					read maxTransferFee
				fi
				tokenExtensionsParsed="${tokenExtensionsParsed} --transfer-fee $(($transferFee * 100)) $( bc <<< \"$maxTransferFee*10^$tokenDecimals\")"
			fi;;

		4) 	if [[ $isOption4Used == false ]];then
				isOption4Used=true
				if [[ $hookProgramId == "null" ]]; then
					echo "[4] Enter the hook program id:"
					read hookProgramId
				fi
				tokenExtensionsParsed="${tokenExtensionsParsed} --transfer-hook $hookProgramId"
			fi;;

		5)	if [[ $isOption5Used == false ]];then
				isOption5Used=true
				tokenExtensionsParsed="${tokenExtensionsParsed} --enable-pause"
			fi;;

		6)	if [[ $isOption6Used == false ]];then
				isOption6Used=true
				tokenExtensionsParsed="${tokenExtensionsParsed} --enable-permanent-delegate"
			fi;;

		7) 	if [[ $isOption7Used == false ]];then
				isOption7Used=true
				tokenExtensionsParsed="${tokenExtensionsParsed} --enable-close"
			fi;;

		8)	if [[ $isOption8Used == false ]];then
				isOption8Used=true
					echo "[8] Enter the UI amount multiplier:"
					read uiMultiplier
				tokenExtensionsParsed="${tokenExtensionsParsed} --ui-amount-multiplier $uiMultiplier"
			fi;;

		9)	if [[ $isOption9Used == false ]];then
				isOption9Used=true
				if [[ $intrestRate == "null" ]]; then
					echo "[9] Enter the intrest rate in percentage (without the % sign):"
					read intrestRate
				fi
				tokenExtensionsParsed="${tokenExtensionsParsed} --interest-rate $($intrestRate * 100)"
			fi;;
	
		10)	if [[ $isOption10Used == false ]];then
				isOption10Used=true
				if [[ $defaultAccountState == "null" ]]; then
					echo "[10] Select the default account state: initialized(i) frozen(f):"
					read defaultAccountState
					if [[ $defaultAccountState == "i" ]]; then defaultAccountState="initialized"
					elif [[ $defaultAccountState == "f" ]]; then defaultAccountState="frozen"
					fi
				fi
				tokenExtensionsParsed="${tokenExtensionsParsed} --default-account-state $defaultAccountState --enable-freeze"
			fi;;

		11) 	if [[ $isOption11Used == false ]]; then
				isOption11Used=true
				if [[ $(find_string "11" "$tokenExtensionId") == "1" ]]; then
					tokenExtensionsParsed="${tokenExtensionsParsed} --enable-freeze"
				fi
			fi;;

		12) if [[ $isOption12Used == false ]]; then
				isOption12Used=true
				if [[ $groupConfigAddr == "null" ]]; then
					echo "[12] Specify address that stores token group configurations or leave empty to initialize a new group on the mint:"
					read groupConfigAddr
				fi
				if [[ $groupConfigAddr != "" ]]; then
					tokenExtensionsParsed="${tokenExtensionsParsed} --group-address $groupConfigAddr"
				else
					tokenExtensionsParsed="${tokenExtensionsParsed} --enable-group"
					isGroupNeedToBeInitialized=true
				fi
			fi;;

		13) if [[ $isOption13Used == false ]]; then
				isOption13Used=true
				if [[ $memberConfigAddr == "null" ]]; then
					echo "[13] Specify address that stores token member configurations or leave empty to initialize a new member on the mint:"
					read memberConfigAddr
				fi
				if [[ $memberConfigAddr != "" ]]; then
					tokenExtensionsParsed="${tokenExtensionsParsed} --member-address $memberConfigAddr"
				else
					tokenExtensionsParsed="${tokenExtensionsParsed} --enable-member"
					isMemberNeedToBeInitialized=true
				fi
			fi;;

		*) 	echo "Option '$element' is invalid, skipping it";;
	esac
done

if [[ $recipientWallet == "null" ]]; then
	echo "[?] Enter the recipient wallet address: (empty for your own)"
	read recipientWallet
	if [[ $recipientWallet == "" ]]; then
		recipientWallet=$wallet
	fi
fi

if [[ $keypair == "null" ]]; then
	echo "[?] Enter the path for the token's keypair or leave empty for random:"
	read keypair
fi

echo ""
echo "Creating token..."

tokenRaw=$( spl-token create-token --program-2022 --enable-metadata --decimals $tokenDecimals $tokenExtensionsParsed $keypair)	#Create token
isSucesess

token=$( echo $tokenRaw  | awk '{print $3}')

echo "Token ID: $token"

if [[ isGroupNeedToBeInitialized == true ]]; then
	if [[ $maxInGroup == "null" ]]; then
		echo "[Group config] Enter the max amount of token mints that can belong to this group:"
		read maxInGroup
	fi
	spl-token initialize-group $token $maxInGroup --update-authority $wallet > /dev/null
	isSucesess
fi
if [[ isMemberNeedToBeInitialized == true ]]; then
	spl-token initialize-member $token --update-authority $wallet > /dev/null
	isSucesess
fi

#Create token account
accountRaw=$( spl-token create-account --program-2022 --owner $recipientWallet --fee-payer $HOME/.config/solana/id.json $token )
isSucesess
account=$( echo $accountRaw  | awk '{print $3}g' )

echo "Token account ID: $account"

maxAmountInAbsolute=18446744073709551615
maxAmountInTokens=$( bc <<< $maxAmountInAbsolute/10^$tokenDecimals )
isSucesess

if [[ $tokenAmount == "null" ]]; then
	echo ""
	echo "[?] How many token do you want to mint? (1-$maxAmountInTokens):"
	read tokenAmount
fi

if [[ $(bc <<< "$tokenAmount>$maxAmountInTokens") == "1" ]]; then
	echo ""
	echo "[ERR] The entered amount is too big!"
	echo "[!!!] Maximum amount is $maxAmountInTokens tokens!"
	echo ""
	echo "[?] Enter a new amount (1-$maxAmountInTokens):"
	read tokenAmount
fi
if [[ $(bc <<< "$tokenAmount>$maxAmountInTokens") == "1" ]]; then
	echo ""
	echo "[ERR] The entered amount is too big!"
	echo "[!!!] Maximum amount is $maxAmountInTokens tokens!"
	echo ""
	echo "[?] Enter a new amount (1-$maxAmountInTokens):"
	read tokenAmount
fi

#Mint token
echo ""
echo "Minting token..."
spl-token mint $token $tokenAmount $account > /dev/null
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

if [[ $tokenName == "null" ]]; then
	echo ""
	echo "[?] How to name your token?:"
	read tokenName
fi

if [[ $tokenSymbol == "null" ]]; then
	echo "[?] What symbol do you want?:"
	read tokenSymbol
fi

if [[ $tokenDescription == "null" ]]; then
	echo "[?] Enter a description for your token:"
	read tokenDescription
fi

if [[ $iconLink == "null" ]]; then
	echo ""
	echo "[!] Uplad the token icon to IPFS (pinata) or any other service"
	sleep 4
	echo "[?] If you done paste here the link of the token icon:"
	read iconLink
fi

OffChainMetadata="{ \"name\": \"$tokenName\", \"symbol\": \"$tokenSymbol\", \"description\": \"$tokenDescription\", \"image\": \"$iconLink\", \"attributes\": [], \"properties\": { \"files\": [ { \"uri\": \"$iconLink\", \"type\": \"image/png\" } ] } }"

echo "$OffChainMetadata" >> $HOME/Solana-token-creator/off-chain_token_metadata.json

if [[ $metadataLink == "null" ]]; then
	echo ""
	echo "[!] Uplad the 'off-chain_token_metadata.json' file($HOME/Solana-token-creator/) to IPFS (pinata)"
	sleep 4

	echo "[?] If you done paste here the link of the file:"
	read metadataLink
fi

spl-token initialize-metadata $token "$tokenName" "$tokenSymbol" "$metadataLink" -v --program-2022 > /dev/null
isSucesess

echo ""
echo "────────────────────────────────────[Your token is done]────────────────────────────────────"

if [[ $network == "m" ]]; then
	echo ""
	echo "[>] View on solscan: https://solscan.io/token/$token"
else
	echo ""
	echo "[>] View on solscan: https://solscan.io/token/$token?cluster=devnet"
fi

echo ""
echo "    Don't worry if you see your token as "Unrecognised Token" just wait 2-4 minutes to let the network process the changes"

echo ""
echo "[?] Do you want to disable mint? (y/n):"
read doDisableMint

if [[ $doDisableMint == "y" ]]; then
	echo "    ┌──────────────────────────[WARNING]──────────────────────────┐"
	echo "    │ If you disable mint you cannot get any more of your token!  │"
	echo "    │ This operation cannot be undone!                            │"
	echo "    │ Please check everithing is correct before countinue!        │"
	echo "    └─────────────────────────────────────────────────────────────┘"
	sleep 3
	echo ""
	echo "    [?] Do you want to countinue? (y/n):"
	read doCountinue

	if [[ $doCountinue == "y" ]]; then
		spl-token authorize --program-2022 $token mint --disable > /dev/null
		isSucesess
	fi
fi

echo ""
echo "───────────────────────────────────────────────────────────────────────────────────────────"
echo "[>] You're done!! 🎉 Congratulations you've created a crypo!! 🎉"
if [[ $network == "m" ]]; then
	echo "[>] View on solscan: https://solscan.io/token/$token"
else
	echo "[>] View on solscan: https://solscan.io/token/$token?cluster=devnet"
fi
echo ""
echo "[>] If you found my script useful don't forget to leave a star ✨ on my repo! Thank you! 😍"