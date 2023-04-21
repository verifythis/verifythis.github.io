pragma solidity >= 0.5.0;
/* This smart contract uses simplified Solidity syntax
   and does not compile as is. The original contract was
   written by Gordon Pace, and contained also a timeout
   as a counter measure against the operator not calling
   decideBet. The current simplified version was written
   by Wolfgang Ahrendt. It deliberately introduces
   security bugs. */

contract Casino {

    /// @notice invariant operator != player;

    address payable public operator;
    address payable public player;

    /// @notice invariant bet + pot == balance;

    uint public pot;
    uint bet;

    // The hashed number submitted by the operator
    bytes32 public hashedNumber;

    enum Coin { HEADS, TAILS }
    Coin guess;

    // The state of the contract
    enum State { IDLE, GAME_AVAILABLE, BET_PLACED }
    State private state;

    // Create a new casino
    /// @notice postcondition state == State.IDLE
    /// @notice postcondition operator == msg.sender
    constructor() public {
        operator = msg.sender;
        state = State.IDLE;
        pot = 0;
        bet = 0;
    }

    // Add money to pot

    /// @notice postcondition pot == __verifier_old_uint(pot) + msg.value
    /// @notice modifies pot
    /// @notice modifies address(this).balance
    function addToPot() public payable {
        require (msg.sender == operator);
        pot = pot + msg.value;
    }


    // Remove money from pot

    /// @notice postcondition pot == __verifier_old_uint(pot) - amount
    /// @notice postcondition operator.balance == __verifier_old_uint(operator.balance) + amount
    /// @notice modifies pot
    /// @notice modifies address(this).balance
    /// @notice modifies operator.balance
    function removeFromPot(uint amount) public {
        // no active bet ongoing:
        require (state != State.BET_PLACED);
        require (msg.sender == operator);
        operator.transfer(amount);
        pot = pot - amount;
    }


    // Operator opens a bet
    /// @notice modifies hashedNumber
    /// @notice modifies state
    function createGame(bytes32 _hashedNumber) public {
        require (state == State.IDLE);
        require (msg.sender == operator);
        hashedNumber = _hashedNumber;
        state = State.GAME_AVAILABLE;
    }

    //caller syntax: contractaddress.placeBet(HEADS).value(1000 Wei)

    // Player places a bet
    /// @notice modifies bet
    /// @notice modifies player
    /// @notice modifies guess
    /// @notice modifies state
    /// @notice modifies address(this).balance
    function placeBet(Coin _guess) public payable {
        require (state == State.GAME_AVAILABLE);
        require (msg.sender != operator);
        require (msg.value <= pot);

        state = State.BET_PLACED;
        player = msg.sender;

        bet = msg.value;
        guess = _guess;
    }


    /// @notice postcondition (pot == __verifier_old_uint(pot) - bet && player.balance == __verifier_old_uint(player.balance) + 2*bet) || pot == __verifier_old_uint(pot) + bet
    /// @notice postcondition bet == 0
    /// @notice modifies pot
    /// @notice modifies bet
    /// @notice modifies player.balance
    /// @notice modifies state
    function decideBet(uint secretNumber) public {
        require (state == State.BET_PLACED);
        require (msg.sender == operator);
        // left out so no undefined function call is needed
        /* require (hashedNumber == keccak265(abi.encode(secretNumber))); */

        Coin secret = (secretNumber % 2 == 0)? Coin.HEADS : Coin.TAILS;

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

        state = State.IDLE;
    }
}
