function c = horzcat(varargin)
% HORZCAT Horizontal concatenation.
% (Clifford overloading of standard Matlab function.)

% Adapted from the Quaternion Toolbox for Matlab function of the same name.
% Copyright (c) 2005, 2009 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

global clifford_descriptor;

if isempty(clifford_descriptor)
    error('No Clifford algebra has been initialised.')
end

if length(varargin) == 1
    c = varargin{1}; % We have been passed one argument, nothing to do!
    return
end

% This is implemented recursively for simplicity, as it is unlikely to be
% used for more than a few arguments.

a = clifford(varargin{1}); % The call to the class constructor ensures
b = clifford(varargin{2}); % that a and b are both multivectors, even if
                           % the first or second varargin parameter was
                           % something else. Calling the constructor
                           % exploits the error checks there, that would
                           % be complex to include here for handling rare
                           % problems like catenating strings with
                           % multivectors.

check_signature(a);
check_signature(b);

if isempty(b)
    if length(varargin) == 2
        c = a;
        return
    else
        c = horzcat(a, varargin{3:end});
        return
    end
elseif isempty(a)
    if length(varargin) == 2
        c = b;
        return
    else
        c = horzcat(b, varargin{3:end});
        return
    end
end

c = a;

for j = 1:clifford_descriptor.m    
    if isempty(a.multivector{j}) && isempty(b.multivector{j})
        continue % Both a and b have empty jth components, so we do nothing
                 % and move on to the next j. This means the jth component
                 % of c will be empty (because it was copied from a).
    end
    
    % One or both of a and b has a non-empty jth component, so we must
    % supply zeros and not empty. We do this using the private function
    % component, which supplies the implicit zeros.
    
    c.multivector{j} = horzcat(component(a, j), component(b, j));
end

if length(varargin) == 2
    return
else
    c = horzcat(c, varargin{3:end});
end

% TODO Given arrays of inconsistent dimensions to concatenate, this code
% currently doesn't trap the error but passes the arrays to Matlab/horzcat
% which does. It might be better to catch the error here.

% $Id: horzcat.m 63 2016-06-20 11:36:32Z sangwine $
