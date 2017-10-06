function r = conj(a)
% CONJ  Computes the conjugate of a multivector.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

% TODO The Matlab conj function is called implicitly when a matrix is
% operated on with the ' (tick) operator (conjugate transpose), so it is
% important that this function exists, and has the correct definition.

r = clifford_conjugate(a);

end

% $Id: conj.m 63 2016-06-20 11:36:32Z sangwine $
