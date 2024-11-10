--- 
title: "Casino Example #1"
subtitle: "Online Discussion"
date: 2021-09-29
tags:
  - casino
aliases:
  - /online-event-sep/
---

<center>

- **[September 29, 2021, 12:00 UTC](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20210519T12&p1=%3A&ah=2)** - 14:00 UHR UTC<br>
- **[September 29, 2021, 14:00 CEST](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20210519T12&p1=%3A&ah=2)** -16:00 UHR CEST<br>
- **[September 29, 2021, 08:00 EDT](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20210519T12&p1=%3A&ah=2)** - 10:00 UHR EDT

</center>

[Information for participating are below.](#participating)

The [VerifyThis Collaborative Large Scale Challenge](/) aims at proving
that deductive program verification can produce relevant results for
real systems with acceptable effort. We selected
[HAGRID](https://gitlab.com/hagrid-keyserver/hagrid), a recently
developed PGP-keyserver, for the challenge. Its development became
necessary as the old keyserver had serious data protection and security
issues.

**Agenda:** We will continue and deepen this discussion by means of a
concrete example to be specified in this meeting. By discussing how
automata-related and contract-related specification artifacts could be
formulated, we plan to identify particular benefits from the viewpoints.
Moreover, it will allow us to constructively think about ideas how such
specifications can be integrated.

In April 2020 four approaches to the verification challenge have been
submitted to and presented during an online workshop, and in November
2020, a [follow-up online discussion](/events/2021-06-23-online-event/) revealed
interesting new ideas regarding specification and verifiation of
interacting systems like Hagrid.

*We will continue and deepen this discussion by means of a concrete
example to be specified in this meeting. By discussing how
automata-related and contract-related specification artifacts could be
formulated, we plan to identify particular benefits from the viewpoints.
Moreover, it will allow us to constructive think about ideas how such
specifications can be integrated.*

### Aggregated Materials

-   [Casino Example](/02casino)
-   [Slides from the meeting in Feburar](/01hagrid/VerifyThisLTC-Feb2021.pdf)
-   [Slides from the meeting in November](/01hagrid/VerifyThisLTC-Nov2020.pdf)
-   [Informal Proceedings of the solutions](https://publikationen.bibliothek.kit.edu/1000119426)

### Who can join the meeting?

Everybody who is interested in the challenge, formal verification, the
proposed solutions or VerifyThis is cordially invited to join the
meeting!

### How can I join the meeting? {#participating}

The online event takes place with Zoom.

In protection against spammers, we require a short registration
beforehand. The login credentials will be sent via your provided email
address. Please register yourself with an email to
[weigl\@kit.edu](mailto:weigl@kit.edu?subject=VTLTC%20registration).

**Note:** If you had already registered for the [Online Event in
November](/events/2020-11-27-online-event/) [or Feburary](/events/2020-02-12-online-event/), [or
June](/events/2021-06-23-online-event/) we will send you the required login
credentials automatically. Another registration is not required in this
case.


## Discussion summary

*September 29, 2021* 

During the last discussion, the feedback was that participants would like to
discuss concrete examples. Therefore, Wolfgang Ahrendt prepared a concrete
example for this discussion.

The example will be introduced, then we will split into different breakout rooms
(where the discussion is not summarised) and at the end of the meeting, we put
everything together.

The example models a Casino Game (and is due to Gordon Pace), encoded
as a Solidity smart contract.

There is 1 operator, and at most 1 player (opponent). 

The state space of the game consists of:
- the `pot` (an integer value)
- the player's `bet` (an integer value)
- player's `guess` (head or tail)
- a hashed `secret` (an integer value), given by the casino operator. 
  By using a hash value, it is ensured that the secret stays unchanged
  during a play and that the player is not able to obtain whether it is head or tail.
  The least-significant digit of the hashed value (not the hash value)
  defines whether it is head or tail. (Bit commitment scheme)
- the current player and the operator identified by their unique addresses.

Initially both, `pot` and `bet`, are empty (i.e. 0). The hashed `secret` and the `guess`
have a default value. The program allows the following operations:

- constructor: Initialises the state of the contract, e.g., sets the `operator`.

- create game: Initialises a new play of the game, e.g., sets the `secret`.

- add money to pot: This is implemented by a *payable* method. The
  *payable* modifier gives a method an implicit argument which holds
  the amount of money which was sent along with the method
  invocation. Here, it indicates that the method caller sends the
  amount of money which goes into the `pot` from his blockchain
  wallet. The operation can only be executed by the operator. If it is
  called by a different party, this condition check fails and the
  state will roll back to the point where the external call to the
  blockchain was made. In Solidity, `require` instructions allow the
  specification of conditions which must hold when the statement is reached.
  Otherwise the transaction is rolled back.

- remove money from the pot: This can only be done if no bet is
  placed, and only by the operator, and only if the the requested
  amount is less than the money in the pot. It will send money back to
  the operator.

- place bet: If the game is available, the caller of this method (not
  the operator) becomes the player.
  This is also a *payable* method.

- decide bet: can only be called by the operator if a bet has been
  placed. The operator reveals the bit commitment. If the player wins,
  the amount of the bet will be doubled, and sent to the player. If
  the operator wins, the bet is moved into the pot.

The idea would be that the code ensures that the player can get the money by
calling decide bet. In smart contracts: calling a method and money transfer are
done hand-in-hand.

In this example, all the money is modeled in the game. Variants are possible,
where the operator can enforce the player to pay a fee to place a bet.

The code has several challenges. It would be possible to create a
denial of service contract that enters the casino as a player. The
transfer method of that malicious contract might be implemented
wrongly, by refusing payment (`require(false);` on the transfer
method). In that case, the state would always roll back, and the game
state would never become idle anymore. The player might not be able to
win anything, but it does damage to the operator who can no longer
claim back money in the pot.

There are solutions, like using the `send` method, that allows to check if the
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
    In many approaches we expect contracts for any method call. This led to the
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
    relational properties could be of use. You can compare different runs of the
    systems. If one run would be able to get blocked, this would potentially be
    a loss of money.

    More thinking would be needed about what are relevant security properties.

    Wolfgang adds that for many people all properties such as no money is lost
    are security relevant, as this guarantees data integrity.

    Wolfgang then discussed a fix that would avoid the problem of the game never
    getting to the idle state. Rather than sending money around directly, the
    system would separate the game and the sending of the money. If a player wins,
    money is earmarked for the transfer. The transfer is then done by a special
    withdraw method, which will start the transfer. However, again care is needed
    here, the money needs to be bookmarked as 'withdrawn' before the actual
    transfer takes place, otherwise a malicious player could do a call back on
    withdraw, and receive the money multiple times.


During the next meeting, we will continue the discussion on this example and we
will focus on the interaction between the temporal and the contract
specifications. In the mean time, all groups are invited to think more about how
to specify the behaviour of the program.
