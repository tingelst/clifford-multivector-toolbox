function r = reverse(m)
% REVERSE  Computes the reverse of a clifford multivector.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

% TODO Rewrite this to use the private function involution.

global clifford_descriptor;

% Create a table, indexed by grade mod 4 which indicates which grades need
% to be negated to compute the reverse.

negate = [false, false, true, true];

r = m; % Copy the input argument.

for g = 0:clifford_descriptor.n % For each grade.
    if negate(mod(g, 4) + 1)
        % We need to negate the components of the multivector of grade g.
        N = ~clifford_descriptor.grade_table(g + 1, :);
        % Now negate all the elements of the multivector indicated by N.
        for i = 1:length(N)
            if N(i)
                r.multivector{i} = -r.multivector{i}; % TODO Vectorise this?
            end
        end
    end
end

end

% $Id: reverse.m 63 2016-06-20 11:36:32Z sangwine $
