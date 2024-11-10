--- 
title: "Specification Languages"
subtitle: "Online Discussion"
date: 2020-11-27 
tags: 
  - hagrid 
  - speclang 
aliases:
  - /online-event-nov/
---


**27th November 2020, [10:00
UTC](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=2020-11-27T10:00:00)**

[Information for participating are below.](#participating)

The [VerifyThis Collaborative Large Scale Challenge](/) aims at proving
that deductive program verification can produce relevant results for
real systems with acceptable effort. We selected
[HAGRID](https://gitlab.com/hagrid-keyserver/hagrid), a recently
developed PGP-keyserver, for the challenge. Its development became
necessary as the old keyserver had serious data protection and security
issues.

In April four approaches to the verification challenge have been
submitted to and presented during an online workshop.

A Dagstuhl seminar on contract-based specification languages was
originally planned for the last week in November 2020, but had to be
cancelled.

We would like to seize the opportunity to use the challenge system and
the available solutions to stipulate a discussion on the features that
an ideal specification language would possess for this purpose. This
online discussion will start a discussion involving people together who
are interested in the design of contract languages and the participants
of systems like the challenge who want to make use of contract languages
in their specifications.

### Material

-   [Slides from the meeting](/01hagrid/VerifyThisLTC-Nov2020.pdf)
-   [Informal Proceedings of the
    solutions](https://publikationen.bibliothek.kit.edu/1000119426)

### Agenda

-   **Introduction to Hagrid**
    1.  Overview of the Long Term Challenge
    2.  What is HAGRID?
    3.  Brief summary of the solutions submitted thus far
-   **Hagrid as a Specification Challenge**  
    Discussion on the ideal specification language for service-based
    software sytems using HAGRID as showcase. Discussion will be driven
    by a number of guiding questions:
    -   What clauses does an ideal contract language have?
    -   *If you want to add an interesting question, feel free to
        contact us!*
-   **Concrete plans from here on**

### Who can join the meeting?

Everybody who is interested about the challenge, formal verification,
the proposed solutions and VerifyThis is cordially to join the meeting!

### How can I join the meeting?

The online event takes place with Zoom.

In protection against spammers, we require a short registration
beforehand. The login credentials will be sent via your provided email
address. Please register yourself with a email to
[weigl@kit.edu](mailto:weigl@kit.edu?subject=VTLTC%20registration).

### Minutes

#### Extracted Links from the chat

1.  <https://verifythis.github.io/online-event-nov/>
2.  <https://verifythis.github.io/VerifyThisLTC-Nov2020.pdf>
3.  [doi: 10.1002/spe.2495](http://dx.doi.org/10.1002/spe.2495)
4.  CoCoSpec: A Mode-Aware Contract Language for Reactive Systems
    (DOI:10.1007/978-3-319-41591-8_24)
5.  [Seamless Interactive Program
    Verification](https://formal.iti.kit.edu/biblio/researcher/ulbrich/pdf/GrebingKlamrothUlbrich2019.pdf)
6.  [Deductive techniques for model-based concurrency
    verification](https://research.utwente.nl/en/publications/deductive-techniques-for-model-based-concurrency-verification)
7.  [DEDUCTIVE
    TECHNIQUES](https://research.utwente.nl/files/160907949/thesis_W_Oortwijn.pdf)
8.  [How Testing Helps to Diagnose Proof
    Failures](https://nikolai-kosmatov.eu/publications/petiot_kbgj_faoc_2018.pdf)
9.  <https://nikolai-kosmatov.eu/publications/robles_kprl_tap_2019.pdf>

#### Summary of discussion on contract specification languages (November 27, 2020)

*Summarised by Marieke Huisman, Raul Monti, Mattias Ulbrich and
Alexander Weigl*

Before the discussion started, a round-up on Hagrid, the verifying
keyserver, was given in a short talk. On an abstract level, Hagrid is an
interactive system and a typical representative of service-oriented
software. Hagrid provides five endpoints, which can be called in an
arbitrary and parallel manner, to manipulate the internal database of
known public keys.

The discussion first focused on finding the right level of abstraction
in specifications. For some applications (including the VerifyThis long
term challenge) writing an abstract (i.e., behavioural/executable) model
is the most natural way to capture the desired properties/behaviour,
rather than doing this directly in terms of declarative specifications
like contracts. But then of course, the question is: what is the
connection between this model and the contracts. Ideally, we would like
to have some way to link those: generate contracts from a model, or
generate a model from the contracts. For Hagrid, the connection between
the model and the contracts is relatively clear, but this is not always
the case. Also, when generating models or contracts from each other, the
big challenge is to come up with the right level of abstraction.

What is the right level of specification (abstract model or contracts)
also depends on what you want to use the specifications for (and in
addition, it can also depend on who actually writes the specification).
A reason to use contracts could be that you want the developers to look
at the specifications, and they are looking at the code. Moreover, it is
important to remember that models are not necessarily the same as the
properties you are interested in - but of course, there is a connection.

There was a common agreement that not every class of properties can be
expressed (nicely) at contract level, but contracts come into play when
we want to say things method-modularly at implementation level, because
they make it possible to use divide-and-conquer techniques for
reasoning. Some things are complex at the implementation level (think
about string handling for example), while they can be nicely explained
at an abstract level. Other examples are protocols, or event histories.
These can be encoded at the level of contracts, but as the specification
notions then are not first-class, it can make reasoning a bit
cumbersome, and it can blur the meaning of the specification (but it is
good to have the possibility to encode these things, to experiment with
different verification approaches).

Finally, it was stressed that models also can be considered as a
contract e.g. as a form of assume-guarantee reasoning), so maybe we
should simply embrace the notion of abstract model as part of our
contract specification languages. We already have class invariants, why
not also finite state machine, regular expressions or whatever. If we
want to do this, we might want to consider the SVComp format to specify
automata. This might also give us a different view on contracts: a
contract should not just express the relation between the pre-state and
post-state of a method, but it should capture all the effects a method
has between its call and return point. A contract then constrains what a
method is allowed to do by the outside world, and it should declare in
what sequences certain things are going to happen. Of course, if we take
this view, we have to distinguish between the effects of a method
itself, and the effects that are created by other actors. If we take
this view, then we should also define a suitable counterpart for framing
conditions of these “effect contracts”. The connection between a model
state machine and ghost code maintaining an internal state of an object
have been discussed. One way to see this is that a state machine is a
specification of how ghost state evolves that could also be implemented
using ghost code. Nevertheless some find it clear to separate the model
with abstract behavior from the code itself. Then the code should be
proven to be a refinement of the model behavior.

There exists different work in this direction. The KeY team once worked
on the possibility to extract contracts from state charts. Simon Bliudze
is working on a technique to annotate Java classes with states and
transitions, where some methods describe transitions, and other methods
serve as guards. Marieke Huisman and Wytse Oortwijn worked on adding the
notion of models to the annotation language of VerCors (based on
permission-based separation logic). The logic allows one to prove that
the program behaves according to the model, i.e. the program refines the
model. External tools (currently mCRL2) are used to verify behavioural
properties about the model, and from this we can conclude that the
program also satisfies these properties.

The discussion then continued on the relation between inheritance and
contracts. How does inheritance match with abstract models? For this you
would need some form of behavioural subtyping. Of course, a challenge is
that programming languages do not guarantee behavioural subtyping, thus
this requires discipline from the programmer. There is a discussion
whether we could find ways to automatically characterise when
inheritance coincides with refinement/behavioural subtyping. The theory
of behavioural subtyping is wellknown, but it requires careful checks
from the developer.

Last, tool support for contract languages was discussed. Tools like
Dafny are nice to use, but it can be annoying that you never get the
symbolic state if verification fails, which can make it hard to
understand why verification fails.

A few approaches to address this problem are discussed. Mattias, from
the KeY team is working on an interactive Dafny verification environment
(DIVE), which gives more feedback when verification fails. With Why3,
there is extensive support for the manipulation of a non-provable goal.
SPARK tries to provide user feedback, based on relatively simple checks.
For example, if a variable is used in the method, but not mentioned in
the pre- and postconditions. The StaDy plugin of Frama-C uses dynamic
verification to analyse the reason that static verification fails, and
it can give feedback if that was because of missing pre- and
postconditions, implementation errors, or prover incompleteness.
