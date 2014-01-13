function dist = distanceMatrix(data0, data1)
%
%   dist = distanceMatrix(data0, data1)
%
%   dist(i,j) is the distance associated with linking i time <--> j time+1
%   data* the TrackingTimeFrame data calsses for 2 times to be matched.
%


o1 = data0.objects;
o2 = data1.objects;

n = length(o1);
m = length(o2);

dist = ones(n,m);
for i = 1:n
   for j = 1:m
      dist(i,j) = trackingDistance(o1(i), o2(j));
   end  
end


end

