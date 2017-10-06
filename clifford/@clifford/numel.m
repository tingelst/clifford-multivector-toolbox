function n = numel(m, varargin)
% NUMEL   Number of elements in an array.
% (Clifford overloading of standard Matlab function.)

% Copied from the Quaternion Toolbox for Matlab (QTFM) with minimal
% modifications to work with multivectors.

% Copyright (c) 2015, 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

if isempty(m)
    n = 0; return % Return zero for an empty multivector array.
end

if nargin == 1
    n = prod(size(m)); % A better method would be builtin('numel', M)
    % where M is a non-empty element of m.multivector, but finding a
    % non-empty element is costly. See size.m for a way of doing this.
else
    % We have more than one argument. This means varargin represents a
    % list of index values. See the Matlab help documentation on the
    % numel function for a detailed (if unclear!) explanation of what
    % numel has to do. It appears that this function should never be
    % called with this parameter profile (Matlab should call the built-in
    % numel function instead), so we trap any call that does occur.

    error('Clifford numel function called with varargin, unexpected.');

    % If we do have to handle this case, here is how it could be done:
    % n = numel(q.x, varargin);
end

% $Id: numel.m 84 2016-07-19 15:37:03Z sangwine $
