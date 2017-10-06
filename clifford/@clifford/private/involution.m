function r = involution(m, g)
% Private function to negate the grades of the multivector indicated by g,
% which may be a scalar or an array, e.g. [1, 4] to negate grades 1 and 4.

global clifford_descriptor

r = m; % Copy the multivector argument to the result.

for j = g % For each grade in g ...
    
    N = ~clifford_descriptor.grade_table(j + 1, :);
    
    % Now negate all the elements of the multivector indicated by N.
    
    % TODO Vectorise this? Here's a fragment of code, but the problem is
    % the left-hand side assignment doesn't work.
    % c{N} = cellfun(@uminus, {c{N}}, 'UniformOutput', false)
    % ERROR: The right hand side of this assignment has too few values to
    % satisfy the left hand side.
    
    for i = 1:length(N)
        if N(i)
            r.multivector{i} = -r.multivector{i};
        end
    end
end

end

% $Id: involution.m 1 2015-03-23 13:00:23Z sangwine $