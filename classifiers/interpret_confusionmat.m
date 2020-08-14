function [OA, AA, Kappa, J] = interpret_confusionmat(label, pred)

% ------------------------------------
% July 26, 2020
% version: 3.0
% Interpret the confusion matrix
%
% Parameters:
%    label (2D matrix)  -- ground labels
%    pred  (1D array)   -- predicted labels
% Returns:
%    classification accuracy indicators: OA, AA, Kappa, J

C = confusionmat(label(:), pred);


J = diag(C) ./ sum(C, 2);
AA = mean(J);
N = sum(C(:));
OA = sum(diag(C))/N;
Kappa = (N*sum(diag(C))-sum(C,1)*sum(C,2))/(N^2-sum(C,1)*sum(C,2));
end