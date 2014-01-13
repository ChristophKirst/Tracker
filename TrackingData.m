classdef TrackingData
   properties 
      name = '';
      frames = [];
   end 
   
   methods
      function obj = TrackingData(data, time, dim)
         if nargin > 0
            nframes  = size(data,1);
            
            if nargin ==2
               dim = time;
               time = 1:nframes;
            end
            
            f(nframes) = TrackingTimeFrameData();
            for t = 0:nframes
               f(t).frames = f(t).fromArray(data(t,:), dim);
               f(t).time = time(t);
            end
            
         end
      end 
      
      function data = toData(obj)
         % convert to data
         data = {};
         for t = 1:length(obj.frames)
            data{t} = obj.frames(t).toData();
         end
      end
      
      
   end % methods
end % classdef
      
      
      
      
      