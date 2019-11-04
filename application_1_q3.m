%Trouver la valeur propre la plus proche de 6.82 en module

clc;
clear;
close all;

%Délai en secondes entre chaque graphique
delai_entre_graphiques = 10;
%Vrai si on doit afficher les graphiques
afficher_graphiques = 1;

%==================================================================

epsilon = 10e-10;
A = generer_matrice_laplacien();
c = 6.82;
Z1 = inv( A - c * eye(size(A)) );
Z2 = inv( A - (-c) * eye(size(A)) );

[lambda_z1, u1, ~] = deflation_wielandt(Z1, epsilon);
[lambda_z2, u2, ~] = deflation_wielandt(Z2, epsilon);

v1 = c + 1 / lambda_z1;
v2 = (-c) + 1 / lambda_z2;

if(abs(abs(v1) - c) < abs(abs(v2) - c))
    lambda = v1;
    u = u1;
else
    lambda = v2;
    u = u2;
end

fprintf("Valeur propre de module le plus proche de 6.82:\n")
fprintf("\t%f\n", lambda)

if(afficher_graphiques)
    close all;
    tracer_graphique(u, lambda, "(Valeur propre au module le plus proche de 6.82)");
    pause(delai_entre_graphiques);
end

% ===================================================== %
%                                                       %
%                                                       %
%           ENSEMBLE DES METHODES UTILITAIRES           %
%                                                       %
%                                                       %
% ===================================================== %

% ==============================================================
%   Dessine le vecteur propre u sous forme de graphique coloré
% ==============================================================
function tracer_graphique(u, lambda, s)
figure(1);
surf(reshape(u, [15 40]), 'FaceColor', 'interp');
title(sprintf("Graphique de l'onde pour \\lambda=%f u.a.\n%s", lambda, s));
xlabel('X');
ylabel('Y');
xlim([1 40]);
ylim([1 15]);
zlabel('Altitude (z)');
view(3);
set(gca, 'Ydir', 'reverse');
colormap(jet);
colorbar();
end

% =================================================
%   Génère la matrice du Laplacien de l'onde
% =================================================
function [A] = generer_matrice_laplacien()

A = zeros(600, 600);

%On parcourt les lignes de la matrice
for i=1:600
    %Coordonnées sur le plateau (15x40)
    [i1, j1] = indiceVersCoords(i);
    
    %Cas des bordures où il n'y a aucune variation d'altitude
    if((i1 == 1 && j1 == 1) || (i1 == 1 && j1 >= 15) || j1 == 40 || i1 == 15 || (i1 == 11 && j1 >= 10 && j1 <= 17))
        A(i, i) = 1;
        %Cas des cases standards
    else
        nbVoisins = 0;
        
        %On parcourt les colonnes de la matrice pour appliquer un coeff
        %pour prendre en compte les voisins
        for j=1:600
            [i2, j2] = indiceVersCoords(j);
            v = voisins(i1, j1, i2, j2);
            nbVoisins = nbVoisins + v;
            A(i, j) = v;
        end
        
        A(i, i) = -nbVoisins;
    end
    
end
end

% =========================================================================
%Renvoie les coordonnées de l'intersection correspondant a l'indice donnee
%en parametre.
%Les intersections sont listées colonnes par colonnes, ainsi
%l'intersection 1 correspond aux coords (j=1, i=1), l'intersection 2
%correspond aux coords (j=1, i=2).
% =========================================================================
function [i, j] = indiceVersCoords(indice)
i = mod(indice - 1, 15) + 1;
j = floor((indice - 1) / 15) + 1;
end


% ===========================================================================
%Retourne vrai si les deux intersections (i1, j1) et (i2, j2) sont voisines
% ===========================================================================
function [b] = voisins(i1, j1, i2, j2)

b = 0;

delta_i = abs(i1 - i2);
delta_j = abs(j1 - j2);

%---------------------------------------
%On gère le cas général, les intersections adjacentes
%---------------------------------------

%On vérifie que les intersections sont côte à côte, l'expression équivalente à
%un xor évite de prendre les diagonales en compte
if((delta_i == 1 && delta_j == 0) || (delta_i == 0 && delta_j == 1))
    b = 1;
end

end