function plotMatchedTimeFrameData(data0, data1, match)
%
% plot result of matching
% 

xyz0 = data0.toCoordinates();
s0 = data0.toSizes();
s0 = s0 / max(s0) .* 200;

xyz1 = data1.toCoordinates();
s1 = data1.toSizes();
s1 = s1 / max(s1) .* 200;


hold on
grid on

if data0.dim == 2
   scatter(xyz0(:,1),xyz0(:,2), s0, [1 0 0])
   scatter(xyz1(:,1),xyz1(:,2), s1, [0 0 1])
   
   for i=1:size(match)
      j = match(i);
      if j>0
         line([xyz0(i,1) xyz1(j,1)], [xyz0(i,1) xyz1(j,1)]);
      end
   end
else
   scatter3(xyz0(:,1),xyz0(:,2),xyz0(:,3), s0, [1 0 0])
   scatter3(xyz1(:,1),xyz1(:,2),xyz1(:,3), s1, [0 0 1])
   
   for i=1:size(match)
      j = match(i);
      if j>0
         line([xyz0(i,1) xyz1(j,1)], [xyz0(i,2) xyz1(j,2)], [xyz0(i,3) xyz1(j,3)]);
      end
   end
end




hold off


end

