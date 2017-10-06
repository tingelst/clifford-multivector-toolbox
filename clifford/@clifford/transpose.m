function t = transpose(a)
% .'  Transpose.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer.

narginchk(1, 1), nargoutchk(0, 1) 

t = overloade(mfilename, a);

% TODO Because transpose is such a fundamental operation, it would be
% better coded directly here rather than calling the overload function.
% Cf the QTFM version of this function (qtfm.sourceforge.net).

% $Id: transpose.m 63 2016-06-20 11:36:32Z sangwine $
