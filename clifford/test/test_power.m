function test_power
% Test code for the power function.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Testing power function ...');

% Test the inverse operation, if it is defined.

s = clifford_signature;
if s(3) ~= 0
    disp(['Not testing power function with exponent -1 because the ', ...
         'inverse is not defined in algebras with r > 0.'])
else

    m = randm(2);
    p = m.^-1; % Compute the inverse of each element in m.
    
    compare(m .* p, 1e0, 1e-6, 'Multivector elementwise inverse fails.');
    
    disp('Passed');
    
end

% $Id$
