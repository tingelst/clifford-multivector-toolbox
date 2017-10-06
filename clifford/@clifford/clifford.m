% Clifford Algebra Toolbox for MATLAB
%
% Clifford multivector class definition and constructor method/function.

% Copyright (c) 2013, 2017 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

classdef clifford
    properties (Access = 'private', Hidden = true)
        % The multivector data is stored in a cell array. The elements of
        % the cell array are the arrays of component data for each element
        % of the multivector. The ordering is lexical, for example:
        %
        % e0 e1 e2 e3 e12 e13 e23 e123
        
        multivector = {}; % Default this to an empty cell array.        
        signature; % [p, q, r], the signature of the algebra of the multivector.
    end
    methods
        
        function s = get_signature(m)
            % GET_SIGNATURE returns the signature of a multivector.
            s = m.signature;
        end
        
        function dump(m)
        % DUMP outputs a human readable dump of the contents of the
        % multivector (for debugging purposes).
        
        disp(['Signature: ', num2str(m.signature)])
        disp(' ')
        disp('Multivector components:')
        for j = 1:length(m.multivector) % NB Not clifford_descriptor.m in
                                        % case we are currently in a
                                        % different signature.
            disp([num2str(j), ': [', num2str(size(m.multivector{j})), ....
                              ']  ', class(m.multivector{j})]);
        end
        end
        
        function check_signature(m)
        % CHECK_SIGNATURE Checks that the signature of an object m matches
        % with the current signature and raises an error if they do not
        % match. This should be called from any class method that has
        % multivectors as input parameters, and it should be called on each
        % such parameter to guard against attempts to combine multivectors
        % with differing signatures.
        
        global clifford_descriptor;
        
        if isempty(clifford_descriptor)
            error('No Clifford algebra has been initialised.')
        end

        if any(m.signature ~= clifford_descriptor.signature)
            error(['Clifford multivector has a signature different to '...
                   'that of the current Clifford algebra.'])
        end
        end
        
        function object = clifford(varargin)
        % CLIFFORD   Construct multivectors from components. Accepts the 
        % following possible arguments, which may be scalars, vectors or
        % matrices:
        %
        % No argument     - returns an empty multivector.
        % One argument    - A multivector argument returns the argument
        %                   unmodified. A non-multivector argument returns
        %                   the argument in the e0 part.
        % 2+ arguments    - returns a multivector, provided the number of
        %                   arguments equals the number of components of a
        %                   multivector in the current Clifford algebra.
        %
        % One string      - the string must be of the form 'e1', 'e123' etc
        %                   and the result will be a multivector
        %                   representing a basis element of the current
        %                   algebra if the string is valid.

        global clifford_descriptor; % This is a structure containing fields
                                    % initialised by the function
                                    % clifford_signature, which must be
                                    % called before this constructor.
        
        if isempty(clifford_descriptor)
            error(['The Clifford algebra you wish to use must first be '...
                   'initialised by calling clifford_signature(p, q)'])
        end
        
        nargoutchk(0, 1) % The number of input arguments is checked below.
                         
        L = length(varargin);
        
        if L > clifford_descriptor.m
            error('Too many input arguments for the algebra')
        end
        
        if L == 0
            % Although the descriptor contains an empty multivector, we
            % cannot use it here, because this is where the empty
            % multivector in the descriptor gets created.
            object.multivector = cell(1, clifford_descriptor.m);
            object.signature = clifford_descriptor.signature;
            return
        end
        
        if L == 1
            V = varargin{1};
            if ischar(V)
                % The parameter is a string. See whether it represents a
                % valid basis element, and if so return a suitable
                % multivector.
                
                TF = strcmp(V, clifford_descriptor.index_strings);
                
                % TODO If the parameter could be permuted into a string
                % which would be valid, we could compute a result (it would
                % differ at most in sign). But we would need to work out
                % the number of swaps needed. The sort function would tell
                % us this fairly easily.
                
                if all(~TF)
                    error(['Basis element ' V ...
                           ' does not exist in current Clifford algebra'])
                end
                
                object = clifford_descriptor.empty;
                object.multivector{TF} = 1; % Set one element to unity.
 
            elseif isa(V, 'clifford')
                % The input argument is already a clifford multivector.
                check_signature(V);
                object = V;
            else
                if isnumeric(V)
                    % We can store this in the scalar part, and leave the
                    % rest empty, subject to altering the class to match V.
                    
                    object = clifford_descriptor.empty;
                    object.multivector{1} = V;
                    E = cast([], 'like', V); % Compute once and re-use.
                    for i = 2:clifford_descriptor.m % TODO Vectorise?
                       object.multivector{i} = E; 
                    end
                else
                    error('A Clifford multivector cannot contain non-numeric components.')
                end
            end
            return
        end
        
        if L == clifford_descriptor.m
            % The parameters supplied must be numeric, or empty.
            
            % TODO Tricky problem here. We want to combine empty with
            % numeric elements, but the first component could be empty. We
            % need to check the size of any non-empty elements against the
            % first non-empty not the first element.
            
            object = clifford_descriptor.empty;
            V = varargin{1};
            if ~isnumeric(V)
                error('Multivector elements must be numeric.')
            end
            C = class(V); S = size(V);
            object.multivector{1} = V;
            for i = 2:L
                V = varargin{i};
                if ~isnumeric(V)
                    error('Multivector elements must be numeric.')
                end
                if ~strcmp(C, class(V))
                    error('Cannot mix elements of different classes in one multivector.')
                end
                T = size(V);
                if length(S) ~= length(T)
                   error('Cannot mix elements with different numbers of dimensions in one multivector.') 
                end
                if any(S ~= T)
                    error('Cannot mix elements with different sizes in one multivector.')
                end
                object.multivector{i} = V;
            end
        else
            error('The number of arguments must equal the number of components in the current Clifford algebra.')
        end
        end

        function n = numArgumentsFromSubscript(~,~,~)
            % Introduction of this function with Matlab R2015b
            % permitted numel to revert to its obvious function
            % of providing the number of elements in an array.
            n = 1;
        end
        
        function r = put(m, j, v)
            % An internal function to insert a value into a multivector at
            % a given index position. It does in reverse what the part and
            % private/component functions do (extract a value from a
            % multivector at a given index). m must be a multivector in the
            % current algebra, j must be an integer from
            % 1:clifford_descriptor.m, and v must be of the same type and
            % size as any existing non-empty elements of the multivector.
            % We do not check the parameters in order to reduce overhead,
            % since the purpose of this function is to make possible
            % efficient insertion of a value into a multivector. Note that
            % it is not necessary to use this function from within a class
            % method, since such methods can directly manipulate the fields
            % within a multivector. The randm function is a classic case of
            % a non class method that uses this function.
            
            r = m; % Copy the input multivector.
            r.multivector{j} = v;
        end
    end
    methods (Static = true)
        function m = empty(varargin)
            % This function makes it possible to use the dotted notation
            % clifford.empty or clifford.empty(0,1) to create an empty
            % array.
            % TODO Make it possible to write clifford.empty('double') and
            % specify the class of the empty components.
            
            global clifford_descriptor;
            
            m = clifford_descriptor.empty; % This will be size 0-by-0.
            
            if ~isempty(varargin)
                error('Cannot yet handle varargin parameters')
            end
        end
    end
end

% $Id: clifford.m 112 2017-04-16 15:05:53Z sangwine $
