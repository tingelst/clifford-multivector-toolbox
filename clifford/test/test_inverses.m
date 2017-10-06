function test_inverses
% Test code for the elementwise and matrix inverses.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Test the inverse operation, if it is defined.

s = clifford_signature;
if s(3) ~= 0
    disp(['Not testing matrix inverse because the ', ...
         'inverse of a multivector is not defined in algebras with r > 0.'])
else
    disp('Testing matrix inverse ...');

    m = randm(5);
    
    compare(m * inv(m) - e0 .* eye(size(m)), e0 .* zeros(size(m)), 1e-4, 'Matrix inverse fails.')
    
    disp('Passed');
end

% $Id: test_inverses.m 113 2017-04-16 15:28:59Z sangwine $
