from solcx import compile_standard, install_solc
import json
from web3 import Web3
import passes

print("Installing...")
install_solc("0.6.0")

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# Get Bytecode - get it from contracts json
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# Get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# Connecting to Ganache
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
# It is actually 5777 but is on 1337 from bug
chain_id = 1337
my_address = passes.address
private_key = passes.private_key

# Create the contract in Python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Get Latest Transaction
nonce = w3.eth.getTransactionCount(my_address)

# 1. Build a Transaction
# 2. Sign a Transaction
# 3. Send a Transaction

transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        # "networkId": chain_id,
        # "gas": 120000,
        # "gasPrice": 1200,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce,
    }
)

# Sign the Contract
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
print("Deploying Contract!")

# Sending Contract
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

# Wait for Transaction to be mined and then returns receipt
print("Waiting for transaction to finish...")
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print(f"Done! Contract deployed to {tx_receipt.contractAddress}")

# Working with the contract
# Need the address and the abi of the contract
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# Call -> Simulate making the call and getting a return value
# Transact -> Actually make a state change
print(f"Initial Stored Value {simple_storage.functions.retrieve().call()}")

greeting_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce + 1,
    }
)

signed_greeting_txn = w3.eth.account.sign_transaction(
    greeting_transaction, private_key=private_key
)

tx_greeting_hash = w3.eth.send_raw_transaction(signed_greeting_txn.rawTransaction)
print("Updating stored Value...")
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_greeting_hash)
print("Updated!")
print(simple_storage.functions.retrieve().call())
