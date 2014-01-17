function dist = distanceMatrix(data0, data1, dist_cutoff)
%
%   dist = distanceMatrix(data0, data1)
%
%   dist(i,j) is the distance associated with linking i time <--> j time+1
%   data* the TrackingTimeFrame data classes for 2 times to be matched.
%   dist(i,j) > dist_cutoff -> Inf
%

% parameter

w_space = 1.0;       % weight for spatial distance
w_size  = 0.0;       % weight for size distance
w_intensity = 0.0;   % weight for intensity distance
w_info = Inf;        % weight for two objects that have different type / info 


n0 = length(data0.objects);
n1 = length(data1.objects);

% calculate spatial distances

if nargin < 3
   dist_cutoff = [];
end


if (w_space > 0)
   r0 = data0.toCoordinates();
   r1 = data1.toCoordinates();
   dim = data0.dim;


   dist = w_space * sqrt(sum(bsxfun(@minus,reshape(r0',[n0,1,dim]),reshape(r1',[1,n1,dim])).^2,3));

   if ~isempty(dist_cutoff)
      dist(dist > dist_cutoff) = Inf; 
   end
else
   dist = zeros(n0, n1);
end



if (w_size > 0 || w_intensity > 0 || w_info > 0)
   
   indx = find(dist < Inf);
   [row, col] = ind2sub(size(dist), indx);
   
   if (w_size > 0 || w_intensity > 0)
      s0 = data0.toSizes()';
      s1 = data1.toSizes()';

      i0 = data0.toIntensities()';
      i1 = data1.toIntensities()';

      length(indx)
      length(row)
      length(col)

      dist(indx) = dist(indx) + w_size * abs( s0(row) - s1(col) ) + w_intensity * abs( i0(row) - i1(col) );
   end

   if (w_info > 0)
      i0 = data0.toInfos()';
      i1 = data1.toInfos()';
      
      if isempty(i0) && isempty(i1)
         return
      else
         di = sum(abs( i0(row,:) - i1(col,:) ),2);   
         di(di > 0) = w_info;
         dist(indx) = dist(indx) + di;
      end
   end

end

end
