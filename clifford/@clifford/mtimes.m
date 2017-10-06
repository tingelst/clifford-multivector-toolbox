function m = mtimes(l, r)
% *  Matrix multiply.
% (Clifford overloading of standard Matlab function.)
 
% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor;

index = 1:clifford_descriptor.m;

ml = isa(l, 'clifford');
mr = isa(r, 'clifford');

if ml && mr
    
    % Both arguments are multivectors.
    
    check_signature(l);
    check_signature(r);
    
    if isempty(l), m = l; return, end
    if isempty(r), m = r; return, end
    
    [lrows, lcols] = size(l);
    [rrows, rcols] = size(r);
    
    if ~(isscalar(l) || isscalar(r) || lcols == rrows)
        error('Left and right operands must be conformable or one must be scalar.')
    end
    
    c = classm(l);
    if c ~= classm(r)
        % NB Empty components have a class, so even if the scalar part is
        % empty it enables us to check the class of the components.
        error('Left and right operands must have components of the same class.')
    end
    
    m = clifford(); % Create a result array.
        
    % Each component of the result multivector is the sum of m products
    % of pairs of components of the left and right operands. Each
    % product has a sign identified in the sign field of the descriptor
    % and it contributes to an element of the result identified by the
    % index field of the descriptor.
    
    nel = ~cellfun(@isempty, l.multivector); % Not empty left.
    ner = ~cellfun(@isempty, r.multivector); % Not empty right.
    
    for row = index(nel)
        lr = l.multivector{row};
        for col = index(ner)
            switch clifford_descriptor.sign(row, col)
                case -1
                    p = lr * r.multivector{col};
                    I = clifford_descriptor.index(row, col);
                    if isempty(m.multivector{I})
                        m.multivector{I} = -p;
                    elseif ~isempty(p)
                        m.multivector{I} = m.multivector{I} - p;
                    end
                case 0
                    % If the result currently has an empty in the e0
                    % element, we need to put an explicit zero array there.
                    % Otherwise we can just do nothing, because the product
                    % will be zero because of the zero sign.
                    
                    if isempty(m.multivector{1})
                        m.multivector{1} = zeros(size(lrows, rcols), c);
                    end
                case +1
                    p = lr * r.multivector{col};
                    I = clifford_descriptor.index(row, col);
                    if isempty(m.multivector{I})
                        m.multivector{I} = p;
                    elseif ~isempty(p)
                        m.multivector{I} = m.multivector{I} + p;
                    end
                otherwise
                    error(['Program error, descriptor sign array ', ...
                           'has value not in set {-1, 0, +1}'])
            end       
        end
    end
    
else

    % One of the arguments is not a multivector. If it is numeric, we can
    % handle it: we just need to multiply all the elements of the
    % multivector by the numeric argument. If the numeric argument is empty
    % the result will be a multivector with empty components.
    
    if ml && isa(r, 'numeric')
        check_signature(l);
        m = l;
        nem = ~cellfun(@isempty, m.multivector); % Not empty m.
        for j = index(nem)
            m.multivector{j} = m.multivector{j} * r;
        end
    elseif isa(l, 'numeric') && mr
        check_signature(r);
        m = r;
        nem = ~cellfun(@isempty, m.multivector); % Not empty m.
        for j = index(nem)
            m.multivector{j} = l * m.multivector{j};
        end
    else
        error('Multiplication of a Clifford multivector by a non-numeric is not implemented.')
    end
end

m = suppress_zeros(m);

end
% $Id: mtimes.m 63 2016-06-20 11:36:32Z sangwine $