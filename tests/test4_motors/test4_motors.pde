
// Robot FB-004
// Synchronisation des moteurs
// J. Lehuen 2011

#define MINSPEED 0
#define MAXSPEED 100
#define SPEED    50

#define UNKNOWN 0
#define ADVANCE 1

int state = UNKNOWN;

unsigned char PMG = 5; // Puissance moteur gauche --> pin5
unsigned char PMD = 6; // Puissance moteur droit --> pin6
unsigned char SMG = 4; // Sens moteur gauche --> pin4
unsigned char SMD = 7; // Sens moteur droit --> pin7

volatile unsigned char speed_left;
volatile unsigned char speed_right;
volatile unsigned long pulses_left;
volatile unsigned long pulses_right;
volatile int pulses_delta;

void pulses_init()
{
    pulses_left = 0;
    pulses_right = 0;
}

void pulses_left_balance()
{
    ++pulses_left;
    pulses_balance();
}

void pulses_right_balance()
{
    ++pulses_right;
    pulses_balance();
}

void pulses_balance()
{
    pulses_delta = speed_right + pulses_right - pulses_left;
    if (pulses_delta <= MINSPEED) speed_left = MINSPEED;
    else if (pulses_delta >= MAXSPEED) speed_left = MAXSPEED;
    else speed_left = pulses_delta;
    advance(speed_left, speed_right);
}

void init_balance(unsigned char left, unsigned char right)
{
    speed_left = left;
    speed_right = right;
    noInterrupts();
    pulses_init();
    interrupts();
}

void advance_balance(unsigned char left, unsigned char right)
{
    if (state == ADVANCE) return;
    state = ADVANCE;
    init_balance(left, right);
    advance(speed_left, speed_right);
}

void advance(unsigned char left, unsigned char right)
{
    analogWrite(PMG, left);
    digitalWrite(SMG, HIGH);
    analogWrite(PMD, right);
    digitalWrite(SMD, HIGH);
}

void setup()
{
    pinMode(PMG,OUTPUT);
    pinMode(PMD,OUTPUT);
    pinMode(SMG,OUTPUT);
    pinMode(SMD,OUTPUT);
    
    attachInterrupt(1, pulses_left_balance, RISING);
    attachInterrupt(0, pulses_right_balance, RISING);
}

void loop()
{
    advance_balance(SPEED, SPEED);
    delay(100);
}


