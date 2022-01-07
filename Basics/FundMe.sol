// SPDX-License-Identifier: unlicensed

pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";

contract FundMe {
    // We don't need safemath in solidity 0.8+
    //using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    // constructor is called right when contract deployed
    constructor() {
        owner = msg.sender;
    }

    // Accepts a type of payment
    // payable means the function can be used to pay for things
    function fund() public payable{
        // $50
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");

        addressToAmountFunded[msg.sender] += msg.value;
        // Need to know ETH -> USD conversion rate
        funders.push(msg.sender);

    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer*10000000000);
    }

    // The input ethAmount is in Wei
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        // "this" is a keyword in Solidity that means this contract
        payable(msg.sender).transfer(address(this).balance);
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}
