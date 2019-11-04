function [lambda, Y] = puissance_iteree(A, epsilon)

n = size(A, 2);
Y = rand([n, 1]);
lambda = norm(Y);

while(1)
    X = A * Y;
    Y = X / norm(X);
    
    lambda_old = lambda;
    lambda = norm(X);

    if(abs(lambda_old - lambda) < epsilon)
        break;
    end
end

%On récupère le signe de la valeur propre

r = (A * Y) ./ (lambda * Y);
[~, i] = max(abs(r));

if(r(i) < 0)
    lambda = -lambda;

end