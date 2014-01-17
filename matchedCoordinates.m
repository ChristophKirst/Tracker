function [X0, X1] = matchedCoordinates(data0, data1, match)
%
% [X0, X1] = matchedCoordinates(data0, data1, match)
%
% returns the coordinates of the objects in data*
% of the matched pairs
%
% columns in X0,X1 are the matched points
%

idx = find(match>0);
n = length(idx);
dim = data0.dim;

X0 = zeros(n, dim);
X1 = zeros(n, dim);
for i=1:n
   X0(i, :) = data0.objects(idx(i)).r;
   X1(i, :) = data1.objects(match(idx(i))).r;
end

X0 = X0';
X1 = X1';

end
   
