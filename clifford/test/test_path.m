function test_path
% Test code to verify that the Matlab path includes the clifford folder.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

disp('Checking that location of clifford folder is appropriate ...')

mr = matlabroot;
cr = clifford_root;

if strncmpi(mr, cr, min(length(mr), length(cr)))
    error(['The clifford toolbox must not be installed in the ', ...
           'MATLAB root hierarchy: see Read_me.txt']);
else
    disp('Location is OK')
end

disp('Checking Matlab search path ...')

% This test code is not bombproof: it is simply a cursory check to trap the
% most obvious case where the user has not added the folder to the path as
% part of the installation process.

p = path;
if isempty(strfind(p, 'clifford'))
    error('The clifford folder is not on the Matlab search path.');
else
    disp('Search path is OK')
end

% $Id: test_path.m 82 2016-07-18 20:53:44Z sangwine $
