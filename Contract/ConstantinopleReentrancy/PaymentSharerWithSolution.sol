// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SmartWallet.sol";

contract PaymentSharerWithSolution {
    
  mapping(address => uint) splits;
  uint deposits;
  address payable first;
  address payable second;
  mapping(address => SmartWallet) private customerWallets;
  address[] private existingWallets;
  
  constructor(address wallet1, address wallet2)  payable {
      existingWallets.push(wallet1);
      existingWallets.push(wallet2);
  }

  function init(address payable _first, address payable _second) public {
    first = _first;
    second = _second;
    customerWallets[first] = SmartWallet(existingWallets[0]);
    customerWallets[second] = SmartWallet(existingWallets[1]);
  }
  
  function deposit() public payable {
    deposits += msg.value;
    customerWallets[msg.sender].deposit{value:msg.value}();
  }

  function updateSplit(uint split) public {
    require(split <= 100);
    splits[msg.sender] = split;
  }
  
  function checkSplit(address user) private returns(bool) {
      uint total = customerWallets[first].getWalletBalance() + customerWallets[second].getWalletBalance();
      uint correctSplit = (customerWallets[user].getWalletBalance() * 100) / total;
      return (correctSplit == splits[user]);
  }

  function splitFunds() public {
    // Here would be: 
    // Signatures that both parties agree with this split
    if (checkSplit(msg.sender)) {
        address caller = first;
        address otherUser = second;
        if (msg.sender == second) {
            caller = second;
            otherUser = first;
        }
        // Split
        uint depo = deposits;
        deposits = 0;
        customerWallets[caller].transfer(caller, depo * splits[caller] / 100);
        customerWallets[otherUser].transfer(otherUser, depo * splits[otherUser] / 100);
    }
    
  }
}