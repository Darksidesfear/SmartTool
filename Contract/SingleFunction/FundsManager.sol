pragma solidity >=0.7.0 <0.9.0;

contract FundsManager {
     
    address private owner;
    mapping(address => uint) private customerBalance;
    
    constructor() public payable {
        owner = msg.sender;
        customerBalance[msg.sender] += msg.value;
    }
    
    function depositFunds() external payable returns(bool) {
        require(msg.value > 0, "Value not greater than 0");
        customerBalance[msg.sender] += msg.value;
        return true;
    }
    
    function withdrawFunds(uint _value) public payable {
        require(_value <= customerBalance[msg.sender], "Balance is low");
        msg.sender.call{value:_value}("");
        customerBalance[msg.sender] -= _value;
    }
    
    function transfer(address to, uint _value) public payable {
        require(_value <= customerBalance[msg.sender], "Valance is low");
        customerBalance[to] -= _value;
        customerBalance[msg.sender] -= _value;
    }
    
    function getFundsManagerLiquidity() external view returns(uint) {
        return address(this).balance;
    }
    
    function getCustomerBalance() public view returns(uint) {
        return customerBalance[msg.sender];
    }
    
}