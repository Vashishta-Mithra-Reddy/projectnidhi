// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Nidhi {
    struct Listing {
        address creator;
        string title;
        string description;
        uint256 targetAmount;
        uint256 amountRaised;
        bool isActive;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCount;

    event ListingCreated(uint256 indexed listingId, address indexed creator, string title, uint256 targetAmount);
    event Funded(uint256 indexed listingId, address indexed funder, uint256 amount);
    event ListingClosed(uint256 indexed listingId);

    function createListing(string memory _title, string memory _description, uint256 _targetAmount) external {
        require(_targetAmount > 0, "Target amount must be greater than zero");
        
        listings[listingCount] = Listing({
            creator: msg.sender,
            title: _title,
            description: _description,
            targetAmount: _targetAmount,
            amountRaised: 0,
            isActive: true
        });
        
        emit ListingCreated(listingCount, msg.sender, _title, _targetAmount);
        listingCount++;
    }

    function fundListing(uint256 _listingId) external payable {
        require(_listingId < listingCount, "Listing does not exist");
        Listing storage listing = listings[_listingId];
        require(listing.isActive, "Listing is not active");
        require(msg.value > 0, "Must send some funds");
        
        listing.amountRaised += msg.value;
        payable(listing.creator).transfer(msg.value);
        
        emit Funded(_listingId, msg.sender, msg.value);
    }

    function closeListing(uint256 _listingId) external {
        require(_listingId < listingCount, "Listing does not exist");
        Listing storage listing = listings[_listingId];
        require(msg.sender == listing.creator, "Only the creator can close the listing");
        require(listing.isActive, "Listing is already closed");
        
        listing.isActive = false;
        emit ListingClosed(_listingId);
    }
}
