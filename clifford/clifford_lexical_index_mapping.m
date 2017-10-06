function [T, R, S] = clifford_lexical_index_mapping(n)
% Constructs tables that map from binary indices to lexically-ordered
% indices and vice versa, plus strings representing the basis blades.

% Copyright (c) 2011, 2016 Stephen J. Sangwine and Eckhard Hitzer.

% The two mappings computed here are between two different ways of indexing
% the components of a multivector. Assuming n is the number of basis
% vectors in an algebra (and therefore the number of elements in a
% multivector is m = 2^n), and that we denote basis vectors by e1, e2 etc,
% then the two representations are:
%
% 1. Lexical or grade-ordered index. This is the order in which the
%    components of multivectors are stored inside the cell array within
%    the multivector, and also the order in which the components are
%    displayed. In this order, the successive grades are stored in order
%    (scalar, vectors, bivectors, trivectors, ... , pseudoscalar), and
%    within each grade the indices are ordered lexically. This type of
%    index runs from 1 upwards, because it is used to index a cell array
%    inside the multivector, and Matlab uses 1-based indexing for arrays.
%
% 2. Binary index. An n-bit word (conceptually) contains one bit
%    representing each basis vector (e2, e2, e3 etc.). A combination of
%    bits represents a basis blade (example, e12 would have the bits set to
%    represent both e1 and e2). The least significant bit represents e1,
%    the most significant bit represents the n-th basis vector (most
%    significant meaning the n-th bit, not the most significant bit of the
%    Matlab data type used to represent the index). A value of zero, with
%    all bits clear, represents the unit element, e0, therefore the binary
%    index is 0-based, contrary to the usual Matlab convention.
%
%    The binary index is used in computations to manipulate basis blades
%    (by bitwise operations), for example, in computing isomorphisms.
%    Manipulation of the bits is equivalent to manipulation of the indices
%    in mathematical notation.
%
% Example: take n = 2, hence m = 4. The 16 possible 4-bit integers
% represent basis elements as follows (e0 is the identity element).
%
% 0000 = e0   0100 = e3    1000 = e4    1100 = e34
% 0001 = e1   0101 = e13   1001 = e14   1101 = e134
% 0010 = e2   0110 = e23   1010 = e24   1110 = e234
% 0011 = e12  0111 = e123  1011 = e124  1111 = e1234
%
% The natural binary ordering is thus:
%
% e0, e1,  e2,  e12,  e3,  e13,  e23,  e123,
% e4, e14, e24, e124, e34, e134, e234, e1234
%
% The lexical ordering places the elements in the following order, in which
% each line corresponds to 'grade' (equivalent to the number of ones in the
% binary representation):
%
% Grade 0: e0,
% Grade 1: e1,   e2,   e3,   e4,
% Grade 2: e12,  e13,  e14,  e23, e24, e34,
% Grade 3: e123, e124, e134, e234,
% Grade 4: e1234
%
% The return parameters are in 1:1 correspondence. Each contains:
%
% T an array of integer index values.
% R an array of integer reverse index values.
% S a cell array of strings such as 'e1', 'e12'.

% Check the sanity of the parameters.

narginchk(1, 1), nargoutchk(0, 3)

assert(isnumeric(n), 'Parameter must be numeric.');
assert( isscalar(n), 'Parameter must be scalar.');
assert(      n >= 0, 'Parameter must be non-negative.');
assert( fix(n) == n, 'Parameter must be an integer.');

m = 2 .^ cast(n,  'uint16');

% Compute the index values in natural binary order, and the corresponding
% lexical representations, and the grades of each index value.

K = 0:m - 1; % This generates the set of index values 0, 1, 2, .... etc.
L = cell(1, m); % This is used for the strings 'e1', 'e12', ... etc.
G = zeros(size(K), 'uint8'); % And this array is for the grades (0 .. m).

for I = 1:length(K)
    L{I} = clifford_literal(I - 1, n);
    G(I) = sum(bitget(K(I), 1:n));
end

% Note that it is tricky to calculate where to store values into T, because
% the calculation is done by grade. The easy way out is to concatenate
% entries onto the end of the array as we go.

T = uint16.empty; % Initialise an empty array for the index values.
S = {};                 % Initialise an empty cell array for the strings.

for H = 0:n % For each possible grade ...
    
    % Extract from L all the entries of grade G, and sort them into lexical
    % order.
    
    I = G == H; % These are logical indices into K and L.
    C = K(I);   % Elements of K, addressed by the logical indices.
    
    [B, IX] = sort({L{I}});
    
    % Concatenate the re-ordered entries on the end of T and S.
    
    T = [T, C(IX)]; S = [S, B];
    
end

% Now make the reverse mapping. This maps from a binary index in which each
% bit represents a basis vector (least significant bit represents e1) to a
% lexical index, which is the order in which the components of a
% multivector are stored (and displayed) (e0, e1, e2, ..., e12, ..., e123,
% ... <pseudoscalar>). NB Since Matlab indices are 1-based, the indices
% stored in this table are 1-based, so an entry of 1 represents e0.

[~, R] = sort(T);

end

% $Id: clifford_lexical_index_mapping.m 83 2016-07-19 13:40:31Z sangwine $
