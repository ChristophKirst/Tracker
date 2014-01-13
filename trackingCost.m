function cc = trackingCost(match, cost)
%
% compute cost for the match
% match can be the permutation vector or association matrix
%

cc = 0;

%osize = size(cost,1)-1;
nsize = size(cost,2)-1;

if ~isequal(size(match),size(cost)) && size(match,2) == 1
   % match is permutation
   for i = 1:length(match)
      j= match(i);
      if j < 0
         j = nsize;
      end
      cc = cc + cost(i, j);
   end
   % add creation cost;
   cc = cc + cost(nsize+1, 1) * (nsize - length(find(match>0)));

else
   
    cc = sum(sum(cost(match > 0)));
    
end

end

