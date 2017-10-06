function descriptor
% CLIFFORD_DESCRIPTOR Outputs the values stored in the descriptor, for
% debugging purposes.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

% TODO Adjust the output according to the size of the algebra. Or consider
% providing a parameter, so that without a parameter the function prints
% just the summary, with a parameter (string), a certain field can be
% returned as a result. Idea: this could provide access to the fields
% without using the global! Maybe make it a private function.

global clifford_descriptor;

if isempty(clifford_descriptor)
    disp('The Clifford descriptor is empty (un-initialised).')
    return
end

disp(clifford_descriptor) % This shows all the fields, but the values only
                          % of scalars and small vectors.

% Now output the arrays.

if clifford_descriptor.m > 8
    disp('index_strings')
    disp(clifford_descriptor.index_strings)
end

% The information in the tensor is redundant, the sign and index arrays
% convey the multiplication table. The tensor may be deleted from the
% descriptor.
%disp('tensor:')
%disp(clifford_descriptor.tensor)

disp('sign:')
disp(clifford_descriptor.sign)

disp('index:')
disp(clifford_descriptor.index)

disp('grade_table:')
disp(clifford_descriptor.grade_table)

end

% $Id: descriptor.m 62 2016-06-20 11:33:56Z sangwine $