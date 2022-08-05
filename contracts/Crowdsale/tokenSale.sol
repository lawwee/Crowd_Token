// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "../token.sol";
import "./capcrowdsale.sol";
import "./finalizedcrowdsale.sol";
import "./timedcrowdsale.sol";
import "./crowdsale.sol";
import "../Extras/tokentimelock.sol";

contract Crowd_Token is Crowdsale, CappedCrowdsale, TimedCrowdsale, FinalizedCrowdsale {
    // Track Contributions
    uint256 public minInvestorPrice = 0.0002 ether;
    uint256 public maxInvestorPrice = 50 ether;
    mapping(address => uint256) public contributions;

    // Crowdsale Stages
    enum CrowdsaleStage { PreICO, ICO }
    CrowdsaleStage public stage = CrowdsaleStage.PreICO;

    address private admin;

    // Token Distribution
    uint256 public tokenSalePercentage = 60;
    uint256 public foundersPercentage = 20;
    uint256 public foundationPercentage = 10;
    uint256 public partnersPercentage = 10;

    // Token reserve funds
    address public foundersFund;
    address public foundationFund;
    address public partnersFund;

    // Token Time lock
    uint256 public releaseTime;
    address public foundersTimelock;
    address public foundationTimelock;
    address public partnersTimelock;

    constructor(
        uint256 _rate,
        address payable _wallet,
        TokenERC20 _token,
        uint256 _cap,
        uint256 _openingTime,
        uint256 _closingTime,
        address _foundersFund,
        address _foundationFund,
        address _partnersFund,
        uint256 _releaseTime
    ) 
        Crowdsale(_rate, _wallet, _token)
        CappedCrowdsale(_cap)
        TimedCrowdsale(_openingTime, _closingTime)
    {
        foundersFund = _foundersFund;
        foundationFund = _foundationFund;
        partnersFund = _partnersFund;
        releaseTime = _releaseTime;
        admin = msg.sender;
    }

    function getUserContributions(address _beneficiary) public view returns (uint256) {
        return contributions[_beneficiary];
    }

    function setCrowdsaleStage(uint _stage) public {
        require(msg.sender == admin, "TokenSale: No access to call function");
        if(uint(CrowdsaleStage.PreICO) == _stage) {
            stage = CrowdsaleStage.PreICO;
        } else if (uint(CrowdsaleStage.ICO) == _stage) {
            stage = CrowdsaleStage.ICO;
        }

        if(stage == CrowdsaleStage.PreICO) {
            _rate = 500;
        } else if(stage == CrowdsaleStage.ICO) {
            _rate = 250;
        }
    }

    function _forwardFunds() internal override {
        if(stage == CrowdsaleStage.PreICO) {
            _wallet.transfer(msg.value);
        } else if(stage == CrowdsaleStage.ICO) {
            super._forwardFunds();
        }
    }

    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal override(Crowdsale, CappedCrowdsale, TimedCrowdsale) {
        super._preValidatePurchase(_beneficiary, _weiAmount);
        uint256 _existingContribution = contributions[_beneficiary];
        uint256 _newContribution = _existingContribution + _weiAmount;
        require(_newContribution >= minInvestorPrice && _newContribution <= maxInvestorPrice, "TokenSale: Investor price is not up to minimum or has exceeded maximum");
        contributions[_beneficiary] = _newContribution;
    }

    function finalize() public override {
        TokenERC20 funtoken;
        uint256 alreadyMinted = funtoken.totalSupply();

        uint256 _finalTokenSupply = (alreadyMinted / tokenSalePercentage) * 100;

        TokenTimelock _foundersTimelock = new TokenTimelock(_token, foundersFund, releaseTime);
        TokenTimelock _foundationTimelock = new TokenTimelock(_token, foundationFund, releaseTime);
        TokenTimelock _partnersTimelock = new TokenTimelock(_token, partnersFund, releaseTime);

        foundersTimelock = address(_foundersTimelock);
        foundationTimelock = address(_foundationTimelock);
        partnersTimelock = address(_partnersTimelock);

        funtoken.mint(foundersTimelock, (_finalTokenSupply * foundersPercentage) / 100);
        funtoken.mint(foundationTimelock, (_finalTokenSupply * foundationPercentage) / 100);
        funtoken.mint(partnersTimelock, (_finalTokenSupply * partnersPercentage) / 100);

        super.finalize();
    }

}