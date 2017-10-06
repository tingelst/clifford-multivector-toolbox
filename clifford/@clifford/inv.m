function R = inv(a)
% INV   Inverse of a multivector (matrix).
% (Clifford overloading of standard Matlab function.)
%
% For a single multivector, this function computes the inverse if it can be
% computed. The result will be a NaN if the multivector has zero modulus.
% For matrices it computes the matrix inverse using an analytical formula
% based on partitioning the matrix into sub-matrices. A better method may
% be substituted in the future.

% Adapted from the corresponding function in the Quaternion Toolbox for
% MATLAB (QTFM), Copyright (c) 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% Reference: Wikipedia article on 'Matrix Inversion', 12 July 2005.
%            Wikipedia article on 'Schur Complement', 13 July 2005.
%
% A similar formula is given in:
%
% R. A. Horn and C. R. Johnson, 'Matrix Analysis',
% Cambridge University Press, 1985, §0.7.3, page 18.

% TODO There is currently no check for a singular matrix. A result is
% returned which is not a valid inverse.

[r, c] = size(a);

if r ~= c
    error('Matrix must be square.');
end

if r == 1 % c must also be 1, since we have checked that r == c above.
    R = a.^-1; % This uses the power function, which implements the inverse
               % of a 1-by-1 multivector. NB This may not exist.
% elseif r == 2
% 
%     % We handle the 2 by 2 case separately since this can be computed
%     % using clifford products, rather than clifford matrix products.
% 
%     A = subsref(a, substruct('()', {1,1})); % A = a(1,1);
%     B = subsref(a, substruct('()', {1,2})); % B = a(1,2);
%     C = subsref(a, substruct('()', {2,1})); % C = a(2,1);
%     D = subsref(a, substruct('()', {2,2})); % D = a(2,2);
% 
%     IA = inv(A); % If A is zero, this will cause a NaN and the whole
%                  % result will be NaNs. Solution unknown as yet.
% 
%     IAB = IA .* B; % These two subexpressions are needed more than
%     CIA = C .* IA; % once each, and are computed once for efficiency.
% 
%     T  = inv(D - CIA .* B);
% 
%     TCIA = T .* CIA; % This is needed twice, so compute it once and reuse.
% 
%     R = [[IA + IAB .* TCIA, -IAB .* T];...
%          [           -TCIA,         T]];
else

    % For matrices larger than 2 by 2, we partition the matrix into sub
    % blocks of half the height/width of the input matrix. If the input
    % matrix has an even number of rows (and therefore columns,  since it
    % is square),  then the sub-blocks will be exactly half the height
    % (width),  otherwise the left block will have one less element,
    % because we round towards zero. The layout of the sub-blocks is:
    %
    %                 [ A B ]
    %                 [ C D ]
    %
    % the same as in the 2 by 2 case above (except that here they are
    % matrices and not scalars).

    p = fix(r./2); % Calculate half the number of rows/columns rounded down.
    q = p + 1;     % Index of first element of right or bottom block.

    A = subsref(a, substruct('()', {1:p, 1:p})); % A = a(1:p, 1:p);
    B = subsref(a, substruct('()', {1:p, q:c})); % B = a(1:p, q:c);
    C = subsref(a, substruct('()', {q:r, 1:p})); % C = a(q:r, 1:p);
    D = subsref(a, substruct('()', {q:r, q:c})); % D = a(q:r, q:c);

    IA = inv(A);

    IAB = IA * B; % These two subexpressions are needed more than
    CIA = C * IA; % once each, and are computed once for efficiency.

    T  = inv(D - CIA * B);

    TCIA = T * CIA; % This is needed twice, so compute it once and reuse.

    R = [[IA + IAB * TCIA, -IAB * T];...
         [          -TCIA,        T]];
end

% $Id: inv.m 94 2016-07-28 20:09:40Z sangwine $
