---
kind: home
---

## What is VerifyThis?

The [VerifyThis](https://www.pm.inf.ethz.ch/research/verifythis.html) verification competition is a regular event run as an onsite meeting with workshop character in which three challenges are proposed that participants have to verify in 90 minutes each using their favourite program verification tool.

**Related Event:** [VerifyThis On-site competition](https://www.pm.inf.ethz.ch/research/verifythis.html)

We have experienced that the state of the art of program verification allows the participants to specify and verify impressively complex algorithms in this short a time span. If such sophisticated, realistic but not real, problems can be solved in real-time, what would be achievable if (a) we as the program verification community collaborated and (b) the time constraints were removed?

## The Memcached Challenge

![](/img/logo.svg)

**VerifyThis Long-Term Challenge** aims at proving that deductive program verification can produce relevant results for real systems with acceptable effort on a large scale in a collaborative manner.

The current challenge is dedicated [memcached](03memcached), a simple LRU-cache based key-value server. Memcached is the backbone for fast response times in distributed web-application. The goal is not only to provide an investigation on the server alone, but also take the client-side and the protocol into our considerations.

*   [Here is the complete description of the challenge.](03memcached/challenge.pdf)
*   [Here are the presentation slides (Talk given at ETAPS'23).](03memcached/slides_etaps23.pdf)

## How to participate?

Participation on the challenge is easy. You should pick your favourite tool for the formal software assessment, and try whether you find a bug or prove adhering of the specification in HAGRID (or a suitable abstraction). Of course you can participate in groups. Moreover, we would like to foster collaboration between participating groups. Therefor we would appreciate if you [register your group](registration/). Do not forget to also subscribe to our [mailing list](https://www.lists.kit.edu/sympa/info/verifythis-ltc) (verifythis-ltc@lists.kit.edu) to be able to share your questions and your work and to keep up to date with the work of the rest of the teams.

We plan to go for a Track on ISoLA 2024. In the intermediate, we plan rather informal meetings on iFM'23 and ETAPS'24.

## Previous Challenges
* [Hagrid:](01hagrid) Verifying key-server, a replacement for the unsecure SKS.
* [Casino:](02casino) Smart contract implementing a simple guessing game.
