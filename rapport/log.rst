=======================
[LOG] Le robot avancera
=======================
------------------
Séance du 14/05/12
------------------

Etape 1 : Re-PID
================

On a développé un bout de code sur le coin d'une table pour un PID qui ne marchait pas.

D'après l'idée Thomas, on change d'orientation et on travaille sur les ticks renvoyés par les encodeurs des roues.

On a besoin du nombre de ticks/tour, on fait donc une série de mesure :

.. sourcecode:: matlab

    roue_gauche = [755 773 767 769 770 767 767];
    sum(roue_gauche)/length(roue_gauche)
    ans = 766.86
    roue_droite = [768 774 765 767 767 767 770]; 
    sum(roue_droite)/length(roue_droite)
    ans =  768.29

Note : afin de tester, on a essayé de varier les vitesses de rotation pour savoir si cela avait une influence (on a un sérieux doute sur la qualité de la bête).

On fixe le nombre de ticks/tour/roue à 767.

Avec ça, il nous manquait aussi la vitesse de rotation à vitesse max.
On repart donc pour une série de mesure, au chrono et on moyenne.
On prend 2 vitesses différentes : 10 (moyenne sur 5 tours) et 100 (moyenne sur 10 tours) :

.. sourcecode:: matlab

    t_100 = [6.7 5.97 6.28 6.12 5.46 6.10 6.07 6.09 6.04];
    (sum(t_100)/length(t_100))/10
    ans =  0.60922
    t_10 = [21.9 22.35 22 24.7 25 23.5 22.14 24 22.08]; 
    (sum(t_10)/length(t_10))/5
    ans =  4.61


Compte tenu de la "précision" relative du processus de mesure, on laisse planer l'incertitude (mais on garde en tête que pour une vraie application, il faudrait du matos).

*Les expérimentateurs vous annonce qu'ils ont perdu leurs oreilles au cours des mesure... plus de HF.* 

On part sur un système linéaire (analyse naïve).
On choisit de tracer une droite : le temps/tour en fonction de la vitesse.


