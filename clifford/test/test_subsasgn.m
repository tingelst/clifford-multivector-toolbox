function test_subsasgn
% Test code for the subsasgn function.

% Copyright (c) 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Testing subscripted assignment ...');

% This is largely a case of testing that calls will work without error.

A = randm(2);

% Make a copy of A rotated 90 degrees, then replace all the elements one by
% one with elements from A. At the end B should be the same as A.

B = rot90(A);
B(1, 1) = A(1, 1);
B(1, 2) = A(1, 2);
B(2, 1) = A(2, 1);
B(2, 2) = A(2, 2);
check(all(all(A == B)), 'Subsasgn fails test 1.');

% These are more demanding tests, since they clear entire rows or columns.

B = A; B(:, 1) = []; check(all(size(B) == [2, 1]), 'Subsasgn fails test 2.')
B = A; B(1, :) = []; check(all(size(B) == [1, 2]), 'Subsasgn fails test 3.')

% This test checks that assigning a multivector with empty components will
% work (e0 has empty components for e1, e2 etc).

B = A; B(1, 1) = e0; check(all(size(B) == [2, 2]), 'Subsasgn fails test 4.')

disp('Passed');
end

% $Id: test_subsasgn.m 115 2017-04-17 18:20:00Z sangwine $
