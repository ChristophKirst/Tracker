function plotMatchedTrajectories(data, traj)
%
% plotMatchedTimeFrameData(data, traj)
%
% plot data points and trajectories 
% 


% plot the data points
nframes = length(data);
dim = data(1).dim;

if nframes > 0 && isequal(class(traj(1)), 'TrackingTrajectoryData')
   traj = traj.toData();
end


cols = hsv2rgb([linspace(0,1-1/nframes,nframes)' ones(nframes,2)]);

xyz{nframes} = [];
for t = 1:nframes
   xyz{t} = data(t).toCoordinates();
end

hold on
grid on

% data points
for t = 1: nframes   
   s = data(t).toSizes();
   s = s / max(s) .* 200;

   if dim == 2
      scatter(xyz{t}(1,:),xyz{t}(2,:), s, cols(t,:));
   else
      scatter3(xyz{t}(1,:),xyz{t}(2,:),xyz{t}(3,:), s, cols(t,:));
   end
end

% trajectories

if nargin > 1   
   ntraj = length(traj);
   cols = hsv2rgb([linspace(0,1-1/ntraj,ntraj)' ones(ntraj,2)]);
   
   for i=1:ntraj
      
      times = traj{i}(1,:);
      ids = traj{i}(2,:);
      
      xyzt = cell2mat(cellfun(@(x,i) x(:,i), xyz(times), num2cell(ids), 'UniformOutput', false));

      if dim == 2
         line(xyzt(1,:), xyzt(2,:), 'Color', cols(i,:))
      else
         line(xyzt(1,:), xyzt(2,:), xyzt(3,:), 'Color', cols(i,:))
      end
      
   end
end


% some legends 
xlabel('x'); ylabel('y'); zlabel('z');
title('matched trajectories between object locations')

hold off


end

