# Hogyan készítsd el a saját cryptovalutádat ingyen?

Cryptovaluta létrehozásához a követketőkre lesz szügséged:
- Akármilyen számitógépre, akár tableten is meg tudod csináln
- Egy ingyenes GitHub fiókra
- Alapvető készségekre a Terminál használatához
- Alapvető ismerettségre json kód írásához
  
> Az alább bemutatott módszer Mac, Linux és Google cloud rendszereken lett tesztelve.

 ## I. Eszközök telepítése
 
 **Mac (Terminal), Linux (Terminal), Google Cloud console:**
 ```
sh -c "$(curl -sSfL https://release.solana.com/v1.16.9/install)”
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install spl-token-cli
```	
**Windows (cmd):**
```
cmd /c "curl https://release.solana.com/v1.16.9/solana-install-init-x86_64-pc-windows-msvc.exe --output C:\solana-install-tmp\solana-install-init.exe --create-dirs"    
C:\solana-install-tmp\solana-install-init.exe v1.16.9
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install spl-token-cli
```

## II. Token létrehozása

1. Új solana fiók létrehozása(Írd fel a kimenetet!)
	```
  solana-keygen new
  ```
2. Solana konfiguráció ellenőrzése
    ```
  	solana config get
  	```

	A WebSocket sorban ha nem  api.devnet.solana.com -ot látsz akkor nem vagy a teszthálózaton akkor a token létrehozásáért fizetned kell (+ a tranzakciókért), *a teszthálózaton semminek sincs valódi pénzbeli értéke.*


3. Ha ingyenesen szeretnél tokent létrehozni ezzel "léphetsz" be a teszthálózatba.
 	```  
	solana config set --url https://api.devnet.solana.com
	```
4. Solana-t kell juttatnod a számládra, ezzel a parancsal 4 teszt SOL-t "hívsz le".
	```   
	solana airdrop 4
	```
   > 	Ha nem a tszthálózaton vagy akkor a saját számládról kell 0,5 SOL-t utalnod ide.

6. Token létrehozása (írd fel a token "címét"!)
 	```  
	spl-token create-token
	```
7. Fiók létrehozása a tokenünk számára (e nélkül nem tudnánk használni)
	```  
	spl-token create-account <token>
	```
8. Ezzel a parancsal tudsz tokent generálni. A tokenek az 1. lépésben létrahozott számlára fognak kerülni(egy számlán max 10 billió lehet).
	```   
	spl-token mint <token> <mennyiség>
	```
9. Ezzel a parancsal nézheted meg, hogy mennyi tokened van
	```   
	spl-token accounts
	```
10. Ezzel a parancsal letilthatod a további tokenek generálását (csak ha már mindennel elégedett vagy :)
	```   
	spl-token authorize <token> mint --disable
	```
## IV. Metadata hozzáadása a tokenhez
Metadata nélkül a token mindenhol “*Unknown Token*” néven fog megjelenni + ikon és szimbólum (pl:BTC) nélkül.

1. Metaboss telepítése
	```   
	bash <(curl -sSf https://raw.githubusercontent.com/samuelvanderwaal/metaboss/main/scripts/install.sh)
	```
2. Hozz létre két .json fájlt a mellékelt minták alapján, plusz egy ikont (png javasolt)
3. [Kövesd ezeket az utasításokat](/upload_to_github.md)
5. Metadata hozzáadása a tokenhez
	```   
	metaboss create metadata -a <token> -m <token_metadata.json fájl (nem a github-os)>
	```  
6. A tokened ***ELKÉSZÜLT*** :)

## V. Token használata

1. Hozz létre egy Solana tárolására alkalmas pénztárcát, például a Phantom(Android, IOS, Bővítmény Chrome-hoz) appban.
2. Ha teszthálózaton hoztál létre tokent akkor a pénztárca appban a hálózatot át kell állítanod "Mainnet"-ről "Devnet"-re
   - Phantom: "Settings" => "Developer settings" => "Testnet mode" ez után egy sérga csíkot kell látnod a képernyő tetején (újraindítás után)
   - Solflare: Beállítások => "General" => "Network" => "Devnet"
     
   - **Nem Minden alkalmazás kompatibilis a teszthálózattal!**     
3. Küld a "Token létrehozása" szakaszban lekért teszt SOL-t az új pénztárcádra (szügséged lesz rá az utalásokhoz 1SOl = +200000 utalás).

	> Ha nem a teszthálózatot használód máshogy kell SOL-t juttatnod az új számládra.
	```   
	solana transfer <pénztárca Solana címe> <mennyiség (összeset nem lehet)>
	```
4. Küld az elkészült tokeneket a pénztárcádra és egyben hozz létre ott egy fiókot a token számára(--fund-recipient). Ez után mér nem kell használnod a Terminált :).
	```
	spl-transfer <token> <mennyiség (valamennyinek maradnia kell)> <pénztárca Solana címe> --fund-recipient
	```
   > Ne feletkezz meg arról hogy mindig szügséged lesz SOL-ra a tranzakciókhoz (ha a teszthálózatot használod és elfogyna hajsd végre a II/4 és a V/3 lépéseket)
   

© *Tatár Márton 2023*

***!! Figelem a repo készítői SEMMILYEN FELELŐSSÉGET NEM VÁLLALNAK !!***
