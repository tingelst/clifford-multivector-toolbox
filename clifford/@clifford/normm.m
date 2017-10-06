function a = normm(m)
% NORMM  Norm of a multivector (norm of each element for arrays)

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1) 

global clifford_descriptor;

a = zeros(size(m), classm(m)); % To accumulate the sum of the squares.

% TODO Can this be vectorized? We should be able to compute which elements
% of the cell array are non-empty, then iterate over them alone, cutting
% out the IF statement.

for j = 1:clifford_descriptor.m
    
    % If any element of the multivector is empty, it is treated as an
    % implicit zero (array) and skipped.
    
    if ~isempty(m.multivector{j})
        a = a + m.multivector{j}.^2;
    end
end

end

% $Id: normm.m 63 2016-06-20 11:36:32Z sangwine $
