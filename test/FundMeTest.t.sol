// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;

import { FundMe } from "../src/FundMe.sol";
import { Test } from "forge-std/Test.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testMinimumUsd() public {
        uint256 minimumUsd = 5e18;
        assertEq(fundMe.MINIMUM_USD(), minimumUsd, "minimumUsd should be 5e18");
    }

    function testOwner() public {
        assertEq(fundMe.getOwner(), address(this), "owner should be this contract");
    }

    function testFund() public payable {
        uint256 ethAmount = 1e18;
        fundMe.fund{value: ethAmount}();
        assertEq(fundMe.getAddressToAmountFunded(address(this)), ethAmount, "ethAmount should be 1e18");
    }
}