// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from './PriceConverter.sol';

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;
    address public owner;

    constructor(){
        owner=msg.sender;
    }

    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmount;

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough ETH !");
        funders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value;
    }

    function withdraw() public ownerOnly {
        for(uint256 funderIndex=0; funderIndex<funders.length;funderIndex++){
            address funder = funders[funderIndex];
            addressToAmount[funder] = 0;
        }
        funders = new address[](0);
        (bool callSuccess,)=payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "Sender must be owner!");
        _;
    }

}