---
title: Registration
---

{: .box-note} 
You can participate as a group or single person. There are no restriction on
which verification tools do you apply. 

{: .box-warning}
The only restriction, is that your endeavour and results should be relevant 
for HAGRID or Key servers.

## Registration 

If you want to participate on this VerifyThis challenge, we appreciate if you
would register your group via an [issues
request](https://github.com/verifythis/verifythis.github.io/issues/new?template=registration.md).
We provide a template for this issues.

Along with your registration, we would appreciate if you give us some information: 

* The **name** and **affiliation** of the group and its participants. 
* A **contact** (name and e-mail) to the groups speaker.
* Feel free to provide **links** to your webpage, or the group webpage and/or 
  a dedicated page of your VerifyThis participation (e.g. a repository or github).
* A **short description** on your endevour. 
  Here are some guiding question: 
  * What do you plan to verify? (Functional Verification, Information Flow, Privacy, etc...)
  * Which tools or techniques do you plan to apply?
  * Which artifacts do you may produce?
* Are you open or even looking for **collaborations**? Which methods or tools do
  think could be beneficial to your endeavor?

{: .box-note}
**Note** your data will be published below. 

{: .box-note}
This is a looooong-term challenge. Therefore we would appreciate if you let us
know how your endeavour goes along, for example writing a short news entry for
this web page.

## Contributing

This section gives you a number of hints how you can contribute to the
collaborative long-term verification challenge.

**The time line** This long term challenge will be open from mid August 2019
until end of February 2020. Results will be presented at the VerifyThis workshop
at ETAPS 2020 in April 2020. A call for papers for a special issue is planned
for that time.

Of course, contribution to the challenge after this time is equally
welcome and will also be published on the online resources.

**Collaboration is central** This is why we encourage you yo subscribe to our
[mailing list](https://www.lists.kit.edu/sympa/info/verifythis-ltc) (verifythis-ltc@lists.kit.edu).
There, you can share your results, ask for help or suggest for collaborations 
with the rest of the teams working on the challenge.


## Currently registered groups

---
### Name: SecC Team

* **Affiliation:** LMU Munich, University of Melbourne
* **Contact:** Gidon Ernst gidon.ernst@lmu.de
* **Participants:** Gidon Ernst gidon.ernst@lmu.de, Toby Murray toby.murray@unimelb.edu.au

* **Webpages:**
  - Group -- https://covern.org/secc/
  - Repository -- https://github.com/gernst/verifythis2020

* **Description:**

  SecC is a verifier for low-level systems code written in C. SecC supports
  expressive annotations for value-dependent security classifications to prove
  information flow security.

* **Collaboration:** We are looking for feedback and collaboration!

---
### Name: VerCors Team

* **Affiliation:** FMT - University of Twente
* **Contact:** Raul Monti r.e.monti@utwente.nl
* **Participants:** Raul Monti, Marieke Huisman, Wytze Oortwijn, Sebastiaan Joosten, Sophie Lathouwers, Fauzia Ehsan, Mohsen Safari.

* **Webpages:**
  - Group -- https://utwente-fmt.github.io/vercors/
  - Repository -- https://vcs.utwente.nl/source/vt_lt_2020/


* **Description:**

  We plan to use VerCors separation logic instruments to verify permission
  concerns on the Server, such as thread safety. We also plan to model the
  server protocol using a model checker such as MCRL2 and then verify that the
  code follows such protocol by using actions and futures in VerCors.

* **Collaboration:** 

  It would be great to compare our protocol models with other models and discuss
  about their correctness. Maybe the differences in abstraction would enrich our
  analysis. Anyone working with futures or history can directly collaborate also
  and we can interchange opinions and results in this direction. Finally we will
  like to know if you can make use of our permission based analysis or if you
  have ideas in how to tackle this issues using other tools.


---
### Name: Lumos Maxima

* Affiliation: [ProofInUse joint lab](https://why3.gitlabpages.inria.fr/proofinuse/) 
               between [AdaCore](https://www.adacore.com/) and [Inria](http://toccata.lri.fr/index.fr.html)
* Contact: Yannick Moy (`<lastname>`@adacore.com) and Claude Marché (`<firstname>.<lastname>`@inria.fr)
* Participants: Claude Marché, Sylvain Dailler, Johannes Kanig, Claire Dross, Yannick Moy
* Webpage(s): https://github.com/AdaCore/Lumos_Maxima

* Description: 

    Our objective is to redevelop HAGRID in
    [SPARK](https://github.com/AdaCore/spark2014/), a subset of the Ada
    programming language targeted at formal verification, and to prove the
    following properties about the code:
    
    - absence of runtime errors
    - correct data and information flows
    - functional correctness
    - security (privacy?) properties that can be encoded in data/control
      contracts

    We also plan to evaluate the efficiency of the executable code to compare it
    with the original implementation in Rust, and to demonstrate its usability
    on a variety of hardware platforms.

* Collaboration:
 
  We are interested in collaborating on the best approach to achieve the above
  goals, either with people willing to contribute to the project directly, or
  with people sharing the same overall goals with other languages and tools.
  
