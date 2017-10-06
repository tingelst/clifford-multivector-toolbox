function m = wedge(l, r, varargin)
% WEDGE  Clifford wedge product

% Copyright (c) 2013, 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% The wedge product is associative, which is why we allow varargin
% parameters. However, to simplify the coding, especially of error
% checking, we make recursive calls to process the varargin parameters.

global clifford_descriptor;

ml = isa(l, 'clifford');
mr = isa(r, 'clifford');

if ml, check_signature(l); end
if mr, check_signature(r); end

m = clifford();

if ml && mr
    
    % Both arguments are multivectors.
    
    m = clifford(zeros(size(l)));
       
    for k = 0:clifford_descriptor.n
        for s = 0:clifford_descriptor.n - k
            g = grade(grade(l, k) .* grade(r, s), k + s);
            if ~isempty(g)
                m = m + g;
            end
        end
    end
 
else

    % One of the arguments is not a multivector. If it is numeric, we can
    % handle it.
    
    if ml && isa(r, 'numeric')
        m = l .* r;
    elseif isa(l, 'numeric') && mr
        m = l .* r;
    else
        error('Wedge product of a Clifford multivector with a non-numeric is not defined.')
    end
end

% We now have in m the wedge product of l and r. But we are not finished if
% varargin is non-empty.

if ~isempty(varargin)
    m = wedge(m, varargin{1}, varargin{2:end});
end

end

% $Id: wedge.m 104 2016-11-26 21:46:15Z sangwine $
