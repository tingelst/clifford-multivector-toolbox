function disp(m)
% DISP Display array.
% (Clifford overloading of standard Matlab function.)

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 0)

global clifford_descriptor

% Handle the case where the input parameter does not have the current
% signature. We could output a value with more work here, but it is
% sufficient to output a sensible message and return. What's important is
% not to raise an error.

if any(m.signature ~= clifford_descriptor.signature)
    disp('Unable to show value')
    disp(['Multivector has signature ' signature_string(m)])
    disp(['Current algebra signature ' signature_string(clifford_descriptor)])
    return
end

d = size(m);
S = blanks(5);
if isempty(m)
    if all(d == [0, 0])
        S = [S '[] ' signature_string(m) ' multivector'];
    else
        S = [S 'Empty ' signature_string(m) ' multivector'];
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
elseif ismatrix(m) && d(1) == 1 && d(2) == 1
    % Scalar case.    
    % S = [S char(m)]; Old code, all on one line.
    % disp(S)
    flag = false;
    for j = 1:size(clifford_descriptor.grade_table, 1) % For each grade ...
        g = grade(m, j - 1);
        if ~isempty(g)
            % TODO We should compute the magnitude of the elements of the
            % grade and control the format of the output accordingly so
            % that we don't display 0.0000 when in fact the elements are
            % non-zero. If we don't do this it is possible to give a
            % misleading impression of the values within a grade.
            disp(char(g, flag)); flag = true;
        end
    end
else
    % Non-scalar case. Build up the string piece by piece, then output it
    % when complete.
    
    l = length(d);
    for k = 1:l
        S = [S, num2str(d(k))];
        if k == l
            break % If we have just added the last dimension, no need for
                  % another multiplication symbol.
        end
        S = [S, 'x'];
    end
    if ~isreal(m),   S = [S, ' complex']; end
                     S = [S, ' ' signature_string(m) ' multivector array'];
                     
    % TODO Add information for the cases where part of the array is empty.
    % For example, state 'clifford vector array' or 'clifford bivector
    % array', or 'array with vector and bivector components' or 'array of
    % grade 4'.
                           
    % Add some information about the components of the multivector, unless
    % the component type is double (the default - implied).
    
    C = class(m.multivector{1});
    if ~strcmp(C, 'double')
        S = [S, ' with ', C, ' components'];
    end
    
    disp(S)
end

    function s = signature_string(a)
        % The parameter may be a multivector or a clifford descriptor,
        % since either has a signatrure field.
        s = ['Cl(' num2str(a.signature(1)) ',' num2str(a.signature(2))];
        if a.signature(3) == 0
            s = [s ')'];
        else
            s = [s ',' num2str(a.signature(3)) ')'];
        end
    end

end

% $Id: disp.m 73 2016-06-24 13:44:42Z sangwine $
