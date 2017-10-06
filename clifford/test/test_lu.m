function test_lu
% Test code for the clifford LU decomposition.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

s = clifford_signature;
if s(3) ~= 0
    disp(['Not testing LU decomposition because the ', ...
          'multivector inverse is not defined in this algebra'])
else
    disp('Testing LU decomposition ...');

    A = randm(5);
    
    [L, U, P] = lu(A);
    
    if max(max(abs(L * U - P * A))) < 1e-5
        disp('Passed')
    else
        warning(['LU decomposition failed. Residual: ', ...
                  num2str(max(max(abs(L * U - P * A)))) ])
    end

end

end

% $Id$
