function [X, Y] = matchedCoordinates(data0, data1, match)
%
% [X, Y] = matchedCoordinates(data0, data1, match)
%
% returns the coordinates of the objects in data*
% of the matched pairs
%
% columns in X,Y are the mathced points
%

idx = find(match>0);
n = length(idx);
dim = data0.dim;

X = zeros(n, dim);
Y = zeros(n, dim);
for i=1:n
   X(i, :) = data0.objects(idx(i)).r;
   Y(i, :) = data1.objects(match(idx(i))).r;
end

X = X';
Y = Y';

end
   
