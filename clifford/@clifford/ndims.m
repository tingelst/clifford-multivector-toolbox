function n = ndims(m)
% NDIMS   Number of array dimensions.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

n = length(size(m));

% Alternative: use builtin ndims on a non-empty component, but this
% involves finding a non-empty component, as in the size function. Maybe
% the search for the non-empty component could be put in a private function
% and then it would be callable from here.

end

% $Id: ndims.m 63 2016-06-20 11:36:32Z sangwine $
