---
title: Specifying the Casino protocol with JML
---

The casino case study does not allow events to occur in arbitrary
order. They must follow a certain protocol. This protocol can be
visualised as a graph as follows:

![/casino/spec/CasinoStates.svg](Finite State Machine for the casino)

The straightforward realisation of this state machine in a contract
based language will be exemplified with a simple JML interface. Note
that this interface is not concerned with data at all, it merely
restricts the allowed method calls to those that the protocol permits.

It seems easy to implement a tool that transforms a FSM defining the
permitted sequences of method calls into an annotated interface.  It
is the job of the implementation to provide a suitable refinement of
the model field `state` that is faithful to this specification. It may
(like in the original solidity code) be an explicit state field, or it
may be implicitly computed from other variables of the implementing
object.

However, while the implementation for the casino is written,
verification against the FSM can already be conducted -- regarding the
possible sequences of method calls.

```
interface Casino {
    //@ public static final ghost int IDLE = 0;
    //@ public static final ghost int AVAILABLE = 1;
    //@ public static final ghost int BET_PLACED = 2;

    //@ public model int state = 0;

    /*@ public behaviour
      @  ensures state == IDLE;
      @*/
    void init();

    /*@ public behaviour
      @  requires state == IDLE || state == AVAILABLE 
      @        || state == BET_PLACED;
      @  ensures state == \old(state);
      @*/
    void addToPot(Message msg);

    /*@ public behaviour
      @  requires state == IDLE || state == AVAILABLE;
      @  ensures state == \old(state);
      @*/
    void removeFromPot(Message msg, int amount);

    /*@ public behaviour
      @  requires state == IDLE;
      @  ensures state == AVAILABLE;
      @*/
    void createGame(Message msg, int hash);

    /*@ public behaviour
      @  requires state == AVAILABLE;
      @  ensures state == BET_PLACED;
      @*/
    void placeBet(Coin guess);

    /*@ public behaviour
      @  requires state == BET_PLACED;
      @  ensures state == IDLE;
      @*/
    coid decideBet(int secret);
}
```
