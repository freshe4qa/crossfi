# Manual node setup
If you want to setup fullnode manually follow the steps below

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export CROSSFI_CHAIN_ID=crossfi-evm-testnet-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Install go
```
VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
```

## Download and build binaries
```
cd $HOME && mkdir -p $HOME/go/bin
curl -L https://github.com/crossfichain/crossfi-node/releases/download/v0.3.0-prebuild3/crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz > crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz
tar -xvzf crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz
chmod +x $HOME/bin/crossfid
mv $HOME/bin/crossfid $HOME/go/bin
rm -rf crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz readme.md $HOME/bin
```

## Config app
```
crossfid config chain-id crossfi-evm-testnet-1
crossfid config keyring-backend test
```

## Init app
```
crossfid init $NODENAME --chain-id crossfi-evm-testnet-1
```

## Download genesis and addrbook
```
curl -L https://snapshots-testnet.nodejumper.io/crossfi-testnet/genesis.json > $HOME/.mineplex-chain/config/genesis.json
curl -L https://snapshots-testnet.nodejumper.io/crossfi-testnet/addrbook.json > $HOME/.mineplex-chain/config/addrbook.json
```

## Set seeds and peers
```
SEEDS="89752fa7945a06e972d7d860222a5eeaeab5c357@128.140.70.97:26656,dd83e3c7c4e783f8a46dbb010ec8853135d29df0@crossfi-testnet-seed.itrocket.net:36656"
PEERS="d58853231357925f5dd53f010f72aaa6790a476e@65.108.121.227:31656,57757c6e0cfae31ab548e2e31bf27f964fe701e4@128.199.224.200:26656,b88d969ba0e158da1b4066f5c17af9da68c52c7a@65.109.53.24:44656,c3ac76d1d2dd72006372fa32805b011d36917bda@5.104.80.240:26656,727651552b1231b150130bb17fb3f75f18fc6b81@45.137.192.143:26656,a985b30974a127852f11da5646f76550e6e79f88@45.88.223.97:26656,54d39f9900e89427df4cb78c8b4e0dccc36d8485@65.109.68.69:26656,d1c47845c9849bf625fd54b4470b19c3ab0dd2a9@178.18.254.5:11656,7e4bd2a380eca22f0b01bb1fdbc37454dedfed75@109.199.108.187:26656,741e4f6997feafbcca4d86eb3bc76900992e79ad@51.81.242.223:26656,c8333d73f10b6cc83a5a10dfa51a374366ebd56d@5.75.131.173:26656,86ab70a7dd0aa23d0ed1c9a0cb72a67ebcccb4c9@95.217.72.177:36656,b5ffb5d0b60ee675b2b391ea67d5e28970b6bbe4@65.108.76.33:28686,8d988eac4b59c6b5d7e95ad14ce2c588ae057c7a@65.108.101.19:26656,4975453979deeb048e3f5d4ad07959928f3069b8@51.81.185.180:36656,fb92a0cc7e76c0f6235fccb9d834a6c172871ea5@95.217.227.236:26656,5925cacd7e97e1a3e1b8eab01cfb5628f49bacfa@65.109.17.115:46656,8cab02a64860408f505bb83f543af29c0a4ffe37@158.220.95.119:36656,53b678afbc206dc85b2a2bf974e34069e0ae84aa@162.19.233.158:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mineplex-chain/config/config.toml
```

## Config pruning
```
# disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.mineplex-chain/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.mineplex-chain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.mineplex-chain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.mineplex-chain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.mineplex-chain/config/app.toml
sed -i "s/snapshot-interval *=.*/snapshot-interval = 0/g" $HOME/.mineplex-chain/config/app.toml
```

## Set minimum gas price and timeout commit
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"5000000000mpx\"/" $HOME/.mineplex-chain/config/app.toml
```

## Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.mineplex-chain/config/config.toml
```

## Reset chain data
```
crossfid tendermint unsafe-reset-all
```

## Create service
```
sudo tee /etc/systemd/system/crossfid.service > /dev/null << EOF
[Unit]
Description=CrossFi node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which crossfid) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable crossfid
sudo systemctl restart crossfid && sudo journalctl -u crossfid -f -o cat
```
