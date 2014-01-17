function dist = estimateDistanceCutoff(data0, data1)
%
%   dist = estimateDistanceCutoff(data0, data1)
%
%   Estimates a cutoff based on data for the distance matrix.
%   The estimate is max of the distances to the 5th nearest neighbours
%   data* the TrackingTimeFrame data calsses for 2 times to be matched.
%   data0 can also be distance matrix
%

if nargin ==2
   dist = distanceMatrix(data0, data1);
else
   dist = data0;
end

nn = min(5, size(dist,1));

dist(dist == Inf) = 0;
dist = sort(dist);
dist = max(dist(nn,:));

fprintf('estimated distance cutoff: %g\n', dist);

end