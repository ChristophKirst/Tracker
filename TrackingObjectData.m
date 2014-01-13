classdef TrackingObjectData
% class storing info for the objects to be tracked
   properties     
      id = 0;        % id
      r = [0 0];     % spatial position
      size = 0;      % size
      intensity = 0; % intensity
      
      info = [];     % additional data
   end 
   
   properties (Dependent)
      dim            % spatial dimensions
      length         % total length of data entries
   end
   
   methods
      function obj = TrackingObjectData(x, d, varargin)
         if nargin > 0
            if nargin == 2 && length(x) >= 2 + d
               obj.id = x(1);
               obj.r = x(2:1+d);
               obj.size = x(2+d);
               if length(x) > 2 + d
                  obj.intensity = x(3+d);
                  obj.info = x(4+d:length(x));
               else
                  obj.intensity = 0;
                  obj.info = [];
               end
            elseif nargin >= 4
               obj.id = x;
               obj.r = d;
               obj.size = varargin{1};
               obj.intensity = varargin{2};
               if nargin == 4
                  obj.info = [];
               else
                  obj.info = varargin{3};
               end  
            end
         end
      end 
      
      function d = get.dim(obj)
         d = length(obj.r);
      end
      
       function l = get.length(obj)
         l = length(obj.r) + 3 + length(obj.info);
      end
      
      
      function data = toData(obj)
         % converst data to vector
         data = [obj.id obj.r obj.size obj.intensity obj.info];
      end
      
      function obj = transformData(obj, R, T, C)
         obj.r = (C * R * obj.r' + T)';
      end

   end % methods
end % classdef
      
      
      
      
      