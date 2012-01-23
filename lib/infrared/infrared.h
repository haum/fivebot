#ifndef INFRARED_H_INCLUDED
#define INFRARED_H_INCLUDED

// Constants for processing
#define BOT_N_MOYENNE    // Number of tests over IR
#define BOT_TIME_BETWEEN // Time between 2 tests

// Constants for IR sensors
#define BOT_IRG 0
#define BOT_IRC 1
#define BOT_IRD 2

int BOT_getDistance(int sensor) {
    return (6762/(analogRead(sensor)-9))-4;
    //return analogRead(sensor);
}

float BOT_getDistAverage(int sensor){
    int i;
    float sum = 0;
    for (i = 0; i < N_MOYENNE; i++) {
        sum += getDistance(sensor);
        delay(TIME_BETWEEN);
    }
    return sum/N_MOYENNE;
}

#endif // INFRARED_H_INCLUDED
