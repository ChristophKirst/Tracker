function testEmbryoTracker()

%% General Tests with Artificial Data

%
% test the Tracking 
%


%% Test tracking


data0 = TrackingTimeFrameData([1 0 10 1 1 0 1 2; 2 0 20 0 1 0 1 2; 3 0 0 0 1 0 1 2; 4 0 30 1 1 0 1 2]',3);
data1 = TrackingTimeFrameData([1 1 20 0 1 0 1 2; 2 1 10 0 1 0 1 2; 3 1 30 0 1 0 1 2; 4 1 0 1 1 2 1 4]',3);


[match, cost] = matchFrames(data0, data1, [] ,[], []);







figure(1)
clf
subplot(1,2,1)
plotMatchedTimeFrameData(data0, data1, match)
title('matches')
subplot(1,2,2)
plotMatchedCostMatrix(match, cost)
title('cost matrix')


%% Test optimal transformation

% some points
X0 = [1 2 3 4 8 3 3 3 11 -5; 3 4 5 6 1 3 9 10 -3 -2; 2 1 0 5 15 9 -1 -5 -8 10];

% some transformation
theta = 1.2;
Rtest = [1, 0, 0; 0, cos(theta), -sin(theta); 0, sin(theta), cos(theta)]
Ttest = [0.4; 1; 0]
Ctest = 1.0

n = size(X0,2);
X1 = zeros(3,n);
for i = 1:n
   X1(:,i) = (Ctest * Rtest * X0(:,i)) + Ttest;
end

[R, T, C] = optimalTransformation(X0, X1)

Xt = zeros(3,n);
for i = 1:size(X0,2)
   Xt(:,i) = (C * R * X0(:,i)) + T;
end

figure(1)
clf
hold on
h0 = scatter3(X0(1, :), X0(2, :), X0(3, :));
h1 = scatter3(X1(1, :), X1(2, :), X1(3, :), 100, [0 1 0]);
ht = scatter3(Xt(1, :), Xt(2, :), Xt(3, :), 50, [1 0 0]);
xlabel('x'); ylabel('y'); zlabel('z');
legend([h0, h1, ht], 'r0', 'r1', 'rotated r0');
title('Test optimalTransformation.m');
hold off








%% Tests with real Data

%
% Test code using typical sample Data
%


%% match embryo data - single step between two frames

data0 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0001_statistics.csv')
data1 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0002_statistics.csv')


[match, cost] = matchFrames(data0, data1, [] ,[], []);

figure(1)
clf
subplot(1,2,1)
plotMatchedTimeFrameData(data0, data1, match)
title('matches')
subplot(1,2,2)
plotMatchedCostMatrix(match, cost)
title('cost matrix')




%% extract data for single embryo for optimized tracking

data0 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0001_statistics.csv');
data1 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0002_statistics.csv');

dat = data0.toCoordinates();
indx = dat(2,:) > 340;
data0.objects = data0.objects(indx)

dat = data1.toCoordinates();
indx = dat(2,:) > 340;
data1.objects = data1.objects(indx)


%% match single embryo

[match, cost] = matchFrames(data0, data1);

%stats = matchedStatistics(data0, data1, match, cost);

figure(1)
clf
subplot(1,2,1)
plotMatchedTimeFrameData(data0, data1, match)
title('matches')
subplot(1,2,2)
plotMatchedCostMatrix(match, cost)
title('cost matrix')



%% find optimal rotation

[X0, X1] = match.toCoordinates(data0, data1);

disp 'optimal transformation:'
[R, T, C] = optimalTransformation(X0,X1)

n = size(X0,2);
Xt = zeros(3,n);
for i = 1:n
   Xt(:,i) = (C * R * X0(:,i)) + T;
end


figure(1)
clf
hold on
grid on
h0 = scatter3(X0(1, :), X0(2, :), X0(3, :));
h1 = scatter3(X1(1, :), X1(2, :), X1(3, :), 100, [0 1 0]);
ht = scatter3(Xt(1, :), Xt(2, :), Xt(3, :), 50, [1 0 0]);
xlabel('x'); ylabel('y'); zlabel('z');
legend([h0, h1, ht], 'r0', 'r1', 'rotated r0');
title('Test optimalTransformation.m');
hold off

%% second match after rotation

data0t  = data0.transformData(R, T, C);

[matcht, costt] = matchFrames(data0t, data1);


figure(1)
clf
subplot(1,2,1)
plotMatchedTimeFrameData(data0, data1, matcht)
title('matches')
subplot(1,2,2)
plotMatchedCostMatrix(matcht, cost)
title('cost matrix')

%% compare results

stats = match.statistics(data0t, data1, cost);
statst = matcht.statistics(data0t, data1, costt);


figure(2)
clf
subplot(2,2,1)
hist(stats.dist.values);
title(sprintf('initial match spatial distances:\nn: %d mean: %g std: %g', length(stats.dist.values), stats.dist.mean, stats.dist.std));

subplot(2,2,2)
hist(statst.dist.values); 
title(sprintf('rotated match spatial distances:\nn: %d mean: %g std: %g', length(statst.dist.values), statst.dist.mean, statst.dist.std));

subplot(2,2,3)
hist(stats.cost.values);
title(sprintf('initial match costs:\nn: %d mean: %g std: %g', length(stats.cost.values), stats.cost.mean, stats.cost.std));

subplot(2,2,4)
hist(statst.dist.values); 
title(sprintf('rotated match costs:\nn: %d mean: %g std: %g', length(statst.dist.values), statst.cost.mean, statst.cost.std));





%% otimized Matching (= match, rotation, match)

[match, cost] = optimizedMatchFrames(data0, data1);

figure(1)
clf
subplot(1,2,1)
plotMatchedTimeFrameData(data0, data1, match)
title('matches')
subplot(1,2,2)
plotMatchedCostMatrix(match, cost)
title('cost matrix')




%% track full list of time frames of single embryo

data = loadEmbryoData('./Test/Data');

for t = 1:length(data)
   
   dat = data(t).toCoordinates();
   indx = dat(2,:) > 340;
   data(t).objects = data(t).objects(indx);

end

[match, cost] = matchAllFrames(data, [] , [], [], 1);


%% plot the result 

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


%% determine trajectories

traj = matchedTrajectories(match);

figure(1)
clf
plotMatchedTrajectories(data, traj)

%% some statistics

stats = trajectoryStatistics(data, traj);

figure(1)
subplot(1,2,1)
hist(stats.length.values)
title(sprintf('trajectory time lengths:\nmean:%g std:%g', stats.length.mean, stats.length.std))
xlabel('time');

subplot(1,2,2)
hist(stats.dist.values)
title(sprintf('trajectory spatial lengths:\nmean:%g std:%g', stats.dist.mean, stats.dist.std))
xlabel('distance')


%% saving data

saveEmbryoData('./Test/Out', data, traj)



%% run full Tracker 


runTracker('./Test/Data', './Test/Out', 1)


%% run full Tacker with a filter 

path(path, './Test')

runTracker('./Test/Data', './Test/Out', 1, @testFilter)




end