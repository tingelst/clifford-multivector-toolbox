function r = grade_four_involution(m)
% GRADE_FOUR_INVOLUTION  Computes the grade 4 involution of a clifford multivector.
% This function negates the grade four elements of a multivector.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor

r = m;

N = ~clifford_descriptor.grade_table(4 + 1, :);

% Now negate all the elements of the multivector indicated by N.

for i = 1:length(N)
    if N(i)
        r.multivector{i} = -r.multivector{i}; % TODO Vectorise this?
    end
end

end

% $Id: grade_four_involution.m 94 2016-07-28 20:09:40Z sangwine $
