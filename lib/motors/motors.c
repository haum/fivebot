#include "motors.h"


// ==================================
//         CONTROLES MOTEURS
// ==================================



// Démarrage moteurs et initialisation du ratio. Le robot passe en mode BOT_ADVANCE
void _advance_balance(unsigned char left, unsigned char right){
    if (BOT_IL_state == BOT_ADVANCE)
        return; // si le robot est déjà lancé, pas la peine de continuer

    BOT_IL_state = BOT_ADVANCE; // le robot entre dans l'état d'esprit "ADVANCE"
    _init_balance(left, right);
    _advance(BOT_IL_speed_left, BOT_IL_speed_right);
}

// réglage des moteurs selon les vitesses de chaque moteurs envoyés en arguments
void _advance(unsigned char left, unsigned char right){
    analogWrite(PMG, left);
    digitalWrite(SMG, HIGH); // (vrai = avance; faux  = recule)
    analogWrite(PMD, right);
    digitalWrite(SMD, HIGH); // (vrai = avance; faux  = recule)
}





// ==================================
//         INITIALISATIONS
// ==================================
//  Les fonctions qui suivent initialisent les moteurs

// initialisation des moteurs
void _initmotors(){
    // initialisation des pins liées au moteurs;
    pinMode(BOT_PMG,OUTPUT);
    pinMode(BOT_PMD,OUTPUT);
    pinMode(BOT_SMG,OUTPUT);
    pinMode(BOT_SMD,OUTPUT);

    attachInterrupt(1, _pulses_left_balance, RISING); // si interruption sur pin 1, (valeur montante(RISING)), appeler la fonction _pulses_left_balance()
    attachInterrupt(0, _pulses_right_balance, RISING);// si interruption sur pin 0, (valeur montante(RISING)), appeler la fonction _pulses_right_balance()
}


// initialisation à zéro des pulsations des moteurs
void _pulses_init(){
    BOT_IL_pulses_left = 0;
    BOT_IL_pulses_right = 0;
}


// initialisation des vitesses des moteurs, ainsi que des pulses (protégés des interruptions)
void _init_balance(unsigned char left, unsigned char right){
    BOT_IL_speed_left = left;
    BOT_IL_speed_right = right;
    noInterrupts();
    _pulses_init();
    interrupts();
}





// ==================================
//         SECURITE MECANIQUE
// ==================================
//  les fonctions qui suivent, gérées par interruptions,
//      vérifient à chaque enclenchement de la roue codeuse la vitesse des moteurs,
//          et réadaptent l'autre moteur en fonction du résultat


// incrémentation de la pulsation du moteur gauche, et appel de l'équilibre des moteurs
void _pulses_left_balance(){
    BOT_IL_pulses_left++; // on augmente la pulsation du moteur gauche
    _pulses_balance();
}

// incrémentation de la pulsation du moteur droit, et appel de l'équilibre des moteurs
void _pulses_right_balance(){
    BOT_IL_pulses_right++; // on augmente la pulsation du moteur droit
    _pulses_balance();
}

// Calcul et ajout de la différence de puissance des deux moteurs (sert à équilibrer la puissance des deux moteurs)
void _pulses_balance(){
    // calcul de pulses_delta
    BOT_IL_pulses_delta = BOT_IL_speed_right + BOT_IL_pulses_right - BOT_IL_pulses_left;

    if (BOT_IL_pulses_delta <= MINSPEED)
        BOT_IL_speed_left = MINSPEED;
    else if (BOT_IL_pulses_delta >= MAXSPEED)
        BOT_IL_speed_left = MAXSPEED;
    else
        BOT_IL_speed_left = BOT_IL_pulses_delta;

    // Avancer, en indiquant aux deux moteurs leur vitesses
    _advance(BOT_IL_speed_left, BOT_IL_speed_right);
}




