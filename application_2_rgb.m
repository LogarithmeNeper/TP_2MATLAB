%{
    BONUS

On essaye de transmettre une image par un canal dans lequel la transmission d’informations est très
lente. Dans une telle situation, l’idéal serait de pouvoir voir apparaître l’image progressivement,
c’est-à-dire grossièrement au début et avec de plus en plus de détails au fur et à mesure que les
informations arrivent. Cela permettrait d’arrêter la transmission très rapidement, si l’on juge l’image
inintéressante ou dès que la qualité est jugée suffisante. Tout cela doit bien évidemment se faire en
transmettant un volume de données le plus petit possible par rapport à ce que contient l’image
elle-même.  
    • Réaliser   cela   à   partir   de   la   décomposition   de   matrices   en   valeurs   singulières.   Cette
    décomposition est décrite dans l’annexe mathématique. 
    • Comment peut-on évaluer la qualité de l’image courante par rapport à l’image d’origine
    (qualité = 100% si les deux images sont identiques ...). 
    • Quels sont, à votre avis, les avantages et les inconvénients de ce codage de l’image ? 
%}

clc;
clear;
close all;

%Temps en secondes entre chaque image
delai_affichage_image = 2;

I_INIT = imread('img_bonus.jpg');

R = double(I_INIT(:,:,1));
G = double(I_INIT(:,:,2));
B = double(I_INIT(:,:,3));

%Affiche l'image
h = imshow(I_INIT);
cd = get(h,'CData');

for N=1:100
%Décomposition en valeurs singulières 
[U_R, S_R, V_R] = svd(R);
[U_G, S_G, V_G] = svd(G);
[U_B, S_B, V_B] = svd(B);

%On garde N valeurs singulières dans la matrice diagonale
S_R(N:end, N:end) = 0;
S_G(N:end, N:end) = 0;
S_B(N:end, N:end) = 0;

%On reconstruit l'image en concaténant les différents channels R, G, B
I = cat(3, uint8(U_R * S_R * V_R'), uint8(U_G * S_G * V_G'), uint8(U_B * S_B * V_B'));

%Met à jour l'image
set(h,'CData',I);
title(sprintf("Image compressée en gardant %d valeurs singulières.", N));
pause(delai_affichage_image);
end
