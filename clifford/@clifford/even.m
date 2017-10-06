function p = even(m)
% EVEN  Extracts the sum of the even grades of a clifford multivector.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

check_signature(m);

% TODO See note in odd.m about a better algorithm.

p = grade(m, 0);

for k = 2:2:clifford_descriptor.n
    p = p + grade(m, k);
end

end

% $Id: even.m 63 2016-06-20 11:36:32Z sangwine $
