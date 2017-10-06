function r = classm(m)
% Private function to return the class of the elements of a multivector.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% Even an empty multivector has empty elements, so we can deal with empty
% multivectors by the same process.

R = cellfun(@class, m.multivector, 'UniformOutput', false);

% R is now a cell array of strings, describing the class of each component
% of the multivector. These should all be the same, since we don't allow
% multivectors to have components of multiple classes.

r = R{1}; % That's it apart from checking! We need to check that all
          % components have the same class, which means all elements of R
          % are identical.

t = strcmp(r, R); % Compare all elements of R with r.

if ~all(t)
    error(['Error in private function classm: multivector has ' ...
           'components of more than one class. Found ' R{~t}]);
end

end

% $Id: classm.m 81 2016-07-17 18:49:11Z sangwine $
