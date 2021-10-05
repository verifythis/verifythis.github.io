# VerifyThis Long Term Challenge
## Discussion summary

*September 29, 2021* 

During the last discussion, the feedback was that participants would like to
discuss concrete examples. Therefore, Wolfgang Ahrendt prepared a concrete
example.

The example will be introduced, then we will split into different breakout rooms
(where the discussion is not summarised) and at the end of the meeting, we put
everything together.

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

We then split into three break out rooms:

- temporal properties
- contract specifications (which could also be connected to the execution 
  semantics of Solidity)
- security

After the breakout rooms, the groups reported back.

1. Temporal Properties

    The temporal properties group started drawing automata-like specifications.
    However, interesting points such as roll back are not discussed yet. These
    specifications would then enable one to verify liveness properties such as the
    AG EF (state = idle).

    To precisely capture the temporal properties, it would be important to know
    about the language semantics.

    Gidon asked if the triangle operator (discussed in an earlier meeting) could be
    useful here.

    Another discussion point was the level of granularity for such specifications.
    In may approaches we expect contracts for any method call. This led to the
    discussion in the contract specification group.


2. Contract Specifications

    This group started to add pre- and postconditions, assuming a special
    built-in specification variable `\balance`, to describe the behaviour of
    payable methods. The group suggested to add an invariant to specify the
    relation between the blockchain's balance and the variables (`pot` and
    `bet`, in this case)

    Their conclusion was that we need some kind of revert preconditions, which
    indicate under which conditions a rollback could happen. Ideally this would
    be transitive, thus in the `decideBet` method, we would specify that the
    state could also roll back if the revert precondition of the transfer method
    (call within `decideBet` method) would hold. You don't need to specify the
    effect of the roll back explicitly - it's just resetting everything, and all
    changes are lost.

    Wolfgang explained that in smart contracts, you often have no access to the
    external code, so you have to be defensive about what it could do.
    Specifiers and programmers have to be aware of this, and thus for example
    for the `decideBet` method, you would always assume that the transfer method
    that is called, could lead to a roll back.

    Gidon was wondering if you could also specify that you would revert if you
    don't have enough money in the blockchain. But the invariant guarantees in
    this particular example that this can never be the case.

3. Security 

    The security group discussed that security is by definition important,
    because smart contracts are about money, and they are open systems.

    The group then discussed about potential relevant properties, such as
    non-interference (making sure that private does not become public) and if
    relational properties could be of use. Can you compare different runs of the
    systems. If one run would be able to get blocked, this would potentially be
    a loss of money.

    More thinking would be needed about what are relevant security properties.

    Wolfgang adds that for many people all properties such as no money is lost
    are security relevant, as this guarantees data integrity.

    Wolfgang then discussed a fix to the problem that would avoid the problem of
    the game never getting to the idle state. Rather than sending money around
    directly, the system would separate the game and the sending of the money.
    If a player wins, money is earmarked for the transfer. The transfer is then
    done by a special withdraw method, which will start the transfer. However,
    again care is needed here, the money needs to be bookmarked as 'withdrawn'
    before the actual transfer takes place, otherwise a malicious player could
    do a call back on withdraw, and receive the money multiple times.

During the next meeting, we will continue the discussion on this example and we
will focus on the interaction between the temporal and the contract
specifications. In the mean time, all groups are invited to think more about how
to specify the behaviour of the program.
