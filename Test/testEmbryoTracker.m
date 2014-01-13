%% General Tests with Artificial Data

%
% test the Tracking 
%


%% Test tracking

data0 = TrackingTimeFrameData([1 0 10 0 1 0; 2 0 20 0 1 0; 3 0 0 0 1 0],3);
data1 = TrackingTimeFrameData([1 1 20 0 1 0; 2 1 10 0 1 0; 3 1 30 0 1 0],3);

match = matchFrames(data0, data1);

clf
plotMatchedTimeFrameData(data0, data1, match)


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
scatter3(X0(1, :), X0(2, :), X0(3, :))
scatter3(X1(1, :), X1(2, :), X1(3, :), 100, [0 1 0])
scatter3(Xt(1, :), Xt(2, :), Xt(3, :), 50, [1 0 0])










%% Tests with real Data

%
% Test code using tzpical sample Data
%


%% match embryo data - single step between two frames

data0 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0001_statistics.csv')
data1 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0002_statistics.csv')

match = matchFrames(data0, data1);

clf
plotMatchedTimeFrameData(data0, data1, match)





%% extract data for single embryo for optimized tracking

data0 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0001_statistics.csv');
data1 = loadEmbryoDataFrame('./Test/Data/Timelapse_11152013_channel=0001_frame=0002_statistics.csv');

dat = data0.toCoordinates();
indx = dat(:,2) > 340;
data0.objects = data0.objects(indx)

dat = data1.toCoordinates();
indx = dat(:,2) > 340;
data1.objects = data1.objects(indx)


%% match single embryo

match = matchFrames(data0, data1);

clf
plotMatchedTimeFrameData(data0, data1, match)


%% find optimal rotation

[X0, X1] = matchedCoordinates(data0, data1, match);

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
scatter3(X0(1, :), X0(2, :), X0(3, :))
scatter3(X1(1, :), X1(2, :), X1(3, :), 100, [0 1 0])
scatter3(Xt(1, :), Xt(2, :), Xt(3, :), 50, [1 0 0])

%% second match after rotation

data0t  = data0.transformData(R, T, C);

match = matchFrames(data0t, data1);

clf
plotMatchedTimeFrameData(data0, data1, match)




%% otimized Matching 

match = optimizedMatchFrames(data0, data1);

clf
plotMatchedTimeFrameData(data0, data1, match)
