
// Robot FB-004
// Test des télémètres à infrarouge
// J. Lehuen 2011

unsigned char IRG = 0; // Infrarouge gauche --> pin0
unsigned char IRC = 1; // Infrarouge centre --> pin1
unsigned char IRD = 2; // Infrarouge droit --> pin2

int ir_distance(unsigned char ir);

void setup ()
{  
  Serial.begin(38400);

  pinMode(IRG, INPUT);
  pinMode(IRC, INPUT);
  pinMode(IRD, INPUT);
}

void loop()
{
  int distG=ir_distance(IRG);
  int distC=ir_distance(IRC);
  int distD=ir_distance(IRD);

  Serial.print("gauche=");
  Serial.print(distG, DEC);
  Serial.print("   centre=");
  Serial.print(distC, DEC);
  Serial.print("   droite=");
  Serial.println(distD, DEC);

  delay(100);
}

int ir_distance(unsigned char ir)
{
  int val = analogRead(ir);
  return (6762/(val-9))-4;
}

