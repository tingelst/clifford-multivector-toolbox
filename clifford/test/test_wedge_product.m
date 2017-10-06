function test_wedge_product
% Test code for the clifford wedge product function.

% Copyright (c) 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Testing wedge product ...');

v1 = grade(randm(5), 1); % Make two random arrays OF VECTORS.
v2 = grade(randm(5), 1);

% The first test is based on the classic formula which relates the
% geometric product to the sum of the wedge and scalar products FOR VECTOR
% ARGUMENTS. These tests assume that the scalar product has already been
% tested and that the geometric product has also been tested by
% verification of the multiplication table. This is why this test is
% referred to as a test of the wedge product which, until this test, has
% not been tested.

check(v1 .* v2 == wedge(v1, v2) + scalar_product(v1, v2), ...
     'Wedge product fails test 1.');
check(v2 .* v1 == wedge(v2, v1) + scalar_product(v2, v1), ...
     'Wedge product fails test 2.');
 
% TODO Add further tests on full multivectors. Problem: there doesn't seem
% to be a formula for this that we can use.

disp('Passed');

% $Id: test_wedge_product.m 105 2016-11-26 21:56:28Z sangwine $
