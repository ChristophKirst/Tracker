function dist = estimateNonLinkingCost(data0, data1)
%
%   dist = estimateNonLinkingCost(data0, data1)
%
%   Estimates the cost for creation or deletion of objects.
%   The estimate is max of the distances to the first nearest neighbour.
%   data* the TrackingTimeFrame data calsses for 2 times to be matched.
%   data0 can also be a distance matrix
%

if nargin ==2
   dist = distanceMatrix(data0, data1);
else
   dist = data0;
end

dist = sort(dist);
dist = dist(1,:);
dist = max(dist(dist < Inf));

fprintf('estimated non/linking cost: %g\n', dist);

end