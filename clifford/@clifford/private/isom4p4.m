function M = isom4p4(m)
% Private function to convert a multivector array in Cl(p, q) to a 
% multivector in Cl(p-4, q+4) using isomorphism. On return the current
% algebra is Cl(p-4, q+4).

% Copyright (c) 2015, 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Reference:
%
% Pertti Lounesto, Clifford Algebras and Spinors,
% London Mathematical Society Lecture Note Series 286,
% Cambridge University Press, 2nd edition, 2001.
% Sections 16.3, 16.4 and Table 1, pp214-217.

global clifford_descriptor

if clifford_descriptor.signature(3) ~= 0
   error(['In private function ', mfilename, ' isomorphism is not implemented for r > 0'])
   % TODO It is possible that this function could be extended to the case r == 0.
end

if any(clifford_descriptor.signature ~= get_signature(m))
    % The current signature doesn't match that of the input parameter, so
    % switch to it, before we proceed.
    clifford_signature(get_signature(m));
end

p = clifford_descriptor.signature(1);
q = clifford_descriptor.signature(2);

% The key is to construct an index vector that expresses the mapping from
% multivector elements in Cl(p,q) to elements in Cl(p-4,q+4), but we also
% need a corresponding table of sign changes. The mapping varies according
% to the values of p and q, and we compute it dynamically here. TODO
% Consider whether this could be stored in the descriptor of the current
% algebra, since it is specific to the current algebra.

if clifford_descriptor.m < 16
    error('Private function should not be called for algebras with m < 16')
end

index = zeros(1, clifford_descriptor.m, 'uint32');
signs = false(1, clifford_descriptor.m);

% Make a mask that extracts from an index, the four bits that need mapping.
% These may be in the 'middle' of the word or at one end, depending on the
% size of algebra and the value of p.

o = p-4+1;

mask = sum(bitset(0, o:p));

% Create the lookup tables for mapping from the extracted 4-bit binary
% index to a new 4-bit binary index and also the associated sign bit.

index4 =  uint16([0 14 13  3 11  5  6  8  7  9 10  4 12  2  1 15]);
signs4 = logical([0  0  1  1  0  1  1  0  1  1  1  1  1  0  1  0]);

for J = 1:clifford_descriptor.m % For each possible index into multivector.

    % J is a Matlab index into the components of the multivector, which are
    % stored in grade order (e0, e1, e2, ..., e12, ..., e123, ...). We need
    % to convert it to a binary index, in order to extract the 4-bit field
    % corresponding to a sub-algebra isomorphic to Cl(0,4).
    
    K = clifford_descriptor.index_table(J);

    B = bitand(K , mask);       % Extract the 4-bits we need.
    C = bitshift(B, -int32(o-1)); % Shift to the least significant end.
    D = index4(C + 1);          % Add 1 to convert to a 1-based index.
    
    % Now we need to insert the 4 bits in D into the place where the 4 bits
    % in B came from. We clear the bits from K by XOR, then we can insert
    % the new bits using an OR operation.
    
    L = bitor(bitxor(K, B), bitshift(D, o-1));
    
    % L is now the binary index in the new algebra corresponding to the J/K
    % indices in the old algebra. We need to convert this back to a
    % grade/lexical index to match J.
    
    index(J) = clifford_descriptor.reverse_index_table(L + 1);
    signs(J) = signs4(D + 1);
end

assert(p >= 4); % Guard against attempts to move to an algebra with p < 0.

clifford_signature(p - 4, q + 4);

M = clifford.empty; % Make an empty output multivector in the new algebra.

M.multivector = m.multivector(index);
     
M.multivector(signs) = cellfun(@uminus, M.multivector(signs), 'UniformOutput', false);

end

% $Id: isom4p4.m 94 2016-07-28 20:09:40Z sangwine $
