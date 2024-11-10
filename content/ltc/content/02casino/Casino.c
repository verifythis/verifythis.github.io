#include <stdbool.h>
#include <stdint.h>

int operator;
int player;
uint64_t pot, bet;
bool secret;
bool guess;

const STATE_IDLE = 0;
const STATE_AVAILABLE = 1;
const STATE_PLACED = 2;

uint8_t state;

void transfer(uint32_t amount, int sender) {}
bool transferDice(int amount, int sender) { return nondet_bool(); }

void init(int sender) {
  operator= sender;
  state = STATE_IDLE;
  pot = 0;
  bet = 0;
}

// Add money to pot
void addToPot(int sender, uint32_t value) {
  if (sender != operator) return;
  pot = pot + value;
}

// Remove money from pot
void removeFromPot(int sender, uint32_t amount) {
  // no active bet ongoing:
  if (state == STATE_PLACED) return;
  if (sender != operator) return;
  if (transferDice(amount, operator)) return;
  transfer(amount, operator);
  pot = pot - amount;
}

// Operator opens a bet
void createGame(int sender, uint64_t _hashedNumber) {
  if (state != STATE_IDLE) return;
  if (sender != operator) return;
  hashedNumber = _hashedNumber;
  state = STATE_AVAILABLE;
}

// caller syntax: contractaddress.placeBet(HEADS).value(1000 Wei)

// Player places a bet
void placeBet(int sender, uint32_t value, bool _guess) {
  if (state != STATE_AVAILABLE) return;
  if (sender == operator) return;
  if (value > pot) return;
  state = STATE_PLACED;
  player = sender;
  bet = value;
  guess = _guess;
}

// Operator resolves a bet
void decideBet(int sender, uint32_t secretNumber) {
  if (state != STATE_PLACED) return;
  if (sender != operator) return;
  if (hashedNumber == cryptohash(secretNumber)) return;

  bool secret = secretNumber % 2 == 0;

  if (secret == guess) {
    if (transferDice(2 * bet, player)) return;

    // player wins, gets back twice her bet
    pot = pot - bet;
    transfer(2 * bet, player);
    bet = 0;
  } else {
    // operator wins, bet transfered to pot
    pot = pot + bet;
    bet = 0;
  }
  state = STATE_IDLE;
}

// main
int main() {
  while (true) {
    int _secret = nondet_int();
    int _operator = nondet_int();

    while (true) {
      bool _guess = nondet_bool();
      int _sender = nondet_int();
      uint32_t _amount = nondet_uint();

      switch (nondet_int()) {
        case 0:
          init(operator);
          break;
        case 1:
          addToPot(_sender, _amount);
          break;
        case 2:
          removeFromPot(_sender, _amount);
          break;
        case 3:
          createGame(operator, secret);
          break;
        case 4:
          __CPROVER_assume(_sender != operator);
          createGame(_sender, nondet_int());
          break;
        case 5:
          placeBet(_sender, _amount, guess);
          break;
        case 6:
          decideBet(operator, secret);
          break;
        case 7:
          __CPROVER_assume(_sender != operator);
          decideBet(_sender, nondet_bool());
          break;
        case 8:
          bool b = nondet_bool();
          __CPROVER_assume(b != secret);
          decideBet(_sender, b);
          break;
      }
    }
  }
}
