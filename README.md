# Tron Village Smart Contract

Home page: [tronvillage.com](https://tronvillage.com/)  
Play page:  [tronvillage.com/en/play](tronvillage.com/en/play.html)

## Details
- Address: [TCPFHFk9VHjTVVdzK4qFTTUmAyv9VwbJmr](https://tronscan.org/#/address/TCPFHFk9VHjTVVdzK4qFTTUmAyv9VwbJmr)
- Solidity compiler version: v0.4.23+commit.124ca40d
- Direct interaction with the contract via TronLink: [interaction](https://tronsmartcontract.space/#/interact/TCPFHFk9VHjTVVdzK4qFTTUmAyv9VwbJmr)


### Full JSON ABI:
```
{"entrys":[{"constant":true,"name":"totalFactories","outputs":[{"type":"uint256"}],"type":2,"stateMutability":2},{"constant":true,"name":"totalPayout","outputs":[{"type":"uint256"}],"type":2,"stateMutability":2},{"constant":true,"name":"players","inputs":[{"type":"address"}],"outputs":[{"name":"coinsForBuy","type":"uint256"},{"name":"coinsForSale","type":"uint256"},{"name":"time","type":"uint256"}],"type":2,"stateMutability":2},{"constant":true,"name":"totalPlayers","outputs":[{"type":"uint256"}],"type":2,"stateMutability":2},{"inputs":[{"name":"_owner","type":"address"},{"name":"_manager","type":"address"}],"type":1,"stateMutability":3},{"name":"deposit","type":2,"payable":true,"stateMutability":4},{"name":"buy","inputs":[{"name":"_type","type":"uint256"},{"name":"_number","type":"uint256"}],"type":2,"stateMutability":3},{"name":"withdraw","inputs":[{"name":"_coins","type":"uint256"}],"type":2,"stateMutability":3},{"constant":true,"name":"factoriesOf","inputs":[{"name":"_addr","type":"address"}],"outputs":[{"type":"uint256[6]"}],"type":2,"stateMutability":2}]}
```
