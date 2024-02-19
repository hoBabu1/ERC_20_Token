// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract hoBabu is IERC20{

  string public name="hoBabu"; //name of the token
  string public symbol="hoBabu"; //symbol of the token
  uint public decimal=18; // manages decimal value 
  address public founder;//initially this will have the total supply 
  uint public totalSupply;

  mapping(address=>mapping(address=>uint)) allowed;
  mapping(address=>uint) public balances; 
  mapping(address => bool) public isFreeze;
  bool stopAllFunctions;
  constructor(){
    founder=msg.sender;
    totalSupply=1000;
    balances[founder]=totalSupply;
  }

  modifier freezeStatus(){
    require(isFreeze[msg.sender]==false,"Your account is freezed");
   _;
  }
  modifier emergencyStatus(){
   require(stopAllFunctions==false,"Emergency declared");
   _;
  }
  
  function balanceOf(address account) external view returns (uint256){
    return balances[account];
  }

  function transfer(address recipient, uint256 amount) external freezeStatus() emergencyStatus() returns (bool){
     require(amount>0,"Amount must be greater than zero");
     require(balances[msg.sender]>=amount,"You don't have enough balance");
     balances[msg.sender]-=amount;
     balances[recipient]+=amount;
     emit Transfer(msg.sender,recipient,amount);
     return true;
  }
 
  function allowance(address owner, address spender) external view returns (uint256){
       return allowed[owner][spender];
  } 
 
  function approve(address spender, uint256 amount) external freezeStatus() emergencyStatus() returns (bool){
      require(amount>0,"Amount must be greater than zero");
      require(balances[msg.sender]>=amount,"You don't have enough balance");
      allowed[msg.sender][spender]=amount;
      emit Approval(msg.sender,spender,amount);
      return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) external freezeStatus() emergencyStatus() returns (bool){
      require(amount>0,"Amount must be greater than zero");
      require(balances[sender]>=amount,"You don't have enough balance");
      require(allowed[sender][recipient]>=amount,"Sender has not authorised to receiver for the given amount");
      balances[sender]-=amount;
      balances[recipient]+=amount;
      return true;
  }
  
    function freezAccount(address freezingAddress) public {
        require(msg.sender==founder,"You are not the founder");
        isFreeze[freezingAddress]=true;
  }

  function unFreezAccount(address unfreezingAddress) public{
        require(msg.sender==founder,"You are not the founder");
        isFreeze[unfreezingAddress]=false;
   }

   function emergency() public {
      stopAllFunctions=true;
   }
  
}