// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {console} from "forge-std/console.sol";

contract Voting {
    error Voting__PollDoesNotExist();
    error Voting__PollIsNotActive();
    error Voting__InvalidOption();
    error Voting__SenderIsNotCreatorOfThePoll();

    struct Poll {
        string question;
        string[] options;
        mapping(uint256 => uint256) votes;
        bool exists;
        bool active;
        address creator;
    }

    uint public pollCount;
    mapping(uint256 => Poll) public polls;

    // events
    event PollCreated(uint256 pollId, string question, string[] options);
    event VoteCasted(uint256 pollId, uint256 optionId);

    // functions
    function createPoll(
        string memory _question,
        string[] memory _options
    ) public {
        Poll storage newPoll = polls[pollCount];
        newPoll.question = _question;
        newPoll.options = _options;
        newPoll.exists = true;
        newPoll.active = true;
        newPoll.creator = msg.sender;

        emit PollCreated(pollCount, _question, _options);
        pollCount++;
    }

    function vote(uint256 _pollId, uint256 _optionId) public {
        Poll storage poll = polls[_pollId];
        if (!poll.exists) {
            revert Voting__PollDoesNotExist();
        }
        if (!poll.active) {
            revert Voting__PollIsNotActive();
        }
        console.log(poll.options.length);
        if (_optionId >= poll.options.length) {
            revert Voting__InvalidOption();
        }

        poll.votes[_optionId] += 1;

        emit VoteCasted(_pollId, _optionId);
    }

    function viewVotes(
        uint256 _pollId,
        uint256 _optionId
    ) public view returns (uint256) {
        Poll storage poll = polls[_pollId];
        if (!poll.exists) {
            revert Voting__PollDoesNotExist();
        }
        if (_optionId >= poll.options.length) {
            revert Voting__InvalidOption();
        }

        return poll.votes[_optionId];
    }

    function closePoll(uint256 _pollId) public {
        Poll storage poll = polls[_pollId];
        if (!poll.exists) {
            revert Voting__PollDoesNotExist();
        }
        if (poll.creator != msg.sender) {
            revert Voting__SenderIsNotCreatorOfThePoll();
        }

        poll.active = false;
    }

    function getPoll(
        uint256 pollId
    )
        public
        view
        returns (
            string memory question,
            string[] memory pollOptions,
            bool active,
            address creator
        )
    {
        Poll storage poll = polls[pollId];

        uint256 numOptions = poll.options.length;

        string[] memory optionsArray = new string[](numOptions);

        for (uint256 i = 0; i < numOptions; i++) {
            optionsArray[i] = poll.options[i];
        }

        return (poll.question, optionsArray, poll.active, poll.creator);
    }
}
