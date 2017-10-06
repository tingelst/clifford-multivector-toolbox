function p = odd(m)
% ODD  Extracts the sum of the odd grades of a clifford multivector.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

check_signature(m);

% TODO A better algorithm here would avoid the composition of grades using
% plus, and just copy the cells across corresponding to the odd grades.

p = grade(m, 1);

for k = 3:2:clifford_descriptor.n
    p = p + grade(m, k);
end

end

% $Id: odd.m 63 2016-06-20 11:36:32Z sangwine $
