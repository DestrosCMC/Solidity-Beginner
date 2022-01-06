// SPDX-License-Identifier: unlicensed

pragma solidity >=0.6.0 <0.9.0;

import "./SimpleStorage.sol";

// The is is for inhereritance
contract StorageFactory is SimpleStorage{

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
        // Address
        // ABI
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256){
        //this line has an explicit cast to the address type and initializes a new SimpleStorage object from the address 
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }

}
