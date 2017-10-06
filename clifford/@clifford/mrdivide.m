function r = mrdivide(a, b)
% /   Slash or right matrix divide.
% (Clifford overloading of standard Matlab function.)
%
% This function is implemented only for the case in which the
% second parameter is a scalar. In this case, the result is as
% given by the ./ function.   The reason for implementing this
% function is that some Matlab code uses / when ./ should have
% been used.    See, for example, the function cov.m in Matlab
% versions up to (at least) 7.0.4.365 (R14) Service Pack 2.

% Copied from the Quaternion Toolbox for Matlab (QTFM) with minimal
% modifications to work with multivectors.

% Copyright (c) 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

if ~isscalar(b)
    error('clifford/mrdivide is implemented only for division by a scalar.');
end

r = a ./ b;

% $Id: mrdivide.m 86 2016-07-19 16:47:51Z sangwine $
