function R = overloade(F, M, varargin)
% Private function to implement overloading of Matlab functions. Called to
% apply the function F to the clifford array M by operating on components
% of M with F. F must be a string, giving the name of the function F. The
% calling function can pass this string using mfilename, for simplicity of
% coding. varargin contains optional arguments that are not multivectors.
% Unlike overload (q.v.) this version also applies F to empty components,
% so F must work correctly with empty components.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

H = str2func(F); % A handle to the function designated by F.

global clifford_descriptor

R = clifford_descriptor.empty;

% TODO Fix this and make it work, to vectorize the algorithm.
% R = cellfun(H, M.multivector, repmat({varargin}, size(M.multivector)), 'UniformOutput', false);

for i = 1:clifford_descriptor.m
    R.multivector{i} = H(M.multivector{i}, varargin{:});
end
end

% $Id: overloade.m 82 2016-07-18 20:53:44Z sangwine $
