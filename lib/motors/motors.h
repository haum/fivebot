#ifndef BOT_MOTORS_H_INCLUDED
#define BOT_MOTORS_H_INCLUDED


// ==================================
//         DEFINES
// ==================================

#define BOT_MINSPEED 0      // vitesse minimum
#define BOT_MAXSPEED 100    // vitesse maximum
#define BOT_SPEED 50        // vitesse de croisière

#define BOT_PMG 5           // Puissance moteur gauche --> pin5
#define BOT_PMD 6           // Puissance moteur droit --> pin6
#define BOT_SMG 4           // pulsation moteur gauche --> pin4
#define BOT_SMD 7           // pulsation moteur droit --> pin7   (vrai = avance; faux  = recule)


// ==================================
//         DECLARATIONS GLOBALES
// ==================================
enum BOT_ETAT_ESPRIT {BOT_UNKNOWN, BOT_ADVANCE, BOT_BACK};



// ==================================
//         PROTOTYPES
// ==================================

void _initmotors(); // initialisation des moteurs




// ==================================
//         VOLATILES VARIABLES
// ==================================
volatile unsigned char BOT_IL_speed_left;   // vitesse du moteur gauche
volatile unsigned char BOT_IL_speed_right;  // vitesse du moteur droit
volatile unsigned long BOT_IL_pulses_left;  // pulsation du moteur gauche (vrai = avance; faux  = recule)
volatile unsigned long BOT_IL_pulses_right; // pulsation du moteur droit
volatile int BOT_IL_pulses_delta;           // ratio des moteurs




// ==================================
//         GLOBAL VARIABLES
// ==================================
int BOT_IL_state = BOT_UNKNOWN;             // robot initialisé dans l'état d'esprit non défini




#endif // MOTORS_H_INCLUDED
