Verifying the Casino contract with VerCors

[INTRODUCTION]

The casino.pvl file uses VerCors to verify two safety properties of the casino contract.

The VerCors tool uses deductive verification and separation logic to verify CONCURRENT programs.
We verified the casino contract by translating it to a PVL program. PVL is the Prototypal Verification Language of VerCors, which you will find very similar to Java in both syntax and semantics.

[APPROACH]

VerCors accounts for full interleaving of processes/threads. Since functions in a Solidity contract are executed atomically, we use the intrinsic lock of the Contract class to work as a mutex over the state of the contract. Every time we run a function, we first lock then we run the body and then we unlock. VerCors makes sure we do not modify protected state without holding the lock.

We use a lock invariant to prove safety properties about the contract. This invariant is verified every time we unlock the mutex and is assumed to be true every time we lock the mutex. It is also verified at the end of the constructor of the casino, just before publication of the casino object (and before the first locking is ever done).

The invariant checks for two properties:

1) The synchronisation between the balance and our own accounting, through the invariant `balance == pot + bet`.

2) That we always have enough money to pay the winner, through the invariant `pot >= bet`.

In functions removeFromPot and decideBet, we unlock consequently lock on the mutex when we call the transfer method on the operator/player. In this way we allow other methods of the contract to be interleaved at this point, as many times and in any order, emulating all possible calls that the transfer method of the player may make to our contract.

[RESULTS]

At this point VerCors will complain about not being able to establish invariant (1) and this is to be expected: in both cases we update our accounting only after returning from the transfer call, while solidity will transfer the amount from our balance at the starting point of the call. Thus, if the transfer method calls us back, it will find our contract in a `violating state` where the accounting and the real balance differ. A fix is to update our accounting just before calling the transfer. But before we are able to prove it, we also need to add an extra invariant, stating that `  bet is 0 when the bet hasn't been placed: `state <= 1 ==> bet == 0`

On the other hand, invariant (2) was verified without problems other than adding the requirement that the value field of messages is always positive, which I hope is a reasonable requirement?

[END NOTES]

Since VerCors deals with permission based separation logic, you will find many annotations of the form `Perm(x,p)`, you can safely ignore this unless you want a deeper understanding of the verification, and then I suggest you to read the VerCors tutorial in github.

I had to abstract all basic types to int (mathematical integers) and boolean, since currently we don't deal with other integer types nor enumeration types in VerCors.

More information and thoughts about the verification study can be found as comments in the casino.pvl file. VerCors pre-compiled can be downloaded from https://github.com/utwente-fmt/vercors/releases/latest and you can run this verification with `vct --silicon casino.pvl`