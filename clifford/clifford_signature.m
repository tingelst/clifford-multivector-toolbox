function s = clifford_signature(p, q, r)
% CLIFFORD_SIGNATURE sets the signature (p, q, r) to be the signature of
% the current Clifford algebra and initialises data structures used
% internally such as the multiplication table. If q and/or r is omitted
% they default to zero. If called without input arguments, the function
% outputs diagnostic information about the currently initialised algebra.
% A single input parameter of form [p, q] or [p, q, r] is also acceptable.
% If called with an output argument, it returns the values of p, q and r
% from the descriptor as a vector. It is not permitted to have input and
% output arguments at the same time.

% Copyright (c) 2013, 2014, 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

global clifford_descriptor; % This is a structure containing fields that
                            % are initialised below to describe the algebra
                            % with signature (p, q, r).
                            
narginchk(0, 3), nargoutchk(0, 1)

if nargin > 0 && nargout > 0
    error('Cannot have input arguments and output arguments at the same time.')
end

switch nargin
    case 0
        if isempty(clifford_descriptor)
            error('No Clifford algebra has been initialised.')
        else
            switch nargout
                case 0
                    diagnostic
                    return
                case 1
                    s = clifford_descriptor.signature; return
            end
        end
    case 1
        if isscalar(p)
            % Assume that q and r are implicit.
            q = 0; r = 0; % Supply the default values for q and r.
        else
            % p must be a vector. It could be of length 2 or 3.
            if isvector(p) && length(p) == 2
                q = p(2); r = 0; p = p(1);
            elseif isvector(p) && length(p) == 3
                q = p(2); r = p(3); p = p(1);
            else
                error('First parameter must be scalar, or a vector of length 2 or 3.')
            end
        end
    case 2
        r = 0; % Supply the default value for r.
end

% Check the values of p, q, r.

if ~isscalar(p) || ~isscalar(q) || ~isscalar(r)
    error('The input parameters must be scalars.')
end

if ~isnumeric(p) || ~isnumeric(q) || ~isnumeric(r)
    error('The input parameters must be numeric.')
end

if p < 0,       error('The first parameter must not be negative'),   end
if p ~= fix(p), error('The first parameter must be an integer'), end

if q < 0,       error('The second parameter must not be negative'),   end
if q ~= fix(q), error('The second parameter must be an integer'), end

if r < 0,       error('The third parameter must not be negative'),   end
if r ~= fix(r), error('The third parameter must be an integer'), end

% The choice of uint16 for the signature is a compromise. uint8 would be
% large enough for p, q and r, but 2^8 is not sufficient for n. To avoid
% the need for type conversions all over the place wherever the signature
% is used, we store it as uint16. 2^16 = 65536, which is the current
% theoretical implementation limit on the number of elements in a
% multivector.

if double(p) + double(q) + double(r) > 65535 % intmax('uint16') is 65535.
    error('Implementation limit: p + q + r cannot exceed 65535')
end

% We are now ready to create the descriptor. This may have been done prior,
% in which case we can load it from the disk cache, which is stored in
% clifford_root/cache/M/N where M and N are the major and minor version
% numbers of the toolbox. The descriptor may not have been computed before,
% or the cache itself may not exist, or the cache specific to this version
% of the toolbox may not exist.

V = ver('clifford');
M = V.Version(1); % The Version field is a string with format '1.2' etc.
N = V.Version(3);

cache = [clifford_root filesep 'cache'];

if ~exist(cache, 'dir')
    % The main cache directory does not exist, so create it for future use.
    mkdir(cache)
end

cache = [cache filesep M];

if ~exist(cache, 'dir')
    % The first level (major version number) cache directory does not
    % exist, so create it.
    mkdir(cache)
end

cache = [cache filesep N];

if ~exist(cache, 'dir')
    % The second level (minor version number) cache directory does not
    % exist, so create it for future use.
    mkdir(cache)
end
      
descriptor_filename = [cache filesep ...
                       num2str(p) '_' num2str(q) '_' num2str(r) '.mat'];

if exist(descriptor_filename, 'file') == 2
    load(descriptor_filename);
    return % and we are done, we assume that the basis blade files exist
    % and have the correct contents because they must have been written
    % when the descriptor was written to disk.
end

% The descriptor does not exist in the cache, so we need to compute it,
% and then write it to the cache for future use.

clifford_descriptor.signature = uint16([p, q, r]);
clifford_descriptor.n = sum(clifford_descriptor.signature, 'native');
clifford_descriptor.m = 2.^clifford_descriptor.n;

% Compute the index tables and strings. For a description, see the function
% that computes them (clifford_lexical_index_mapping).

[clifford_descriptor.index_table, ...
 clifford_descriptor.reverse_index_table, ...   
 clifford_descriptor.index_strings] = ...
    clifford_lexical_index_mapping(clifford_descriptor.n);

% Now calculate the multiplication table. This requires two arrays, one
% to store the sign and one to store the index position (of the
% result). The latter can be computed from the index and reverse index
% tables computed just above.

clifford_descriptor.sign = clifford_sign_table(p, q, r);

% Now calculate the index table. This is dependent only on the
% dimension of the algebra, it does not depend on the signature. The
% index table works like this. The elements of a multivector are stored
% in grade order: e0, e1, e2, ..., e12, e13, ..., e123 etc. Ordering
% within the grade is lexical on the indices, so e12 comes before e13
% and before e23 etc. The index of an element of the multivector is
% 1-based, so for an 8-dimensional algebra, the indices run from 1 to
% 8. Given two multivectors to multiply together we must take the index
% values of each pair of components, and combine these indices to
% compute the index of the component where the result will be stored.
% E.g. 3 e3 * 2 e12 will give 6 e123 with a sign dependent on the
% algebra. The indices must be combined by putting the index into a
% binary form where each bit represents a basis blade. Thus, assuming 8
% dimensions, 3 bits are needed to represent the index in binary form,
% and e3 is represented by 100, e12 by 011. These are combined by
% exclusive-OR to give 111 which is the binary index of the result. But
% this binary index must be converted back into the lexically-ordered
% grade-based index before we actually store the result into the output
% multivector. This is the basis of the calculation below, which
% creates a lookup table for finding the grade-ordered index, given two
% grade-ordered indices.

[RI, CI] = meshgrid(1:clifford_descriptor.m);

clifford_descriptor.index = ...
uint16(clifford_descriptor.reverse_index_table(...
bitxor(clifford_descriptor.index_table(RI), ...
       clifford_descriptor.index_table(CI)) + 1));

% Now calculate the grade table, which indicates which parts of the
% multivector are included for each grade. This is a Boolean array
% containing true where the n-th grade has a null multivector
% element. The rows correspond to the grades, and the columns
% correspond to the indexing of the multivector itself, which is
% lexical, e.g. e0 e1 e2 e3 e12 e13 e23 e123.

clifford_descriptor.grade_table = true(clifford_descriptor.n + 1, ...
    clifford_descriptor.m);
index = 0;
for grade = 0:clifford_descriptor.n
    N = nchoosek(clifford_descriptor.n, grade);
    clifford_descriptor.grade_table(grade + 1, index + 1:index + N) = false;
    index = index + N;
end
% clifford_descriptor.grade_table

% Create and store an empty multivector in the descriptor. This enables
% code in the toolbox to avoid calling the constructor to make a
% multivector, instead it can just copy this empty multivector and
% modify it, thus avoiding all the parameter checking overhead of the
% constructor.

clifford_descriptor.empty = clifford();

% Write the descriptor to a cache file. We've already made sure the
% cache directory exists.

save(descriptor_filename, 'clifford_descriptor');

% Create the parameterless function files e0.m, e1.m etc. Since the number
% of these files is without limit, depending on the algebra which is
% initialised, they are created automatically. Note that we create only the
% canonic versions with the indices in order - we cannot create all the
% permutations such as e132.m, e213.m etc.

% To avoid re-creating these files every time and writing a new version to
% disk, we create the file content in a string, check to see whether the
% file exists, and if it does we compare the string to the file content on
% disk. If they match exactly we do nothing further, but if they don't
% match, we write the string content to the file, replacing what was there
% before. This means that any old versions of the files will be overwritten
% if the toolbox is updated, but once the file is written to disk it won't
% be replaced unless the content changes. This is important if a new time
% stamp would result in a backup system or dropbox or similar thinking that
% the file is new, when in fact the content is unchanged, because the
% number of these files can be large.

% We create a string containing the entire file content. This is done in
% two parts: (1) the invariant lines from 3 to the end, and (2) the first
% two lines which contain the function name, and therefore need to be
% generated for each file.

% Invariant part of the file text, computed once outside the loop for
% speed. It is HERE that edits must be done if the content of these files
% is to be altered. It cannot be done by editing the files themselves as
% is noted in the warning message in the last two lines of each file.

t =     sprintf('%s\n', '% Copyright (c) 2015 Stephen J. Sangwine and Eckhard Hitzer');
t = [t, sprintf('%s\n', '% See the file : Copyright.m for further details.')];
t = [t, sprintf('%s\n', '%')];
t = [t, sprintf('%s\n\n', 'narginchk(0,0), nargoutchk(0,1)')];
t = [t, sprintf('%s\n\n', 'result = clifford(mfilename);')];
t = [t, sprintf('%s\n\n', 'end')];
t = [t, sprintf('%s\n', '% *** DO NOT EDIT THIS FILE --- it was automatically created. ***')];
t = [t, sprintf('%s\n', '% *** Edit the code that creates it (in clifford_signature.m) ***')];

for i = 1:clifford_descriptor.m

    name = clifford_descriptor.index_strings{i}; % 'e0', 'e1', 'e12' etc.
    
    % Now the first two lines of the file, plus the invariant tail end
    % lines created above.
    
    f =     sprintf('%s\n', ['function result = ', name]);
    f = [f, sprintf('%s\n\n', ['% ', name, ' Return basis element of current algebra.'])]; %#ok<*AGROW>
    f = [f, t];
    
    filename = [clifford_root, filesep, name, '.m'];
    
    if exist(filename, 'file') == 2
        % The file exists already. Read its contents and compare these with
        % the string we have just created. If the file content matches we
        % don't need to do anything further, and we can skip to the next
        % iteration of the loop and next file.

        if strcmp(f, fileread(filename)), continue, end
    end
    
    % The file did not exist, or the file exists but its content did not
    % match, so we write a new file.
        
    fid = fopen(filename, 'w'); % TODO This part of the process is very
    fprintf(fid, '%s', f);      % slow for large algebras. Can it be made
    fclose(fid);                % faster?
    
    % Now read the file back and confirm its contents. This is a precaution
    % against write-only folders, even though an error should occur when we
    % attempt to write the file. The cost of checking the file is so small
    % that it is worth doing this check as a belt-and-braces verification
    % that the file has been correctly written.
    
    if ~strcmp(f, fileread(filename))
        error(['Failed to write file: ', filename, ' correctly to disk.'])
    end
end

rehash; % This is intended to make Matlab notice the new files such as e0.m
        % which we have just created. This is important only the first time
        % this function is called. Without this, if a user installs the
        % toolbox and then runs the test code, errors will occur because
        % e0.m etc will not be found until the test code is run for a
        % second time (or possibly after a restart of Matlab).
end

function diagnostic
% Output some diagnostic information.
% TODO To be expanded to include other information cf CLICAL.

global clifford_descriptor;

if clifford_descriptor.signature(3) == 0
    disp(['Algebra Cl(' num2str(clifford_descriptor.signature(1)), ',' ...
                        num2str(clifford_descriptor.signature(2)), ')']);
else
    disp(['Algebra Cl(' num2str(clifford_descriptor.signature(1)), ',' ...
                        num2str(clifford_descriptor.signature(2)), ',' ...
                        num2str(clifford_descriptor.signature(3)), ')']);
end

disp(['Dimensionality:   ', num2str(clifford_descriptor.m)])
disp(['Number of grades: ', num2str(size(clifford_descriptor.grade_table, 1))])
disp('Multiplication table:')
if clifford_descriptor.m > 64
    disp('Too large to output to command window')
else
    disp(clifford_multiplication_table)
end

end

% $Id: clifford_signature.m 111 2017-04-05 09:32:16Z sangwine $