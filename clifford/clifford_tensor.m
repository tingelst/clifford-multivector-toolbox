function g = clifford_tensor(p, q, r)
% CLIFFORD_TENSOR computes a tensor which represents the multiplication
% rules for the Clifford algebra Cl(p,q,r).

% Copyright (c) 2011, 2014 Stephen J. Sangwine and Eckhard Hitzer.

% The tensor g is a 3-dimensional array of dimension [m, m, m], where
% m = 2.^n and n = p + q. The parameters p and q are the usual values
% representing the numbers of basis elements of the vector space that
% square to +1 and -1 respectively. Elements of the tensor are in the set
% {-1, 0, +1} and every 'row' (in any direction) has at most one non-zero
% element. The tensor encodes the multiplication rules of the algebra.
% The formal details are given in the paper below by Perwass et al, using
% tensor notation and the Einstein summation convention, but a simpler
% account is given in the paper by Schultz et al, in which the matrices Tx
% are the planes of the tensor with the third index constant.

% References:
%
% 1. C. Perwass, C. Gebken and G. Sommer,
% 'Estimation of geometric entities and operators from uncertain data',
% in W. G. Kropatsch, R. Sablatnig and A. Hanbury (editors),
% PATTERN RECOGNITION, PROCEEDINGS, 27th Annual Meeting of the German
% Association for Pattern Recognition, Vienna University of Technology,
% Vienna, Austria, 31 August - 2 September 2005.
% LECTURE NOTES IN COMPUTER SCIENCE, Vol. 3663, pp.459-467.
% SPRINGER-VERLAG BERLIN.
%
% (The tensor g is defined in ?2, on p461.)
%
% 2. Dominik Schulz, Jochen Seitz and Joao Paulo C. Lustosa da Costa,
% 'Widely Linear SIMO Filtering for Hypercomplex Numbers',
% 2011 IEEE Information Theory Workshop (ITW 2011), 16-20 October, 2011,
% Paraty, Brazil.
%
% (The matrices Tx which are planes of the tensor are defined in equation
% 1, ?II.B.)
%
% The tensor is computed in natural binary order, and then re-ordered
% before return into lexical order, which is the order in which it is most
% naturally expressed and used elsewhere.

% Check the sanity of the parameters.

narginchk(3, 3), nargoutchk(0, 1)

assert(isnumeric(p) && isnumeric(q) && isnumeric(r), 'Parameters must be numeric.');
assert( isscalar(p) &&  isscalar(q) &&  isscalar(r), 'Parameters must be scalars.');
assert(      p >= 0 && q >= 0       && r >= 0,       'Parameters must be non-negative.');
assert( fix(p) == p && fix(q) == q  && fix(r) == r,  'Parameters must be integers.');
assert(p + q + r >= 0, 'Parameters must sum to a non-negative value.');

n = uint32(p + q + r); m = 2 .^ n;

g = zeros([m, m, m], 'int8'); % Pre-allocate the tensor.

% The algebra Cl(p,q,r) has p basis elements that square to +1, q that
% square to -1 and r that square to 0. We represent this by the following
% vector.

e = [ones([1, p], 'int8'), -ones([1, q], 'int8'), zeros([1, r], 'int8')];

% Now iterate over two of the indices of the tensor (I, J). For each pair
% of indices, there is at most one element along the corresponding 'row' in
% the tensor which has a non-zero value, and this value is +1 or -1. So, we
% have to compute the value, and the index where it belongs. The indices I
% and J represent products of basis elements of the algebra (conventionally
% denoted e_1, e_2 etc). If a bit is set in the binary representation of
% the index, the corresponding basis element is present in a product. When
% we multiply the product of elements I by J we get a result with sign S.

for I = 0:m-1 %#ok<*BDSCI>
    for J = 0:m-1        
        S = ones('int8'); % This is the sign (+1, 0, or -1 ultimately).
        
        % Stage 1. Eliminate the common basis elements from the I and J
        % values. Notionally, we are moving an element inside the product
        % represented by I to the right, and the same element inside the
        % product represented by J to the left, in order to cancel them
        % out. The number of position swaps we have to do is the number of
        % sign changes. In addition when we eliminate an element, we must
        % take account of the sign of its square, which is determined by
        % the values of p and q.
        
        C = bitand(I, J); % This represents the common terms.
        
        for t = 1:n % Bits in Matlab are numbered from 1 upwards.
            if bitget(C, t) == 1
                % Calculate the number of swaps needed. This is composed of
                % the number of bits to the right of t in I, plus the
                % number to the left of t in J, less the number to the left
                % of t in C.
                N = sum(bitget(I, t+1:n), 'native') ... % Native ensures
                  + sum(bitget(J, 1:t-1), 'native') ... % the result in N
                  - sum(bitget(C, 1:t-1), 'native');    % is uint32.
                if bitget(N, 1) == 1
                   S = -S; % Negate because the number of swaps is odd.
                end
                S = S .* e(t); % Include the 'sign' of the basis element.   
            end
        end
        
        % Stage 2. Merge the non-common elements into lexical order, again
        % accumulating the signs as we do.
        
        UI = bitxor(I, C); % This clears any bits in I that are set in C.
        UJ = bitxor(J, C); % Ditto for J. Hence these two integers
                           % represent the non-common basis elements.
        for t = 1:n
            if bitget(UJ, t) == 1
                % The t element of the right product is present. Move it to
                % its position in the left, and take account of signs.
                CI = sum(bitget(UI, t+1:n), 'native');
                if bitget(CI, 1) == 1
                    S = -S; % Negate because the number of swaps is odd.
                end
            end
        end
                
        % Finally, the third index is the bitwise exclusive-OR of the other
        % two. Set the tensor at the resulting index to the sign we have
        % computed above. We have to add one to the index values because
        % Matlab arrays are indexed from 1.
        
        g(I + 1, J + 1, bitxor(I, J) + 1) = S;
    end
end

% At the moment, the tensor is in natural binary order because that was the
% easiest way to compute it. Convert it to lexical order before return,
% because that is the natural way to use it.

[index, ~, ~] = clifford_lexical_index_mapping(n);

index = index + 1; % Matlab indices run from 1.

g = g(index, index, index);

end

% $Id: clifford_tensor.m 88 2016-07-20 15:33:01Z sangwine $
