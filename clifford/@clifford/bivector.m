function p = bivector(m)
% BIVECTOR  Extracts the bivector component of a clifford multivector.
% The result is a multivector.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

if clifford_descriptor.n < 2
    error('There are no bivectors in the current clifford algebra.')
end

p = grade(m, 2);

end

% $Id: bivector.m 63 2016-06-20 11:36:32Z sangwine $
