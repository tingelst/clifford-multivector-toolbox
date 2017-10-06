function B = clifford_basis
% CLIFFORD_BASIS Return a column vector containing the basis elements of
% the current algebra.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer.

narginchk(0, 0), nargoutchk(0, 1)

global clifford_descriptor;

if isempty(clifford_descriptor)
    error('No Clifford algebra has been initialised.')
end

B = e0;

for j = 2:clifford_descriptor.m
    B = vertcat(B, clifford(clifford_descriptor.index_strings{j}));
end

end

% $Id: clifford_basis.m 62 2016-06-20 11:33:56Z sangwine $
