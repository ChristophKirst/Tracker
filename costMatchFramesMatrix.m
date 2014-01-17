function cost = costMatchFramesMatrix(data0, data1, creation_cost, deletion_cost, dist_cutoff)
%
%   cost = costMatchFramesMatrix(data0, data1, creation_cost, deletion_cost, dist_cutoff)
%
%   cost(i,j) is the cost associated with linking i time <--> j time+1
%   data*      the TrackingTimeFrame data for 2 times to be matched.
%  
%   creation_cost, deletion_cost the costs for creatin or deleting objects
%   dist_cutoff a cutoff for distances cost(i,j) > dist_cutoff -> Inf
%   dist_cutoff = Inf for no cutoff, = [] for automatic estimation
%

n = length(data0.objects);
m = length(data1.objects);
cost = zeros(n+1,m+1);

% distance cost

if nargin < 5 || isempty(dist_cutoff) 
   % automatic detection
   cost(1:n, 1:m) = distanceMatrix(data0, data1);
   dist_cutoff = estimateDistanceCutoff(cost(1:n, 1:m));
   cost(cost > dist_cutoff) = Inf;
elseif dist_cutoff < 0
   % no cut_off
   cost(1:n, 1:m) = distanceMatrix(data0, data1);
else
   % given distance cutoff
   cost(1:n, 1:m) = distanceMatrix(data0, data1, dist_cutoff);
end


% object creation and deletion

if nargin < 3 || isempty(creation_cost)
   creation_cost = estimateNonLinkingCost(cost(1:n, 1:m));
end
if nargin < 4 || isempty(deletion_cost)
   deletion_cost = creation_cost;
end

for i = 1:n
   cost(i,m+1) = deletion_cost;
end
for j = 1:m
   cost(n+1,j) = creation_cost;
end
cost(n+1,m+1) = Inf;

end  