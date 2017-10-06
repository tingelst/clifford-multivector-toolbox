function m = mean(X, dim)
% MEAN   Average or mean value.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% Adapted (minimally) for the Clifford toolbox, 2017 by Stephen Sangwine.
% See the file : Copyright.m for further details.

narginchk(1, 2), nargoutchk(0, 1) 

if nargin == 1
    m = overload(mfilename, X);
else
    if ~isnumeric(dim)
        error('Dimension argument must be numeric');
    end
    
    if ~isscalar(dim) || ~ismember(dim, 1:ndims(X))
        error(['Dimension argument must be a positive'...
               ' integer scalar within indexing range.']);
    end

    m = overload(mfilename, X, dim);
end

% $Id: mean.m 119 2017-04-19 21:08:59Z sangwine $
