function R = overload(F, M, varargin)
% Private function to implement overloading of Matlab functions. Called to
% apply the function F to the clifford array M by operating on components
% of M with F. F must be a string, giving the name of the function F. The
% calling function can pass this string using mfilename, for simplicity of
% coding. varargin contains optional arguments that are not multivectors.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

H = str2func(F); % A handle to the function designated by F.

R = M; % Copy the input argument to avoid the need to call the constructor.

global clifford_descriptor;

% TODO We should vectorise this using cellfun.

for i = 1:clifford_descriptor.m
    % TODO This may not be the ultimate solution. The companion function
    % overloade applies H to all components of M, even the empty ones. For
    % some functions H this makes sense, but for others it doesn't. Here,
    % we copy the empty components across without applying H, but this may
    % cause other issues, for example with incorrect sizes.
    if isempty(M.multivector{i})
        R.multivector{i} = M.multivector{i}; % Copy the empty component
                                             % without applying H to it.
    else
        R.multivector{i} = H(M.multivector{i}, varargin{:});
    end
end
end

% $Id: overload.m 64 2016-06-20 11:37:49Z sangwine $
