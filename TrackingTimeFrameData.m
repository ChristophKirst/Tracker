classdef TrackingTimeFrameData
   % class holding all objects to track in a certain time frame
   
   properties 
      time = 0;      % time
      objects        % list of objects in frame
      filename = ''; % source file of data
   end
   
   properties (Dependent)
      dim            % spatial dimensions
      length         % total length of a single data entry
   end
   
   methods
      function obj = TrackingTimeFrameData(objdata, dim, time, filename)
         if nargin > 0 
            obj = fromData(obj, objdata, dim);
            if nargin > 2
              obj.time = time;
            end
            if nargin > 3
               obj.filename = filename;
            end
         end
      end 

      function obj = fromData(obj, objdata, dim)
         % stores data in array in the object
         n = size(objdata,2);            
         o(n) = TrackingObjectData();
         for i=1:n
            o(i) = TrackingObjectData(objdata(:,i), dim);
         end
         
         obj.objects = o;
      end
      
      function data = toData(obj)
         % converts data in array form
         data = obj.objects.toData();
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
      
      function s = size(obj)
         % converts intensities into vector
         s = length(obj.objects);
      end
      
      
      function coords = toCoordinates(obj)
         % converts coordinates into array form
         coords = [ obj.objects.r ];
      end
             
      function ints = toIntensities(obj)
         % converts intensities into vector
         ints = [ obj.objects.intensity ];
      end
      
      function ints = toInfos(obj)
         % converts intensities into vector
         ints = [ obj.objects.info ];
      end  
      
      function sizes = toSizes(obj)
         % converts sizes into vector
         sizes = [ obj.objects.size ];
      end

      function sizes = toIds(obj)
         % converts sizes into vector
         sizes = [ obj.objects.id ];
      end
      
      function obj = transformData(obj, R, T, C)
         for i=1:length(obj.objects)
            obj.objects(i) = obj.objects(i).transformData(R, T, C);
         end
      end

   end % methods
end % classdef
      
      
      
      
      