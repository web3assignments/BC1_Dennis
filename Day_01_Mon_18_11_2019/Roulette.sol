
pragma solidity >=0.5.0 <0.7.0;


contract Roulette {

  /*
  Functions this contact will have:
  
	randomNumber() a number between 0 and 36
	placeBet() with the params value and number.
	payout() checks if payout is to player or bank.
  checkBank() if bet exeeds bank there is no round.
  */
  
  uint testBankBalance=100; // swap this with eth balance of the contract.
  uint playerBet;
  uint playerNumber;
  uint rouletteNumber;
  
  
 
  function getBankBalance() public view returns(uint256) {
        return testBankBalance;
  }
  
  function winOrLose() private returns(bool){
    bool outcome=false;
    rouletteNumber=getRandom();
    if(playerNumber==rouletteNumber){
    	testBankBalance-=playerBet*2;
      outcome=true;
    }
    return outcome;
  
  }
  /* ToDo: 
  				make number range between 0 and 36.
          make number random;
  */
  function getRandom() public view returns(uint256) { 
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.coinbase, block.timestamp)));  
    }
  
  
 	
  function PlayerBet(uint number) public payable returns(bool){
    	playerBet=msg.value;
    	playerNumber=number;
    	testBankBalance+=playerBet;// add bet to balance;
    	require(playerBet > 0, "No money added to bet.");
      require(testBankBalance <= playerBet*2, "Not enough money in bank for this bet.");
    	return winOrLose();
    
    	
    	
    }
    