function stats = matchedStatistics(data0, data1, match, cost)
%
% stat = matchedStatistics(data0, data1, cost, match)
%
% returns statistics on the match given the cost matrix cost
%

if isequal(class(match), 'TrackingMatchData')
   match = match.match;
end


% pairs
stats.pairs = matchedPairs(match, size(cost,2)-1, []);

% spatial distances
r0 = data0.toCoordinates();
r1 = data1.toCoordinates();

pairs = matchedPairs(match, size(cost,2)-1);
pairs = pairs(min(pairs,[], 2) > 0,:);

stats.dist.values = sum((r0(:, pairs(:,1))- r1(:, pairs(:,2))).^2, 1);
stats.dist.mean = mean(stats.dist.values);
stats.dist.std = std(stats.dist.values,1);


% linking 
if nargin > 3
   indx = sub2ind(size(cost), stats.pairs(:,1), stats.pairs(:,2));
   stats.cost.values = cost(indx);
   stats.cost.mean = mean(stats.cost.values);
   stats.cost.std = std(stats.cost.values,1);
end
