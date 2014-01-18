function data = loadEmbryoDataFrame(fn)
%
% data = loadEmbryoDataFrame(fn)
%
% loads the segmentated embryo data from a single time frame
% returns list of (cellid, x, y, z, size, intensity)
% file fn should be a comma separated table in format:
% In/Out, EmbryoId, CellId, Size, TE/ICM, X, Y, Z, CH1-Avg, CH1-Sum, CH2-Avg, CH2-Sum
%

% send messages / info to user on first read 
persistent size_flag time_flag;

%% labels for the relevant data 
% order should be: {Cell ID, X, Y, Z, (Size), (Intensity), ...} 
% size and intensity are optional, further entries can be used for
% identifaction of cells (i.e. Embryo Id)

data_label = { 'Cell ID', 'X', 'Y', 'Z', 'Size', 'CH1-Avg'};


%% time 
[idx1, idx2] = regexpi(fn, 'frame=[0-9]+' ); 
time = str2double( fn(6+idx1:idx2) );

if isempty(time_flag)
    fprintf('Inferred time or frame number = %d\nfrom file= %s\n', time, fn);
    fprintf('If not correct see loadEmbryoDataFrame.m\n');
    time_flag = time;
end

%% import data, check and find labels
data = importdata(fn, ',', 1);

s = size(data.data,2);
if s < 8
    error('loadEmbryoDataFrame.m: number of data columns is too small (<8): %d\nin file: %s', s, fn);  
elseif isempty(size_flag) && s < 12 
   fpirntf('Warning: loadEmbryoDataFrame.m: number of data columns is not 12 but %d\nin file: %s', s, fn);
   size_flag = s;
end

labels = strsplit(data.textdata{1}, ', ');
[~, data_inds] = ismember(data_label,labels);

if ismember(0, data_inds)
   id = find(data_inds==0, 1);
   error('Error: loadEmbryoDataFrame.m: cannot find all labels %s\nin file: %s', char(data_label(id)), fn);
end

if length(data_inds) < 4
    error('Error: loadEmbryoDataFrame.m: number of data labels to small\nneed at least {id, x, y, z}');
end
  

%% extract relevant data: (cellid, x, y, z, size, intensity)

data = data.data;
data = data(:,data_inds);

% code assumes that columns are data points
data = data';


%% convert to data class
data = TrackingTimeFrameData(data, 3, time, fn);

end
