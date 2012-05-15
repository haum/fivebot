/* test des sensors infrarouge sans les bullshits */

#define N_MOYENNE 3
#define TIME_BETWEEN 25

unsigned char IRG = 0; // Infrarouge gauche --> pin0
unsigned char IRC = 1; // Infrarouge centre --> pin1
unsigned char IRD = 2; // Infrarouge droit --> pin2


int getDistance(int sensor) {
    return (6762/(analogRead(sensor)-9))-4;
    //return analogRead(sensor);
}

float getDistAverage(int sensor){
    int i;
    float sum = 0;
    for (i = 0; i < N_MOYENNE; i++) {
        sum += getDistance(sensor);
        delay(TIME_BETWEEN);
    }
    return sum/N_MOYENNE;
}

void setup()
{
    Serial.begin(9600);
}

void loop()
{
     float g = getDistAverage(IRG);
     float c = getDistAverage(IRC);
     float d = getDistAverage(IRD);
     Serial.print("Gauche : ");
     Serial.print(g);
     Serial.print(" Centre : ");
     Serial.print(c);
     Serial.print(" Droite : ");
     Serial.println(d);
}
