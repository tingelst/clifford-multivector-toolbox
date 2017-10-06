function t = sum(a, dim)
% SUM Sum of elements.
% (Clifford overloading of standard Matlab function.)

% This function was copied from the Quaternion Toolbox for Matlab (QTFM).

% Copyright (c) 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

narginchk(1, 2), nargoutchk(0, 1)

if nargin == 1
    t = overload(mfilename, a);
else
    if ischar(dim)
        if (strcmp(dim, 'double') || strcmp(dim, 'native'))
            error(['Parameters ''double'' or ''native'' are not'...
                   ' implemented in the clifford sum function.']);
        else
            error('Dimension argument must be numeric');
        end
    end
    
    if ~isnumeric(dim)
        error('Dimension argument must be numeric');
    end
    
    if ~isscalar(dim) || ~ismember(dim, 1:ndims(a))
        error(['Dimension argument must be a positive'...
               ' integer scalar within indexing range.']);
    end
    
    t =  overload(mfilename, a, dim);
end

% $Id: sum.m 63 2016-06-20 11:36:32Z sangwine $
