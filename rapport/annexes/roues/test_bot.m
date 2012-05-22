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


% === Proposition d'un modèle ===

hold on;

% partie basse
a = polyfit(vitesses(4:11,1),temps(4:11,1),1)
plot(vitesses(4:11,1), a(2)+a(1)*vitesses(4:11,1),'r');

% partie haute
b = polyfit(vitesses(1:3,1), temps(1:3,1), 1)
plot(vitesses(1:3,1), b(2)+b(1)*vitesses(1:3,1),'r');

% partie centrale
c = polyfit(vitesses(3:4,1), temps(3:4,1), 1);
plot(vitesses(2:5,1), c(2)+c(1)*vitesses(2:5,1),'r');


% Rendre la courbe bien visible (décalage sur les axes)
xlim([0 110]);
ylim([0 6]);

% grille
grid on;

% annotations
xlabel("Vitesse");
ylabel("Temps/tour");
title("Graphe du temps/tour en fonction de la vitesse commandee");
legend("Donnees mesurees", "Modele propose");
