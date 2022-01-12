// SPDX-License-Identifier: unlicensed
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {
    
    uint256 favoriteNumber;

    //Struct
    struct People{
        uint256 favoriteNumber;
        string name;
    }

    // Instantiating an array
    People[] public people;

    // Creating a mapping for name and favorite number
    // Very Similar to a python dictionary
    mapping(string => uint256) public nameToFavoriteNumber;

    // Stores parameter _favoriteNumber as the internal variable favoriteNumber
    function store(uint256 _favoriteNumber) public{
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}