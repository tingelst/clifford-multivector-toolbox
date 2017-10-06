function test_matfuns
% Test code for various Matlab functions that work with multivectors.

% Copyright (c) 2017 Stephen J. Sangwine and Eckhard Hitzer
% Adapted from a similar file in the Quaternion Toolbox for Matlab.
% See the file : Copyright.m for further details.

disp('Testing Matlab functions that work with multivectors ...')

% Check circshift. Shift the data and shift it back again.

A = clifford(randi(100, 20, 10));
check(all(all(circshift(circshift(A, [3,4]), [-3,-4]) == A)), ...
             'circshift fails test');

% Check covariance. This is a simple test using only the scalar part to
% make sure that cov does not raise any errors. It does not check the full
% multivector result.

T = 1e-9;

A = randn(4);
B = cov(A);       % The covariance of a real array.
C = cov(A .* e0); % The covariance of the same data in a multivector.
compare(B, C, T, 'cov function fails test')

A = randm(10, 1);
B = randm(10, 1);

compare(dot(A, B), A' * B, T, 'dot (vector dot product) fails test')

% TODO Replace flipdim with flip (new in R2013a, so we would need to make
% sure the test code insists on this release or later).

% flipdim - Flip matrix along specified dimension
% fliplr - Flip matrix in left/right direction
% flipud - Flip matrix in up/down direction

A = randi(100, 5, 4);

check(~any(any(flipdim(A, 1) - part(flipdim(clifford(A), 1), 1))), ...
                                'flipdim fails test 1')
check(~any(any(flipdim(A, 2) - part(flipdim(clifford(A), 2), 1))), ...
                                'flipdim fails test 2')

check(~any(any(fliplr(A) - part(fliplr(clifford(A)), 1))), 'fliplr fails test')
check(~any(any(flipud(A) - part(flipud(clifford(A)), 1))), 'flipud fails test')

% isequal  - True if arrays are numerically equal
% isscalar - True if array is a scalar
% iscolumn - True if array is a column vector
% ismatrix - True if array is a matrix
% isrow    - True if array is a row vector
% isvector - True if array is a vector

A = randm(10, 1);

check( isequal(A, A),              'isequal fails test 1')
check(~isequal(A, randm(size(A))), 'isequal fails test 2')

check( isscalar(randm), 'isscalar fails test 1')
check(~isscalar(A),     'isscalar fails test 2')

check( iscolumn(A),   'iscolumn fails test 1')
check(~iscolumn(A.'), 'iscolumn fails test 2')

check( ismatrix(randm(2,2)),   'ismatrix fails test 1')
check(~ismatrix(randm(2,2,2)), 'ismatrix fails test 2')

check( isrow(A.'), 'isrow fails test 1')
check(~isrow(A),   'isrow fails test 2')

check( isvector(A),          'isvector fails test 1')
check(~isvector(randm(2,2)), 'isvector fails test 2')

% kron - Kronecker product

A = randi(100, 4, 5);
B = randi(100, 2, 3);

check(all(all(kron(A, B) == scalar(kron(clifford(A), clifford(B))))), ...
       'Kronecker product fails test')

% nchoosek - Combinations of a vector
% perms    - Permutations

A = randi(100, [4, 1]);

check(all(all(nchoosek(A, 2) == scalar(nchoosek(clifford(A), 2)))), ...
                                                     'nchoosek fails test')
check(all(all(perms(A) == scalar(perms(clifford(A))))), 'perms fails test')

% rot90 - Rotate matrix 90 degrees

A = randm(4);

check(all(all(rot90(rot90(rot90(rot90(A)))) == A)), 'rot90 fails test')

% trace

compare(trace(A), sum(diag(A)), T, 'trace fails test')

% std - Standard deviation
% var - Variance

A = randm(10,1);

compare(std(A), sqrt(sum(abs(A - mean(A)).^2) ./ (9)), T, 'std fails test')
compare(var(A),      sum(abs(A - mean(A)).^2) ./ (9),  T, 'var fails test')

% trace - Sum of diagonal elements

A = randm(4, 4);

check(trace(A) == sum(diag(A)), 'trace fails test')

disp('Passed');

end

% $Id: test_matfuns.m 131 2017-05-17 08:50:03Z sangwine $
