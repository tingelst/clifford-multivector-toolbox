function M = isom1m1(m)
% Clifford multivector to matrix of multivector conversion. This is a
% private function to convert a multivector array in Cl(p, q) to a
% multivector array in Mat(2, Cl(p-1, q-1)) using isomorphism with 2-by-2
% matrices. The result has double the number of rows and columns as the
% input parameter, and each multivector in the input is represented by a
% 2-by-2 matrix of multivectors in algebra Cl(p-1,q-1) in the output. This
% function also has an important side-effect: it changes the current
% algebra to Cl(p-1,q-1) before return.

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

if any(clifford_descriptor.signature ~= get_signature(m))
    % The current signature doesn't match that of the input parameter, so
    % switch to it, before we proceed.
    clifford_signature(get_signature(m));
end

index_characters = '123456789abcdefg';

% Since this is a private function, errors here cannot be the user's fault,
% so we use assertions to guard against attempts to move to an algebra with
% negative p or q.

p = clifford_descriptor.signature(1); assert(p > 0);
q = clifford_descriptor.signature(2); assert(q > 0);

p = p - 1;
q = q - 1;

assert(clifford_descriptor.signature(3) == 0); % We checked this above.

if p == 0 && q == 0
    b1 = e0; % TODO There ought to be a more elegant way to achieve this,
             % without the need for the IF test. The problem is that 1:p is
             % an empty range when p == 0.
else
    b1 = eval(['e' index_characters([1:p, p+2:p+1+q])]);
end
b2 = eval(['e' index_characters(1:p+1+q)]);
b3 = eval(['e' index_characters(p+1)]);
b4 = eval(['e' index_characters([1:p p+2:p+1+q+1])]);
b5 = eval(['e' index_characters(p+1+q+1)]);
b6 = b3 .* b5;

% TODO The computations below are capable of being replaced by bit shifting
% and component moves. Making this change would probably reduce rounding
% errors and increase the speed of computation. As a side effect, we would
% no longer need the sub-function inverse below, which is crudely coded and
% inelegant.

m1 = left_contraction(m, b1)  .* inverse(b1);
m2 = right_contraction(left_contraction(m - m1,      b2) .* inverse(b2), inverse(b3));
m3 = right_contraction(left_contraction(m - m1 - m2, b4) .* inverse(b4), inverse(b5));
m4 = right_contraction(m - m1 - m2 - m3, inverse(b6));

D = clifford_descriptor; % Save algebra Cl(p, q) to use later.

clifford_signature(p, q); % Switch to the algebra of the result.

% Create the output argument in algebra Cl(p-1, q-1). It must have a 2-by-2
% matrix in place of each element of the input, with elements of the same
% class as elements of the input.

M1 = translate(m1);
M2 = translate(m2);
M3 = translate(m3);
M4 = translate(m4);

M = [                 M1 + M4,                    M2 - M3; ...
     grade_involution(M2 + M3),  grade_involution(M1 - M4)];
 
return

    function M = translate(m)
        % Map from a multivector in Cl(p, q) to a result in Cl(p-1,q-1).
        % NB We must be in Cl(p-1, q-1) even though m is in Cl(p, q).
        
        M = clifford.empty; % Create an empty multivector in Cl(p-1, q-1).
        
        % We need here to copy across components 0 and 1:p p+2:p+1+q and
        % all products of the vectors. The components we don't need have
        % vector index p+1 and p+1+q+1. TODO Check this statement.
        
        P = ~(logical(bitget(D.index_table, p+1    )) | ...
              logical(bitget(D.index_table, p+1+q+1)));
                        
        % The next step is where the real jiggery-pokery is done, since the
        % two multivectors are in different algebras. However, the number
        % of elements on the right side selected by P will match the number
        % required on the left side.
        
        M.multivector = m.multivector(P);
    end

    function d = inverse(e)
        % TODO Replace this with a better method. Why did we do this? NB In
        % some cases the inverse is simply -e, but in some it is +e.
        % Temporary inverse, the argument must be a basis blade (example e13).
        % (NB If we eliminate the use of left and right contractions above,
        % we will no longer need this function.)
        d = e .* e .* e;
    end

end

% $Id: isom1m1.m 94 2016-07-28 20:09:40Z sangwine $
