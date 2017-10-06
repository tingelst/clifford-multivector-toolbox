function [L, U, P] = lu(A)
% LU decomposition.
% (Clifford overloading of standard Matlab function.)

% This function was copied from the Quaternion Toolbox for Matlab (QTFM)
% with minor modifications to work with matrices of Clifford multivectors.

% Copyright (c) 2010, 2011, 2015 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m in QTFM (qtfm.sourceforge.net).

narginchk(1, 1), nargoutchk(2, 3)

[m, n] = size(A);

N = min(m, n); % The number of elements on the diagonal of A.

P = eye(m); % This may not be needed as a return result, but it is needed
            % internally even if not returned.
            
A = expand_zeros(A);

% Reference:
%
% Algorithm 3.2.1, section 3.2.6, modified along the lines of section
% 3.2.11 of:
% Gene H. Golub and Charles van Loan, 'Matrix Computations', 3rd ed,
% Johns Hopkins University Press, 1996.

% The code below handles all three cases, m > n, m == n and m < n.

for j = 1:N
    
    % TODO (Due to Eckhard, 24 August 2015). Consider whether the pivoting
    % scheme can be adapted to take account of divisors of zero, similar to
    % the way it avoids zero pivots by putting the largest diagonal element
    % at position j. It might be necessary to detect divisors explicitly,
    % in which case see the function isdivisor in QTFM (not yet public).
    
    % Partial pivoting: place the largest diagonal element in j:N at
    % position j (taking largest to mean largest modulus) by swapping rows.
    % We use abs twice so that the modulus of a complex multivector array A
    % yields a real result.
            
    [~, k] = max(abs(abs(subsref(diag(A), substruct('()', {j:N})))));
    if k ~=1 % If k == 1, the largest element is already at A(j, j).
        % Swap rows j and j + k - 1 in both A and P.
        l = j + k - 1;
        P([j l], :) = P([l j], :);
        r1 = substruct('()', {[j l], ':'});
        r2 = substruct('()', {[l j], ':'});
        A = subsasgn(A, r1, subsref(A, r2)); % A([j l], :) = A([l j], :)
    end
    
    if j == m, break, end % If true, j+1:m would be an empty range.
    s1 = substruct('()', {j,     j});
    s2 = substruct('()', {j+1:m, j});
    %A(j+1:m, j) = A(j+1:m, j) ./ A(j, j);
    A = subsasgn(A, s2, expand_zeros(subsref(A, s2) ./ subsref(A, s1)));
    
    if j == n, break, end % If true, j+1:n would be an empty range.
    s3 = substruct('()', {j+1:m, j+1:n});
    s4 = substruct('()', {j,     j+1:n});
    %A(j+1:m, j+1:n) = A(j+1:m, j+1:n) - A(j+1:m, j) * A(j, j+1:n);
    A = subsasgn(A, s3, expand_zeros(subsref(A, s3) - subsref(A, s2) * subsref(A, s4)));
end

% The algorithm above computes L and U in place, so extract them into the
% separate results demanded by the calling profile. The diagonal of L is
% implicit in the result produced above, so we have to supply the explicit
% values which are all ones.

% L has size [m, N],     where N = min(m, n), the number of elements on the
% U has size [N, n]      diagonal of A.

% U = suppress_zeros(triu(A(1:N, :))); This is what the next three lines compute.
% L = suppress_zeros(tril(A(:, 1:N)) + eye( ... );
U = suppress_zeros(triu(subsref(A, substruct('()', {1:N, ':'}))));   
L = suppress_zeros(tril(subsref(A, substruct('()', {':', 1:N})), -1) ...
    + eye(m, N, 'like', A.multivector{1}));

if nargout < 3
    % The third output parameter is not needed, therefore we must modify L.
    % This behaviour matches that of the Matlab LU function. It ensures
    % that A == L * U, rather than P * A == L * U, which is the case if P
    % is returned.
    L = P.' * L;
end

% Note on subscripted references: these do not work inside a class method
% (which this is). See the file 'implementation notes.txt', item 8.

end

% $Id: lu.m 100 2016-08-23 15:55:42Z sangwine $
