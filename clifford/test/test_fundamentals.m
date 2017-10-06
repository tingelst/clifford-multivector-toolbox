function test_fundamentals
% Test code for the fundamental clifford functions.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Testing fundamentals ...');

% Do some checks on the basis and signature.

s = clifford_signature; p = s(1); q = s(2); r = s(3);
n = sum(s);
m = 2.^n;
b = clifford_basis;

check(2.^sum(s) == length(b), 'Basis does not agree with signature.')

B = b .* b; % Square the basis.
S = part(B, 1); % The coefficient of the scalar part.

check(S(1)     ==  1, 'e0 does not square to +1! Test 1.')
check(e0 .* e0 == e0, 'e0 does not square to +1! Test 2.')

check(sum(S(2:2+n-1) == +1) == p, 'Number of basis elements squaring to +1 incorrect')
check(sum(S(2:2+n-1) == -1) == q, 'Number of basis elements squaring to -1 incorrect')
check(sum(S(2:2+n-1) ==  0) == r, 'Number of basis elements squaring to 0 incorrect')

disp('Passed');

% $Id: test_fundamentals.m 3 2015-03-26 11:38:49Z sangwine $
