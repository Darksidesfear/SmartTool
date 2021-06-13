// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SmartWallet.sol";

contract FundsManagerWithSolution {
    
    address private attacker;
    address private owner;
    address[] private participants;
    mapping(address => uint) private customerBalance;
    mapping(address => SmartWallet) private customerWallets;
    address[] private existingWallets;
    uint private counter;
    
    constructor(address wallet1, address wallet2, address wallet3)  payable {
        owner = msg.sender;
        customerBalance[msg.sender] += msg.value;
        existingWallets.push(wallet1);
        existingWallets.push(wallet2);
        existingWallets.push(wallet3);
        counter = 0;
    }
    
    modifier ownerOnly() {
        require(msg.sender == owner, "Error not owner");
        _;
    }
    
    function getAttackerAddress() external view ownerOnly returns(address) {
        return attacker;
    }
    
    function getParticipants(uint ID) external view ownerOnly returns(address) {
        return participants[ID];
    }
    
    function addUser(address userAddress) public {
        participants.push(userAddress);
        customerWallets[userAddress] = SmartWallet(existingWallets[counter]);
        counter++;
    }
    
    function depositFunds() external payable returns(bool) {
        require(msg.value > 0, "value not greater than 0");
        customerBalance[msg.sender] += msg.value;
        customerWallets[msg.sender].deposit{value:msg.value}();
        return true;
    }

    function checkTransaction() private returns(bool) {
        bool result = true;
        for(uint i = 0; i < participants.length; i++){
            result = customerBalance[participants[i]] == customerWallets[participants[i]].getWalletBalance();
        }
        return result;
    }
    
    function updateState() private {
        for (uint i = 0; i < participants.length; i++){
            customerBalance[participants[i]] != customerWallets[participants[i]].getWalletBalance();
        }    
    }
    
    function withdrawFunds(uint _value) public payable {
        require(_value <= customerBalance[msg.sender], "balance is low");
        if (checkTransaction()) {
            customerWallets[msg.sender].transfer(msg.sender, _value);
            customerBalance[msg.sender] -= _value;
        } else {
            attacker = msg.sender;
            updateState();
        }
    }
    
    function transfer(address to, uint _value) public payable {
        require(_value <= customerBalance[msg.sender], "balance is low");
        if (checkTransaction()) {
            customerWallets[msg.sender].transfer(to, _value);
            customerBalance[msg.sender] -= _value;
            customerBalance[to] += _value;
        } else {
            attacker = msg.sender;
            updateState();
        }
    }
    
    function getBankLiquidity() external view returns(uint) {
        return address(this).balance;
    }
    
    function getCustomerBalance() public view returns(uint) {
        return customerWallets[msg.sender].getWalletBalance();
    }
}