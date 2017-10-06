function S = randm(varargin)
% RANDM   Creates random multivectors.

% TODO Write this properly so that the results are normalised and uniformly
% distributed. See the corresponding quaternion function.

% Copyright (c) 2013, 2015, 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

nargoutchk(0, 1)

global clifford_descriptor

S = clifford(randn(varargin{:})); % This will go in the scalar part.

% TODO This loop could be parallelised using parfor, provided that the
% intermediate results are stored in an array and added after the loop.
% Suggestion by Harry Elman, April 2017.
% Note however, that since that date the code below has been significantly
% speeded up by the use of the put method, in place of the previous
% approach using eval and plus, which accounted for a lot of the slowness.

for j = 2:clifford_descriptor.m
    S = put(S, j, randn(varargin{:}));
end

if clifford_descriptor.m > 1 % If we are working in the reals, do not normalise!
    S = unit(S); % Normalise the random multivectors to unit norm.
end

end

% $Id: randm.m 112 2017-04-16 15:05:53Z sangwine $
