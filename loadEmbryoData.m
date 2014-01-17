function data = loadEmbryoData(dirname)
%
% data = loadEmbryoData(dir)
%
% loads the segmentated embryo data time frames in a directory
% returns list of (cellid, x, y, z, size, intensity, frame, time) for each time frame
%
% note: segmentation fails completely in single time frames where there is
% only a single cell -> these time frames are removed !


%% find data file names
fn = dir(fullfile(dirname, '*.csv'));

%% extract data and time
j = 1;

if ~isempty(fn)
    data(1) = TrackingTimeFrameData();
end

for i=1:length(fn)
    
    dat = loadEmbryoDataFrame(fullfile(dirname,fn(i).name));

    % ignore data if segmentation failed
    if length(dat.objects) > 1
        data(j) = dat; %#ok<AGROW>
        j = j+1;
    end
        
end

fprintf('loaded %d frames from %d files in %s\n', length(data), length(fn), dirname)


end

