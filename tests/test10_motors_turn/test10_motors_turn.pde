/*
 *   File: test10_motors_turn.pde
 *   Author : Mathieu (matael) Gaborit
 *   Year : 2012
 *   Licence : WTFPL
 *   Licence Terms :
 *
 *           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                   Version 2, December 2004
 *
 *   Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
 *
 *   Everyone is permitted to copy and distribute verbatim or modified
 *   copies of this license document, and changing it is allowed as long
 *   as the name is changed.
 *
 *           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *
 *   0. You just DO WHAT THE FUCK YOU WANT TO.
 *
 *   This program is free software. It comes without any warranty, to
 *   the extent permitted by applicable law. You can redistribute it
 *   and/or modify it under the terms of the Do What The Fuck You Want
 *   To Public License, Version 2, as published by Sam Hocevar. See
 *   http://sam.zoy.org/wtfpl/COPYING for more details.
 *
 */

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

void advance(unsigned char left, unsigned char right);
void advance_balance(unsigned char left, unsigned char right);
void init_balance(unsigned char left, unsigned char right);
void init_balance(unsigned char left, unsigned char right);
void pulses_balance();

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
    analogWrite(PMD, right);
    digitalWrite(SMD, HIGH);
    analogWrite(PMG, left);
    digitalWrite(SMG, HIGH);
}


void turn_left(unsigned char left, unsigned char right)
{
    analogWrite(PMD, right);
    digitalWrite(SMD, LOW);
    analogWrite(PMG, left);
    digitalWrite(SMG, HIGH);
}

void stop() {
    analogWrite(PMD, 0);
    analogWrite(PMG, 0);
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

int machin=1;

void loop()
{
    if(machin) {
        advance_balance(SPEED, SPEED);
        delay(90);
        // On désactive les interruptions
        detachInterrupt(0);
        detachInterrupt(1);
        stop();
        delay(50);
        turn_left(SPEED, SPEED);
        delay(400);
        stop();
        machin=0;
    }
}

// vim: ft=arduino
