
// Robot FB-004
// Test des bumpers
// J. Lehuen 2011

unsigned char BD = 8; // Bumper droit --> pin8
unsigned char BC = 9; // Bumper centre --> pin9
unsigned char BG = 10; // Bumper gauche --> pin10

void setup ()
{
    Serial.begin(38400);

    pinMode(BG, INPUT);
    pinMode(BC, INPUT);
    pinMode(BD, INPUT);
}

void loop()
{
    boolean bumperG = !digitalRead(BG);
    boolean bumperD = !digitalRead(BD);
    boolean bumperC = !digitalRead(BC);

    Serial.print("gauche=");
    Serial.print(bumperG, DEC);
    Serial.print("   centre=");
    Serial.print(bumperC, DEC);
    Serial.print("   droite=");
    Serial.println(bumperD, DEC);

    delay(100);
}






