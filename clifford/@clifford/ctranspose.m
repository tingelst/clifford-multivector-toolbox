function t = ctranspose(a)
% '   Clifford conjugate transpose.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

% TODO Implement the conjugate using the private function involution and
% the transpose by direct coding here.

t = conj(transpose(a));

end

% $Id: ctranspose.m 87 2016-07-19 17:01:31Z sangwine $
