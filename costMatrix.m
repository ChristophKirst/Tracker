function cost = costMatrix(data0, data1, creation_cost, deletion_cost, dist_cutoff)
%
%   cost = costMatrix(data0, data1, creation_cost, deletion_cost, dist_cutoff)
%
%   cost(i,j) is the cost associated with linking i time <--> j time+1
%   data*      the TrackingTimeFrame data for 2 times to be matched.
%  
%   creation_cost, deletion_cost the costs for creatin or deleting objects
%   dist_cutoff a cutoff for distances cost(i,j) > dist_cutoff -> Inf
%   dist_cutoff = Inf for no cutoff, = [] for automatic estimation
%
 
o1 = data0.objects;
o2 = data1.objects;

n = length(o1);
m = length(o2);

cost = ones(n+1,m+1);
for i = 1:n
   for j = 1:m
      cost(i,j) = trackingDistance(o1(i), o2(j));
   end
end

% distance cutoff
if nargin < 5 || isempty(dist_cutoff) 
   dist_cutoff = estimateDistanceCutoff(cost(1:n, 1:m));
end
if dist_cutoff < 0
   dist_cutoff = Inf;
end

cost(cost > dist_cutoff) = Inf;

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
cost(n+1,m+1) = 0;

end  