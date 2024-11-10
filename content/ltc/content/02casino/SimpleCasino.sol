/* This smart contract uses simplified Solidity syntax
   and does not compile as is. The original contract was
   written by Gordon Pace, and contained also a timeout
   as a counter measure against the operator not calling
   decideBet. The current simplified version was written
   by Wolfgang Ahrendt. It deliberately introduces
   security bugs. */

contract Casino {

  address public operator;
  
  uint public pot;
  
  // The hashed number submitted by the operator
  bytes32 public hashedNumber;
  
  address public player;
  
  enum Coin { HEADS, TAILS }
  Coin guess;

  uint bet;

  // The state of the contract
  enum State { IDLE, GAME_AVAILABLE, BET_PLACED }
  State private state;
  
  // Create a new casino
  constructor() public {
    operator = msg.sender;
    state = IDLE;
    pot = 0;
    bet = 0;
  }
  
  // Add money to pot
  function addToPot() public payable {
    require (msg.sender == operator);
    pot = pot + msg.value;
  }
  
  // Remove money from pot
  function removeFromPot(uint amount) public {
    // no active bet ongoing:
    require (state != BET_PLACED);
    require (msg.sender == operator);
    operator.transfer(amount);
    pot = pot - amount;
  }
  
  // Operator opens a bet
  function createGame(bytes32 _hashedNumber) public {
    require (state == IDLE);
    require (msg.sender == operator);
    hashedNumber = _hashedNumber;
    state = GAME_AVAILABLE;
  }

  //caller syntax: contractaddress.placeBet(HEADS).value(1000 Wei)
  
  // Player places a bet
  function placeBet(Coin _guess) public payable {
    require (state == GAME_AVAILABLE);
    require (msg.sender != operator);
    require (msg.value <= pot);
    
    state = BET_PLACED;
    player = msg.sender;

    bet = msg.value;
    guess = _guess;
  }
  
  // Operator resolves a bet
  function decideBet(uint secretNumber) public {
    require (state == BET_PLACED);
    require (msg.sender == operator);
    require (hashedNumber == cryptohash(secretNumber));
    
    Coin secret = (secretNumber % 2 == 0)? HEADS : TAILS;
    
    if (secret == guess) {
      // player wins, gets back twice her bet
      pot = pot - bet;
      player.transfer(2*bet);
      bet = 0;
    } else {
      // operator wins, bet transfered to pot
      pot = pot + bet;
      bet = 0;
    }
    
    state = IDLE;
  }
}
