export const contractAddress = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";

export const abi = [
    {
        type: "function",
        name: "closePoll",
        inputs: [
            {
                name: "_pollId",
                type: "uint256",
                internalType: "uint256",
            },
        ],
        outputs: [],
        stateMutability: "nonpayable",
    },
    {
        type: "function",
        name: "createPoll",
        inputs: [
            {
                name: "_question",
                type: "string",
                internalType: "string",
            },
            {
                name: "_options",
                type: "string[]",
                internalType: "string[]",
            },
        ],
        outputs: [],
        stateMutability: "nonpayable",
    },
    {
        type: "function",
        name: "getPoll",
        inputs: [
            {
                name: "pollId",
                type: "uint256",
                internalType: "uint256",
            },
        ],
        outputs: [
            {
                name: "question",
                type: "string",
                internalType: "string",
            },
            {
                name: "pollOptions",
                type: "string[]",
                internalType: "string[]",
            },
            {
                name: "active",
                type: "bool",
                internalType: "bool",
            },
            {
                name: "creator",
                type: "address",
                internalType: "address",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "pollCount",
        inputs: [],
        outputs: [
            {
                name: "",
                type: "uint256",
                internalType: "uint256",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "polls",
        inputs: [
            {
                name: "",
                type: "uint256",
                internalType: "uint256",
            },
        ],
        outputs: [
            {
                name: "question",
                type: "string",
                internalType: "string",
            },
            {
                name: "exists",
                type: "bool",
                internalType: "bool",
            },
            {
                name: "active",
                type: "bool",
                internalType: "bool",
            },
            {
                name: "creator",
                type: "address",
                internalType: "address",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "viewVotes",
        inputs: [
            {
                name: "_pollId",
                type: "uint256",
                internalType: "uint256",
            },
            {
                name: "_optionId",
                type: "uint256",
                internalType: "uint256",
            },
        ],
        outputs: [
            {
                name: "",
                type: "uint256",
                internalType: "uint256",
            },
        ],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "vote",
        inputs: [
            {
                name: "_pollId",
                type: "uint256",
                internalType: "uint256",
            },
            {
                name: "_optionId",
                type: "uint256",
                internalType: "uint256",
            },
        ],
        outputs: [],
        stateMutability: "nonpayable",
    },
    {
        type: "event",
        name: "PollCreated",
        inputs: [
            {
                name: "pollId",
                type: "uint256",
                indexed: false,
                internalType: "uint256",
            },
            {
                name: "question",
                type: "string",
                indexed: false,
                internalType: "string",
            },
            {
                name: "options",
                type: "string[]",
                indexed: false,
                internalType: "string[]",
            },
        ],
        anonymous: false,
    },
    {
        type: "event",
        name: "VoteCasted",
        inputs: [
            {
                name: "pollId",
                type: "uint256",
                indexed: false,
                internalType: "uint256",
            },
            {
                name: "optionId",
                type: "uint256",
                indexed: false,
                internalType: "uint256",
            },
        ],
        anonymous: false,
    },
    {
        type: "error",
        name: "Voting__InvalidOption",
        inputs: [],
    },
    {
        type: "error",
        name: "Voting__PollDoesNotExist",
        inputs: [],
    },
    {
        type: "error",
        name: "Voting__PollIsNotActive",
        inputs: [],
    },
    {
        type: "error",
        name: "Voting__SenderIsNotCreatorOfThePoll",
        inputs: [],
    },
];
