---
title: The PGP Key Server
---



As a consequence, the OpenPGP community decided to implement a new
server framework that manages the access to public keys. The new
official server is called
[HAGRID](https://gitlab.com/hagrid-keyserver/hagrid), it is a open
source, and it is already in [production](https://keys.openpgp.org).
The project is written in the programming language Rust and comprises
some 6,000 lines of code in total. This implementation is the
reference implementation of the server.

For citation, please use the [following publication](https://doi.org/10.1007/978-3-030-64354-6_10):

```bibtex
@incollection{HuismanMontiUlbrichWeigl2020,
  author =       {Marieke Huisman and  Ra{\'u}l Monti and Mattias Ulbrich
                  and  Alexander Weigl},
  title =        {The VerifyThis Collaborative Long Term Challenge},
  editor =       {Ahrendt, Wolfgang and Beckert, Bernhard and Bubel,
                  Richard and H{\"a}hnle, Reiner and Ulbrich, Mattias},
  bookTitle =    {Deductive Software Verification: Future
                  Perspectives: Reflections on the Occasion of 20
                  Years of KeY},
  year =         2020,
  month =        dec,
  series =       {Lecture Notes in Computer Science},
  publisher =    {Springer},
  volume =       {12345},
  part =         {IV: Feasibility and Usability},
  chapter =      {10},
  pages =        {246--260},
  isbn =         {978-3-030-64354-6},
  doi =          {10.1007/978-3-030-64354-6_10},
  url =          {https://doi.org/10.1007/978-3-030-64354-6_10}
}
```

[Challenge Description](/01hagrid/challenge)
&mid;
[Informal Proceedings](https://publikationen.bibliothek.kit.edu/1000119426)
&mid;
[Call For Papers](/01hagrid/cfp)



# Verification Contributions

-   Gidon Ernst and Lukas Rieger  
    **Information Flow Testing of a PGP Keyserver**
    -   [Abstract](/01hagrid/abstracts/VTLTC_2020_paper_4.pdf)
    -   Resources: <https://github.com/gernst/verifythis2020>
-   Diego Diverio, Cláudio Lourenço and Claude Marché  
    **"You-Know-Why": an Early-Stage Prototype of a Key Server Developed
    using Why3**
    -   [Abstract](/01hagrid/abstracts/VTLTC_2020_paper_2.pdf)
    -   Resources: <https://gitlab.inria.fr/why3/verifythis2020>
-   Stijn de Gouw, Mattias Ulbrich and Alexander Weigl  
    **The KeY Approach on Hagrid**
    -   [Abstract](/01hagrid/abstracts/VTLTC_2020_paper_3.pdf)
    -   Resources:
        -   [Keyserver](https://github.com/KeYProject/verifythis-ltc-2020/blob/master/simplified/Keyserver.java)
            -- A simplified single-class version of the Keyserver using
            arrays.
        -   [Map](https://github.com/KeYProject/verifythis-ltc-2020/blob/master/imap/)
            -- A multi-class version using map data types.
-   Claire Dross, Johannes Kanig, and Yannick Moy  
    **A Solution to the Long-Term Challenge in SPARK**
    -   [Abstract](/01hagrid/abstracts/VTLTC_2020_paper_1.pdf)
    -   Resources: <https://github.com/AdaCore/Lumos_Maxima>
-   Gidon Ernst, Toby Murray and Mukesh Tiwari  
    **Verifying the Security of a PGP Keyserver**
    -   [Abstract](/01hagrid/abstracts/VTLTC_2020_paper_5.pdf)
    -   Resources:
        -   [Case Study
            (tiny-email.c)](https://bitbucket.org/covern/secc/src/master/examples/tiny-email.c)
        -   [paper](https://www.sosy-lab.org/research/pub/2019-CAV.SecCSL_Security_Concurrent_Separation_Logic.pdf)
        -   [or the easy-to-access
            slides](https://www.sosy-lab.org/research/prs/2019-07-18-CAV19-SecCSL_Security_Concurrent_Separation_Logic.pdf)
-   Mattias Ulbrich  
    **Event-B Formalisation of the key manager**
    -   [PDF documentation of the Event-B
        model](https://formal.iti.kit.edu/~ulbrich/pub/LongTermChallenge.pdf)
    -   Event-B (RODIN) sources are available on request. Just send me
        a mail (ulbrich@kit.edu).

### Alternative Implementations

-   [in Scala](https://github.com/gernst/verifythis2020)
-   [in Java](https://github.com/wadoon/keyserver-java)
