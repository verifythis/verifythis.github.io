---------------------------------- MODULE Casino ------------------------------
EXTENDS Integers, FiniteSets, TLC

VARIABLES 
    operator,      \* Identifier of the contract operator
    player,         \* Identifier of the current player
    pot,           \* Value of the pot
    hashedNumber,  \* bit commitment
    guess,         \* (true,false) player's guess
    bet,           \* (uint) player's bet 
    state,         \* state of play (STATES)
    WALLETS        \* (record: id -> uint) current amount of money in user wallets

STATES == { "IDLE", "GAME_AVAILABLE", "BET_PLACED" }

INVARIANT ==
    /\ state \in STATES 
    /\ 0 \leq pot 
    /\ 0 \leq bet
    /\ guess \in BOOLEAN 
    /\ \forall x \in DOMAIN WALLETS: WALLETS[x] \geq 0

Init(op) == 
    /\ operator = op
    /\ state = "IDLE"
    /\ pot = 0
    /\ bet = 0
            
AddToPot(sender, money) == 
    /\ sender = operator
    /\ pot' = pot + money
    
\* Remove money from pot
RemoveFromPot(sender, amount) ==     
    /\ state # "BET_PLACED" \* no active bet ongoing:    
    /\ sender = operator
    /\ WALLETS'[operator] = WALLETS[operator] + amount \* operator.transfer(amount);
    /\ pot' = pot - amount
    
\* Operator opens a bet
CreateGame(sender, hash) == 
    /\ state = "IDLE"
    /\ sender = operator
    /\ hashedNumber' = hash
    /\ state' = "GAME_AVAILABLE"

\* Player places a bet
PlaceBet(sender, money, _guess) == 
    /\ state = "GAME_AVAILABLE"
    /\ sender # operator
    /\ money <= pot
    /\ state' = "BET_PLACED"
    /\ player' = sender
    /\ bet' = money
    /\ guess' = _guess

DecideBet0(sender, secret) ==
    /\ state = "BET_PLACED"
    /\ sender = operator
    \* /\ hashedNumber == cryptohash(secret)

\* Operator resolves a bet    
DecideBetWin(sender, secret) ==
    /\ DecideBet0(sender, secret)
    /\ (secret % 2) = guess
    /\ \* player wins, gets back twice her bet
        pot' = pot - bet
    /\ WALLETS[player] = WALLETS[player] + 2*bet
    /\ bet = 0
    /\ state' = "IDLE"


\* Operator resolves a bet    
DecideBetLoose(sender, secret) ==
    /\ (secret % 2) = guess
    /\ \* operator wins, bet transfered to pot
        pot' = pot + bet
    /\ bet = 0
    /\ state' = "IDLE"
    /\ DecideBet0(sender, secret)

\* Normal form: Spec == Init /\ [](A /\ B)

A == bet = CHOOSE a \in Int: (\forall x \in Int : a # x)
B == bet = CHOOSE a \in Int: (CHOOSE x \in Int : a # x)

Step(secret) ==  \exists sender  \in Int :
         \exists secret2 \in Int :
         \exists money   \in Int :
              \/ CreateGame(sender, secret)
              \/ AddToPot(sender, money)
              \/ RemoveFromPot(sender, money)
              \/ (\exists g \in BOOLEAN  : PlaceBet(sender, money, g))
              \/ DecideBetWin(sender, secret2)
              \/ DecideBetLoose(sender, secret2) 

Spec == \forall op \in Int : \forall secret \in Int :
          /\ Init(op)
          /\ [][Step(secret)]_<<>>
              


(* PROPERTY 
   LIVENESS(DecideBetWin/Loose) G F (state = IDLE)
*)

(* + Notion of ENABLED actions and deadlocks
 * + Modeling of different contracts via modules possible.
 *)

===============================================================================

