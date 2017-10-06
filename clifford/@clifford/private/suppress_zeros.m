function r = suppress_zeros(m)
% Private function to suppress zero components of a multivector by
% replacing them with empty. Only components which are exactly zero are
% suppressed (all elements of the component must be exact zeros).

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor

index = 1:clifford_descriptor.m;

r = m; % Copy the input multivector.

er = cellfun(@isempty, r.multivector); % Which elements of r are empty?

if all(er)
    return % The multivector m was empty, no suppression to do.
end

for j = index(~er)
    if all(r.multivector{j}(:) == 0)
        r.multivector{j} = []; % TODO This should have the correct class.
    end
end

% If all elements are now empty we should set the e0 coefficient to be an
% array of zeros of the same size as m on entry. Notice that if all
% elements are now empty, this cannot be because m was empty on entry: we
% excluded that above and returned an empty multivector in that case.

if all(cellfun(@isempty, r.multivector))
    r.multivector{1} = zeros(size(m), classm(m));
end

end

% $Id: suppress_zeros.m 64 2016-06-20 11:37:49Z sangwine $
