function p = grade(m, k)
% GRADE  Extracts the k-th grade component of a clifford multivector.
% The result may be empty (example: grade(e1, 2) = []).

% Copyright (c) 2013, 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(2, 2), nargoutchk(0, 1)

global clifford_descriptor;

if ~isscalar(k) || ~isnumeric(k) || k < 0 || fix(k) ~= k
    error('Second parameter must be non-negative integer scalar.')
end

if k > clifford_descriptor.n
    error(['Second parameter (', num2str(k), ') is greater than the number', ...
           ' of grades (', num2str(clifford_descriptor.n), ') in a multivector,', ...
           ' given the currently selected algebra.'])
end

check_signature(m);

if isempty(m)
    p = m; % Just copy the empty input to the output and we are done.
    return
end

% m is not empty, but most of the result will be, so we make an empty
% result and then copy across only the components of m that we need. But
% before we do this, we must cast the empty arrays to the same type as m.

c = classm(m);
if strcmp(c, 'double') % TODO If and when clifford.empty is modified to
    % take a class parameter, we could just create the empty array with the
    % correct class.
    p = clifford.empty; % Default class is fine.
else
    p = cast(clifford_descriptor.empty, c);
end

% TODO Vectorise this with logical indexing.
% index = ~clifford_descriptor.grade_table(k + 1, :); 
% p.multivector{index} = m.multivector{index};

for i = 1:clifford_descriptor.m
    if ~clifford_descriptor.grade_table(k + 1, i)
        p.multivector{i} = m.multivector{i};
    end
end

end

% $Id: grade.m 88 2016-07-20 15:33:01Z sangwine $
