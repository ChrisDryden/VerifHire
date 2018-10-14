from web3 import Web3
from solc import compile_files

# web3.py instance
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
# compile all contract files
contracts = compile_files(['user.sol', 'stringUtils.sol'])
# separate main file and link file
main_contract = contracts.pop("user.sol:userRecords")
library_link = contracts.pop("stringUtils.sol:StringUtils")