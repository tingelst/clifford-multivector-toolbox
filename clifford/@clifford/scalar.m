function p = scalar(m)
% SCALAR  Extracts the scalar component of a clifford multivector.
% The result is numeric, not a multivector.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

p = grade(m, 0);

end

% $Id: scalar.m 63 2016-06-20 11:36:32Z sangwine $
