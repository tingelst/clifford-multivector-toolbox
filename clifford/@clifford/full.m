function y = full(x)
% FULL  Convert sparse matrix to full matrix.
% (Clifford overloading of standard Matlab function.)

% Adapted from the Quaternion Toolbox for Matlab.
% Copyright (c) 2013 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% Note: this function is necessary to enable the Matlab trace function to
% work for multivector arguments.

narginchk(1, 1), nargoutchk(0, 1)

y = overload(mfilename, x);

% $Id: full.m 132 2017-05-17 16:53:51Z sangwine $
