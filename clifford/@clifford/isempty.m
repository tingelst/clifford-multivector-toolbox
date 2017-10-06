function tf = isempty(m)
% ISEMPTY True for empty matrix.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tf = all(cellfun(@isempty, m.multivector));

% $Id: isempty.m 63 2016-06-20 11:36:32Z sangwine $
