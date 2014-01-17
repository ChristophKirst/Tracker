function [match, varargout] = matchAllFrames(data, creation_cost, deletion_cost, dist_cutoff, optimize)
%
% [match, cost] = matchAllFrames(data, creation_cost, deletion_cost, dist_cutoff)
% 
% Compute the optimum matching between subsequent frames in data
% match such that i -> match(i) is the link if match(i)>0 
% otherwise match(i) < 0 implies i -> nothing, 
% indices not in match(i) are newly created objects
%

%% parameter
if nargin < 2
   creation_cost = [];
end
if nargin < 3
   deletion_cost = [];
end
if nargin < 4
   dist_cutoff = [];
end
if nargin < 5
   optimize = [];
end

% for negative parameter we calculate the estimates once
% use [] for automatic detection in each round with little extra computation
if ((~isempty(dist_cutoff) && dist_cutoff < 0) ...
   ||(~isempty(creation_cost) && creation_cost < 0) ...
   ||(~isempty(deletion_cost) &&  deletion_cost < 0)) && lenght(data) > 1

   dist = distanceMatrix(data(1), data(2));

   if (dist_cutoff < 0)
      dist_cutoff = estimateDistanceCutoff(dist);
   end
   if (creation_cost < 0)
      creation_cost = estimateNonLinkingCost(dist);
   end
   if (deletion_cost < 0)
      creation_cost = estimateNonLinkingCost(dist);
   end
end


%% find best linking between successive frames

nframes = length(data);
match(nframes-1) = TrackingMatchData();
if (nargout > 1)
   cost{nframes-1} = [];
end

for t = 1:nframes-1
  
   fprintf('matching timeframe: %d / %d\n', t, nframes-1);
   
   if isempty(optimize) || optimize <= 0
      [match(t), co] = matchFrames(data(t), data(t+1),  creation_cost, deletion_cost, dist_cutoff);
   else
      [match(t), co] = optimizedMatchFrames(data(t), data(t+1),  creation_cost, deletion_cost, dist_cutoff);
   end

   if (nargout > 1)
      cost{t} = co;
   end
end

if (nargout > 1)
   varargout{1} = cost;
end

end
  