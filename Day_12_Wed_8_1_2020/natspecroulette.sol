pragma solidity >=0.5.0 <0.7.0;
/// @title A Roulette contract for hhs blockchain minor 2019-2020
/// @author Dennis Verbuijs

contract Roulette {
  

  struct Player{
    mapping(address => uint) playerRound;
  }
  bytes32 public queryId;
  uint bankBalance;
  uint playerBet;
  Player player;
  enum  betModes{ByNumber,ByOddEven,ByRedBlack,ByRow,ByCorner} 
  event rouletteOutcome(uint result, bool winner);
  event rollResult(uint player, uint table);
  address public owner;
  modifier onlyOwner(){require(msg.sender==owner); _;}
  
  constructor() public payable {
    owner=msg.sender;
  }
/// @return current balance of the contract
  function getBankBalance() public view returns(uint256) {
        return address(this).balance;
  }
/// @notice fuction takes care of all gamemodes and returns the outcome.
/// @return returns true if player has won else returns false
  function winOrLose(betModes mode, uint playernumber) private returns(bool){
    
    uint rouletteNumber=getRandom();
    emit rollResult(playernumber,rouletteNumber);
    //Rework so it can check for the other bets line 9 till 10 
    bool outcome =betBy(mode,playernumber,rouletteNumber);
    if(playernumber==rouletteNumber){
      outcome=true;
    }
    emit rouletteOutcome(rouletteNumber,outcome);
    return outcome;
  
  }
/// @notice this switches between the gamemodes.
/// @return returns true if player has won else returns false
  function betBy(betModes mode, uint playerNumber,uint tableNumber)private view returns(bool){
    if(betModes.ByNumber == mode){
      return betByNumber(playerNumber,tableNumber);
    }else if(betModes.ByOddEven==mode){
        return betByOdd(playerNumber,tableNumber);
    }else{
      return false;
    }

    
  }
  
/// @notice this gamemode is for players that bet on a single number.
/// @return returns true if player has won else returns false
  function betByNumber(uint playernumber,uint tableNumber) public view returns(bool){
    if(playernumber==tableNumber){
      return true;
    }else{
      return false;
    }
  }
  
/// @notice this gamemode is for players that bet on odd or even numbers.
/// @return returns true if player has won else returns false.
  function betByOdd(uint number,uint rNumber)public view returns(bool){
    uint isOdd=rNumber%2;
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
/// @notice check if number are correcty converted to enum.
/// @param mode is a number to check if 
/// @dev for test purpose only will be but on internal use only when contract goes to mainnet.
  function returnEnum(uint mode) public view returns(bool){
      betModes betModesCon = betModes(mode);
    if(betModes.ByNumber==betModesCon){
    	return true;
    }else{
      return false;
    }
    
  }

/// @notice genarates a random number.
/// @notice should be replace by a oracle but those are only one time uses and thats not usefull if more rounds are played.
/// @return returns a number between 0 and 36.
  function getRandom() public view returns(uint256) { 
        uint random = uint256(keccak256(abi.encodePacked(block.difficulty, block.coinbase, block.timestamp)))%37;
        assert(random <=36);
        return random;  
    }
/// @notice this is the main function users are calling.
/// @param number is the number the player has bet on.
/// @param mode is the gamemode the player is playing.
  function PlayerBet(uint number, betModes mode) public payable returns(bool){
      
      address payable betPlacer = address(msg.sender); 
     
    	playerBet=msg.value;
    	require(playerBet > 0, "No money added to bet.");
        require(playerBet*2 <=getBankBalance(), "Not enough money in bank for this bet."); 
    	bool winner= winOrLose(mode , number);
        
        if(winner){
        betPlacer.transfer(playerBet*2);
        }
        return winner;
    }
/// @notice this will destroy the contract and send the balance back to the owner.
/// @notice this function can only be called by owner.
  function destructTable() public onlyOwner{
      selfdestruct(msg.sender);
  }

}
