// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Voting} from "src/Voting.sol";

contract VotingTest is Test {
    Voting voting;

    address USER = makeAddr("user");

    event PollCreated(uint256 pollId, string question, string[] options);
    event VoteCasted(uint256 pollId, uint256 optionId);

    function setUp() public {
        voting = new Voting();
    }

    /*//////////////////////////////////////////////////////////////
                            CREATE POLL
    //////////////////////////////////////////////////////////////*/

    function testCreatePoll() public {
        // Arrange
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        (string memory question, , , ) = voting.polls(0);

        assertEq(question, "Should we upgrade?");
    }

    function testCreatePollEmitsPollCreatedEvent() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        vm.expectEmit(true, true, true, true);
        emit PollCreated(0, "Should we upgrade?", options);

        // Call the function
        voting.createPoll("Should we upgrade?", options);
    }

    function testPollCountIncreasedOrNot() public {
        uint256 pollCount = voting.pollCount();
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        // Act
        uint256 updatedPollCount = voting.pollCount();

        assert(updatedPollCount > pollCount);
    }

    /*//////////////////////////////////////////////////////////////
                                VOTE
    //////////////////////////////////////////////////////////////*/

    function testVoteRevertsIfPollNotExists() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";

        vm.expectRevert(Voting.Voting__PollDoesNotExist.selector);
        voting.vote(0, 1);
    }

    function testVoteRevertsIfPollNotActive() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        voting.closePoll(0);
        vm.expectRevert(Voting.Voting__PollIsNotActive.selector);
        voting.vote(0, 1);
    }

    function testVoteRevertsIfOptionSelectedIsInvalid() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        vm.expectRevert(Voting.Voting__InvalidOption.selector);
        voting.vote(0, 2);
    }

    function testVoteCountIncreased() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        voting.vote(0, 1);
        voting.vote(0, 1);
        voting.vote(0, 0);

        uint256 yesVotes = voting.viewVotes(0, 0);
        uint256 noVotes = voting.viewVotes(0, 1);

        assert(yesVotes == 1);
        assert(noVotes == 2);
    }

    function testVoteEmitsVoteCastedEvent() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        vm.expectEmit(true, true, true, true);
        emit VoteCasted(0, 0);

        voting.vote(0, 0);
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW VOTES
    //////////////////////////////////////////////////////////////*/

    function testViewVoteRevertsIfPollNotExists() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";

        vm.expectRevert(Voting.Voting__PollDoesNotExist.selector);
        voting.viewVotes(0, 1);
    }

    function testViewVoteRevertsIfOptionSelectedIsInvalid() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        vm.expectRevert(Voting.Voting__InvalidOption.selector);
        voting.viewVotes(0, 2);
    }

    /*//////////////////////////////////////////////////////////////
                            CLOSE POLL
    //////////////////////////////////////////////////////////////*/

    function testClosePollRevertsIfPollNotExists() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";

        vm.expectRevert(Voting.Voting__PollDoesNotExist.selector);
        voting.closePoll(0);
    }

    function testClosePollRevertsIfNotCreator() public {
        string[] memory options = new string[](2);
        options[0] = "Yes";
        options[1] = "No";
        voting.createPoll("Should we upgrade?", options);

        vm.expectRevert(Voting.Voting__SenderIsNotCreatorOfThePoll.selector);
        vm.prank(USER);
        voting.closePoll(0);
    }
}
