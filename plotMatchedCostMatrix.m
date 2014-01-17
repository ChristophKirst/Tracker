function plotMatchedCostMatrix(match, cost)
%
% plotMatchedCostMatrix(cost, match)
%
% plots the cost matrix and indicates the matches 
%

if isequal(class(match), 'TrackingMatchData')
   match = match.match;
end


[n,m] = size(cost);
pairs = matchedPairs(match, m-1, []);

hold on
imagesc(cost);
scatter(pairs(:,2),pairs(:,1), 50, [1 1 1]);
axis([0 m 0 n] + 0.5);

xlabel('post'); ylabel('pre');

hold off
