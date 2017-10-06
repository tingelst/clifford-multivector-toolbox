function clifford_test
% Run clifford test code.
%
% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

current_dir = pwd;

root = [clifford_root filesep 'test'];
cd(root)
test

cd(current_dir);

% $Id: clifford_test.m 62 2016-06-20 11:33:56Z sangwine $
