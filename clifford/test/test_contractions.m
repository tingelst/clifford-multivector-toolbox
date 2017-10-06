function test_contractions
% Test code for the clifford left and right contraction functions.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Testing left and right contractions ...');

global clifford_descriptor

% TODO Add tests on array arguments.

% The tests below cannot all be used for all algebras, so we return early
% and skip any tests that cannot be executed in the current algebra because
% the necessary basis elements don't exist.

if clifford_descriptor.n < 2
    disp('Not testing left and right contractions, algebra too small.')
    return
end

cz = 0 .* e0; % A multivector zero.

% The parameters are left, right arguments, result from a left contraction,
% test number.

contraction(e0, e0, e0,       1);
contraction(e0, e0, e0,       2);
contraction(e1, e1, e1 .* e1, 3);

if clifford_descriptor.n < 3, disp('Passed'); return, end

contraction(e12, e12, e12 .* e12,  4);
contraction(e12, e1, cz,           5);
contraction(e12, e2, cz,           6);
contraction(e1, e12, e1 .* e1 .* e2, 7);

if clifford_descriptor.n < 4, disp('Passed'); return, end

contraction(e12, e123, -e3 .* e1 .* e1 .* e2 .* e2, 8);
contraction(e123, e12, cz,                          9);

if clifford_descriptor.n < 5, disp('Passed'); return, end

contraction(e123, e1234, -e4 .* e1 .* e1 .* e2 .* e2 .* e3 .* e3, 10);
contraction(e4, e1234, -e123 .* e4 .* e4,                         11);

disp('Passed');

end

function contraction(l, r, y, n)
% Applies tests to the left and right contraction.

check(left_contraction(l, r) == y, ...
    ['Left contraction fails test ' num2str(n)]);
check(right_contraction(reverse(r), reverse(l)) == reverse(y), ...
    ['Right contraction fails test ' num2str(n)]);

end

% $Id: test_contractions.m 65 2016-06-20 11:39:39Z sangwine $
