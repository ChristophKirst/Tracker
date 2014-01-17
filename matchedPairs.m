function pairs = matchedPairs(match, k, creation_id, deletion_id)
%
% pairs = matchedPairs(match, k)
%
% returns array of paried indices corresponding to the matches
% [i match(i)] taking into account creation of new objects as [-1 j]
%

if isequal(class(match), 'TrackingMatchData')
   match = match.match;
end
if ~iscell(match)
   ma{1} = match;
else
   ma = match;
end

if nargin < 2 || isempty(k) || k < length(ma{length(ma)})
   k = length(ma{length(ma)});
end

if nargin < 3 
   c_id = -1;
   creation_id = -1;
else
   c_id = creation_id;
end

if nargin < 4
   d_id = c_id;
   deletion_id = creation_id;
else
   d_id = deletion_id;
end


nframes = length(ma);
p{nframes} = [];

for t = 1:nframes
   n = length(ma{t});
   
   if t==nframes
      m = k;
   else
      m = length(ma{t+1});
   end
   
   if isempty(creation_id)
      c_id = m+1;
   end
   if isempty(deletion_id)
      d_id = n+1;
   end
   
   i = 1:n;
   j = ma{t}'; j(ma{t}<0) = d_id;

   j = [j setdiff(1:m, j)]; %#ok<AGROW>
   i = [i c_id * ones(1,length(j)-length(i))]; %#ok<AGROW>

   p{t} = [i' j'];
end

if ~iscell(match)
   pairs = p{1};
else
   pairs = p;
end

end

