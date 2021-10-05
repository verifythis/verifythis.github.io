<center>

![](LasBlockchainSign.svg | width=500)
 
</center>


## Introduction

During the last discussion, the feedback was that participants would like to
discuss concrete examples. Therefore, Wolfgang Ahrendt prepared a concrete
example.

The example will be introduced, then we will split into different breakout rooms
(where the discussion is not summarised) and at the end of the meeting, we put
everything together.


## State Space
The example models a Casino Game (and is due to Gordon Pace), encoded as
a Solidity smart contract.

There is 1 operator, and 1 player. 

State space of the game consists of:
- the `pot` (an integer value)
- the player's `bet` (an integer value)
- player's `guess` (head or tail)
- a hashed `secret` (an integer value), given by the casino operator. 
  By using a hash value, it is ensured that the secret stays is unchanged
  during a play and the player is not able to obtain whether it is head or tail.
  The least-significant digit defines whether it is head or tail. (Bit commitment
  scheme)
- the current player and the operator identified by their unique addresses.

![](A0.JPG)
## A Play

Initially both, `pot` and `bet`, are empty. The hashed `secret` and the `guess`
have a default value value. The program allows the following operations:

- constructor: Initialises the state of the contract, e.g., sets the `operator`.

- create game: Initialises a new play of the game, e.g., sets the `secret`.

- add money to pot: This is implemented by a *payable* method. The *payable*
  modifier gives a method an implicit argument which holds the amount of money
  which was sent along with the method invocation. Here, it indicates that the
  method caller sends the amount of money which goes into the `pot` from his
  blockchain wallet. The operation can only be executed by the operator. If this
  condition fails, the state will roll back to the point where the external call
  to the blockchain was made. In Solidity, the roll back conditions are
  expressed as require instructions.

- remove money from the pot: This can only be done if no bet is placed. It will 
  send money back to the operator.

- place bet: If the game is available, the caller of this method becomes the player.

- decide bet: can only be called if the bet is placed. If the player wins, the
  amount of the bet will be doubled, and send to the player. If the operator
  wins, the bet is moved into the pot.

The idea would be that the code ensures that the player can get the money by
calling decide bet. In smart contracts: calling a method and money transfer are
done hand-in-hand.

In this example, all the money is modeled in the game. Variants are possible,
where the operator can enforce the player to pay a fee to place a bet.

The code has several challenges. It would be possible to create a denial of
service contract. The transfer might be implemented wrongly, by refusing payment
(`require(false);` on the transfer method). In that case, the state would always
roll back, and the game state would never become idle anymore. The player might
not be able to win anything, but it does damage to the operator.

There are solutions, like using the send method, that allows to check if the
payment actually succeeded.

In parallel there was a discussion about how to express absence of denial of
service attacks, by using temporal properties like AG EF (state = idle).
