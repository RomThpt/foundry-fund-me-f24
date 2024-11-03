// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    //
    using PriceConverter for uint256;
    // Storage variables

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    AggregatorV3Interface public s_priceFeed;

    // Constants
    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    /**
     * Modifiers
     * @dev This modifier checks if the sender is the owner of the contract
     */
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    /**
     * Constructor
     * @param _priceFeed The address of the price feed contract
     */
    constructor(address _priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(_priceFeed);
    }
    /**
     * @notice This function allows you to fund the contract
     * @dev This function requires a minimum amount of USD to be funded
     */

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    /**
     * @notice This function returns the version of the price feed
     * @return The version of the price feed
     */
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    /**
     * @notice This function allows the owner to withdraw the funds
     */
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    /**
     * Fallback functions
     */
    fallback() external payable {
        fund();
    }
    /**
     * Receive functions
     */

    receive() external payable {
        fund();
    }

    /* View Function */

    /**
     * @notice This function returns the amount funded by a funder
     * @param _address The address of the funder
     */
    function getAddressToAmountFunded(address _address) public view returns (uint256) {
        return s_addressToAmountFunded[_address];
    }

    /**
     * @notice This function returns the list of funders
     */
    function getFunders() public view returns (address[] memory) {
        return s_funders;
    }

    /**
     * @notice This function returns the price feed
     */
    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
