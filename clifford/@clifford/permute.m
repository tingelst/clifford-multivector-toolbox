function B = permute(A, order)
% PERMUTE Rearrange dimensions of N-D array
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2015, 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

B = overload(mfilename, A, order);

% $Id: permute.m 94 2016-07-28 20:09:40Z sangwine $
