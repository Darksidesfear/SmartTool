pragma solidity >=0.7.0 <0.9.0;

import "./FundsManagerWithSolution.sol";

contract Attacker2 {

    FundsManagerWithSolution public target;
    
    
    constructor(address victimAddress) payable {
        target = FundsManagerWithSolution(victimAddress);
    }
    
    function withdraw(uint _value) public payable {
        target.withdrawFunds(_value);
    }
    
    function getAttackerBalance() public view returns(uint){
        return address(this).balance;
    }
    
    fallback() external payable {
    }
}