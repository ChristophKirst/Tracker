classdef TrackingMatchData
%
% TrackingMatchData(match, k) class storing data from matching two frames
%
   properties      
      n0 = 0;     % number of objects in time frame 0
      n1 = 0;     % number of objects in time frame 1 
      match = []; % links of the form i -> match(i) =-1 if object is deleted
   end

   methods
      function obj = TrackingMatchData(match, n1)
         if nargin > 0
            obj.n0 = max(match); % = length(match)
            obj.match = match;
         end
         if nargin > 1
            obj.n1 = n1;
         else
            obj.n1 = obj.n0;
         end
      end      
       
      function data = toData(obj, create_id, delete_id)
      %
      % data = toData(obj, create_id, delete_id)
      %
      % returns array of paried indices corresponding to the matches
      % [i match(i)] taking into account creation of new objects as [-1 j]
      %
         
         if nargin < 2
            create_id = [];
         end
         if nargin < 3
            delete_id = [];
         end

         data = matchedPairs(obj.match, obj.n1, create_id, delete_id);
      
      end


      function [X0, X1] = toCoordinates(obj, data0, data1)
      %
      % [X, Y] = toCoordinates(obj, data0, data1)
      %
      % returns the coordinates of the objects in data*
      % of the matched pairs
      %
      % columns in X,Y are the matched points
      %
      
         [X0, X1] = matchedCoordinates(data0, data1, obj.match);

      end
      
            
      function stats = statistics(obj, data0, data1, cost)
      %
      % stats = statistics(obj, data)
      %
      % returns some statistics of the trajectory
      %
         if nargin < 4
            stats = matchedStatistics(data0, data1, obj.match);
         else
            stats = matchedStatistics(data0, data1, obj.match, cost);
         end
 
      end
      

   end % methods
end % classdef
      
      
      
      
      