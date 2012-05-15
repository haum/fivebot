#define MINSPEED 0
#define MAXSPEED 100
#define SPEED    10

unsigned char PMG = 5; // Puissance moteur gauche --> pin5
unsigned char PMD = 6; // Puissance moteur droit --> pin6
unsigned char SMG = 4; // Sens moteur gauche --> pin4
unsigned char SMD = 7; // Sens moteur droit --> pin7

void setup()
{
    pinMode(PMG,OUTPUT);
    pinMode(PMD,OUTPUT);
    pinMode(SMG,OUTPUT);
    pinMode(SMD,OUTPUT);
}

void loop()
{
    analogWrite(PMG, SPEED);
    analogWrite(PMD, SPEED);
    digitalWrite(SMG, HIGH);
    digitalWrite(SMD, HIGH);
}

// vim: ft=arduino
