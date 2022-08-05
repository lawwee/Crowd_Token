// SPDX-License-Identifier: Unlicense

import "./timedcrowdsale.sol";

pragma solidity ^0.8.9;

abstract contract FinalizedCrowdsale is TimedCrowdsale {
    bool private _finalized;

    event CrowdsaleFinalized();

    constructor() {
        _finalized = false;
    }

    function finalized() public view returns(bool) {
        return _finalized;
    }

    function finalize() public virtual {
        require(!_finalized, "FinalizedCrowdsale: already finalized");
        require(hasClosed(), "FinalizableCrowdsale: crowdsale has not closed");

        _finalized = true;

        _finalization();
        emit CrowdsaleFinalized();
    }

    function _finalization() internal {}
}