`sudo apt update`

``sudo apt install lz4 -y``

``sudo systemctl stop crossfid``

``cp $HOME/.mineplex-chain/data/priv_validator_state.json $HOME/.mineplex-chain/priv_validator_state.json.backup``

``crossfid tendermint unsafe-reset-all --home $HOME/.mineplex-chain --keep-addr-book``

``curl https://snapshot.crypton-node.tech/crossfi-testnet/crossfi-testnet_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.mineplex-chain``

``mv $HOME/.mineplex-chain/priv_validator_state.json.backup $HOME/.mineplex-chain/data/priv_validator_state.json``

``sudo systemctl restart crossfid``

``sudo journalctl -u crossfid -f --no-hostname -o cat``
