// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CroudFunding {

    // public variables and properties of a campaign
    string public name;
    string public description;
    uint256 public goal; // how much person want to raise
    uint256 public deadline;
    address public owner; // wallet address of the owner of the campaign.  


    constructor(
        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _durationInDays
    ) {
        name = _name;
        description = _description;
        goal = _goal;
        deadline =  block.timestamp + (_durationInDays * 1 days); // getting curret time by block.timestamp and adding duration in day to it
        owner = msg.sender; // getting wallet address from message sender
    }


    // function that allows us to fetch and do operartions
    // now we use requre(conditon); so that if the conditions are not met then our function won't execute and gas won't be used unnecesaary, same as code optimization

    function fund() public payable {

        // if this is not true function won't execute
        require(msg.value > 0, "Too little funds to fund the campaign (should be > 0)");
        require(block.timestamp < deadline, "Campaign has ended");
    }

    function withdraw() public {
        require(msg.sender == owner, "Only hte owner can withdraw.");
        require(address(this).balance >= goal, "Goal has not been reached.");

        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        payable(owner).transfer(balance);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}