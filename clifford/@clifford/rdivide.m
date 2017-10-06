function r = rdivide(a, b)
% ./  Right array divide.
% (Clifford overloading of standard Matlab function.)

% This function was adapted from the Quaternion Toolbox for Matlab (QTFM)
% with minor modifications to work with matrices of Clifford multivectors.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

global clifford_descriptor;

% There are three cases to be handled:
%
% 1. Left and right arguments are multivectors.
% 2. The left argument is a multivector, the right is not.
% 3. The right argument is a multivector, the left is not.
%
% In fact, cases 1 and 3 can be handled by the same code. Case 2
% requires different handling.

if isa(b, 'clifford')
    
    % The right argument is a multivector. We can handle this case by
    % forming its elementwise inverse and then multiplying. Of course,
    % if any elements have zero norm, this will result in NaNs.
     
    r = a .* b .^ -1;
    
else
    
    % The right argument is not a multivector. We assume therefore
    % that if we divide components of the left argument by the right
    % argument, that Matlab will do the rest.
    
    % TODO Perhaps we should check that b is numeric, and if not raise an
    % error? Otherwise an obscure error could occur when we try to divide
    % by b.
    
    r = a;
    for j = 1:clifford_descriptor.m
        r.multivector{j} = component(a, j) ./ b;
    end
end

% $Id: rdivide.m 94 2016-07-28 20:09:40Z sangwine $
