
// Robot FB-004
// Test des encodeurs
// J. Lehuen 2011

unsigned char PMG = 5; // Puissance moteur gauche --> pin5
unsigned char SMG = 4; // Sens moteur gauche --> pin4

volatile int encoderpos = 0; // Compteur de la roue codeuse
volatile int rpmcount = 0; // Compteur par itération

unsigned int rpm = 0; // Vitesse de la roue
unsigned long oldTime = 0;

void setup()
{
	Serial.begin (38400);
	
    pinMode(PMG,OUTPUT);
    pinMode(SMG,OUTPUT);
   
  attachInterrupt(INT1, interrupt, RISING);

  analogWrite(PMG, 25);
  digitalWrite(SMG, HIGH);
}

void loop()
{

  rpm = 120/(millis() - oldTime)*rpmcount;
  oldTime = millis();
  rpmcount=0;
  
  Serial.print ("pos = ");
  Serial.print (encoderpos, DEC);
  Serial.print ("   rpm = ");
  Serial.println(rpm, DEC);
}

void interrupt()
{
  encoderpos++;
  rpmcount++;
}



