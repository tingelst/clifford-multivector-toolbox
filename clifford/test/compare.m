function compare(A, B, T, E)
% Test function to check that two multivector arrays (real or complex)
% are equal, to within a tolerance, and if not, to output an error
% message from the string in the parameter E.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hizer
% See the file : Copyright.m for further details.

narginchk(4, 4), nargoutchk(0, 0)

if any(any( abs(abs(A - B)) > T ))
    max(max(abs(abs(A - B)))) % Added 13 March 2006 to show the max error.
    error(E);
end

% $Id: compare.m 65 2016-06-20 11:39:39Z sangwine $
