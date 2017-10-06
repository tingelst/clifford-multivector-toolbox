function p = pseudoscalar(m)
% PSEUDOSCALAR  Extracts the pseudoscalar component of a clifford multivector.
% The result is a multivector.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

p = grade(m, clifford_descriptor.n);

end

% $Id: pseudoscalar.m 63 2016-06-20 11:36:32Z sangwine $
