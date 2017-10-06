function test_scalar_product
% Test code for the clifford scalar product function.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Testing scalar product ...');

m1 = randm(5); % Make two random arrays.
m2 = randm(5);

% The test is based on a simple formula for computing the scalar product.
% The scalar_product function does not use this formula because it would
% compute the entire product of two multivectors and then discard most of
% the result. We do however use the formula here as a check that the rather
% more complicated code in the scalar product function yields the correct
% result.

check(scalar_product(m1, m2) == part(m1 .* reverse(m2), 1), ...
     'Scalar product fails test 1.');
check(scalar_product(m1, m2) == part(reverse(m1) .* m2, 1), ...
     'Scalar product fails test 2.');
check(scalar_product(m1, m2) == part(m2 .* reverse(m1), 1), ...
     'Scalar product fails test 3.');
check(scalar_product(m1, m2) == part(reverse(m2) .* m1, 1), ...
     'Scalar product fails test 4.');

disp('Passed');

% $Id: test_scalar_product.m 65 2016-06-20 11:39:39Z sangwine $
