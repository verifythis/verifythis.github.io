---
title: Long-term Challenge
subtitle: The PGP Key Server
---

This *VerifyThis Collaborative Large Scale Challenge* aims at proving
that deductive program verification can produce relevant results for
real systems with acceptable effort.

## HAGRID, the new PGP Key Server

A few months ago, the public server that would provide OpenGPG keys to
anyone who issued a query was proved to have security flaws. There was
not protection on who could publish a key. This opened the gate for
*Denial-of-Service* attacks: The attackers publish a huge amount of
keys under the identity of the target. This lead to two result:
Poeple, who want to send an email to the target, picked the wrong key
entry in the key server. And more critical, the clients, like
\textsc{gpg}, have struggle to handle these large *spam*
keys---resulting into
[CVE-2019-13050](https://access.redhat.com/articles/4264021). More
background information are available in the [blog post of the
developers](https://sequoia-pgp.org/blog/2019/06/14/20190614-hagrid/).
Also the old key server software \textsc{sks} was not conform to GPDR
and had performance issues.

As a consequence, the OpenGPG community decided to implement a new
server framework that manages the access to public keys. The new
official server is called
[HAGRID](https://gitlab.com/hagrid-keyserver/hagrid), it is a open
source, and it is already in [production](https://keys.openpgp.org).

The project is written in the programming language Rust and comprises
some 6000 lines of code in total. Not included the underlying web
framework or GPG library. This implementation is the reference
implementation of the server; but not necessarily the only conceivable
implementation doing the job.

The server essentially is a database that allows users to store their
public key for their e-mail address, to query for keys for e-mail
addresses and to tracelessly remove e-mail-key pairs from the
database. To avoid illegal database entry and removal actions,
confirmations are sent out to issuing users upon an addition or
removal request.

The server possesses a web frontend which accepts requests from users
or via API. It additionally possesses a connection to a database from
which it reads key-value pairs and writes to it. And an e-mail
connection.

At the core of the server there are n operations that can be triggered
from outside via the web front end. These are

* **Request adding a key:** A user can issue a request for storing
  a key for a particular e-mail address. To avoid that anybody can
  store a key for someone else's e-mail address, the key is not
  directly stored into the database, but a confirmation code is
  returned which is then sent by e-mail to the specified address. Only
  once the confirmation code is activated, will the address be
  actually added to the database.
* **Querying an e-mail address:** Any user can issue a request for
  learning the key(s) stored with a concrete e-mail address. No
  patterns allowed. Unconfirmed keys are not returned.
* **Request removing a key:** The user can request a removal of the
  association between a key and an e-mail address. The process begins
  with the confirmation via an e-mail address: The users enter one of
  their previous confirmed addresses. The server sends an e-mail to
  this address containing a link. Behind this link, there then
  a website that allows the removal of the key's association.

  If a key is not associated to an e-mail address it can be finally
  deleted.

* **Confirming a request:** Additions and removals are indirect
  actions. Instead of modifying the database directly, they issue
  a (secret and random) confirmation code. Confirmation of a code is
  performed using this operation. If the provided code is one recently
  issued then the corresponding oepration (addition/removal) is
  finalised.
  
## The Challenge

The challenge is to prove such a real/realistic key server application
correct. This may be done by analysing the Rust reference
implementation or by abstracting from it towards a transition system
or by re-implementing the requirements of the key server in your own
implementation.

Instead of verifying the reference implementation, any implementation
that satisfies the requirements from Sect.~\ref{sec:req} can be
considered for your verification. An implementation may also make use
of underlying (provenly correct, or assumedly correct)
libraries/middleware for the database or e-mail handling or web server
management.

This challenge proposes a number of concrete verification tasks that
qallow participants to shape their verification effort. However, there
are certainly other challenges not mentioned in this document which
are interesting. Any participant should feel free to add to the long
term challenge by contributing additional questions and possibly
answers for them.

The basic verification tasks for the *Collaborative Large Scale
Challenge* are described in the following.

The first job is the least specific task and allows almost any formal
system to participate. Verification tools that run fully automatically
(like the participants in VSCOMP) are partiuclarly invited to
contribute here and show that this can be done without further user
input. This is a foundational question and does not yet need a formal
specification.

{: .challenge} 
Verify that the implementation of the key server does
not exhibit undesired runtime effects (no runtime exceptions in
Java, no undefined behaviour in C, ...)

Traditionally, the challenged in Verify This are more heavy weight,
usually go much beyond this and require a formalisaiton of a property
that needs to be verified.

To this end the requirements devised in natural language in
Sect.~\ref{sec:req} are to be taken into consideration now and are to
be made accessible for formal verification. We assume that every
operation:

{: .challenge} 
Formalise and verify the informal specifications for the 

{: .challenge} 
Specify and verify that if an e-mail address is
queried, the respective key is returned if there is one.


Classical Functional specification.

We can go beyond that and prove secruty questions. Like the following
information flow property:

{: .challenge} 
Specify and verify that if an e-mail address has
been deleted from the system, no information about the e-mail adress
is kept in the server. \end{challenge}


Also:

{: .challenge} 
Prove that your implementation is free of data races. 

Or sequentially consistent or...

{: .challenge} 
Prove that any operation of the server terminates.

It may be of interest to go beyond mere termination and specify and
verify that the runtime is below an upper bound.

{: .challenge} 
Prove that any created confirmation code is

1. randomly chosen (i.e. that every string from the range is equally
   likely)
1. cannot easily be predicted \prelim{(that's more cryto then)}
1. is never leaked but as the return value of its issuing operation

leaked 

## Informal Functional Requirements for a Key Server

The Key server is a service that must provide the following
operations:

* Add key
* Remove key 
* Query key 
* tbd. 

The reference implementation does not only comprise these
functionality but contains also the database underneath the server
application and the webserver on top of the application.

While this challenges primarly focus on the server application, the
outer and inner level may as well be addressed. Otherwise sensible
assumptions about database have to be made (for instance using an
in-memory database in form of a hash table) and specified.


The informal requirements for the individual operations are
as follows:


