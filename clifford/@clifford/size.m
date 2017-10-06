function varargout = size(m, dim)
% SIZE   Size of matrix.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% We need to find the size of any non-empty part of the multivector. If
% there is no non-empty part, we need to return the appropriate values for
% the empty parts.

switch nargout
    case 0
        switch nargin
            case 1
                size(m.multivector{find_non_empty})
            case 2
                size(m.multivector{find_non_empty}, dim)
            otherwise
                error('Incorrect number of input arguments.')
        end
    case 1
        switch nargin
            case 1
                varargout{1} = size(m.multivector{find_non_empty});
            case 2
                varargout{1} = size(m.multivector{find_non_empty}, dim);
            otherwise
                error('Incorrect number of input arguments.')
        end
    case 2
        switch nargin
            case 1
                [varargout{1}, varargout{2}] = size(m.multivector{find_non_empty});
            case 2
                error('Unknown command option.'); % Note 1.
            otherwise
                error('Incorrect number of input arguments.')
        end
    otherwise
        switch nargin
            case 1
                d = size(m.multivector{find_non_empty});         
                for k = 1:length(d)
                    varargout{k} = d(k);
                end
            case 2
                error('Unknown command option.'); % Note 1.                
            otherwise
                error('Incorrect number of input arguments.')
        end
end

    function j = find_non_empty
        % Find the first non-empty element of m and return its index.
        
        % TODO This operation is quite costly. Is it possible to cut out
        % some of the time in most cases by checking the size of the first
        % element, and only then inspecting others? Or should we store the
        % size of the multivector as an extra field inside the multivector?
        
        j = find(~cellfun(@isempty, m.multivector), 1);
        
        if isempty(j)
            j = 1; % The first element serves if they are all empty.
        end
    end
end

% Note 1. Size does not support the calling profile [r, c] = size(q, dim),
% or [d1, d2, d3, .... dn] = size(q, dim). The error raised is the same as
% that raised by the built-in Matlab function.

% $Id: size.m 63 2016-06-20 11:36:32Z sangwine $
