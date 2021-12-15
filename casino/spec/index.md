---
title: Specifications for the Casino
---

**Currently under construction ...**


* [Original Solidity file](../SimpleCasino.sol) contributed by Wolfgang Ahrendt

* [Verified Solidity](Casino.sol), [Logfile of SLCVerify](slcverify-out.txt)
contributed by Jonas Schiffl  

* Timed Automata (Uppaal) contributed by Jonas Becker and Paula Herber
 
 
     Automata describing the smart contract calls:
    ![](uppaal/first.png)
    
    
    Automata describing the smart contract operations:
    ![](uppaal/second.png)


    > The "direct" versions are closely based on the source code, the
    >     "state" versions on the state chart. The versions without
    >     overflow protection model the system with all its flaws,
    >     while the versions with overflow protection at least prevent
    >     integer overflows and underflows, because Uppaal does not
    >     allow to check other properties while those are still
    >     possible.
    
  * [uppaal/DirectCasinoOverflowProtection.xml](uppaal/DirectCasinoOverflowProtection.xml)
  * [uppaal/DirectCasino.xml](uppaal/DirectCasino.xml)
  * [uppaal/StateCasinoOverflowProtection.xml](uppaal/StateCasinoOverflowProtection.xml)
  * [uppaal/StateCasino.xml](uppaal/StateCasino.xml)
  
* [Temporal Logic of Actions (TLA)](https://lamport.azurewebsites.net/tla/book.html) contributed by Alexander Weigl
  * [Casino.tla](Casino.tla)
  
* Translation to C contributed by Alexander Weigl for the use in 
  C-based verification tools (e.g., CBMC, SEAHORN)
  * [Casino.c](Casino.c)
  
* Automata describing the protocol contributed by Mattias Ulbrich
  ![](CasinoStates.svg)
