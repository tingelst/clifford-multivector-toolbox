function Z = power(X, Y)
% .^   Array power.
% (Clifford overloading of standard Matlab function.)

% This function was adapted from the Quaternion Toolbox for Matlab (QTFM).
% TODO Some powers may not yet work because the necessary functions are not
% yet implemented.

% Copyright (c) 2015, 2016 Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

global clifford_descriptor

% This function can handle left and right parameters of the same size, or
% cases where one or other is a scalar.  The general case of a matrix or
% vector raised to a matrix or vector power requires elementwise operations
% and is handled using a general formula using logarithms, even though some
% of the elements of the right argument may be special cases (discussed
% below).

% When the right operand is a scalar, some special cases are handled using
% specific formulae because of the greater accuracy or better speed
% available. E.g. for Y == -1, the elementwise inverse is used, for Y == 2,
% elementwise squaring is used.

% For a power of +/- 1/2, the sqrt function is used, with or without a
% reciprocal.

if isscalar(Y)
    
    isny = isnumeric(Y);
    
    % Y is a scalar. Check for and handle the various numeric powers that
    % are dealt with as special cases.
    
    if     isny && Y == -2, Z = (X .* X) .^ -1; % Use the next case recursively.
    elseif isny && Y == -1
        
        % Inverse of a multivector, raising to the power -1. The algorithms
        % used below (except for the trivial case of algebras with less
        % than three grades) were developed by the authors of the toolbox
        % during 2015 and 2016.
        %
        % Reference:
        %
        % Hitzer, E. and Sangwine, S. J.,
        % 'Multivector and multivector matrix inverses in real Clifford
        % algebras', Applied Mathematics and Computation, in press,
        % accepted 2 May 2017.
        %
        % TODO: Add DOI and volume/issue/page details when available.
        %
        % A preprint is available as: Technical Report CES-534, School of
        % Computer Science and Electronic Engineering, University of Essex,
        % 21 July 2016, available at: http://repository.essex.ac.uk/17282/.

        s = clifford_descriptor.signature;
        if s(3) ~= 0
            % Assumed, this has not been proven mathematically ...
            error(['The inverse of a multivector cannot be ' ...
                   'computed in an algebra with signature ' num2str(s) ...
                   ' because there are basis blades that square to zero.'])
        end
        
        % The algorithm for computing the inverse becomes more complicated
        % as we add higher grades. To avoid needless function calls in the
        % lower algebras, we check the dimensionality of the algebra and
        % choose the appropriate method.
        
        check_signature(X);
        
        switch clifford_descriptor.n
            case {1, 2}
                P = conj(X);
            case 3
                % P = conj(X) .* grade_involution(X) .* reverse(X);
                Q = conj(X); P = Q .* involution(X .* Q, 3);
            case 4
                % P = conj(X) .* involution(X .* conj(X), [3,4]);
                Q = conj(X); P = Q .* involution(X .* Q, [3, 4]);
            case 5
                L = conj(X) .* grade_involution(X) .* reverse(X);
                P = L .* involution(X .* L, [1, 4]);
            otherwise
                
                % For higher grades we use isomporphisms to represent the
                % multivector in a different algebra, compute the inverse
                % in the different algebra, then map the result back to the
                % current algebra.
                                
                S = get_signature(X); p = S(1); q = S(2); r = S(3);

                if r ~= 0
                    error('Cannot handle algebra with r > 0');
                end
                
                if p == 0 && q == 0
                    % TODO Avoid the constructor here?
                    Z = clifford(power(part(X,1), -1));
                    return
                end
                
                % TODO We have available isomorphisms which can add or
                % subtract 8 to/from p or q. These could be used below to
                % implement large jumps in signature in one step (although
                % the current implementation is done using the 2x2 matrix
                % and plus/minus 4 isomorphisms). E.g. we could move from
                % algebra Cl(0,9) to Cl(0,1) in one step using c2cm8q.
                
                if p ~= 0 && q ~= 0
                    % Use an isomorphism with 2x2 matrices, reducing p and
                    % q by one each and then computing the matrix inverse.
                    % TODO Ideally here we could use arrayfun if this is
                    % implemented for multivector arrays. But for now we
                    % use iteration, treating X as a one-dimensional array
                    % so that we can handle any number of dimensions.
                    
                    Z = X; % Make a copy of the input array to preallocate.
                    for i = 1:numel(X)
                        % Z(i) = isop1p1(inv(isom1m1(X(i))));
                        S = substruct('()', {i});
                        Z = subsasgn(Z, S, ...
                                     isop1p1(inv(isom1m1(subsref(X, S)))));
                    end
                    return
                else
                     % One of p or q is zero (we checked above for both
                     % equal to zero), so we can't use the matrix
                     % isomorphism. Instead we use a p+4,q-4 or p-4,q+4
                     % isomorphism. This doesn't directly enable us to
                     % compute the inverse, but it does enable the
                     % recursive call to use the matrix isomorphism above.
                     
                    if p == 0
                        Z = isom4p4(power(isop4m4(X), Y));
                        return
                    else
                        assert(q == 0);
                        Z = isop4m4(power(isom4p4(X), Y));
                        return
                    end
                end
                
        end
        A = X .* P;
        
        R = A - scalar(A); % This should be zero or empty, or close.
        M = abs(R) ./ abs(X);
        assert(isempty(R) || all(M(:) < 1e-3), ['Assertion failed: ', ...
                                                 num2str(max(M(:)))])
        
        % The right division that follows needs to be a numeric
        % division and not a multivector division, and we have just
        % checked that all except the scalar part of A is zero or
        % close to it.
        
        % TODO Check that component(A, 1) has no components close to zero,
        % which would indicate that X is a divisor of zero.
        
        Z = P ./ component(A, 1);
    elseif isny && Y == 0
        Z = ones(size(X));
    elseif isny && Y == 1
        Z = X;
    elseif isny && Y == 2
        Z = X .* X;
    elseif isny && Y == 1/2
        Z = sqrt(X);
    elseif isny && Y == -1/2
        Z = sqrt(X .^ -1); % Use the case Y == -1 above recursively.
    else
        Z = general_case(X, Y);
    end
    
elseif isscalar(X)

    % X is a scalar, but Y is not (otherwise it would have been handled
    % above). The general case code will handle this, since it will expand
    % X to the same size as Y before pointwise multiplication.
    
    Z = general_case(X, Y);

else
    
    % Neither X nor Y is a scalar, therefore we have to use the general
    % method, but first we need to check that the sizes of the parameters
    % match, otherwise an error will occur in the pointwise multiply when
    % the logarithm is multiplied by the exponent.
    
    if ~all(size(X) == size(Y))
        error('Matrix dimensions must agree.');
    end
    
    Z = general_case(X, Y);

end

function Z = general_case(X, Y)

% Whether this will work for Clifford multivectors is not known.

check_signature(X);
check_signature(Y);
        
Z = exp(log(X) .* Y); % NB log(X) is the natural logarithm of X.
                      % (Matlab convention.)

% $Id: power.m 125 2017-05-03 14:19:22Z sangwine $
