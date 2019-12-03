
pragma solidity >=0.5.0 <0.7.0;


contract Roulette {
   /*
    Functions this contact will have:
	  randomNumber() a number between 0 and 36
	  placeBetByNumber() with the params value and number.
    placeBetOddEven()
    placeBetRedBlack()
    placeBetRow()
    placeBetCorner()
	  payout() checks if payout is to player or bank.
    checkBank() if bet exeeds bank there is no round.

  */

  struct Player{
    mapping(address => uint) playerRound;
  }

  uint bankBalance; 
  uint playerBet;
  uint playerNumber;
  Player player;
  enum betModes{ByNumber,ByOddEven,ByRedBlack,ByRow,ByCorner}
  
  event rouletteOutcome(uint result, bool winner);
  event rollResult(uint player, uint table);
  
  constructor() public payable {}
 
  function getBankBalance() public view returns(uint256) {
        return address(this).balance;
  }
  
  function winOrLose() private returns(bool){
    bool outcome=false;
    uint rouletteNumber=getRandom();
    emit rollResult(playerNumber,rouletteNumber);
    //Rework so it can check for the other bets line 9 till 10 
    if(playerNumber==rouletteNumber){
      outcome=true;
    }
    emit rouletteOutcome(rouletteNumber,outcome);
    return outcome;
  
  }

  function betBy(betModes mode, uint number)private view returns(bool){
    return true;
  }
  function betByNumber(uint number) private view returns(bool){
    if(playerNumber==number){
      return true;
    }else{
      return false;
    }
  }
  function betByOdd(uint number,uint rNumber)private view returns(bool){
    uint isOdd=rNumber;
    if(number==isOdd){
       return true;
    }else{
      return false;
    }
  }
  function betByColor()private view returns(bool){
    return true;
  }
  function betByRow() private view returns(bool){
    return true;
  }
  function betByCorner() private view returns(bool){
    return true;
  }
  
  /*
    make real random number
  */
  function getRandom() public view returns(uint256) { 
        uint random = uint256(keccak256(abi.encodePacked(block.difficulty, block.coinbase, block.timestamp)))%37;
        assert(random <=36);
        return random;  
    }
  
  function PlayerBet(uint number) public payable returns(bool){
      
      address payable betPlacer = address(msg.sender); 
      player.playerRound[msg.sender]=number;
    	playerBet=msg.value;
    	playerNumber=player.playerRound[msg.sender];
    	bankBalance=getBankBalance();// add bet to balance;
    	require(playerBet > 0, "No money added to bet.");
      require(playerBet*2 <=bankBalance, "Not enough money in bank for this bet."); 
    	bool winner= winOrLose();
      if(winner){
        betPlacer.transfer(playerBet*2);
      }
      return winner;
    }
  function AddToJackPot() public payable returns(bool){
    return true;
  }

  
}
    