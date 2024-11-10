--- 
title: Finalisation of the Casino Example
subtitle: "Online Discussion" 
date: 2023-02-15
tags:
  - casino
---

<center>

Online Discussion
=================


**[Feb 15, 2023, 08:00 UTC](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20230215T09&p1=37&ah=2)** - 09:30 UHR UTC<br>
**[Feb 15, 2023, 09:00 CET](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20230215T09&p1=37&ah=2)** - 10:30 UHR CET<br>
**[Feb 15, 2023, 19:00 AEDT](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20230215T09&p1=37&ah=2)** - 20:30 UHR EDT

</center>

[Information for participating are below.](#participating)

**Backgrund:** The [VerifyThis Collaborative Large Scale Challenge](/)
aims at proving that deductive program verification can produce
relevant results for real systems with acceptable effort. We initially
looked [HAGRID](https://gitlab.com/hagrid-keyserver/hagrid) as a case
study, but have since moved on to considering [a simple Solidity
casino](/02casino) as the running example.

**Agenda:** We are happy to invite you to join for the final round of
presentations on the Casino case study, one by [Franck Cassez
(Macquarie University)](https://franck44.github.io/) and one by
[Alexander J. Summers (University of British
Columbia)](https://www.cs.ubc.ca/~alexsumm/), and [Marco Eilers (ETH
Zurich)](https://www.pm.inf.ethz.ch/people/personal/meilers-pers.html).

We aim to wrap up the discussion of the Casino case study and make
plans for follow-up work. See you soon!

### Aggregated Materials

-   [Casino Example](/02casino/)
-   [Fact Sheets](/02casino/factsheets), [submitted solutions](/02casino/)
-   [Last meeting](/online-event-dec/)


### Minutes

Two talks were given: 

* Marco Eilers and Alex Summers on Verification with Vyper
  * https://github.com/viperproject/2vyper
  * Automated Verifier for Ethereum 
  * Two-States Invariants
  *  Specification in terms of resource transfers
  *  Who has Money and who owns. 
  *  `transfer` transfers money, not ownership
  * Discussion on `casino.vy`
  * Question: “When did an invariant needs to hold?” Every time an external caller can invoke a method. This includes invocation to foreign methods, which can call me back. 
  * Access control via invariant: `\old(state) == X --> state=X \/ (state=Y and msg.sender=Z)`
Custom resources
Paper on the approach: https://dl.acm.org/doi/10.1145/3485523
Questions:
Resources and NFT
Over- and underflows semantics

* Frank Cassez, Verification of Smart Contracts with Dafny
  * Basics on sending messages (sender, value, notion of gas)
  * “Closed Contracts” -- no reentrance 
  * Global Invariant 
  * Pre-condition to capture Over-/underflow, Additional parameter for implicit parameters like message, and gas. 
  * Methods are rewritten: If precondition is violated, the method reverts. Gas is decreased by function calls and loops
  * External Calls are modeled in Dafny (re-entrance to transfer, re-entrance to other methods of the contract, or to other contracts), Mutually recursive calls. Gas decreases. Global Invariant holds on entrance/exit of external calls.
  * Explanation on the source


Wolfgang Ahrendt published a paper on the Casino example: “Modeling
and Security Verification of State-Based Smart Contracts”
https://doi.org/10.1016/j.ifacol.2022.10.366 


### Who can join the meeting?

Everybody who is interested in the challenge, formal verification, the
proposed solutions or VerifyThis is cordially invited to join the
meeting!

### How can I join the meeting?

The online event takes place with Zoom.

In protection against spammers, we require a short registration
beforehand. The login credentials will be sent via your provided email
address. Please register yourself with an email to
[weigl\@kit.edu](mailto:weigl@kit.edu?subject=VTLTC%20registration).

**Note:** If you had already registered for a previous online event,
we will send you the required login credentials automatically. Another
registration is not required in this case.
