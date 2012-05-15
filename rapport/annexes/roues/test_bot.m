clear all;
close all;

raw = load("test_bot.data")
vitesses = raw(:,1);
delta = 0.1*ones(1,length(vitesses));
temps = raw(:,2);

xlabel("Vitesse");
ylabel("Temps/tour");

title("Graphe du temps/tour en fonction de la vitesse commandée");

errorbar(vitesses, temps, delta);

