%Renvoie la valeur propre de plus grand module et la matrice ayant subi la
%déflation
function [lambda, u, A] = deflation_wielandt(A, epsilon)

[lambda, u] = puissance_iteree(A, epsilon);
[~, v] = puissance_iteree(A', epsilon);
A = A - lambda * (u * v') / (v' * u);

end

