classdef TrackingTrajectoryData
%
% TrackingTrajectoryData(times, ids) class storing trajectories
%
   properties     
      times = {};    % times of the trajectories {[t1 t2 ...], [t1, t2, ...]}
      ids = {};      % objects ids in the trajectories     
   end 
   
   properties (Dependent)
      length         % number of trajectories
   end
   
   methods
      function obj = TrackingTrajectoryData(times, ids)
         if nargin > 1
            obj.times = times;
            obj.ids = ids;
         elseif nargin > 0
            obj.times = cellfun(@(x)x(1,:), times, 'UniformOutput', false);
            obj.ids = cellfun(@(x)x(2,:), times, 'UniformOutput', false);
         end
      end 
      
      function l = get.length(obj)
         l = length(obj.times);
      end
      
      
      function [tids, oids] = timeSlice(obj, t)
      %
      % [tids, oids] = timeSlice(obj, t)
      %
      % finds all trajectories tids and objed ids passing through time t
      %
      
         tpos = cellfun(@(x) find(x==t,1), obj.times, 'UniformOutput', false);   
         tids = find(cellfun(@length, tpos));
         oids  = cell2mat( cellfun(@(x, i) x(i), obj.ids, tpos,'UniformOutput', false) );
         
        
         %tids = cell2mat(tids);
         %ts = TrackingTrajectoryData(obj.times(tids), obj.ids(tids));
         
      end
      
      function [tids, oids, preids, postids] = timeSliceNN(obj, t)
      %
      % [tids, odis, preids, postids] = timeSliceNN(obj, t)
      %
      % finds all trajectories tids and objects ids passing through time t
      % together with neares neibour objects in previous and following frame
      %
      
         tpos = cellfun(@(x) find(x==t,1), obj.times, 'UniformOutput', false);   
         tids = find(cellfun(@length, tpos));
         oids  = cell2mat( cellfun(@(x, i) x(i), obj.ids, tpos,'UniformOutput', false) );
         
         tpos = cell2mat(tpos);
         
         preids = - ones(1, length(tids));
         indx = find(tpos > 1);
         preids(indx) = cell2mat( cellfun(@(x, i) x(i-1), obj.ids(tids(indx)), num2cell(tpos(indx)),'UniformOutput', false) );
         
         postids = - ones(1, length(tids));
         indx = find(tpos < cellfun(@length, obj.times(tids)) );
         postids(indx) = cell2mat( cellfun(@(x, i) x(i+1), obj.ids(tids(indx)), num2cell(tpos(indx)),'UniformOutput', false) );
         
      end
      
      
      function data = toData(obj)
      %
      % data = toData(obj)
      %
      % returns trajectories as list of arrays of the form 
      % [time1, time2, ...;
      %  obj1,  obj2,  ...];
      %

         data = cellfun(@(t,i) vertcat(t,i) , obj.times, obj.ids, 'UniformOutput', false);
         
      end

      
      function start = starts(obj)
      %
      % data = start(obj)
      %
      % returns trajectories as list of arrays of the form 
      % [time1, time2, ...;
      %  obj1,  obj2,  ...];
      %         
      end
         
      
      
      function stats = statistics(obj, data)
      %
      % stats = statistics(obj, data)
      %
      % returns some statistics of the trajectories
      %
      
         stats = trajectoryStatistics(data, obj.toData());
         
      end
 

   end % methods
end % classdef
      
      
      
      
      