classdef TrackingObjectData
%
% TrackingObjectData(x, d, varargin) class storing info for the objects to be tracked
%
   properties
      id = 0;        % id
      r = [0; 0];    % spatial position
      size = 0;      % size
      intensity = 0; % intensity
      
      info = [];     % additional data that identifes the object
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
               obj.size = 0;
               obj.intensity = 0;
               obj.info = [];
               
               n = length(x);
               if n > 1+d
                  obj.size = x(2+d);
               end
               if n > 2 + d
                  obj.intensity = x(3+d);
               end
               if n > 3 + d
                  obj.info = x(4+d:length(x));
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
      %
      % data = toData(obj)
      %
      % convert data to vector
      %
         data = [obj.id; obj.r; obj.size; obj.intensity; obj.info];
      end
      
      function obj = transformData(obj, R, T, C)
      %
      % obj = transformData(obj, R, T, C)
      %
      % applies rotation R, translation T and scaling C to coordinates
      %
         obj.r = (C * R * obj.r + T);
      end

   end % methods
end % classdef
      
      