function r = unit(a)
% UNIT multivector. Divides a multivector by its own modulus.
% The result is a multivector with unit modulus.

% Based on the unit function in the Quaternion Toolbox for Matlab (QTFM)
% Copyright (c) 2005 Stephen J. Sangwine and Nicolas Le Bihan.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

m = abs(a);

% Since m could be complex, the warning check below has to
% use abs again to get a real result for comparison with eps.

if any(any(abs(m) < eps))
    warning(['At least one element has zero modulus, '...
             'and divide by zero will occur.']);
end

r = a .* (1 ./ m);
 
% TODO: Dividing by a small modulus can result in numerical errors such
% that the result does not have unit modulus. The QTFM code contains an
% elaborate check on this, and a similar check should be inserted here in
% due course.

% $Id: unit.m 63 2016-06-20 11:36:32Z sangwine $
