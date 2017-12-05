#!/bin/bash
# install.sh
# v0.0.1 - Release "Adult Supervision Recommended"

# https://github.com/markcross/universal-crypto-wallet-system/
# Provided under GNU Lesser General Public License - Copyright 2017 Mark Cross, UK callsign M1BXD
# Please see accompanying LICENSE file

# Go to http://www.cointales.com/ for full documentation and tutorials

# Thanks to this page for bash dialog code https://ubuntuforums.org/showthread.php?t=1371340
printf "\033c"
echo "################################################################"
echo "# Universal Crypto Wallet System by cointales.com              #"
echo "################################################################"
echo
echo "  When ucw prompts you to enter your password                  "
echo "                Use the one for this username: $USER"
echo
echo " If you get cold feet, READ the install.sh file in a text editor"
echo " Escape by doing CTRL-C now"
echo
echo "################################################################"
echo "# To help my enthusiam to maintain this please                 #"
echo "# consider donating to the following addresses                 #"
echo "# Ethereum ETH: 0x2e9829483f76B00976Db5215976b677808679634     #"
echo "################################################################"
echo 
echo "Full documenation at http://www.cointales.com/"
echo "to run installer again type this"
echo "./install.sh"
echo 
echo "Basic documentation paths explained at the end of the install"
echo 
read -p "Enable ufw firewall regardless of current state, please press y or n " -n 1 -r
echo  
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# enable firewall
	sudo ufw enable
fi

echo "###"
echo
echo "Add PPA for QR code generator"
qreatorstable=$(apt-cache search qreator)
if [ -z "qreatorstable" ]
	then
	# Add ppa for QR code generator
	#yes '' | sudo add-apt-repository ppa:qreator-hackers/qreator-stable
	sudo add-apt-repository ppa:qreator-hackers/qreator-stable -y
	else
	echo "qreator-stable already in apt-cache"
fi
	echo
	echo "Add repro for Google Chrome for MyEtherWallet - MEW" 
	chromerepro=$(apt-cache search google-chrome-stable)
if [ -z "chromerepro" ]
	then
	# This makes Google Chrome installable for MyEtherWallet.com IE Lets get Chrome
	# if you want to add the Chrome extension which you manually install through Chrome
	# Add the repro to the "apt" sources.list.d as it's own repro file
	# Add the signing key
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
	else
	echo "google-chrome-stable already in apt-cache"
fi

echo "###"
echo "update & upgrade?"
echo

read -p "Please press y or n " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# Update base system so it knows where to find also the repros
	sudo apt update -y
	 
	# Bring the system uptodate
	sudo apt upgrade -y
fi

printf "\033c"
UWCpath=$(dialog --inputbox "Universal Crypto Wallet System installation path, change if you want" 25 75 $HOME/ucw --output-fd 1)

mkdir -p $UWCpath/docs

printf "\033c"
#######################################################################################
echo "Installation selections"
echo "###########################"
echo "On the next screen press the space bar to make a selection"
echo "Arrow keys to move up and down"
echo "Then press the ENTER or RETURN key when you have make your choices"
echo
#######################################################################################
read -p "Press [Enter] to proceed to install selection screen"
#######################################################################################

pkglist=""
n=1
for pkg in $(cat walletsandtools.menu)
do
        pkglist="$pkglist $pkg $n off"
        n=$[n+1]
done

echo $pkglist

choices=`/usr/bin/dialog --stdout --checklist 'Wallets & Utilities to install:' 80 40 20 $pkglist`

if [ $? -eq 0 ]
then
        for choice in $choices
        do
                echo "You chose: $choice"
        done
else
        echo cancel selected
fi

if [ $? -eq 0 ]
then
        for choice in $choices
        do
##########################################################################################################                
# Within this loop check and do the installs

if [ $choice == 'ARK' ]
then
sudo rm -r ark-desktop
printf "\033c"
echo "Installing: $choice"
git clone https://github.com/ArkEcosystem/ark-desktop.git
ark=$(cd ark-desktop; git describe --tags `git rev-list --tags --max-count=1`)

# https://github.com/ArkEcosystem/ark-desktop/releases
echo
echo
wget https://github.com/ArkEcosystem/ark-desktop/releases/download/$ark/ArkClient-Ubuntu-$ark"_"amd64.deb
echo 'https://github.com/ArkEcosystem/ark-desktop/releases/download/$ark/ArkClient"-"Ubuntu"-"$ark"_"amd64.deb'
if [ $? -ne 0 ]; then
    echo "Problem with binary release retrieval for $ark for $choice please raise issue on github THANK YOU"
fi
sudo dpkg -i ArkClient-Ubuntu-$ark_amd64.deb
echo "USAGE $choice" > ARK.txt
echo "v$ark $choice is now installed and executable via your Accessories menu" >> ARK.txt
echo

elif [ $choice == 'Byteball' ]
then
sudo rm -r byteball
sudo rm -r $UWCpath/byteball-linux64
printf "\033c"
echo "Installing: $choice"
git clone https://github.com/byteball/byteball.git
byteball=$(cd byteball; git describe --tags `git rev-list --tags --max-count=1`)
rm byteball-linux64.zip
rm -r $UWCpath/byteball-linux64
wget https://github.com/byteball/byteball/releases/download/$byteball/byteball-linux64.zip
unzip byteball-linux64.zip
mv byteball-linux64 $UWCpath/.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "USAGE $choice v$byteball" > byteball.txt
echo
echo "At the terminal run this by:" >> byteball.txt
echo "cd $UWCpath/byteball-linux64" >> byteball.txt
echo "./Byteball &" >> byteball.txt
echo

# UWCpath=$/home/mark/ucw

elif [ $choice == 'Dash' ]
then
sudo rm -r $UWCpath/electrum-dash
printf "\033c"
echo "Installing: $choice"
# Install the Electrum python dependencies
sudo apt-get install python-qt4 pyqt4-dev-tools python-pip python-setuptools python-pyqt5 pyqt5-dev-tools python-dev -y
pyrcc4 icons.qrc -o gui/qt/icons_rc.py
git clone https://github.com/dashpay/electrum-dash.git
electrumdash=$(cd electrum-dash; git describe --tags `git rev-list --tags --max-count=1`)
wget -O electrum-dash-$electrumdash.tar.gz https://github.com/dashpay/electrum-dash/archive/$electrumdash.tar.gz
tar -xvf electrum-dash-$electrumdash.tar.gz
rm electrum-dash-$electrumdash.tar.gz
mv electrum-dash-$electrumdash $UWCpath/electrum-dash
mv electrum-dash-$electrumdash electrum-dash-$electrumdash-source
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "USAGE $choice v$electrumdash" > dash.txt
echo
echo "At the terminal run this by:" >> dash.txt
echo "cd $UWCpath/electrum-dash" >> dash.txt
echo "./electrum &" >> dash.txt
echo

elif [ $choice == 'Electrum-Bitcoin-Coin-Cash' ]
then
printf "\033c"

echo "Installing: $choice"
# Install the Electrum python dependencies
sudo apt-get install python-qt4 python-pip python-setuptools python-pyqt5 pyqt5-dev-tools python-dev -y

git clone git://github.com/fyookball/electrum.git
bccelectrumversion=$(cd electrum; git describe --tags `git rev-list --tags --max-count=1`)
mv electrum $UWCpath/bcc"-"electrum"-"$bccelectrumversion

echo "USAGE $choice v$bccelectrumversion" > bcc-electrum.txt
echo "It the files are located in this directory" >> bcc-electrum.txt
echo
echo "At the terminal run this:" >> bcc-electrum.txt
echo "cd $UWCpath/bcc-electrum-$bccelectrumversion" >> bcc-electrum.txt
echo "paste this into the terminal and hit return" >> bcc-electrum.txt
echo "pyrcc5 icons.qrc -o gui/qt/icons_rc.py" >> bcc-electrum.txt
echo "./electron-cash" >> bcc-electrum.txt
echo

elif [ $choice == 'Electrum-Bitcoin-Core' ]
then
printf "\033c"
echo "Installing: $choice"
git clone https://github.com/spesmilo/electrum.git
electrum=$(cd electrum; git describe --tags `git rev-list --tags --max-count=1`)
# Install the Electrum family python dependencies
sudo apt-get install python3-setuptools python3-pyqt5 python3-pip -y
sudo pip3 install https://download.electrum.org/$electrum/Electrum-$electrum.tar.gz

echo "USAGE $choice v$electrum" > BTC-electrum.txt
echo "$choice is now installed and executable via your Internet menu" >> BTC-electrum.txt
echo

elif [ $choice == 'Electrum-LTC' ]
then
printf "\033c"
echo "Installing: $choice"
git clone https://github.com/pooler/electrum-ltc.git
electrumltc=$(cd electrum-ltc; git describe --tags `git rev-list --tags --max-count=1`)
# Install the Electrum family python dependencies
sudo apt-get install python-qt4 python-pip python-dev python-setuptools -y
sudo pip2 install https://electrum-ltc.org/download/Electrum-LTC-$electrumltc.tar.gz

echo "USAGE $choice v$electrum" > BTC-LTC.txt
echo 'Electrum-LTC is now installed and executable via your Internet menu or by typing into the terminal "electrum-ltc"' >> BTC-LTC.txt
echo

elif [ $choice == 'Electrum-Stratis' ]
then
printf "\033c"
echo "Installing: $choice"
git clone https://github.com/stratisproject/electrum-stratis.git
electrumstratis=$(cd electrum-stratis; git describe --tags `git rev-list --tags --max-count=1`)
# Install the Electrum family python dependencies
sudo apt-get install python-qt4 python-pip python-dev python-setuptools -y
sudo pip install https://github.com/stratisproject/electrum-stratis/releases/download/$electrumstratis/Electrum-Stratis-$electrumstratis-unix.tar.gz
echo "USAGE $choice" > stratis-electrum.txt
echo "$choice is now installed and executable via your Internet menu" >> stratis-electrum.txt
echo

elif [ $choice == 'Neon' ]
then
printf "\033c"
echo "Installing: $choice"
git clone https://github.com/CityOfZion/neon-wallet.git
neonwallet=$(cd neon-wallet; git describe --tags `git rev-list --tags --max-count=1`)
#https://github.com/CityOfZion/neon-wallet/releases
wget https://github.com/CityOfZion/neon-wallet/releases/download/$neonwallet/Neon"-"$neonwallet"_"amd64.Linux.deb
if [ $? -ne 0 ]; then
    echo "Binary release $neonwallet for $choice probably not available just yet, sorry"
	read -p "Press [Enter] to proceed"
fi
printf "\033c"
sudo dpkg -i Neon"-"$neonwallet"_"amd64.Linux.deb
echo "USAGE $choice v$neonwallet" > neon.txt
echo "$choice is now installed and executable via your Accessories menu"  >> neon.txt
echo

elif [ $choice == 'Monero-GUI' ]
then
sudo rm -r $UWCpath/monero-gui
printf "\033c"
echo "Installing: $choice"
git clone https://github.com/monero-project/monero.git
monero=$(cd monero; git describe --tags `git rev-list --tags --max-count=1`)
wget -O monero-gui-linux-x64.tar.bz2 https://downloads.getmonero.org/gui/linux64
tar -xvjf monero-gui-linux-x64.tar.bz2
rm monero-gui-linux-x64.tar.bz2
mv monero-gui-$monero $UWCpath/monero-gui
sudo mv monero monero-$monero-source
echo "USAGE $choice $monero" > Monero-GUI.txt
echo "At the terminal run this by:" >> Monero-GUI.txt
echo "cd $UWCpath/monero-gui" >> Monero-GUI.txt
echo "./start-gui.sh" >> Monero-GUI.txt
echo

elif [ $choice == 'MyEtherWallet-MEW' ]
then
mkdir -p $UWCpath/eth/
cd ~/universal-crypto-wallet-system
printf "\033c"
echo "Installing: $choice and Chrome extension"
sudo apt-get install google-chrome-stable
git clone https://github.com/kvhnuke/etherwallet.git
etherwallet=$(cd etherwallet; git describe --tags `git rev-list --tags --max-count=1`)
wget https://github.com/kvhnuke/etherwallet/releases/download/$etherwallet/etherwallet"-"$etherwallet.zip
unzip etherwallet"-"$etherwallet.zip

etherwallet=$(cd etherwallet; git describe --tags `git rev-list --tags --max-count=1`)
wget https://github.com/kvhnuke/etherwallet/releases/download/$etherwallet/chrome"-"extension"-"$etherwallet.zip
unzip chrome"-"extension"-"$etherwallet.zip -d mew-chrome-extension-$etherwallet

mv mew-chrome-extension-$etherwallet $UWCpath/eth/.
mv etherwallet"-"$etherwallet $UWCpath/eth/.

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "USAGE $choice v$etherwallet" > MyEtherWallet.txt
echo "Open your **Chrome Browser** and enter the following URL into the location input box and press return" >> MyEtherWallet.txt
echo "~/$USER/uwc/eth/etherwallet"-"$etherwallet/index.html" >> MyEtherWallet.txt
echo 
echo "Then the easiest thing to do is bookmark this page for ease and security" >> MyEtherWallet.txt
echo
cd ~/universal-crypto-wallet-system

elif [ $choice == 'Utilities' ]
then
cd $UWCpath
printf "\033c"

##########################################################################################################
echo "Installing: Mnemonic Code Converter"
# Mnemonic Code Converter
# You can enter an existing BIP39 mnemonic, or generate a new random one.
# Typing your own twelve words will probably not work how you expect,
# since the words require a particular structure (the last word is a checksum).
# Online version at https://iancoleman.io/bip39/
# https://github.com/Coinomi/bip39
git clone https://github.com/Coinomi/bip39.git
echo "USAGE Mnemonic Code Converter by Coinomi" > iancolemanMnemonicGenerator.txt
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Open your web browser and enter the following URL into the location input box and press return" >> iancolemanMnemonicGenerator.txt
echo "$DIR/bip39/bip39-standalone.html" >> iancolemanMnemonicGenerator.txt
##########################################################################################################
echo "Installing: swansontec generating seeds for dice rolls tool" 
echo "See script for usage" 
# Rolling the dice to generate key seeds
# http://www.swansontec.com/bitcoin-dice.html
wget -O dice2key.zip https://github.com/swansontec/dice2key/archive/master.zip
unzip -o dice2key.zip
 
echo "USAGE dice2key" > dice2key.txt
echo >> dice2key.txt
echo "dice2key over Ian Coleman's utility gets you the ability to generate ARK passphrases via the original Electrum"  >> dice2key.txt
echo "./dice2key.sh 123456123456123456123456123456123456123456123456123" >> dice2key.txt
echo "51 dice rolls - the dice2key software will now warn you it's not 100," >> dice2key.txt
echo "but we're not using it for the actual key, just the entropy," >> dice2key.txt
echo "more than 51 rolls in Electrum v2.4+ creates a seed phrase greater than 13 words." >> dice2key.txt
echo "Next we need the number for Electrum as a decimal not hex, which we can do from the command line:" >> dice2key.txt
echo "mark@asrock:~/dice2key-master$ ./dice2key.sh 123456123456123456123456123456123456123456123456123" >> dice2key.txt
echo "warning: The input has less than 100 dice rolls" >> dice2key.txt
echo "91D89C79009852800BFFCCDC406B1BA0" >> dice2key.txt
echo 'mark@asrock:~/dice2key-master$ echo "ibase=16; 91D89C79009852800BFFCCDC406B1BA0"|bc' >> dice2key.txt
echo "193862769152946304546066490817889639328" >> dice2key.txt
echo "Go to the command line, NOT the console within electrum and run" >> dice2key.txt
echo "mark@asrock:~/dice2key-master$ electrum make_seed --entropy=193862769152946304546066490817889639328" >> dice2key.txt
echo "marine enemy core equal brief swarm swear six castle detect cream penalty describe" >> dice2key.txt
echo "Now this 13 word passphrase can be used for Electrum BTC/BCC, Electrum Stratis & ARK" >> dice2key.txt
echo "You can now also take a private key from an Electrum BTC/BCC key pair and use that as your NEON wallet passphrase" >> dice2key.txt
#######################################################################################################
echo "Installing: zbarcam - Scans QR codes via webcam" 
# zbarcam - Scans QR codes
sudo apt-get install libpython-dev python-dev -y
sudo apt-get install zbar-tools libzbar0 libzbar-dev -y
echo "USAGE zbarcam" > zbarcam.txt
echo "At the terminal run this:" >> zbarcam.txt
echo "zbarcam" >> zbarcam.txt
######################################################################################################
echo "Installing: qreator - creates QR codes" 
# qreator - creates QR codes
sudo apt install qreator python-qrencode -y
# qreator does not display QR code image after Ubuntu 16.04 update/upgrade
# sudo apt-get remove qreator
# Then see this bug report
# https://bugs.launchpad.net/qreator/+bug/1573577/comments/8
echo "USAGE qreator" > qreator.txt
echo "At the terminal run this:" >> qreator.txt
echo "qreator" >> qreator.txt
#######################################################################################################
echo "Installing: lxterminal vim htop firefox zim zint"
#######################################################################################################    
echo "USAGE zint -b 20 uses the Code 128" > zint.txt
echo "zint - Create 2D barcode saves .eps (default .png .svg file)" >> zint.txt
echo "To list codes available type: zint -t" >> zint.txt
echo "zint -b 20 --notext -d '!FGas_WHATEVER_df111' " >> zint.txt
    

# Mop and install THE useful apps, especially vim... :-)
# I was using something very like vim on a mainframe in 1991...
# Then when I introduced commercial Linux software into the UK in 1997
# while at http://www.GreyMatter.com/ I sort of "found" vi & vim which I prefer :-)
# https://en.wikipedia.org/wiki/Vim_(text_editor)
# lxterminal - don't know why it's not part of Linx Mint XFCE edition
# Now "zim" is a really cool local wiki tool very useful for development and server hosting notes

cd ~
sudo apt-get install lxterminal vim htop firefox zim zint -y

fi
	done
else
	echo cancel selected
fi

cd ~/universal-crypto-wallet-system
mv *.txt $UWCpath/docs/.

printf "\033c"
echo "################################################################################################"    
echo "Basic documentation to the cryptowallets and tools you have installed can be found at:"
echo "$UWCpath/docs/*"
echo
echo "Good Luck"
echo "################################################################################################"    
echo "To help my enthusiam to maintain it please consider donating to the following addresses"  > 0_donate.txt
echo >> 0_donate.txt
echo "Ethereum ETH: 0x2e9829483f76B00976Db5215976b677808679634" >> 0_donate.txt
echo >> 0_donate.txt
echo "Full documenation will appear at http://www.cointales.com/" >> 0_donate.txt
echo >> 0_donate.txt
echo "My crypto information site can be found at http://www.cointales.com/" >> 0_donate.txt

# https://askubuntu.com/questions/760896/how-can-i-automatically-fix-w-target-packages-is-configured-multiple-times
# sudo add-apt-repository --remove ppa:whatever/ppa
# sudo add-apt-repository --remove

