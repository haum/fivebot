/*
 * project : fivebot
 * author : mathieu
 * license : wtfpl
 * date : 04/01/2012
 * version : 1.0
 * goal :
 * test the bumpers abstraction
 *
 */

#include "bumpers.h"

#define BR BOT_RIGHTBUMPER
#define BM BOT_MIDDLEBUMPER
#define BL BOT_LEFTBUMPER

void setup()
{
 	_init_bumpers();
    Serial.begin(38400);
}

void loop()
{
    bool bumperG = !digitalRead(BL);
    bool bumperD = !digitalRead(BR);
    bool bumperC = !digitalRead(BM);

    Serial.print("gauche=");
    Serial.print(bumperG, DEC);
    Serial.print("   centre=");
    Serial.print(bumperC, DEC);
    Serial.print("   droite=");
    Serial.println(bumperD, DEC);

    delay(100);
}
