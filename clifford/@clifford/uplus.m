function u = uplus(a)
% +  Unary plus.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

u = a; % Since + does nothing, we can just return a.

% $Id: uplus.m 63 2016-06-20 11:36:32Z sangwine $

