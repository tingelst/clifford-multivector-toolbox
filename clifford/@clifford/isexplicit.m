function tf = isexplicit(m)
% ISEXPLICIT True for a clifford multivector without empty components.
% This means that every component of the multivector contains a numeric
% array, none is empty.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

tf = ~any(cellfun(@isempty, m.multivector));

% $Id: isexplicit.m 63 2016-06-20 11:36:32Z sangwine $
