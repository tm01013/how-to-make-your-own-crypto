# Hogyan készítsd el a saját cryptovalutádat ingyen?

> **_For English version click [here](./README.en.md)_**

Cryptovaluta létrehozásához a követketőkre lesz szügséged:

- Akármilyen számitógépre, akár tableten is meg tudod csinálni
- Egy ingyenes GitHub fiókra
- Alapvető készségekre a Terminál(vagy cmd) használatához
- Alapvető ismerettségre json kód írásához
- Internetkapcsolat

> Az alább bemutatott módszer Mac, Linux és Google cloud rendszereken lett tesztelve.

### Ez hogyan is működik?

Először is nem egy _"cryriptovalutát"_ hozunk létre (mii??), hanem egy _Tokent_.

- A tokeneknek nincs saját blokkláncuk és hálózatuk, hanem egy meglévő cryptovaluta hálózatát használják (esetünkben a Solana-áét).
- Egy _"cryptovalutának"_ a létrehozásához **_nagyon magas_** szintű programozási készségek kellenek és **sok** erőforrás valamint idő.
- Viszont egy token létrehozása nagyon egyszerű valamint az elkészült token funkciója majdnem **_MEGEGGYEZIK_** egy cryptovalutáéval (na jó csak 99%-ban). <br><br>
- Lényegében egy **_saját cryptovalutát_** fogsz létrehozni **_saját blokklánc_** nálkül

Most már mindent tisztáztunk, kezdhetjük:

---

# Token creator

A _solana-token-creator_ segítségével 2 perc alatt elkészítheted a cryptovalutádat mindössze 1 paranccsal!

1. Tölsd le a repo-t (_Code_ => _Download Zip_)
2. Nyisd meg a Terminált(Windows-al jelenleg nem kompatibilis) írd be az alábbi parancsot:
   ```bash
   bash <solana-token-creator.sh fájl>
   ```
3. Először meg fogja kérdenzi, hogy a szügséges programokat telepítse-e. Ha először futtatod akkor muszály (vagy ha frissíteni akarod).

   > Utánna zárd be a Terminált majd nyisd meg újra (ez feltétlenül szükséges)

4. Neked sikerül a többi 2 percen belül? :)

---

## `Manual way`

## I. Eszközök telepítése

**Mac (Terminal), Linux (Terminal), Google Cloud console:**

```bash
sh -c "$(curl -sSfL https://release.solana.com/v1.16.9/install)"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install spl-token-cli
```

> Indísd újra a Terminált, hogy minden rendben működjön <br>

**Windows (cmd):**

```bash
cmd /c "curl https://release.solana.com/v1.16.9/solana-install-init-x86_64-pc-windows-msvc.exe --output C:\solana-install-tmp\solana-install-init.exe --create-dirs"
C:\solana-install-tmp\solana-install-init.exe v1.16.9

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install spl-token-cli
```

> Indísd újra a cmd-t, hogy minden rendben működjön

## II. Token létrehozása

1.  Új solana fiók létrehozása

    ```bash
    solana-keygen new
    ```

    > Ez egy új Solana kulcspárt hoz létre ez [_file system wallet_](https://docs.solana.com/wallet-guide/file-system-wallet) ként fog funkcionálni.<br>
    > A kulcspár generálása előtt egy _BIP39 Passphrase_-t fog kérni ami extra védlemként szolgál, de nekünk nincs feltétlenül szükségünk rá.<br>
    > Ird fel a nyilvános kulcsot!!

2.  Solana konfiguráció ellenőrzése

    ```bash
    solana config get
    ```

    Ellenőrizd hogy melyik hálózaton vagy mielőtt továblépnél! Ezt az RPC sorban láthatod<br>

    A Solana-nak 3 _föbb_ hálózata van, mi a _Devnetet_ fogjuk használi:<br>

    - **_Mainnet_**: _valódi_ pénz, tranzakcióknak _valódi_ díja van, RPC: https://api.mainnet-beta.solana.com <br>
    - **_Devnet_**: _nem valódi_ SOL, tranzakcióknak _szimulált_ dija van, RPC: https://api.devnet.solana.com <br>
    - **_Testnet_**: hasonló mint a devnet, viszont célja megának a hálózatnak a tesztelése, RPC: https://api.testnet.solana.com <br>

3.  Ha ingyenesen szeretnél tokent létrehozni ezzel "léphetsz" be a teszthálózatba.
    ```bash
    solana config set --url https://api.devnet.solana.com
    ```
4.  Solana-t kell juttatnod a számládra, ezzel a parancsal 4 teszt SOL-t "hívsz le".

    ```bash
    solana airdrop 4
    ```

    >     Ha nem a teszthálózaton vagy akkor a saját számládról kell 0,5 SOL-t utalnod ide.

    >     Azért van szükség Salana-ra mert a token létrehozásáért + a későbbi tranzakciókért fizetni kell<br>
    >     Ez a 4 SOL több mint 800000 utalásra elegendő a **teszthálózaton**.

5.  Token létrehozása (írd fel a token "címét"!)

    ```bash
    spl-token create-token
    ```

    > Egy pénztárcával több különböző tokent is létre tudsz hozni. <br>
    > Tehát ha nem elégszel meg egy tokennel ettől a lépéstől kell megismételned a folyamatot :)

6.  Fiók létrehozása a tokenünk számára (e nélkül nem tudnánk használni)

    ```bash
    spl-token create-account <token>
    ```

    > Ez nem egy új számlát fog létrehozni hanem egy _fiókot_ a pénztárcán belül a token számára <br>
    > Minden cryptovalutának szügsége van egy fiókra ahol tárolják őket, ezeket a fiókokat pedig a pénztárcán belül vannak. <br>
    > Egy fiók létrehozásáért fizetni kell (kevesebb mint 0,00001 SOL) <br>

7.  Ezzel a parancsal tudsz tokent generálni. A tokenek az 1. lépésben létrahozott számlára fognak kerülni(egy számlán max 10 billió lehet).

    ```bash
    spl-token mint <token> <mennyiség>
    ```

    > Ahoz hogy a tokenedből generálni tudj ahoz szügséged van arra a _file system wallet_-ra amelyikkel létrehoztad a tokent!

8.  Ezzel a parancsal nézheted meg, hogy mennyi tokened van
    ```bash
    spl-token accounts
    ```
9.  Ezzel a parancsal letilthatod a további tokenek generálását
    ```bash
    spl-token authorize <token> mint --disable
    ```
    > <picture>
    >   <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
    >   <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
    > </picture>
    > Ezt a lépést ne végezd el addig amíg nem adtál metaadatot a tokenedhez!!

## IV. Metadata hozzáadása a tokenhez

Metadata nélkül a token mindenhol “_Unknown Token_” néven fog megjelenni + ikon és szimbólum (pl:BTC) nélkül.

1. Metaboss telepítése
   ```bash
   bash <(curl -sSf https://raw.githubusercontent.com/samuelvanderwaal/metaboss/main/scripts/install.sh)
   ```
2. Hozz létre két .json fájlt a token_metadata.json és a token_metadata_github.json minták alapján, plusz egy ikont (png javasolt)

   > Fontos! Töröld ki a megjegyzéseket (`//` kezdődnek a sorok végén) a json fájlokból mielőtt tovább lépnél!

3. [Itt](/.how-to-upload-to-github/upload_to_github.md) megtudhatod, hogyan tölsd fel a token ikonját valamint a _token_metadata_github.json_-t a githubra és szerezd meg a raw linkeket.
4. Metadata hozzáadása a tokenhez

   ```bash
   metaboss create metadata -a <token> -m <token_metadata.json fájl (nem a github-os)>
   ```

   > Ne aggódj ha a tokened _"Unrecognised Token"_ néven jelenik meg, csak várj 2-4 percet hogy a hálózat fel tudja dolgozni a módosításokat

5. A tokened **_ELKÉSZÜLT_** :)

## V. Token használata

1. Hozz létre egy Solana tárolására alkalmas pénztárcát, például a Phantom(Android, IOS, Bővítmény Chrome-hoz) appban.
2. Ha teszthálózaton hoztál létre tokent akkor a pénztárca appban a hálózatot át kell állítanod "Mainnet"-ről "Devnet"-re
   - Phantom: "Settings" => "Developer settings" => "Testnet mode" ez után egy sérga csíkot kell látnod a képernyő tetején (újraindítás után)
   - Solflare: Beállítások => "General" => "Network" => "Devnet"
   - **Nem Minden alkalmazás kompatibilis a teszthálózattal!**
3. Küld a "Token létrehozása" szakaszban lekért teszt SOL-t az új pénztárcádra (szügséged lesz rá az utalásokhoz 1SOl = +200000 utalás).

   > Ha nem a teszthálózatot használód máshogy kell SOL-t juttatnod az új számládra.

   ```bash
   solana transfer <pénztárca Solana címe> <mennyiség>
   ```

   > Ezzel a parancsal kizárólag SOL-t tudsz utalni.
   > A számlán legalább 0,001 SOL-nak maradnia kell a tranzakció fizetéséhez.

4. Küld az elkészült tokeneket a pénztárcádra és egyben hozz létre ott egy fiókot a token számára(`--fund-recipient`). Ez után mér nem kell használnod a Terminált :).

   ```bash
   spl-transfer <token> <mennyiség> <pénztárca Solana címe> --fund-recipient
   ```

   > Legalább 0,000000001 tokennek maradnia kell. <br>

   > Ne aggódj ha a tokened _"Unrecognised Token"_ néven jelenik meg, csak várj 2-4 percet hogy a hálózat fel tudja dolgozni a módosításokat

   > Ne feletkezz meg arról hogy mindig szügséged lesz SOL-ra a tranzakciókhoz (ha a teszthálózatot használod és elfogyna hajsd végre a II/4 és a V/3 lépéseket)

<br><br>

**© _Tatár Márton 2023_**

> <picture>
>   <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
>   <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
> </picture>
> Figelem a repo készítői SEMMILYEN FELELŐSSÉGET NEM VÁLLALNAK
