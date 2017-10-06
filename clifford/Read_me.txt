Clifford Multivector Toolbox for Matlab - installation instructions
-------------------------------------------------------------------

To install this toolbox:

1. Unzip the distribution file. Copy or move the clifford directory/folder
   to a suitable location. DO NOT CHOOSE the location where MATLAB itself
   and its toolboxes are located. When you run Matlab, it must have write
   access to the chosen folder, not just read access. This is because files
   called e0.m, e1.m, e12.m etc are created when you initialise an algebra,
   so there must be write access for them to be written to the folder. Also
   these files will not be correctly found on the search path if the folder
   is in the MATLAB/toolboxes folder due to path cacheing.

2. Set the Matlab path to include the directory/folder clifford.
   This is done from the Matlab File -> Set Path menu up to version 7 of
   Matlab, and from the Home tab, Environment section in versions 8 and 9.
   [The clifford folder must be near the top of the path, i.e.
   higher than the standard Matlab folders, otherwise the
   overloading of Matlab functions will not work.]

3. To run a test of the toolbox, type the command 'clifford_test'
   in the Matlab command window. This runs a test of many parts
   of the toolbox and will allow you to confirm that installation
   is correct. This will not work unless the path is set correctly
   (see previous point). This test takes many minutes because it tests the
   toolbox in many algebras.

4. Documentation for the toolbox is provided, and should be visible in the
   Help window provided the path has been set correctly as noted in point 2
   above. Look for the hyperlink under Supplemental Software.

   Also, the MATLAB command 'doc clifford' typed in the command window will
   produce a helpful listing of functions with help information derived
   from the source code files.

5. There is a mailing list

   clifford_multivector-toolbox-releases@lists.sourceforge.net

   Subscribe to this list to receive (infrequent) email notification of new
   releases or other important information about the toolbox.

6. For TeX/LaTeX users: there is a folder within the toolbox containing
   BiBTeX records for the toolbox itself and any papers referred to in the
   source code.

Steve Sangwine
Eckhard Hitzer

March 2015
Updated June 2015
Updated July 2015
Updated November 2016

$Id: Read_me.txt 104 2016-11-26 21:46:15Z sangwine $
