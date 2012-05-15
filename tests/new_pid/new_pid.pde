#define MINSPEED 0
#define MAXSPEED 100
#define Kp 10

unsigned char PMG = 5; // Puissance moteur gauche --> pin5
unsigned char PMD = 6; // Puissance moteur droit --> pin6
unsigned char SMG = 4; // Sens moteur gauche --> pin4
unsigned char SMD = 7; // Sens moteur droit --> pin7

volatile unsigned char speed_left=0;
volatile unsigned char speed_right=0;
volatile unsigned long pulses_left=0;
volatile unsigned long pulses_right=0;

void changespeed(char left, char right){
    analogWrite(PMG, left);
    digitalWrite(SMG, HIGH);
    analogWrite(PMD, right);
    digitalWrite(SMD, HIGH);
} 

void orderspeed(char sl, char sr){
	speed_left = sl;
	speed_right = sr;
	pulses_left = 0;
	pulses_right = 0;
}

void equilibrage(){
    // Get average
    int avg = (pulses_right - pulses_left)/2;

    /* Which wheel is too fast ?
     * 
     * fact = -1 if right is faster
     * fact = 1 if left is faster
     *
     */
    char fact = pulses_left > pulses_right ? 1 : -1;

    // Erase counters
    pulses_right = 0;
    pulses_left = 0;

    // Choose speed
    changespeed(speed_left+(avg*Kp*fact), speed_right+(avg*Kp*fact));
}


/******** interrupts *********/
void pulses_left_balance(){
    pulses_left++;
}

void pulses_right_balance(){
    pulses_right++;
}
/****** End interrupts *******/


void setup(){
    pinMode(PMG,OUTPUT);
    pinMode(PMD,OUTPUT);
    pinMode(SMG,OUTPUT);
    pinMode(SMD,OUTPUT);

    attachInterrupt(1, pulses_left_balance, RISING);
    attachInterrupt(0, pulses_right_balance, RISING);
	orderspeed( 20, 20);	
}


void loop(){
	equilibrage();
}

// vim: set ft=arduino :
