function c = component(m, n)
% Private function to extract the numerical value of the nth component of
% the multivector m. Returns an appropriate array of zeros if that
% component is empty, but empty if the whole multivector is empty.

% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

if isempty(m)
    c = []; % TODO This should have the same size and class as m.
else
   % The multivector is not empty. But the component we want could be.
   c = m.multivector{n};
   if isempty(c)
       % FIXME This isn't quite correct. The empty component may not have
       % the same class as the non-empty. We need a better way to determine
       % the class of the non-empty components. Here is a test case:
       %
       % a = e0 .* cast(2, 'single')
       %
       % class(part(a, 1))  gives 'single' but
       % class(part(a, 2))  gives 'double' which is incorrect.
      c = zeros(size(m), class(c));
   end
end

end

% $Id: component.m 64 2016-06-20 11:37:49Z sangwine $
