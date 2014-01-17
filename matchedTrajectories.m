function [traj, varargout] = matchedTrajectories(matches, nfinal)
%
% [traj, times] = matchedTrajectories(matches, nfinal)
%
% identifies the trajectories as chains from the pairwise matches
% matches is assumed to be a cell of match vectores or a vector of TrackingMatchData
% returns a TrackingTrajectoryData class
%

if isvector(matches) && isequal(class(matches(1)), 'TrackingMatchData')
   nfinal  = matches(end).n1;
   matches = {matches.match};
end

nframes = length(matches) + 1;
   
if (nargin < 2 && isempty(nfinal))
   nfinal = length(matches(end));
end

ncells = cellfun(@length, matches);
ncells(end+1) = nfinal;


% construct trajectories

ntraj = ncells(1);
active = 1:ntraj;
traj = num2cell(active);
times = num2cell(ones(1,ntraj));

for t = 1:nframes-1
   
   pre = cellfun(@(l) l(end), traj(active));
   post = matches{t}(pre)';
  
   % trajectory ends
   active = active(post > 0);
   post = post(post>0);

   % trajectory continues
   traj(active) = cellfun(@(l, a) [l a], traj(active), num2cell(post),'UniformOutput', false);
   times(active) = cellfun(@(l, a) [l a], times(active), num2cell((t+1) * ones(1, length(active))),'UniformOutput', false);
   
   % trajectory starts
   new = setdiff(1:ncells(t+1), post);
   traj = [traj num2cell(new)]; %#ok<AGROW>
   times = [times num2cell((t+1) * ones(1, length(new)))]; %#ok<AGROW>
   
   active = [active, ntraj+1:length(traj)]; %#ok<AGROW>   
   ntraj = length(traj);
end
   
if nargout > 1
   varargout{1} = times;
else
   traj = TrackingTrajectoryData(times, traj);
end


end

