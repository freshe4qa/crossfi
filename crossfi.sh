#!/bin/bash

while true
do

# Logo

echo -e '\e[40m\e[91m'
echo -e '  ____                  _                    '
echo -e ' / ___|_ __ _   _ _ __ | |_ ___  _ __        '
echo -e '| |   |  __| | | |  _ \| __/ _ \|  _ \       '
echo -e '| |___| |  | |_| | |_) | || (_) | | | |      '
echo -e ' \____|_|   \__  |  __/ \__\___/|_| |_|      '
echo -e '            |___/|_|                         '
echo -e '    _                 _                      '
echo -e '   / \   ___ __ _  __| | ___ _ __ ___  _   _ '
echo -e '  / _ \ / __/ _  |/ _  |/ _ \  _   _ \| | | |'
echo -e ' / ___ \ (_| (_| | (_| |  __/ | | | | | |_| |'
echo -e '/_/   \_\___\__ _|\__ _|\___|_| |_| |_|\__  |'
echo -e '                                       |___/ '
echo -e '\e[0m'

sleep 2

# Menu

PS3='Select an action: '
options=(
"Install"
"Create Wallet"
"Create Validator"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Install")
echo "============================================================"
echo "Install start"
echo "============================================================"

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export CROSSFI_CHAIN_ID=crossfi-evm-testnet-1" >> $HOME/.bash_profile
source $HOME/.bash_profile

# update
sudo apt update && sudo apt upgrade -y

# packages
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

# install go
if ! [ -x "$(command -v go)" ]; then
VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
fi

# download binary
cd $HOME && mkdir -p $HOME/go/bin
curl -L https://github.com/crossfichain/crossfi-node/releases/download/v0.3.0-prebuild9/crossfi-node_0.3.0-prebuild9_linux_amd64.tar.gz > crossfi-node_0.3.0-prebuild9_linux_amd64.tar.gz
tar -xvzf crossfi-node_0.3.0-prebuild9_linux_amd64.tar.gz
chmod +x $HOME/bin/crossfid
mv $HOME/bin/crossfid $HOME/go/bin
rm -rf crossfi-node_0.3.0-prebuild9_linux_amd64.tar.gz readme.md $HOME/bin

# config
crossfid config chain-id $CROSSFI_CHAIN_ID
crossfid config keyring-backend test

# init
crossfid init $NODENAME --chain-id $CROSSFI_CHAIN_ID

# download genesis and addrbook
wget -O $HOME/.mineplex-chain/config/genesis.json https://testnet-files.itrocket.net/crossfi/genesis.json
wget -O $HOME/.mineplex-chain/config/addrbook.json https://testnet-files.itrocket.net/crossfi/addrbook.json

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"10000000000000mpx\"/" $HOME/.mineplex-chain/config/app.toml

# set peers and seeds
SEEDS="dd83e3c7c4e783f8a46dbb010ec8853135d29df0@crossfi-testnet-seed.itrocket.net:36656"
PEERS="66bdf53ec0c2ceeefd9a4c29d7f7926e136f114a@crossfi-testnet-peer.itrocket.net:36656,b88d969ba0e158da1b4066f5c17af9da68c52c7a@65.109.53.24:44656,5ebd3b1590d7383c0bb6696ad364934d7f1c984e@160.202.128.199:56156"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mineplex-chain/config/config.toml

#disable indexing
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.mineplex-chain/config/config.toml

# config pruning
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.mineplex-chain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.mineplex-chain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.mineplex-chain/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.mineplex-chain/config/config.toml

# create service
sudo tee /etc/systemd/system/crossfid.service > /dev/null <<EOF
[Unit]
Description=Crossfi node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.mineplex-chain
ExecStart=$(which crossfid) start --home $HOME/.mineplex-chain
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

crossfid tendermint unsafe-reset-all --home $HOME/.mineplex-chain --keep-addr-book
curl https://snapshots-testnet.nodejumper.io/crossfi-testnet/crossfi-testnet_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.mineplex-chain

# start service
sudo systemctl daemon-reload
sudo systemctl enable crossfid
sudo systemctl restart crossfid

break
;;

"Create Wallet")
crossfid keys add $WALLET
echo "============================================================"
echo "Save address and mnemonic"
echo "============================================================"
CROSSFI_WALLET_ADDRESS=$(crossfid keys show $WALLET -a)
CROSSFI_VALOPER_ADDRESS=$(crossfid keys show $WALLET --bech val -a)
echo 'export CROSSFI_WALLET_ADDRESS='${CROSSFI_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CROSSFI_VALOPER_ADDRESS='${CROSSFI_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile

break
;;

"Create Validator")
crossfid tx staking create-validator \
--amount 9990501710000000000000mpx \
--pubkey $(crossfid tendermint show-validator) \
--moniker=$NODENAME \
--chain-id crossfi-evm-testnet-1 \
--commission-rate=0.05 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-prices 10000000000000mpx \
--gas-adjustment=1.5 \
--gas=auto \
-y
  
break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
