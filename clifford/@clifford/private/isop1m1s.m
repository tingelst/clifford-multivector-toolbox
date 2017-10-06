function M = isop1m1s(m)
% Clifford multivector to multivector isomorphism conversion. This is a
% private function to convert a multivector array in Cl(p, q) to a
% multivector array in Cl(q+1, p-1). The 's' in the filename stands for
% swap or symmetry, as the p parameter in the new algebra is computed from
% the q parameter in the old algebra. This function is self-inverse. This
% function also has an important side-effect: it changes the current
% algebra to Cl(q+1, p-1) before return.

% Copyright (c) 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Reference:
%
% Pertti Lounesto, Clifford Algebras and Spinors,
% London Mathematical Society Lecture Note Series 286,
% Cambridge University Press, 2nd edition, 2001.
% Section 16.3, p215.

global clifford_descriptor

if clifford_descriptor.signature(3) ~= 0
   error(['In private function ', mfilename, ' isomorphism is not implemented for r > 0'])
   % TODO It is possible that this function could be extended to the case
   % r == 0 with further study.
end

if any(clifford_descriptor.signature ~= get_signature(m))
    % The current signature doesn't match that of the input parameter, so
    % switch to it, before we proceed.
    clifford_signature(get_signature(m));
end

% Since this is a private function, errors here cannot be the user's fault,
% so we use assertions to guard against attempts to convert from an algebra
% with p = 0, which would lead to negative q in the new algebra.

p = clifford_descriptor.signature(1); assert(p > 0);
q = clifford_descriptor.signature(2);

% Create index and sign tables which will ultimately be used to map the
% components of the input multivector to the components of the output
% multivector, with a sign change if needed. These tables are in
% grade/lexical order. The contents of both tables apply to the new
% algebra, whereas the indices are in the old. The signs are applied to the
% old multivector components as they are mapped across to the new
% multivector.

index =  ones(1, clifford_descriptor.m, 'uint32'); % We handle e0 by the
signs = false(1, clifford_descriptor.m);           % initialisation to ones.

% Create a bit field mapping to convert the bit ordering of the basis
% vectors in the input algebra to the bit ordering of the basis vectors in
% the output algebra. We will use this table in the loop below to implement
% the mapping. The binary representation of any multivector index has n
% bits, so we need m = 2^n entries in our table. In the old algebra the
% vectors are numbered in sequence from 1:p (positive squares) followed by
% p+1:p+q (negative squares). We must re-order so that bit 1 stays in
% place, and bits p+1:p+q follow bit 1, with bits 2:p at the end.

bitmap = zeros(1, clifford_descriptor.m, 'uint32');

% TODO This array is needed to store whether or not a change of sign is
% needed due to the bit mapping. We found the need for this on 22 July
% 2016, and EH worked out that it is due to re-ordering of the basis
% vectors after mapping to the new algebra. So the sign here is dependent
% on how many bits are present in the two fields BP and BN below. We have
% not worked out exactly how it is done, but it could be some sort of
% parity on the total or the difference.
bitsigns = false(size(bitmap));

% We need to use the new values of p and q here.

P = q + 1;
Q = p - 1;

for I = 1:length(bitmap)
   B = fliplr(dec2bin(I - 1, clifford_descriptor.n));
   BP = B(P+1:P+Q); NBP = sum(BP == '1');
   BN = B(2:P);     NBN = sum(BN == '1');
   C = fliplr([B(1), BP, BN]);
   bitmap(I) = cast(bin2dec(C), 'uint32');
end

for J = 1:clifford_descriptor.m % For each multivector component.
    K = clifford_descriptor.index_table(J); % Obtain the binary index.

    B = logical(bitget(K, 1)); % Find out whether K has the e1 bit set, as
                               % we need to take different actions in each
                               % case below according to whether the blade
                               % contains or doesn't contain e1 as a
                               % factor.

    % Count the number of bits in K, modulo 4, and use it to switch.
    
    switch mod(sum(dec2bin(K) == '1'), 4);
        case 1
            if B                
                L = K;
            else                
                L = bitset(K, 1); % Set the e1 bit.
                signs(J) = true;
            end
        case 2
            signs(J) = true;
            if B
                L = bitset(K, 1, 0); % Clear the e1 bit.
            else
                L = K;
            end            
        case 3
            if B
                L = K;
                signs(J) = true;
            else
                L = bitset(K, 1); % Set the e1 bit.
            end
        case 0
            if B
                L = bitset(K, 1, 0); % Clear the e1 bit.                
            else
                L = K;
            end
        otherwise
            error('Impossible: result of mod 4 is not in {0, 1, 2, 3}!');
    end
    
    index(J) = clifford_descriptor.reverse_index_table(bitmap(L + 1) + 1);
    signs(J) = xor(signs(J), bitsigns(L + 1)); % TODO This is untried, see above.
end

clifford_signature(q + 1, p - 1); % Switch to the new algebra.

M = clifford.empty; % Make an empty output multivector in the new algebra.

M.multivector = m.multivector(index);
     
M.multivector(signs) = cellfun(@uminus, M.multivector(signs), 'UniformOutput', false);

% TODO Work out whether the following method can be made to work, because
% it avoids the expensive call to cellfun.

% % Map the multivector components. We have to use subsref/subsasgn because
% % this is a class method.
% 
% % M.multivector( signs) =  m.multivector(index( signs));
% S = substruct('()', {index(signs)});
% T = substruct('()', {index(signs)});
% M = subsasgn(subsref(m.multivector, T), S);
% 
% % M.multivector(~signs) = -m.multivector(index(~signs));
% S = substruct('()', {~signs});
% T = substruct('()', {index(~signs)});
% M = subsasgn(subsref(-m.multivector, T), S);

end

% $Id$
