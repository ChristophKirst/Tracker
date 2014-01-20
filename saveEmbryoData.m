function saveEmbryoData(dirname, data, traj)
%
% saveEmbryoData(dirname, data, traj)
%
% Adds trajecktory data to the input files that generated data
% and saves them under same name in the directory dirname.
%


%% label for id

id_label = 'Cell ID';


%% save data

if ~exist(dirname, 'dir')
   mkdir(dirname)
end

nframes = length(data);

for t = 1:nframes
         
   % get full data from source file
   fd = importdata(data(t).filename, ',', 1);
   fd.textdata{1} = [fd.textdata{1} 'Trajectory ID, Prev. Cell ID, Next Cell ID, '];


   % create tracking data entries
   [tids, oids, preids, postids] = traj.timeSliceNN(t);
   % tids are the trajectory indices in traj
   % oids(i) is object id at time t in the trajectory tids(i)
   % preids(i) is object id at time t-1 in the trajectory tids(i) (-1 if trajectory starts)
   % postids(i) is object in the subsequent frame (-1 if trajectory stops)
   
   
   % above ids based on ordering in data, restore real ids data.toIdsI()  
   if t > 1 
      ids = find(preids > 0);
      dids = data(t-1).toIds();
      preids(ids) = dids(preids(ids));
   end

   if t < nframes
      ids = find(postids > 0);
      dids = data(t+1).toIds();
      postids(ids) = dids(postids(ids));
   end

   % find index for id in data file
   labels = strsplit(fd.textdata{1}, ', ');
   [~, id_pos] = ismember(id_label,labels);
   if id_pos == 0
      error('saveEmbryoData: Error: cannot find id label in file:\n%s\n', data{t}.filename)
   end
   
   fids = fd.data(:,id_pos); % all ids in file
   dids = data(t).toIds();   % possible subset of data ids used in tracking

   % find data ids
   [~, ids] = ismember(dids, fids);
   nids = length(fids);
   if length(ids) ~= length(oids)
      error('saveEmbryoData.m: Error: index mismatch !\n');
   end
   % ids(1) is index in file of first object in data{t}
   


   
   
   % assing trajectories to the indices
   [~, torder] = sort(oids);
   
   ftids = - ones(1,nids);
   ftids(ids) = tids(torder);
   
   fpreids = - ones(1,nids);
   fpreids(ids) = preids(torder);
     
   fpostids = - ones(1,nids);
   fpostids(ids) = postids(torder);
   
   fd.data = [fd.data, ftids', fpreids', fpostids'];

   [~, name, ext] = fileparts(data(t).filename);
   filename = [dirname filesep name ext];

   
   % write data to file
   writeCSV(filename, fd.data, fd.textdata{1});

end

fprintf('saved data to %d files in %s\n', length(data), dirname)

end