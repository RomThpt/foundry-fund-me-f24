// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;
    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testGetAddressToAmountFunded() public view {
        assertEq(fundMe.getAddressToAmountFunded(USER), 0);
    }

    function testPriceFeedVersionIsAccurate() public view {
        if (block.chainid == 11155111) {
            assertEq(fundMe.getVersion(), 4);
        } else if (block.chainid == 1) {
            assertEq(fundMe.getVersion(), 6);
        } else {
            assertEq(fundMe.getVersion(), 4);
        }
    }

    function testFundFailsWithLessThanMinimum() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdateFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 1 ether);
    }

    function testWithdraw() public {
        vm.deal(USER, 10 ether);
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
        _;
    }

    function testGetFunders() public {
        vm.deal(USER, 10 ether);
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
        assertEq(fundMe.getFunders(0), USER);
    }

    function testWithdrawWithASingleFunder() public {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFundersIndex = 1;

        for (uint160 i = startingFundersIndex; i < numberOfFunders; i++) {
            hoax(address(i), 10 ether);
            fundMe.fund{value: 1 ether}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        assert(address(fundMe).balance == 0);
        assert(fundMe.getOwner().balance == startingOwnerBalance + startingFundMeBalance);
    }
}
