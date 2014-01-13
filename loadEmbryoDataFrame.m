function data = loadEmbryoDataFrame(fn)
%
% data = loadEmbryoDataFrame(fn)
%
% loads the segmentated embryo data from a single time frame
% returns list of (cellid, x, y, z, size, intensity)

%% import data
% data assumed to be in format:
% Inlier/Outlier EmbryoId CellId Size TE/ICM X Y Z CH1-Avg CH1-Sum CH2-Avg CH2-Sum
data = importdata(fn, ',', 1);
data = data.data;

%% relevant data: (cellid, x, y, z, size, intensity)
data = data(:,[3 6 7 8 4 9]);

%% time
str = strsplit(fn, {'=', '_'});
time = str2double(str{length(str)-1});    

%% convert to data class
data = TrackingTimeFrameData(data, 3, time);

end
