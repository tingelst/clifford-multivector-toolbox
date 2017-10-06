function a = abs(m)
% ABS Absolute value, or modulus, of a multivector.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

a = sqrt(normm(m));

end

% $Id: abs.m 63 2016-06-20 11:36:32Z sangwine $
