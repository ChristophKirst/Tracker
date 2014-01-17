function [match, varargout] = optimizedMatchFrames(data0, data1, creation_cost, deletion_cost, dist_cutoff)
%
% match = optimizedMatchFrames(data0, data1)
% 
% Compute the matching between sucessive frames, 
% from there estimate optimal transformation and then match again
% match such that i -> match(i) is the link if match(i)>0 otherwise
% match(i) < 0 implies i -> nothing, 
% indices not in match(i) are newly created objects
%


% parameter
if nargin < 3
   creation_cost = [];
end
if nargin < 4
   deletion_cost = [];
end
if nargin < 5
   dist_cutoff = [];
end

% match 
match = matchFrames(data0, data1, creation_cost, deletion_cost, dist_cutoff);

% optimal coord transformation
[X0, X1] = match.toCoordinates(data0, data1);

disp 'optimal transformation:'
[R, T, C] = optimalTransformation(X0,X1)

data0t  = data0.transformData(R, T, C);

% match transformed data
[match, cost] = matchFrames(data0t, data1);

if nargout > 1
   varargout{1} = cost;
end

end
