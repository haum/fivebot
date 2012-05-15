clear all;
close all;

% Récupération des données
raw = load("test_bot.data")
vitesses = raw(:,1);
temps = raw(:,2);

% Incertitude de 10%
delta = 0.2*temps;

% Tracé
errorbar(vitesses, temps, delta);

% Rendre la courbe bien visible (décalage sur les axes)
xlim([0 110]);
ylim([0 6]);

% grille
grid on;

% annotations
xlabel("Vitesse");
ylabel("Temps/tour");
title("Graphe du temps/tour en fonction de la vitesse commandee");
