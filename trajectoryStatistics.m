function stats = trajectoryStatistics(data, traj)
%
% stat = trajectoryStatistics(data, traj)
%
% returns some useful statistics on the trajectories traj
%

if isequal(class(traj), 'TrackingTrajectoryData')
   traj = traj.toData();
end


% discrete trajectory lengths
stats.n = length(traj);
stats.length.values = cellfun(@length, traj);
stats.length.mean = mean(stats.length.values);
stats.length.std = std(stats.length.values,1);


% spatial trajectory lengths
nframes = length(data);
xyz{nframes} = [];
for t = 1: nframes
   xyz{t} = data(t).toCoordinates();
end

ntraj = length(traj);
stats.dist.values(ntraj) = 0;

for i=1:ntraj 
   times = traj{i}(1,:);
   ids = traj{i}(2,:);
   
   xyzt = cell2mat(cellfun(@(x,i) x(:,i), xyz(times), num2cell(ids), 'UniformOutput', false));

   stats.dist.values(i) = sum(sqrt(sum((xyzt(:, 2:end) - xyzt(:, 1:end-1)).^ 2)));
end   

stats.dist.mean = mean(stats.dist.values);
stats.dist.std = std(stats.dist.values,1);


