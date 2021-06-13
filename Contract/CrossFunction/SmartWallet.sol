pragma solidity >=0.7.0 <0.9.0;

contract SmartWallet {
    
    uint public walletBalance;
    
    constructor() payable {
        walletBalance = 0;
    }
    
    function deposit() public payable returns(bool) {
        require(msg.value > 0, "value not greater than 0");
        walletBalance += msg.value;
        return true;
    }
    
    function transfer(address user, uint _value) public payable {
        walletBalance -= msg.value;
        user.call{value:_value}("");
    }
    
    function getWalletBalance() public view returns(uint){
        return address(this).balance;
    }
}
