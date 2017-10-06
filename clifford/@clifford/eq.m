function b = eq(l, r)
% ==  Equal.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2014, 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor;

cl = isa(l, 'clifford');
cr = isa(r, 'clifford');

if cl && cr
    % Both parameters are multivectors. The full monty, we need to compare
    % each component, interpreting empty components implicitly as arrays of
    % zeros of the same size as the non-empty components.
    
    check_signature(l);
    check_signature(r);
        
    ela = cellfun(@isempty, l.multivector); % Identify the empty components
    era = cellfun(@isempty, r.multivector); % of each operand multivector.
    
    if all(ela) || all(era)
        % If either operand is empty (Clifford or not), the result should
        % be empty (copying the behaviour of Matlab).
        b = []; return
    end
    
    b = true(max(size(l), size(r))); % Initial result to be modified below.

    index = 1:clifford_descriptor.m;
    
    for j = index(~ela & ~era)
        b = b & (l.multivector{j} == r.multivector{j});
    end
    for j = index(ela  & ~era)
        b = b & (r.multivector{j} == 0);
    end
    for j = index(~ela &  era)
        b = b & (l.multivector{j} == 0);
    end
else
    % One of the arguments is not a multivector (the other must be, or
    % Matlab would not call this function). The non-multivector argument
    % must be a numeric (if we don't impose this restriction it could be
    % anything such as a cell array or string which makes no sense at all
    % to compare with a multivector).
            
    if cl && isa(r, 'numeric')
        % A multivector can equal a numeric if the scalar part of the
        % multivector equals the numeric, and the rest of the multivector
        % is zero/empty. For simplicity, we promote the numeric value to a
        % multivector, then a recursive call to the code above does the
        % rest.
        % TODO It would clearly be better to extract the scalar part, check
        % the rest for empty and then use Matlab == on the two numerics.
        
        b = l == clifford(r);
    elseif isa(l, 'numeric') && cr
        b = clifford(l) == r; 
    else
        error('Cannot compare a multivector with a non-numeric');    
    end
end

end

% $Id: eq.m 120 2017-04-20 19:40:52Z sangwine $
