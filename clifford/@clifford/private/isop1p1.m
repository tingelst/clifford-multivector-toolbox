function m = isop1p1(M)
% Clifford multivector block matrix to multivector conversion. This is a
% private function to convert a multivector array in Mat(2, Cl(p, q)) to a
% multivector array in Cl(p+1, q+1) using isomorphism with 2-by-2 matrices.
% This function reverses the conversion carried out by c2m. The result has
% half the number of rows and columns as the input parameter, and it is
% represented in algebra Cl(p+1,q+1). This function also has an important
% side-effect: it changes the current algebra to Cl(p+1,q+1) before return.

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
   % TODO It is possible that this function could be extended to the case
   % r == 0 with further study.
end

if any(clifford_descriptor.signature ~= get_signature(M))
    % The current signature doesn't match that of the input parameter, so
    % switch to it, before we proceed.
    clifford_signature(get_signature(M));
end

MS = size(M); % We could find the size of the input parameter later, but we
              % do it now to be safe, while we are still in Cl(p, q).
              
% Verify that M has a multiple of two rows and columns (other dimensions
% don't matter). If it doesn't it can't be a valid matrix representation of
% a multivector in Cl(p+1, q+1).

assert(all(rem(MS(1:2), 2) == 0))

R = MS(1); % Number of rows in M.
C = MS(2); % Number of columns in M.

J = R ./ 2; % Half the number of rows in M (exact).
K = C ./ 2; % Half the number of columns in M (exact).

% This is a (private) class method, so we have to use subsref here and not
% regular matrix indexing.

M11 = subsref(M, substruct('()', {  1:J,   1:K})); % TODO This will fail if
M12 = subsref(M, substruct('()', {  1:J, K+1:C})); % M has more than 2
M21 = subsref(M, substruct('()', {J+1:R,   1:K})); % dimensions.
M22 = subsref(M, substruct('()', {J+1:R, K+1:C})); assert(ndims(M) <= 2);

M1 = (M11 + grade_involution(M22)) ./ 2;
M2 = (M12 + grade_involution(M21)) ./ 2;
M3 = (grade_involution(M21) - M12) ./ 2;
M4 = (M11 - grade_involution(M22)) ./ 2;

p = clifford_descriptor.signature(1);
q = clifford_descriptor.signature(2);

clifford_signature(p+1, q+1);

m1 = translate(M1);
m2 = translate(M2);
m3 = translate(M3);
m4 = translate(M4);

index_characters = '123456789abcdefg';

b2 = eval(['e' index_characters(p+1)]);
b3 = eval(['e' index_characters(p+1+q+1)]);
b4 = eval(['e' index_characters([p+1 p+1+q+1])]);

m = m1 + m2 .* b2 + m3 .* b3 + m4 .* b4;

    function M = translate(m)
        % Function to map from a multivector in Cl(p, q) to a result in
        % Cl(p+1,q+1). NB We must be in Cl(p+1, q+1).
        
        % We need here to copy across components 0 and 1:p p+2:p+1+q and
        % all products of the vectors. The components we don't need have
        % vector index p+1 and p+1+q+1.
        
        L = ~(logical(bitget(clifford_descriptor.index_table, p+1    )) | ...
              logical(bitget(clifford_descriptor.index_table, p+1+q+1)));
                        
        M = clifford(); % Create an empty multivector in Cl(p+1, q+1).
        
        M.multivector(L) = m.multivector;
    end
end

% $Id: isop1p1.m 94 2016-07-28 20:09:40Z sangwine $
