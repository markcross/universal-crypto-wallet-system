# universal-crypto-wallet-system
Universal Crypto Wallet System for deploying many crypto wallets on a Ubuntu 16.04+ distro see Cointales.com for tutorials

USAGE

The Universal Crypto Wallet System is methodoloy intended to be executed on a Ubuntu 64bit based distribution. It has been tested against Linux Mint XFCE Serena 18.2/18.1 based on Ubuntu 16.04 It allows you select from a variety of cyrptocurrency wallet you may like to install.

![First screen on UCW](https://github.com/markcross/universal-crypto-wallet-system/raw/master/images/1%20ucw%20preparation.png)
![Main Menu on UCW](https://github.com/markcross/universal-crypto-wallet-system/raw/master/images/2%20uwc%20main%20menu.png)

If you do not have a Linux Ubuntu 64bit based distribution on a PC I have a tutorial guide at:

http://www.cointales.com/

Assuming you have then proceed to go into a terminal window.

You can do that from the menu or often do CTRL-ALT-T as key combinations

You have a black box with a prompt like this:

$

To make sure that you are in the right part of the file system of your newly created ubuntu installation
type: cd ~

The "~" or tilda symbol is often shifted "#" just to the left of the ENTER/RETURN key

username@machinename:~$ cd ~

FOLLOWED BY ENTER/RETURN

Then copy and past the following:

$ sudo apt-get update
$ sudo apt-get install git
$ git clone https://github.com/markcross/universal-crypto-wallet-system.git
$ cd universal-crypto-wallet-system

You can often short cut to this directory by just yping at the prompt

cd uni 

Then the TAB key

If there are no other directories starting with uni, the terminal will pre-fill the rest of the directory name for you:

cd universal-crypto-wallet-system

Press return and then type

chmod +x install.sh
./i
Then the TAB key and the install.sh will autocomplete with "./" infront

$ ~/cointales-wallets-install$ ./install.sh

FOLLOWED BY ENTER/RETURN and enjoy.

To see the "brief" notes after installation choices look in the "docs" directory for each crypto you have installed.

And please go to http://www.cointales.com/ for the full documentation.

If you get really stuck PM me @l0ts0fl00t @ http://thebitcoin.pub - the friendliest forum for cryptocurrency n00bies IMHO

Donations in ETH accepted here:

0x2e9829483f76B00976Db5215976b677808679634

All the best,

Mark Cross, M1BXD, UK





