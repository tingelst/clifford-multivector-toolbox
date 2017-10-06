function r = subsasgn(a, ss, b)
% SUBSASGN Subscripted assignment.
% (Clifford overloading of standard Matlab function.)

% This function was copied from the Quaternion Toolbox for Matlab (QTFM)
% with modifications to work with matrices of Clifford multivectors.

% Copyright (c) 2005, 2010 Stephen J. Sangwine and Nicolas Le Bihan.
% Copyright (c) 2015, 2017 Stephen J. Sangwine and Eckhard Hitzer.
% See the file : Copyright.m for further details.

% Some code in this function was re-written in April 2017 following a
% report by Radek Tichy about problems with subscripted assignments with
% empty components, and assignment of empty to parts of a multivector
% array.

global clifford_descriptor;

switch ss.type
case '()'
    if length(ss) ~= 1
        error(['Multiple levels of subscripting are not ', ...
               'supported for multivectors.'])
    end
    
    if ~isa(a, 'clifford')
        error(['Left side must be a multivector in subscripted ', ...
               'assignment if right side is a multivector.'])    
    end
    
    if ~isa(b, 'clifford')
        
           % Handle the special case where b is empty first. This occurs
           % when deleting rows or columns of an array, for example:
           %
           % A(3, :) = [];
           %
           % We need to work on the components of a, taking note of any
           % existing empties, which we can skip over (since replacing part
           % of an empty array with an empty array is a no-operation).

           if isempty(b)
               for j = 1:clifford_descriptor.m
                   aj = a.multivector{j};
                   if ~isempty(aj)
                       aj(ss.subs{:}) = []; % This has to be an explicit []
                                            % for reasons noted in the QTFM
                                            % subsasgn function (q.v.)
                                            
                       % If aj is now all zero (exactly), suppress it and
                       % replace with empty.
        
                       if any(aj(:) ~= 0)
                           a.multivector{j} = aj;
                       else
                           a.multivector{j} = []; % TODO Assign an empty of the correct class.
                       end
                   end
               end
               r = a;
               return
           end
           
           % Now we know that b is not empty, because we dealt with that
           % above. b could be numeric, or it could be something we can't
           % handle, like a string.
           
           if isnumeric(b)
               r = subsasgn(a, ss, clifford(b)); % Convert b to a multivector
                                                 % (with empty non-scalar part)
               return                            % and call recursively.
           else
               error('Cannot convert right-hand argument to a multivector.');
           end
    end
    
    % Operate on the components of the multivector one by one. However, we
    % have to handle empty components carefully, as on the left-hand side,
    % empty components represent implicit zeros, which we may have to make
    % explicit if the right-hand side value is not empty at the given
    % component.
    
    sa = size(a); ca = classm(a);
    sb = size(b); cb = classm(b);
    
    for j = 1:clifford_descriptor.m
        aj = a.multivector{j};
        bj = b.multivector{j};
        
        % There are four cases to consider, according as to whether aj and
        % bj are empty:
        %
        % aj    bj    Action
        % -----------------------------------------------------------------
        % no    no    Default case, do the assignment.
        % yes   no    Replace aj with explicit zeros and do the assignment.
        % no    yes   Replace bj with explicit zeros and do the assignment.
        % yes   yes   Nothing to do, since assigning empty to empty is NOP.

        if isempty(aj) && isempty(bj)
            continue % Nothing more to do for index j, move on to the next.
        end
        
        if isempty(aj)
           aj = zeros(sa, ca); 
        end
        
        if isempty(bj)
           bj = zeros(sb, cb);
        end
        
        % Now we can safely carry out the subscripted assignment.
        
        aj(ss.subs{:}) = bj;
        
        % If aj is now all zero (exactly), we should suppress it and
        % replace with empty.
        
        if any(aj(:) ~= 0)
            a.multivector{j} = aj;
        else
            a.multivector{j} = []; % TODO Assign an empty of the correct class.
        end
    end
    r = a;
case '{}'
    error('Cell array indexing is not valid for multivectors.')
case '.'
    error('Structure indexing is not implemented for multivectors.')
otherwise
    error('Clifford subsasgn received an invalid subscripting type.')
end

% $Id: subsasgn.m 115 2017-04-17 18:20:00Z sangwine $
