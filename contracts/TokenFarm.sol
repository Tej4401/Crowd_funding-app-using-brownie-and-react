// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract TokenFarm is Ownable {
    // mapping token address -> fundr address -> amount 
    mapping(address => mapping(address => uint256)) public stakingBalance;
    mapping(address => uint256) public ethStakingBalance;
    mapping(address => uint256) public uniqueTokensFundd;
    mapping(address => address) public tokenPriceFeedMapping;
    address[] public fundrs;
    address[] public allowedTokens;
    IERC20 public dappToken;
// fundTokens - DONE!
// unFundTokens - DONE
// issueTokens - DONE!
// addAllowedTokens - DONE!
// getValue - DONE!

// 100 ETH 1:1 for every 1 ETH, we give 1 DappToken
// 50 ETH and 50 DAI fundd, and we want to give a reward of 1 DAPP / 1 DAI

    constructor(address _dappTokenAddress) public {
        dappToken = IERC20(_dappTokenAddress);
    }

    function setPriceFeedContract(address _token, address _priceFeed)
        public
        onlyOwner 
    {
        tokenPriceFeedMapping[_token] = _priceFeed;
    }

    function getUserTotalValue(address _user) public view returns (uint256){
        uint256 totalValue = 0;
        require(uniqueTokensFundd[_user] > 0, "No tokens fundd!");
        for (
            uint256 allowedTokensIndex = 0;
            allowedTokensIndex < allowedTokens.length;
            allowedTokensIndex++
        ){
            totalValue = totalValue + getUserSingleTokenValue(_user, allowedTokens[allowedTokensIndex]);
        }
        return totalValue;
    }

    function getUserSingleTokenValue(address _user, address _token) 
    public
    view 
    returns (uint256) {
        if (uniqueTokensFundd[_user] <= 0){
            return 0;
        }
        // price of the token * stakingBalance[_token][user]
        (uint256 price, uint256 decimals) = getTokenValue(_token);
        return 
            // 10000000000000000000 ETH
            // ETH/USD -> 10000000000
            // 10 * 100 = 1,000
            (stakingBalance[_token][_user] * price / (10**decimals));
    }

    function getTokenValue(address _token) public view returns (uint256, uint256) {
        // priceFeedAddress
        address priceFeedAddress = tokenPriceFeedMapping[_token];
        AggregatorV3Interface priceFeed = AggregatorV3Interface(priceFeedAddress);
        (,int256 price,,,)= priceFeed.latestRoundData();
        uint256 decimals = uint256(priceFeed.decimals());
        return (uint256(price), decimals);
    }


    function fundTokens(uint256 _amount, address _token) public {
        require(_amount > 0, "Amount must be more than 0");
        require(tokenIsAllowed(_token), "Token is currently no allowed");
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        updateUniqueTokensFundd(msg.sender, _token);
        stakingBalance[_token][msg.sender] = stakingBalance[_token][msg.sender] + _amount;
        if (uniqueTokensFundd[msg.sender] == 1){
            fundrs.push(msg.sender);
        }
    }

    function updateUniqueTokensFundd(address _user, address _token) internal {
        if (stakingBalance[_token][_user] <= 0){
            uniqueTokensFundd[_user] = uniqueTokensFundd[_user] + 1;
        }
    }

    function addAllowedTokens(address _token) public onlyOwner {
        allowedTokens.push(_token);
    }

    function tokenIsAllowed(address _token) public returns (bool) {
        for( uint256 allowedTokensIndex=0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++){
            if(allowedTokens[allowedTokensIndex] == _token){
                return true;
            }
        }
        return false; 
    }
    function currentFundBalance() public view returns(uint256) {
        return(uint256(address(this).balance));
    }

    function fundEth() public payable{
        ethStakingBalance[msg.sender] = msg.value;
    }
}