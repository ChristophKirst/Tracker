function [match, varargout] = matchFrames(data0, data1, creation_cost, deletion_cost, dist_cutoff)
%
% match = matchFrames(data0, data1, creation_cost, deletion_cost, dist_cutoff)
% 
% Compute the optimum matching between two frames data0 and data1
% and return array match such that i -> match(i) is the link if match(i)>0. 
% otherwise match(i) < 0 implies i -> nothing, 
% indices not in match(i) are newly created objects.
%

%% parameter
if nargin < 3
   creation_cost = [];
end
if nargin < 4
   deletion_cost = [];
end
if nargin < 5
   dist_cutoff = [];
end


%% find best linking
cost = costMatchFramesMatrix(data0, data1, creation_cost, deletion_cost, dist_cutoff);
A = optimalAssociationMatrix(cost);


%% convert matrix to permutation list

osize = size(cost,1) - 1;
nsize = size(cost,2) - 1;

[iLink, jLink] = find(A(1:osize,:));
jLink(jLink==(nsize+1)) = -1;
[~, perm] = sort(iLink);
jLink = jLink(perm);

%if osize ~= length(range) || ~all(range' == 1:osize)
%    printf(1, 'matchFrames: index off: iLink, jLink, range, perm\n');
%    iLink, jLink, range, perm
%end
%% unclear the best place to put generic print of what match did, perhaps include above also.
% do you have a separate boundary match in your cost matrix at this point, It used to be -2??
fprintf(1, '# Cells T0 %d, %d matched, %d unmatched, %d lost through bndry, #Cells T1 %d\n',...
   osize, sum(jLink>0), sum(jLink==-1), sum(jLink==-2), nsize); %% length(find(A(1:osize,1:nsize))), nsize);

match = TrackingMatchData(jLink, nsize);

if nargout > 1
   varargout{1} = cost;
end

end

