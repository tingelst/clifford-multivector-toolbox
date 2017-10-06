function test_multiplication_table
% Test code for the clifford multiplication table.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Checking multiplication table ...');

% The method used here is to test the products of all combinations of basis
% elements using character string manipulation as the reference case (the
% fundamental definition of multiplication of basis blades). For example,
% e12 * e13 = - e23. The result can be computed by concatenating the
% indices 12 and 13 to make 1213, then permuting and sign changing to
% obtain -1123, then replacing 11 with the sign of e1^2. The sign of the
% basis element squared must be taken into account, of course.

global clifford_descriptor

m = clifford_descriptor.m;
n = clifford_descriptor.n;

d = '0123456789abcdefg'; % Subscript digits, as in 'e123'.

% Compute the signs of the n basis blades, for use in the permutation
% algorithm below.

s = clifford_signature;

signs = ['+' ... % This is the sign of e0 squared, which is always positive
         repmat('+', [1, s(1)]) ... % p positive squares
         repmat('-', [1, s(2)]) ... % q negative squares
         repmat('0', [1, s(3)])];   % r zero squares.
     
assert(length(signs) == n + 1)

for row = 1:m % of the multiplication table, indexed in binary order.
    l = clifford_literal(row - 1, n);     % E.g. 'e123'
    for col = 1:m
        r = clifford_literal(col - 1, n); % E.g. 'e2'
        p = [l(2:end) r(2:end)];          % E.g. '1232'
                
        % Now we have in p the string of numeric indices, e.g. 1232, and in
        % s the initial sign (positive) which we must now reduce to canonic
        % form by permutation and sign changes.
        
        % The numeric indices may include letters for large algebras, but
        % these are lexically ordered correctly by Matlab, so we do not
        % need special treatment.
        
        % First sort the string into lexical order, and determine the
        % number of swaps needed. We do this by creating a permutation
        % matrix, the determinant of which gives us the sign directly
        % (-1 if an odd number of swaps, +1 if even).
        
        % Because e0 commutes we need to treat any zeros in p specially, by
        % not including them in the sort. Since zeros can occur only at the
        % start or end of the string, and a zero at the start is already
        % correctly sorted, we just need to move a zero at the end, if
        % present to the start.
        
        if p(end) == '0'
            p = ['0' p(1:end-1)];
        end
        
        % Now make a permutation matrix from the string p showing the swaps
        % needed to rearrange the matrix into lexical order. The
        % determinant of this matrix will give us the sign parity.
        
        [p, I] = sort(p); % Sort p into order. I is the index order needed.
       
        P = eye(length(p)); % Make an identity matrix, then ...
        P(1:end, I) = P;    % re-arrange the columns into the order in I.
        
        s = sign(det(P)); % The sign due to the parity of swaps.
        
        % We have the string in lexical order. Now remove duplicates.
        
        q = ''; % This will be the string without duplicates.
        
        while length(p) > 1
            if p(1) == p(2)
                % The first two characters of p are duplicates. We need to
                % compute a sign change, and remove the two duplicate
                % characters. The means that e1 * e1 will be replaced with
                % e0 (in effect) plus a 'sign' which may be -1, 0, or +1.
                
                % Index the signs table with the index of the character in
                % the string d (the list of subscripts).
                
                I = find(p(1) == d); assert(~isempty(I));
                switch signs(I)
                    case '+'
                        % Nothing to do here, the sign is positive. Since
                        % there is no no-operation statement in Matlab, we
                        % do a harmless unary plus.
                        s = +s;
                    case '-'
                        % We need to toggle the current sign value.
                        s = -s;
                    case '0'
                        % This means the entire result is going to be zero,
                        % so we could stop right here, but if we do, it
                        % makes the further processing complicated, so we
                        % will continue.
                        s = 0;
                    otherwise
                        error('Program error, found a sign not in {-1,0,+1}')
                end
                
                p(1:2) = ''; % Delete the pair of characters.
                
                if isempty(q) && isempty(p)
                    q = '0'; % This is needed for cases like e1 * e1, where
                             % otherwise q would be left empty.
                end
            else
                % The first character of p differs from the second, so just
                % move it across from the head of p to the tail of q.
                q = [q, p(1)]; p(1) = '';
            end
        end
        
        q = [q p]; % Move the last character from p.
        
        assert(length(p) == 1 || isempty(p));
        
        % Check for a leading zero and remove it if present. We need to
        % remove only one leading zero, since if we computed e0 * e0, we
        % would have two zeros only, and we want the final result to be
        % '0'. In all other cases, there can only be one zero at most, if
        % we multiplied e0 by something else.
        
        if ~strcmp(q, '0') && q(1) == '0'
            q(1) = '';
        end

        % Now for some trickery. We have the two literal values that we
        % started with, in the form 'e1', 'e123' etc. By evaluating the
        % string as a Matlab expression we can obtain the corresponding
        % basis element. This works, of course, because it results in a call
        % to the parameterless function that implements the basis blade,
        % for example e12.m, which returns a multivector result with the
        % value 1 e12. We can then use * to multiply them together and test
        % the table. We form the result from the above calculation with
        % character indices in the same way and compare the two. For good
        % measure we also test the .* function.
        
        switch s
            case -1
                u = eval(['-e' q]);
            case 0
                u = eval(['0 .* e' q]);
            case 1
                u = eval(['e' q]);
            otherwise
                error('Sign value not in {-1, 0, +1}.')
        end

        t = eval(l) .* eval(r); % The result here is a multivector.
        
        if t ~= u
            error(['Error in multiplication of ' l ' .* ' r ...
                   ' found ' char(t) ', expected' char(u)]);
        end
        
        t = eval(l) * eval(r); % The result here is a multivector.
        
        if t ~= u
            error(['Error in multiplication of ' l ' * ' r ...
                  ' found ' char(t) ', expected' char(u)]);
        end
        
    end
end

disp('Passed');

end

% $Id: test_multiplication_table.m 65 2016-06-20 11:39:39Z sangwine $
