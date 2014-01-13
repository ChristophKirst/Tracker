function dist = trackingDistance(to1, to2)
%
% dist = trackingDistance(to1, to2)
%
% calculates distance between two objects to1 and to2 to be tracked
% 

%% parameter

w_space = 1.0;       % weight for spatial distance
w_size  = 0.0;       % weight for size distance
w_intensity = 0.0;   % weight for intensity distance
w_info = Inf;        % weight for two objects that have different type / info 


%% distance
if to1.dim ~= to2.dim || ~isequal(to1.info, to2.info)
   dist = w_info;
   if dist == Inf
      return
   end
else
   dist = 0;
end

dist = dist + w_space * sqrt(sum((to1.r - to2.r).^2));
dist = dist + w_size * abs(to1.size- to2.size);
dist = dist + w_intensity * abs(to1.intensity- to2.intensity);

