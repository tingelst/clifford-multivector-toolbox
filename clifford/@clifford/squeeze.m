function x = squeeze(y)
% SQUEEZE  Remove singleton dimensions.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

x = overload(mfilename, y);

% $Id: squeeze.m 63 2016-06-20 11:36:32Z sangwine $
