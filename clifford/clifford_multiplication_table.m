function T = clifford_multiplication_table
% MULTIPLICATION_TABLE This function creates a printable character array
% containing a multiplication table labelled with basis elements in string
% form (e.g. e1, e123).

% Copyright (c) 2011, 2012, 2014, 2015 Stephen J. Sangwine and Eckhard Hitzer.

global clifford_descriptor

% Compute the set of literals in lexical order.

m = cast(clifford_descriptor.m, 'double'); % Cast these to double to permit
n = cast(clifford_descriptor.n, 'double'); % multiplication below @ line 23

[~, ~, E] = clifford_lexical_index_mapping(n);

w = 3 + n; % The max width of a basis literal such as
           % e123, including sign and a trailing space.

% Pre-allocate the result array, and populate it with spaces.

T = repmat(blanks(m .* (1 + n)), [m + 2, 1]);

% Format the heading at the top row of the table.

for I = 0:m-1
    EI = E{I + 1};
    J = w + 3 + I .* w;
    T(1, J:J + length(EI) - 1) = EI;
end

% Insert a row of dashes to delineate the headings.

T(2,:) = repmat('-', [1, size(T,2)]);

% Insert a column of vertical bars to delineate the left headings.

T(:,w + 1) = repmat('|', [size(T,1), 1]);
T(2,w + 1) = '+';

% Insert the literals down the left hand side.

for I = 0:m-1
    EI = E{I + 1};
    T(3 + I, 1:length(EI)) = EI;
end

% Now fill in the table.

Sign_Table = '-  '; % A 3-character LUT for the sign.

for I = 1:m % These are index values into the multiplication table, which
            % is ordered by lexical ordering.
    for J = 1:m

        % First deal with the sign. This is contained in the table.
        
        S = clifford_descriptor.sign(I, J);
        K = J - 1;
        T(I + 2, w + 2 + K .* w) = Sign_Table(S + 2);
        
        % Now output the literal. If the sign was zero, we do not need to
        % output a literal (the entry in the table is zero). The inverse
        % mapping XI is needed here to convert the lexical index into a
        % binary index before computing the XOR.
        
        if S == 0
            % The sign is zero and a space will have been output. Now we
            % need to output the zero itself in place of a literal.
            T(I + 2, w + 3 + K * w) = '0';            
        else
            L = E{clifford_descriptor.index(I, J)};
            T(I + 2, w + 3 + K * w:w + 3 + K * w + length(L) - 1) = L;
        end
    end
end

end

% $Id: clifford_multiplication_table.m 88 2016-07-20 15:33:01Z sangwine $
