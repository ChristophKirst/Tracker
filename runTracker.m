function runTracker(indir, outdir, print, filter)
%
% runTracker(indir, outdir, print, filter)
%
% loads data in directory indir,
% runs tracking algrothim on all subsequent time frame pairs, 
% writes analysis data to directory outdir
% print is level of verbosity for diagnostics
% filter is a function pointer to filter each TrackingTimeFrameData object
% according to some user defined criteria.
%

%% parameter
param.optimize = true;       % optimize match using an optimal rotation
param.dist_cutoff = [];      % distance_cutoff above possible matches are ignored
param.creation_cost = [];    % cost for not matching a point at time t+1 to an one at t (starts a new trajectory)
param.deletion_cost = [];    % cost for not matching a point at time t to a point at t+1 (ends a trajectory)
param.min_time = [];         % start matching after this time
param.max_time = [];         % stop matching above this time
param.max_steps = [];        % maximal number of steps matching steps (e.g. use for testing)

if nargin < 2
   outdir = indir;
end
if nargin < 3
   print = [];
end
if isempty(print) 
   print = 0;  % default print level
end

if nargin < 4
   filter = [];
end


%% load data
data = loadEmbryoData(indir);


if ~isempty(param.min_time )
   times = [data.time];
   data = data(find(times > param.min_time, 1,'first'): end);
end

if ~isempty(param.max_time )
   times = [data.time];
   data = data(1: find(times<param.max_time, 1,'last'));
end

if ~isempty(param.max_time )
   data = data(1: param.max_steps);
end


if ~isempty(filter)
   for i=1:length(data)
      data(i) = filter(data(i));
   end
end

%% match frames
if print > 2 % verbosity at least 3
   [match, cost] = matchAllFrames(data, param.dist_cutof, param.creation_cost, param.deletion_cost, param.optimize);

   for t =1:length(match)
      figure(t)
      clf
      subplot(1,2,1)
      plotMatchedTimeFrameData(data(t), data(t+1), match(t))
      title('matches')
      subplot(1,2,2)
      plotMatchedCostMatrix(match(t), cost{t})
      title('cost matrix')
   end
else
   match = matchAllFrames(data, param.dist_cutoff, param.creation_cost, param.deletion_cost, param.optimize);
end   


%% find trajectories

traj = matchedTrajectories(match);

if print > 0
   figure(1)
   clf
   plotMatchedTrajectories(data, traj)
end

if print > 2
   stats = trajectoryStatistics(data, traj);

   figure(2)
   subplot(1,2,1)
   hist(stats.length.values)
   title(sprintf('trajectory time lengths:\nmean:%g std:%g', stats.length.mean, stats.length.std))
   xlabel('time');

   subplot(1,2,2)
   hist(stats.dist.values)
   title(sprintf('trajectory spatial lengths:\nmean:%g std:%g', stats.dist.mean, stats.dist.std))
   xlabel('distance')
end

%% save data

saveEmbryoData(outdir, data, traj);

