function d = triu(v, k)
% TRIU Extract upper triangular part.
% (Clifford overloading of standard Matlab function.)

% This function was copied from the Quaternion Toolbox for Matlab (QTFM).

% Copyright (c) 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m in QTFM (qtfm.sourceforge.net).

narginchk(1, 2), nargoutchk(0, 1) 

if nargin == 1
    d = overloade(mfilename, v);
else
    d = overloade(mfilename, v, k);
end

% $Id: triu.m 94 2016-07-28 20:09:40Z sangwine $
