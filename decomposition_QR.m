function [V] = decomposition_QR(A, epsilon)
%Fait la decomposition QR successivement jusqu'a obtenir ce que l'on veut

%On vérifie que la matrice s'approche d'une matrice triangulaire supérieure
while (max(max(tril(A, -1))) > epsilon)
    [Q, R] = qr(A);
    A = R * Q;
end

V = diag(A);

end

