function m = plus(l, r)
% +   Plus.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2013, 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor;

% Three cases have to be handled:
%
% l is a multivector, r is not,
% r is a multivector, l is not,
% l and r are both multivectors.

% An additional complication is that the parameters may be empty (numeric,
% one only) or empty (multivector, one or both). Matlab adds empty + scalar
% to give empty: [] + 2 gives [], not 2, but raises an error (Matrix
% dimensions must agree) on attempting to add empty to an array. This
% behaviour is copied here, whether the empty parameter is a multivector or
% a numeric empty. The result is always a multivector empty. However, this
% does not apply to empty components within a multivector, which are
% treated as zero. This is to permit blades to be represented with empty
% components which are treated as zero in arithmetic operations.

cl = isa(l, 'clifford');
cr = isa(r, 'clifford');

if cl, check_signature(l); end
if cr, check_signature(r); end

% Find the sizes and classes of the arguments or their components if they
% are multivectors.

if cl, ls = size(l); lc = class(part(l, 1)); ... % TODO Use classm here.
else   ls = size(l); lc = class(l); end
if cr, rs = size(r); rc = class(part(r, 1)); ... % TODO Use classm here.
else   rs = size(r); rc = class(r); end

pl = prod(ls); % The product of the elements of size(l).
pr = prod(rs); % The product of the elements of size(r).

sl = pl == 1; % Equivalent to isscalar(l), since ls must be [1,1]. Note 1.
sr = pr == 1; % Equivalent to isscalar(r).

el = pl == 0; % Equivalent to isempty(l), since ls must be [0,0], without
er = pr == 0; % calling an isempty function (clifford or Matlab). Note 2.

% Now check for the case where one or other argument is empty and the other
% is scalar. In this case we choose to return an empty multivector, similar
% to the behaviour of Matlab's plus function.

if (el && sr) || (sl && er)
    m = clifford.empty;
    return
end

% Having now eliminated the cases where one parameter is empty and the
% other is scalar, the parameters must now be compatible in size, or one
% must be scalar. To permit implicit singleton expansion, we do not check
% for compatibility of size: we let Matlab's underlying functions do that.
% It could also be that they are both empty arrays of size [0, n] or [n, 0]
% etc, in which case we must return an empty array of the same size to
% match Matlab's behaviour.

eq = all(ls == rs); % True if l and r have the same size.

% if ~(eq || sl || sr)
%     error('Matrix dimensions must agree.'); Commented out 22 April 2017
% end

if ~strcmp(lc, rc)
    error(['Class of left and right parameters does not match: ', ...
           lc, ' ', rc])
end

if el && er
   % We must return an empty (multivector) matrix.
   if cl && cr
       m = l; % r would do just as well, since both are multivectors.
   elseif cl
       m = l; % This must be l because r isn't a multivector.
   else
       m = r; % This must be r because l isn't a multivector.
   end
   return
end

if cl && cr
    m = l; % Copy one of the arguments to provide the initial result.
    
    for i = 1:clifford_descriptor.m
        a = l.multivector{i}; % Either of these, or both, could be empty.
        b = r.multivector{i};
        isea = isempty(a);
        iseb = isempty(b);
        if isea && iseb
            % Both components are empty, either will do to assign to m.
            m.multivector{i} = a; continue
        end
        if isea
            % a is empty, so use b as it is not, but we need to take care
            % in case b is a scalar, but a is not, to promote b to the size
            % of a.
            if sr && ~sl
                m.multivector{i} = repmat(b, ls);
            else
                m.multivector{i} = b;
            end
            continue
        end
        if iseb
            % b is empty, so use a as it is not, but we need to take care
            % in case a is a scalar, but b is not, to promote a to the size
            % of b.
            if sl && ~sr
                m.multivector{i} = repmat(a, rs);
            else
                m.multivector{i} = a;
            end
            continue
        end
        % The general case. We are adding two non-empty components here, so
        % Matlab will promote one of them to the size of the other if they
        % don't match in size (because one is scalar).
        m.multivector{i} = a + b;
    end
elseif isa(r, 'numeric')
    
    % The left parameter must be a multivector, otherwise this function
    % would not have been called. Add the right parameter to the e0
    % component of the left parameter.

    m = l;
    if ~isempty(m.multivector{1})   
        m.multivector{1} = m.multivector{1} + r;
    else
        if eq
            m.multivector{1} = r;
        else
            m.multivector{1} = repmat(r, ls);
        end
    end

elseif isa(l, 'numeric')
    
    % The right parameter must be a multivector, otherwise this function
    % would not have been called. Add the left parameter to the e0
    % component of the right parameter.
    
    m = r;
    if ~isempty(m.multivector{1})
        m.multivector{1} = m.multivector{1} + l;
    else
        if eq
            m.multivector{1} = l;
        else
            m.multivector{1} = repmat(l, rs);
        end
    end

else
  error('Unhandled parameter types in function +/plus')
end

m = suppress_zeros(m);

end

% Note 1. Actually ls could be [1,1,1] or [1,1,1,...], but these cases are
% treated as scalar by Matlab (try it with rand(1,1,1) to see).

% Note 2. Actually ls could be [0,1,2,....], which is also empty. However,
% Matlab will add two arrays of this type of the same size to yield another
% empty array of the same size.

% $Id: plus.m 122 2017-04-22 19:52:39Z sangwine $
