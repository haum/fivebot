/*
 * project : fivebot
 * author : mathieu
 * license : wtfpl
 * date : 04/01/2012
 * version : 1.0
 * category : bumpers
 *
 */
    
#ifndef bumpers_h
#define bumpers_h

// This pins are freely modifiable arccording to your
// mapping on the bot.
#define BOT_RIGHTBUMPER 10; // Bumper right --> pin8
#define BOT_MIDDLEBUMPER 9; // Bumper middle --> pin9
#define BOT_LEFTBUMPER 8; // Bumper left --> pin10

// This macro returns true if a bumpers has been hit. False else.
#define BOT_getBumperState(bumper_pin) (!digitalRead(bumper_pin))

// True if something hit one of the bumpers
#define BOT_getCollision (BOT_getBumperState(BOT_LEFTBUMPER) || BOT_getBumperState(BOT_MIDDLEBUMPER) || BOT_getBumperState(BOT_RIGHTBUMPER))

// This initialize bumpers.
// Just remind to add that in your setup().
// The only thing it does is pinMode each bumper pin as INPUT
void _init_bumpers();

#endif
