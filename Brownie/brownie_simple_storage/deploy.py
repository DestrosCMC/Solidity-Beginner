from brownie import accounts, SimpleStorage, network, config


def deploy_simple_storage():
    account = get_account()
    # account = accounts.load("first-rink-account")
    # print(account)
    simple_storage = SimpleStorage.deploy({"from": account})
    stored_value = simple_storage.retrieve()
    print(stored_value)
    transaction = simple_storage.store(15, {"from": account})
    transaction.wait(1)
    updated_stored_value = simple_storage.retrieve()
    print(updated_stored_value)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        # return accounts.add(e91be63de5764b26a7f8011bf0e373b5)
        return accounts.load("first-rink-account")


def main():
    deploy_simple_storage()
