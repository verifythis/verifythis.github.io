--- 
title: "Specification Language #2" 
summary: "Online Discussion on Hagrid."
date: 2021-06-23 
tags: [hagrid, speclang] 
---

# Online Discussion

**[June 23, 12:00
UTC](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20210519T12&p1=%3A&ah=2)**
- 14:00 UHR UTC  
**[June 23, 14:00
CEST](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20210519T12&p1=%3A&ah=2)**
-16:00 UHR CEST  
**[June 23, 08:00
EDT](https://www.timeanddate.com/worldclock/fixedtime.html?msg=VerifyThis&iso=20210519T12&p1=%3A&ah=2)**
- 10:00 UHR EDT

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
2020, a [follow-up online
discussion](/events/2020-11-27-online-event/) revealed interesting new
ideas regarding specification and verifiation of interacting systems
like Hagrid.

### Aggregated Materials

-   [Slides for this meeting](/01hagrid/vtltc_contracts.pdf)
-   [Slides for this meeting in Feburar](/01hagrid/VerifyThisLTC-Feb2021.pdf)
-   [Slides from the meeting in November](/01hagrid/VerifyThisLTC-Nov2020.pdf)
-   [Informal Proceedings of the
    solutions](https://publikationen.bibliothek.kit.edu/1000119426)

### Who can join the meeting?

Everybody who is interested in the challenge, formal verification, the
proposed solutions or VerifyThis is cordially invited to join the
meeting!

### How can I join the meeting?

The online event takes place with Zoom.

In protection against spammers, we require a short registration
beforehand. The login credentials will be sent via your provided email
address. Please register yourself with an email to
[ulbrich@kit.edu](mailto:ulbrich@kit.edu?subject=VTLTC%20registration).

**Note:** If you had already registered for the [Online Event in
November](/online-event-nov/) [or Feburary](/online-event-feb/), we will
send you the required login credentials automatically. Another
registration is not required in this case.

## Minutes of the Meeting: Contracts Discussion

VerifyThis discussion June 23, 2021  
Marieke Huisman, Raúl Monti, Mattias Ulbrich, Alexander Weigl

The discussion starts with a presentation by Christian Lidström about
different formalisms to specify automata-like properties (slides
attached).

The presentation contains the following formalisms: - Finite state
machines describe finite traces of events. Such FSMs can be described in
different formats, e.g. NuSMV style models). - Regular expressions -
Context-free grammars - Interval temporal logic, which is typically used
to described sequences of states, rather than events. - TimedCSP: one
important take-away is that we even forget to think about time. With
explanation by Paula Herber: can be used to describe external behaviour,
by abstracting away from the internal details. The specification
formalisms also allows to distinguish between external and internal
choice. - Model-based specifications in VerCors (with brief explanation
by Wytse Oortwijn)

Afterwards, we discuss what this tells us about specifications.

In particular, considering the CSP-like specifications, how does this
come together with classical deductive verification approaches (design
by contract, program verification). Could the CSP-actions correspond to
methods?

Combining the two is very challenging: it is possible to show that
certain actions or methods are called in a specific order, but
incorporating reasoning about the internal state is difficult (but
desirable). The VerCors approach with process algebras is an attempt to
do this, but the difference is that it works more at an internal level,
while the CSP-style of specifications is more external.

What we would need is some way to specify state changes in an abstract
way. Often we wish to talk about events that happen, and about state
dependencies and updates in a mixed way, and we would need a single
logic that supports both.

Daniel Grahl did something in this direction with adding temporal logic
specifications to KeY (see his PhD thesis).

Another typical use case where this would be welcome would be protocol
specifications (both sequential and concurrent).

Also TLA (+) is mentioned as a maybe suitable all-in-one specification
language, but it also has limitations, because it does not allow to
describe how programs are connected to actions. We could maybe use
deductive verification to see how the program changes the state (a bit a
la what is done in VerCors), and then derive the TLA+ specifications.
This could be an extension to the VerCors approach, which would make it
less specific to the VerCors style of specifications.

TLA\* is mentioned. This is an extension of TLA+ that allows one to say
that an action has been taken. It could be worth looking more into this.

We continue the discussion about the other formalisms that Christian
mentioned. Some are just subsets of more complex ones. The advantage of
using them would be that they might be easier to automate (because less
expressive), and might be easier to use.

It might be interesting to think about such specifications as
interface-level specifications. They describe possible orders of calls,
the user has to check for protocol adherence. Thus, the combination may
enable a separation of concerns: The automata-based specification
describes the order of events/calls whereas the contract-based languages
are used to specify the effects of individual events.

The code would only look at a single automaton, and the automata
exchange messages for communication, from which global properties could
be derived. Distributed programs might be a good use case for this.

We also should think about the direction in which we would like to go.
Do we want to start with a model, and then synthesise the code, or do we
want to start with a program, and then construct a model. It seems there
are use cases for both of them. It also depends on what is your starting
point: sometimes this will be a protocol description, sometimes the code
is the main artifact.

Inferring the automaton from the code is still a major challenge. Some
work has been done in this direction on process mining, or using
automata learning for protocols. A major problem is that the resulting
model does not have any abstraction (at least, you don’t get this for
free). Getting the intent of the code as a model is a major challenge.

What is the best formalisms depends on what is verifiable, and on what
sort of properties we want to capture.

We end with a short discussion about follow up discussions. The
attendants like it if the discussion is concrete, about a particular
case (the long term challenge, or some other challenge). It would be
good if concrete programs or properties are the starting point for the
discussion, so we could talk for example about how a certain property
could be specified (as a community effort).
