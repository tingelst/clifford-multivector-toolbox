function M = isom8m0(m)
% Private function to convert a multivector array in Cl(p, q) to a 
% multivector in Cl(p-8, q) using isomorphism. On return the current
% algebra is Cl(p-8, q).

% Copyright (c) 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Reference:
%
% Pertti Lounesto, Clifford Algebras and Spinors,
% London Mathematical Society Lecture Note Series 286,
% Cambridge University Press, 2nd edition, 2001.
% Sections 16.3, 16.4 and Table 1, pp214-217.

global clifford_descriptor

if clifford_descriptor.signature(3) ~= 0
   error(['In private function ', mfilename, ' isomorphism is not implemented for r > 0'])
   % TODO It is possible that this function could be extended to the case r == 0.
end

if any(clifford_descriptor.signature ~= get_signature(m))
    % The current signature doesn't match that of the input parameter, so
    % switch to it, before we proceed.
    clifford_signature(get_signature(m));
end

if clifford_descriptor.signature(1) < 8
    error('Cannot map to an algebra with negative p')
end

M = isop1p1(isop1p1(isop1p1(isop1p1(isom4p4(m)))));

end

% $Id$
