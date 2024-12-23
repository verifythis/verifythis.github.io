--- 
title: "Casino Example #2"
date: 2021-12-15
tags:
  - casino
summary: "Online Discussion on the Casino Example."
---

<center>

- **[December 15, 2021, 12:00 UTC](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20211215T14&p1=964&ah=2)** - 14:00 UHR UTC<br>
- **[December 15, 2021, 14:00 CST](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20211215T14&p1=964&ah=2)** -16:00 UHR CST<br>
- **[December 15, 2021, 08:00 EDT](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20211215T14&p1=964&ah=2)** - 10:00 UHR EDT

</center>

[Information for participating are below.](#participating)

The [VerifyThis Collaborative Large Scale Challenge](/) aims at proving
that deductive program verification can produce relevant results for
real systems with acceptable effort. We selected
[HAGRID](https://gitlab.com/hagrid-keyserver/hagrid), a recently
developed PGP-keyserver, for the challenge. Its development became
necessary as the old keyserver had serious data protection and security
issues.

**Agenda:** 

In earlier meetings we have discussed what general specification
concepts exist, with particular focus on exploring automaton- and
contract-based techniques and their potential relationships.

For the upcoming meeting, we want to encourage you, the participants,
to sketch a specification of the [Casino Example](/casino) in your
favorite specification formalism.

### Aggregated Materials

-   **[Specifications for the Casino Example](/02casino)**
-   [Casino Example](/02casino)
-   [Slides from the meeting in Feburar](/01hagrid/VerifyThisLTC-Feb2021.pdf)
-   [Slides from the meeting in November](/01hagrid/VerifyThisLTC-Nov2020.pdf)
-   [Informal Proceedings of the solutions](https://publikationen.bibliothek.kit.edu/1000119426)

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

**Note:** If you had already registered for a previous event, then you
should be on the mailing list and have received the Zoom link.

## Artifacts Summary 

**[To the submitted specifications](/02casino)**


## Minutes 

We started the meeting by looking at the previous meeting and the
example that was introduced there: a smart contract implementation of
a small betting game. The implementation was rediscussed quickly, and
in particular it was stressed that the implementation follows some
kind of state machine. Both liveness and safety properties are
relevant for this example: a desired liveness property would be that
that you eventually get your money if you win, a desired safety
property would be that no money is lost in the system.

The contracts are completely sequential, but a challenge is that call
backs are possible, i.e. a contract can invoke another contract in any
intermediate state, thus one cannot rely upon the contracts to be
completely finished.

Several participants have prepared partial specifications to model the
system, and these specifications are discussed.

Jonas Becker has modeled the system using timed automata (in Uppaal).
He modelled two variants of the system:

* closely following the implementation, having a special variable
  called state, and model with a single location: all calls loop back
  to that location, and the guards describe from which state the call
  may be made. Also the requirements in the contract implementation
  are modelled as guards.

While rediscussing the example implementation, Jonas realised that his
model of transfer is not completely faithful to the Solidity
implementation, as it misses that you wait until you are called within
the transfer function. He will look into this, and see if this can be
adjusted.

* a model with multiple location, where each location corresponds to
  a possible value of the state variable. This model gives a nicer
  view on the state machine that is implemented.

Several properties are checked, such as absence of deadlocks, and if
a bet is placed, then at some point it will be decided
`PCas.bet_placed --> PCas.idle`, which is Uppaal notation for `AG
(p -> EF q))`.

The counterexample trace shows that an actor can decide to quit, and
then no return is possible.

### Uppaal

The Uppaal model was relatively simple to make, but there are some
limitations, in particular there is a fixed number of players and
amounts for the bet.

Moreover, when checking the properties, one quickly has a state
explosion, and it would be interesting to find out if there would be
a way to exploit the contracts (ie. function specifications) to make
the model checking not explode. (Pretty tight bounds like 3 actors,
2 players had to be chosen to keep the verification time within
bearable limits.)

Ultimately, this leads to the question whether we can ever prove
liveness properties for unbounded state space.

The simple initial model does not use clocks to model time which would
be possible with timed automata in Uppaal; and might have a use case
for the casino example (Wolfang showed a solidity version with
explicit time later).

A central question for the combination of operation abstractions
(contracts) and model checking has been identified as: How can we
abstract from player automaton faithfully to get away from state space
explosion? An idea is to abstract away from parts of the system by
replacing a component by a nondeterministic component. That works for
small systems, but does not scale well. Translate the idea of
contracts into automata to obtain benefits for model checking.

### TLA

Alexander Weigl then showed how he modelled the system in TLA.
Interestingly, the specification language is more expressive than what
the model checker can analyse. As a result, he has given a model that
is quite close to the Solidity implementation, but which cannot be
checked by the tool. Some liveness properties are expressed, but
cannot be verified, because the specifications are (implicitly)
quantified over all possible (unbounded) values of a variable.

In the model, actions are described as logical formulas (conjunctions
of equations). The overall system is described as a non-deterministic
choice between the different (enabled) actions.

It is remarked that this specification formalism is more declarative
than many other specification languages. The specifications are purely
logical, variable updates are expressed by introducing a new primed
variable (e.g. x').

Alexander remarks that reverting of actions is abstracted away from
into no action happening. This is not completely faithful to the
implementation, but might be a good abstraction. We discuss further
about this: reverting is not the same as failing, but observationally
they are the same, so it might be fine to abstract away from this
difference. This depends also on the level of abstraction that we
consider further, because if we consider the loss of gas, then they
are not the same, and we cannot ignore the difference. But probably,
for what we are interested in, focusing on the desired behaviour, gas
is irrelevant, and we can ignore the difference. As a side remark,
Elvira Albert and her team are working on resource analysis, and they
use this to model gas-based properties of smart contracts.



Jonas Schiffl remarks that the transfer contract including its possible
revert is the most interesting one, because it is hard to compute the
weakest precondition for this one. The weakest precondition depends on
the execution (i.e. a dynamic property). But as Wolfgang remarks, you
could statically describe the different options.

Another point to discuss is what we try to specify/verify. Do we want
to focus on the intended behaviour in our model, or do we want to able
to faithfully model the implementation. Both options are viable, but
one has to be aware of the two different purposes. In particular, if
we want to use the model as a specification, then it should be without
errors. However, if we want to use the model to find errors in the
implementation, then it should be faithful to the implementation
(including the errors). How to show that a model is faithful to an
implementation is also an open issue.

In particular, do we want to reason about reverts, or would we like to
show that they never happen (because we don't want them)? For safety
properties, reverts might be irrelevant, then you just want to see
that after termination, you get the desired result, but for liveness
properties the reverts are relevant. Still a question is how reverting
relates to contract-based reasoning, because a call may be finished,
but the postcondition might not hold. Contracts as we know them are
over-approximations. Maybe we need some variant of contracts that
under-approximate their behaviour, and that can be used to reason
about liveness properties. Matthias proposes to call these
CO-CONTRACTS!

Wolfgang then tells that the real world code actually has a time out,
and that with a model in Uppaal these timing aspects could be modelled
as well (after a certain time, a player can always win).

### SolC-verify

Jonas Schiffl then shows his formalisation in SolC-verify. This is
a contract-based tool for Solidity. The require statements are
considered preconditions, the user adds postconditions and modifies
clauses. Internally, this is translated into Boogie.

The tool is still in early stages, and it only considers partial
correctness and normal termination. It misses the possibility to
specify an exceptional behaviour (in this specific case a reverting
behaviour). Reverting is now completely ignored in the tool.


### VerCors

Raúl Monti is working on modelling safety properties of the example in
VerCors, using a translation into VerCors's internal language PVL. To
make the contract functions fully atomics, the encoding surrounds them
by a global lock. This lock is then associated to a loop invariant
that expresses the global property that the money in the pot + bet =
balance. This property has to be proven every time the lock is
released, i.e. at the end of every contract. A formal refinement from
VerCors to executable SC code is conceptually possible.

Proving that you will get back to the idle state is out of reach for
VerCors.


### Event B

Mattias Ulbrich developed an EventB model, also modelling the
preservation property. The specification is essentially a repetition
of the implementation.


## Next Meeting

For the next meeting, the participants will further refine their
models and formalisations. They will also see if there are properties
that they would need from another tool, and phrase this as concrete
verification challenges. Also, the idea of co-contracts that
under-approximate the behaviour of a smart contract/function might be
developed further and discussed during a next meeting. When dealing
with an approximation for model checking, it is important to know what
kind of approximation one needs. This is different for liveness and
for safety (over- vs. underspecification) Design-by-contracts always
uses overapproximation. We might also need underapproximating
contracts.

Dealing with sufficient gas was not discussed here. There are people
outside our community that deal with gas consumption and analysis
thereof.
