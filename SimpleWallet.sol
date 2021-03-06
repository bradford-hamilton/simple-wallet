contract SimpleWallet {
  address owner;

  struct WithdrawalStruct {
    address to;
    uint amount;
  }

  struct Senders {
    bool allowed;
    uint amount_sends;
    mapping(uint => WithdrawalStruct) withdrawals;
  }

  mapping (address => Senders) isAllowedToSendFundsMapping;

  event Deposit(address _sender, uint amount);
  event Withdrawal(address _sender, uint amount, address _beneficiary);

  function SimpleWallet() {
    owner = msg.sender;
  }

  function() {
    if (msg.sender == owner || isAllowedToSendFundsMapping[msg.sender] == true) {
      Deposit(msg.sender, msg.value);
    } else {
      throw;
    }
  }

  function sendFunds(uint amount, address receiver) returns (uint) {
    if (isAllowedToSend(msg.sender)) {
      if (this.balance >= amount) {
        if (!receiver.send(amount)) {
          throw;
        }
      }
      Withdrawal(msg.sender, amount, reveiver);
      isAllowedToSendFundsMapping[msg.sender].amount_sends++;
      isAllowedToSendFundsMapping[msg.sender].withdrawals[isAllowedToSendFundsMapping[msg.sender].amount_sends].to = receiver;
      isAllowedToSendFundsMapping[msg.sender].withdrawals[isAllowedToSendFundsMapping[msg.sender].amount_sends].amount = amount;
      return this.balance;
    }
  }

  function getAmountOfWithdrawals(address _address) constant returns (uint) {
    return isAllowedToSendFundsMapping[_address].amount_sends;
  }

  function getWithdrawalForAddress(address _address, uint index) constant returns (address, uint) {
    return (isAllowedToSendFundsMapping[_address].withdrawals[index].to, isAllowedToSendFundsMapping[_address].withdrawals[index].amount);
  }

  function allowAddressToSendMoney(address _address) {
    if (msg.sender == owner) {
      isAllowedToSendFundsMapping[_address].allowed = true;
    }
  }

  function disallowAddressToSendMoney(address _address) {
    if (msg.sender == owner) {
      isAllowedToSendFundsMapping[_address].allowed = false;
    }
  }

  function isAllowedToSend(address _address) constant returns (bool) {
    return isAllowedToSendFundsMapping[_address].allowed || _address == owner;
  }

  function killWallet() {
    if (msg.sender == owner) {
      suicide(owner);
    }
  }
}
