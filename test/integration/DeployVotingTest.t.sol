// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Voting} from "src/Voting.sol";
import {DeployVoting} from "script/DeployVoting.s.sol";

contract DeployVotingTest is Test {
    DeployVoting deployVoting;
    Voting voting;

    function setUp() public {
        deployVoting = new DeployVoting();
        deployVoting.run();

        voting = Voting(address(deployVoting));
    }

    function testVotingIsDeployed() public view {
        assert(address(voting) != address(0));
    }
}
