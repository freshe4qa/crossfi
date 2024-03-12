<p align="center">
  <img height="100" height="auto" src="https://github.com/freshe4qa/crossfi/assets/85982863/273c75b8-7454-44c9-a457-15ee40525032">
</p>

# CrossFi Testnet — crossfi-evm-testnet-1

Official documentation:
>- [Validator setup instructions](https://docs.crossfi.org/crossfi-chain)

Explorer:
>- [Xfiscan](https://test.xfiscan.com/dashboard)

### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)

### Recommended Hardware Requirements 
 - 8x CPUs; the faster clock speed the better
 - 64GB RAM
 - 1TB of storage (SSD or NVME)

## Set up your nibiru fullnode
```
wget https://raw.githubusercontent.com/freshe4qa/crossfi/main/crossfi.sh && chmod +x crossfi.sh && ./crossfi.sh
```

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Synchronization status:
```
crossfid status 2>&1 | jq .SyncInfo
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
crossfid keys add $WALLET
```

Recover your wallet using seed phrase
```
crossfid keys add $WALLET --recover
```

To get current list of wallets
```
crossfid keys list
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu crossfid -o cat
```

Start service
```
sudo systemctl start crossfid
```

Stop service
```
sudo systemctl stop crossfid
```

Restart service
```
sudo systemctl restart crossfid
```

### Node info
Synchronization info
```
crossfid status 2>&1 | jq .SyncInfo
```

Validator info
```
crossfid status 2>&1 | jq .ValidatorInfo
```

Node info
```
crossfid status 2>&1 | jq .NodeInfo
```

Show node id
```
crossfid tendermint show-node-id
```

### Wallet operations
List of wallets
```
crossfid keys list
```

Recover wallet
```
crossfid keys add $WALLET --recover
```

Delete wallet
```
crossfid keys delete $WALLET
```

Get wallet balance
```
crossfid query bank balances $CROSSFI_WALLET_ADDRESS
```

Transfer funds
```
crossfid tx bank send $CROSSFI_WALLET_ADDRESS <TO_CROSSFI_WALLET_ADDRESS> 10000000mpx
```

### Voting
```
crossfid tx gov vote 1 yes --from $WALLET --chain-id=$CROSSFI_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
crossfid tx staking delegate $CEOSSFI_VALOPER_ADDRESS 10000000mpx --from=$WALLET --chain-id=$CROSSFI_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
crossfid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000mpx --from=$WALLET --chain-id=$CEOSSFI_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
crossfid tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CROSSFI_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
crossfid tx distribution withdraw-rewards $CEOSSFI_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CROSSFI_CHAIN_ID
```

Unjail validator
```
crossfid tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CROSSFI_CHAIN_ID \
  --gas=auto
```
