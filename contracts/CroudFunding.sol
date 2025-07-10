// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CroudFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256){
        Campaign storage campaign = campaigns[numberOfCampaigns];
        
        // is everything ok?
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    // payable is a keyword that allows the function to accept ether
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id]; // mapping we did above

        campaign.donators.push(msg.sender); // add the address of the donator to the campaign
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected += amount;
        }
    }
    
    // address[] memory, uint256[] memory means that we are returning two arrays and they are both in memory
    // view means that this function does not modify the state of the contract
    // public means that this function can be called from outside the contract
    // _id is the id of the campaign we want to get the donators and donations for

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        // we are creating a new array variable of Campaign structs with the size of numberOfCampaigns
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0;i < numberOfCampaigns; i++) {
            // storage means that we are getting the campaign from the blockchain
            // Campaign storage means that we are getting the campaign from the storage

            Campaign storage item = campaigns[i];

            allCampaigns[i] = item; // we are assigning the item to the array
        }

        return allCampaigns;
    }
}