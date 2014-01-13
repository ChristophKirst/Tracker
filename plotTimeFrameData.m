function plotTimeFrameData(data)
%
% plot data in a time frame
% 

xyz = data.toData();
s = xyz(:,5);
s = s / max(s) .* 200;
xyz = xyz(:,2:4);

col = 1:size(xyz,1)
scatter3(xyz(:,1), xyz(:,2), xyz(:,3), s, col)

end

