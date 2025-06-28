---
title: "Contract Languages I/25: Jacques-Henri Jourdan: Creusot – 12 March 2025"
author: ulbrich
date: 2025-03-12
---

[Jacques-Henri Jourdan](https://jhjourdan.mketjh.fr/) will present the
Rust verification system [CREUSOT](https://github.com/creusot-rs/creusot).

**Time and Date:** *19 March 2025, 16:00 CET*,

<!--more-->

As a follow-up to the March 2024 [Lorentz Center workshop on Contract
Languages](https://www.lorentzcenter.nl/contract-languages.html), we
will host a series of online presentations and discussions around
formal methods with contract languages, aligning with the LTC goal of
enabling information exchange between different formal systems.

#### Title

CREUSOT

#### Abstract

I will present Creusot, a verification tool for the Rust programming
language. Creusot tries to leverage the advances of the Rust programming
language to ease modular specification and verification of low-level
programs. In particular, the type system or Rust provides strong
guarantees on the aliasing of pointers in the program, which makes it
possible to prove correct in Creusot programs that manipulate pointers
to memory, even with mutation, and with little specification overhead.
Leveraging Rust's feature of type traits and closures enabled us to give
strong yet usable specification for Rust iterators, including those that
involve mutation and higher-order. Finally, we will see how we envision
exploiting Rust's ownership mechanisms to define a notion of Ghost
ownership, useful to take into account complex aliasing patterns,
concurrency or multi-language verification.
If time allows, we will present a short demo of the tool.


#### A short bio:

Jacques-Henri Jourdan defended his PhD in 2016 under the supervision of
Xavier Leroy: during his PhD, he developed Verasco, a formally verified
static analyzer based on abstract interpretation. Since then, his left
abstract interpretation to move towards separation logic, the Rust
programming language and deductive verification. During his post-doc at
MPI-SWS, he was involved in the development of the Iris separation
logic, and used it to formalize the type system of the Rust programming
language (RustBelt). Since his recruitment as a CNRS researcher at
Laboratoire Méthodes Formelles in 2017, he worked at extending Iris and
RustBelt to weak memory for both Rust and OCaml. He also started the
development of the Creusot tool for verification of Rust programs.

#### Participation

If you are interested in joining, drop a mail to [Mattias
Ulbrich](mailto:ulbrich@kit.edu) for the link.
