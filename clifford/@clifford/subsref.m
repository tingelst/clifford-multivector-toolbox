function b = subsref(a, ss)
% SUBSREF Subscripted reference.
% (Clifford overloading of standard Matlab function.)

% This function was copied from the Quaternion Toolbox for Matlab (QTFM)
% with modifications to work with matrices of Clifford multivectors.

% Copyright (c) 2005, 2010 Stephen J. Sangwine and Nicolas Le Bihan.
% Copyright (c) 2015       Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

global clifford_descriptor;

if length(ss) ~= 1
    error('Only one level of subscripting is currently supported for multivectors.');
end

check_signature(a);

switch ss.type
case '()'
    if length(ss) ~= 1
        error('Multiple levels of subscripting are not supported for multivectors.')
    end
    
    b = a; % Copy the input parameter to avoid calling the constructor.
   
    % To implement indexing, we operate separately on the components.
    
    for j = 1:clifford_descriptor.m
        % TODO We must cope here with empty multivector components. This
        % will require some thought, as subscripted indexing of an empty
        % component might require explicit zeros to be substituted. Tried
        % using the private function component. DONE.
        t = component(a, j);
%         if isempty(t)
%             error('Clifford subsref found an empty multivector component: cannot handle yet.');
%         end
        b.multivector{j} = t(ss.subs{:});
    end
case '.'
    error('Structure indexing is not implemented for multivectors.')
case '{}'
    error('Cell array indexing is not valid for multivectors.')
otherwise
    error('subsref received an invalid subscripting type.')
end

b = suppress_zeros(b);

end

% $Id: subsref.m 81 2016-07-17 18:49:11Z sangwine $
