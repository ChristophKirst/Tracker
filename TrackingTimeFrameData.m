classdef TrackingTimeFrameData
   % class holding all objects to track in a certain time frame
   
   properties 
      time = 0; % time
      objects   % list of objects in frame
   end
   
   properties (Dependent)
      dim       % spatial dimensions
      length    % total length of a single data entry
   end
   
   methods
      function obj = TrackingTimeFrameData(objdata, dim, time)
         if nargin > 0 
            obj = fromData(obj, objdata, dim);
            if nargin == 3
              obj.time = time;
            else
              obj.time = 0;
            end
         end
      end 

      function obj = fromData(obj, objdata, dim)
         % stores data in array in the object
         n = size(objdata,1);            
         o(n) = TrackingObjectData();
         for i=1:n
            o(i) = TrackingObjectData(objdata(i,:), dim);
         end
         
         obj.objects = o;
      end
      
      function data = toData(obj)
         % converts data in array form
         n = length(obj.objects);
         
         data = zeros(n, obj.length);
         for i=1:n
            data(i, :) = obj.objects(i).toData();
         end
      end
            
      function d = get.dim(obj)
         if isempty(obj.objects) 
            d = 3; % default
         else
            d = obj.objects(1).dim;
         end
      end
      
      
      function l = get.length(obj)
         if isempty(obj.objects) 
            l = 6; % default
         else
            l = obj.objects(1).length;
         end
      end
      
      function coords = toCoordinates(obj)
         % converts data in array form
         n = length(obj.objects);   
         coords = zeros(n, obj.dim);
         for i=1:n
            coords(i, :) = obj.objects(i).r;
         end
      end
             
      function ints = toIntensities(obj)
         % converts data in array form
         n = length(obj.objects);   
         ints = zeros(n, 1);
         for i=1:n
            ints(i) = obj.objects(i).intensity;
         end
      end
      
      function sizes = toSizes(obj)
         % converts data in array form
         n = length(obj.objects);   
         sizes = zeros(n, 1);
         for i=1:n
            sizes(i) = obj.objects(i).size;
         end
      end

      function obj = transformData(obj, R, T, C)
         for i=1:length(obj.objects)
            obj.objects(i) = obj.objects(i).transformData(R, T, C);
         end
      end

   end % methods
end % classdef
      
      
      
      
      