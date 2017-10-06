function show_internal(name, value)
% Displays the components of a multivector (array). This code is called
% from show.m, which must pass the name of the variable as a string.
% (It may be empty if the value is anonymous, as results for example, from
% the call 'show(e1)'.)

% Copyright (c) 2013, 2016 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor;

if isempty(clifford_descriptor)
    error('No Clifford algebra has been initialised.')
end

check_signature(value);

if isempty(value)
    
    if ~isempty(name)
        disp(' ');
        disp([name, ' =']);
    end

    % There are no numeric values to be output, so we simply output a
    % description of the empty value, depending on its size, which may be
    % 0-by-0, or 0-by-N, and it may be a matrix (2-dimensional) or an array
    % (more than two-dimensional). We can output something informative in
    % all these cases and not just '[]'.
    
    S = blanks(5);
    d = size(value);
    if sum(d) == 0
        S = [S '[] clifford multivector'];
    else
        S = [S 'Empty multivector'];
        l = length(d);
        if l == 2
            S = [S ' matrix: '];
        else
            S = [S ' array: '];
        end
        for k = 1:l
            S = [S, num2str(d(k))];
            if k == l
                break % If we have just added the last dimension, no need
                      % for another multiplication symbol.
            end
            S = [S, '-by-'];
        end
    end
    disp(S)
else
    % The multivector is not empty, therefore we can output numeric data.
    % We do this by outputting the m components one by one. There is a
    % special case if the multivector is scalar, since we can output this
    % in one step, using disp.
    
    % TODO At the moment this is done by component, rather than by grade.
    % It might be better to output by grade with a suitable scale factor
    % chosen PER GRADE so that it is immediately apparent when a whole
    % grade is negligible. See similar comments in the disp function, for
    % the case of scalar value display. However, unless the components
    % within a grade have the same scale factor, Matlab's disp will also
    % add a scale factor, which could be confusing.
    
    disp(' ');
    if ~isempty(name)
        disp([name, ' =']);
        disp(' ');
    end
    if isscalar(value)
        disp(value);
        disp(' ');
    else
        % Output the components one by one, using the Matlab disp function,
        % but add text output to show the basis elements etc.

        sign = ''; % This will be changed below, after the first output.
        for i = 1:clifford_descriptor.m
            if isempty(value.multivector{i})
                continue % Omit the empty component.
            end
            disp([sign, clifford_descriptor.index_strings{i}, ' *']);
            disp(' ');
            disp(component(value, i));
            sign = '+ ';
        end
    end
end

% $Id: show_internal.m 64 2016-06-20 11:37:49Z sangwine $
