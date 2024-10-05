import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { contractAddress, abi } from "./constants";

const Voting = () => {
    const [provider, setProvider] = useState(null); // Store the web3 provider
    const [signer, setSigner] = useState(null); // Store the signer (the user)
    const [contract, setContract] = useState(null); // Store the smart contract instance
    const [account, setAccount] = useState(null); // Store the smart contract instance
    const [polls, setPolls] = useState([]); // Store the list of polls
    const [question, setQuestion] = useState(""); // State to store the new poll question
    const [options, setOptions] = useState(["", ""]);
    const [voteCounts, setVoteCounts] = useState({});

    const contAddress = contractAddress;

    useEffect(() => {
        const connectWallet = async () => {
            try {
                if (window.ethereum) {
                    const tempProvider = new ethers.providers.JsonRpcProvider(
                        "http://127.0.0.1:8545"
                    );

                    const signer = tempProvider.getSigner();
                    setProvider(tempProvider);
                    setSigner(signer);

                    const accountAddress = await signer.getAddress();
                    setAccount(accountAddress);

                    const tempContract = new ethers.Contract(
                        contAddress,
                        abi,
                        tempProvider.getSigner()
                    );
                    setContract(tempContract);
                }
            } catch (error) {
                throw new Error(error);
            }
        };
        connectWallet();
    }, []);
    const loadPolls = async (contract) => {
        const pollCount = await contract.pollCount();
        const tempPolls = [];
        const tempVoteCounts = {};

        for (let i = 0; i < pollCount; i++) {
            const [question, options, active, creator] = await contract.getPoll(
                i
            );
            tempPolls.push({
                question,
                options,
                active,
                creator,
                pollId: i,
            });

            const votes = [];
            for (let j = 0; j < options.length; j++) {
                const voteCount = await contract.viewVotes(i, j);
                votes.push(voteCount.toNumber());
            }
            tempVoteCounts[i] = votes;
        }

        setPolls(tempPolls);
        setVoteCounts(tempVoteCounts);
    };

    const createPoll = async () => {
        await contract.createPoll(question, options);
        await loadPolls(contract);
    };

    const voteOnPoll = async (pollId, optionId) => {
        await contract.vote(pollId, optionId);
        await loadPolls(contract);
    };

    return (
        <div>
            <h1>Voting DApp</h1>
            {account && <p>Connected Account: {account}</p>}
            <h2>Create Poll</h2>

            <input
                placeholder="Poll Question"
                onChange={(e) => setQuestion(e.target.value)}
            />

            <input
                placeholder="Option 1"
                onChange={(e) => setOptions([e.target.value, options[1]])}
            />

            <input
                placeholder="Option 2"
                onChange={(e) => setOptions([options[0], e.target.value])}
            />

            <button onClick={createPoll}>Create Poll</button>

            <h2>Vote on Polls</h2>

            {polls.map((poll, index) => (
                <div key={index}>
                    <h3>{poll.question}</h3>
                    {poll.options.map((option, i) => (
                        <div key={i}>
                            <button onClick={() => voteOnPoll(index, i)}>
                                {option}
                            </button>
                            <p>
                                Votes:{" "}
                                {voteCounts[index] ? voteCounts[index][i] : 0}
                            </p>
                        </div>
                    ))}
                </div>
            ))}
        </div>
    );
};

export default Voting;
