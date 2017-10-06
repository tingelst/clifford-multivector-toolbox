function m = left_contraction(l , r)
% LEFT_CONTRACTION  Computes the left contraction of two multivectors.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor;

ml = isa(l, 'clifford');
mr = isa(r, 'clifford');

if ml, check_signature(l); end
if mr, check_signature(r); end

if ml && mr
    
    % Both arguments are multivectors.
    % TODO Consider carefully what happens with empty arguments, or
    % arguments with empty components.
    
    if ~(isscalar(l) || isscalar(r) || all(size(l) == size(r)))
        error('Left and right operands must be the same size or one must be scalar.')
    end
    
    m = clifford(zeros(size(l), classm(l))); % This should be zerosm(...).

    for k = 0:clifford_descriptor.n
        for s = k:clifford_descriptor.n
            lk = grade(l, k);           if isempty(lk), continue, end
            rs = grade(r, s);           if isempty(rs), continue, end
            g = grade(lk .* rs, s - k); if isempty(g),  continue, end
            m = m + g;
        end
    end
 
else

    % One of the arguments is not a multivector. If it is numeric, we can
    % handle it.
    
    if ml && isa(r, 'numeric')
        m = left_contraction(l, clifford(r));
    elseif isa(l, 'numeric') && mr
        m = left_contraction(clifford(l), r);
    else
        error('Left contraction of a Clifford multivector with a non-numeric is not defined.')
    end
end

end

% $Id: left_contraction.m 63 2016-06-20 11:36:32Z sangwine $
