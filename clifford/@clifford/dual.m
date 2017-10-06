function r = dual(m)
% DUAL  Computes the dual of a multivector.

% Copyright (c) 2013 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

narginchk(1, 1), nargoutchk(0, 1)

global clifford_descriptor;

% We need the inverse of the pseudoscalar, which will be plus or minus
% itself depending on the algebra. TODO Replace this with less kludgy code!

P = clifford();
P.multivector{clifford_descriptor.m} = 1; % Create a pseudoscalar.

% if sign(part(P .* P, 1)) == 1
%     Q = -P;
% else
%     Q = P;
% end

% Now multiply the multivector by the inverse of the pseudoscalar.

r = m .* (P .* P .* P);

end

% $Id: dual.m 63 2016-06-20 11:36:32Z sangwine $
