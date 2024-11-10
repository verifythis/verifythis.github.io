--- 
title: "Hagrid Results #1"
subtitle: "Online Discussion"
date: 2020-02-12 
tags: [ hagrid ] 
aliases:
  - /online-event-feb/
---

# Online Discussion

**12th February, 2020, 14:00 – 16:00 UTC [14:00
UTC](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=2021-02-12T14:00:00)**
- [16:00
UTC](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=2021-02-12T16:00:00)

[Information for participating are below.](#participating)

The [VerifyThis Collaborative Large Scale Challenge](/) aims at proving
that deductive program verification can produce relevant results for
real systems with acceptable effort. We selected
[HAGRID](https://gitlab.com/hagrid-keyserver/hagrid), a recently
developed PGP-keyserver, for the challenge. Its development became
necessary as the old keyserver had serious data protection and security
issues.

In April 2020 four approaches to the verification challenge have been
submitted to and presented during an online workshop, and in November
2020, a [follow-up online discussion](/events/2020-11-27-online-event/) revealed
interesting new ideas regarding specification and verifiation of
interacting systems like Hagrid.

*We would like to continue and deepen this discussion in this online
meeting, in particular thinking about the potentials of using
automata-based specifications for the specification of interacting
systems. How does automata specification tie in with contract-based
specification? How with model checking?*

### Material

-   [Slides fir this meeting](/01hagrid/VerifyThisLTC-Feb2021.pdf)
-   [Slides from the meeting in November](/01hagrid/VerifyThisLTC-Nov2020.pdf)
-   [Informal Proceedings of the
    solutions](https://publikationen.bibliothek.kit.edu/1000119426)

### Agenda

-   **Presentation of a automata-based specification for Hagrid** as a
    starting point for a discussion on the requirements and benefits of
    such a way of specification.  
    Interesting questions include:
    -   What is the right formalism?
    -   How does it relate to ghost code?
    -   How does it relate to design-by-contract?
    -   What is the specified entity? (a "component"?)
    -   Can this bring model checking and deduction into one integrated
        verification approach?
    -   Is this suited for lightweight and/or heavyweight specification?
    -   ...
-   **Concrete plans from here on**

### Who can join the meeting?

Everybody who is interested in the challenge, formal verification, the
proposed solutions or VerifyThis is cordially invited to join the
meeting!

### How can I join the meeting?

The online event takes place with Zoom.

In protection against spammers, we require a short registration
beforehand. The login credentials will be sent via your provided email
address. Please register yourself with an email to
[weigl@kit.edu](mailto:weigl@kit.edu?subject=VTLTC%20registration).

**Note:** If you had already registered for the [Online Event in
November](/online-event-nov/), we will send you the required login
credentials automatically. Another registration is not required in this
case.

## Minutes of the Meeting: Contracts Discussion

*Prepared by Gidon Ernst, Marieke Huisman, Raúl Monti, Mattias Ulbrich,
Alexander Weigl*

*February 12, 2021*

The slides that were used to start the introduction are available above

The discussion started with an introduction to the topic by Mattias. We
did a quick poll among the participants:

> What do they understand by formal methods in software development:
>
> -   58 % deductive verification
> -   42 % model checking

Beforehand, participants were asked to explain what they consider as an
automaton. The different answers are discussed.

Most remarkable is that some people consider the environment part of the
automaton. This leads to a discussion on what we consider as the
environment of an automaton: are these only the external events, or do
we really expect to have a full model of the environment. A full model
would include detailed information about the behaviour of the
environment. But often when people talk about a model of the
environment, they only consider the possible sequences of the
environmental actions that are relevant to the automaton.

The discussion then zoomed in on top level specifications for the key
registration system in Hagrid. Some example specifications were given,
which consist of automata + contracts (pre- and postconditions). This is
different from standard automaton specifications, where often guards are
used. But here, we also want to be able to express postconditions of the
actions in the automaton.

Event-B machines are an example of such stateful specifications, where
actions have contracts (i.e. pre- and postconditions) and can be
triggered by the environment. Different techniques exist to reason about
such stateful specifications:

-   we can encode them into JML
-   in Why3 the state of such a specification is encoded into a map with
    an invariant that restricts the reachable states (i.e. the invariant
    has to hold at entry and exit of the actions)
-   Wytse Oortwijn (based on work by Marina Zaharieva) developed a
    technique where automaton specifications used program data. With
    this approach, it can be proven that the program is a refinement of
    the specification, and there is an explicit connection between the
    program and the automaton. (When the automaton is encoded as a JML
    specification, this relation is implicit, as part of the encoding).

The following hypothesis is made: both sides (automaton and program)
need to be aware of each other, otherwise we cannot establish a
refinement between the two.

The discussion then moved on to synthesis: if we have an automaton, can
we generate a program from this. The main issue is the performance of
the resulting program, which is often not sufficient. An alternative
approach is to use synthesis to derive a program template as a starting
point for further improvements, towards a highly performant program.

In certain areas, code synthesis has been quite successful. Control
systems are specified with Esterel, and they manage togenerate code with
explicit time constraints. The conclusion is that this works because
they target a limited domain.

Other experiences are discussed. It seems that B-refinement from
specification to code is not actively developed anymore.

Paula Herber reports on experiences with a CSP to LLVM generator. The
main problem when using this approach was to find the right abstractions
in the refinement process (i.e. which steps to take). This is where most
of the effort goes when code is being synthesised, and it seems more
like a shift of effort, rather than a reduction.

Because of time zone issue, several new participants join the
discussion.

Therefore, we poll again.

> What do you think about when they think about formal methods in
> software development?
>
> -   72% deductive verification
> -   17% model checking
> -   6% runtime verification
> -   6% type systems

And we discuss the definition of automata, and the relation to the
environment again.

Why3 can reason about a model and a specific environment. However, it
does not provide you with a possibility to generate all possible clients
or the most general clients.

So far we focused on: how can we prove that an implementation respects a
specification. But we can also consider the following issue: what can we
do already if we only have the (automaton-level) specification. In
particular, this might be the right level to prove temporal properties.
But then: what sort of properties can be proven. Eventually properties
might be difficult, but absence of deadlock seems a useful one. Ideally,
the automaton specification could then be used as input for a model
checker.

We get back to the point that finding the right abstraction is often the
most challenging in the whole refinement process. There are examples of
case studies for a single system (using Event-B), where everybody does
the refinement in a different way.

Why3 has some examples of multi-step refinements (replacing data
structures, with a compositional approach), and it is shown that this
approach can also help for proof automation. However, often a more
limited approach is used, where only small parts are refined. A
consequence is then that you often loose the overall view of what the
system is doing.

In deductive verification, often asserts are used to explicitly break
down the proof obligations. This is never advocated as refinement, but
it can be considered that way. And moreover, the additional asserts
often give a lot of insight in the proof structure and correctness
argument.

The discussion then moved on to runtime verification, which can be
useful to check temporal properties at code level. Runtime verification
is often used to check whether model and code correspond. Models can
also be used to control the behaviour of an application. For runtime
verification, the internal data structures are less relevant, but the
focus is more on what is going on at the abstract level.

The BIP system can help to go all the way from abstract specification to
code, but it is usually used for a specific case study, and there is no
fully generic approach. And it needs a lot of work.

We then discuss whether there are other important techniques that need
to be discussed. Dependently typed languages can force you to write
correct programs. Some of those languages have a possibility to generate
C-code.

An alternative is to use model checking for C-code directly. These
checkers typically work at system-level, looking at the composition of
the individual components. A strong point of model checkers is that they
have very good abstractions built in, but because of the abstraction,
not all properties can be checked, in particular not when they are
specific to the interaction between the components.

It is a pity that the verification communities are so separated. It
would be good to have some notion of contract in the model checking
community. Of course, one issue is that the logics are very different.
It seems like model checking has a more monolithic view on verification,
in contrast to the more fine-grained approach of deductive verification.

Next, we discussed how should we continue with the VTLTC. The suggested
directions were a) to study what information should be included into the
automaton for it to be useful for both model checking and deductive
verificationm b) Investigate how to incorporate contracts into model
checking, and c) how to do the other way round, i.e. support model
checking of contracts.

We will continue with the current case study on the Hagrid system, while
we investigate these points, and then think about moving to a more
interesting case study once we find our approaches useful.
