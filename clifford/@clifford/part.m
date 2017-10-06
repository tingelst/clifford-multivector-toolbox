function p = part(m, n)
% PART  Extracts the n-th component of a clifford multivector.
% This may be empty if the multivector has an empty component at the nth
% position.

% TODO Consider whether this should be replaced with a GET function.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

global clifford_descriptor;

if ~isnumeric(n)
    error('Second parameter must be numeric.')
end

if n < 1
    error('Second parameter must be positive.')
end

% TODO Check that n has an integer value. Although if it doesn't the
% indexing of the cell array below will raise an error.

if n > clifford_descriptor.m
    error(['Second parameter is greater than the number of parts in a ' ...
           'multivector, given the currently selected algebra.'])
end

p = component(m, n); % This is a call to a private function.

end

% $Id: part.m 63 2016-06-20 11:36:32Z sangwine $
