cd "$1"
pwd
solc $(ls | grep "$2".sol) --bin --abi --optimize -o .
web3j generate solidity -a=$(ls | grep *.abi) -b=$(ls | grep *.bin) -o . -p "$3"
