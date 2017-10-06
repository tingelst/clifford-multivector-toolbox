# Clifford Multivector Toolbox
## A toolbox for computing with Clifford algebras in MATLAB

This is a toolbox (software library) for computing with matrices of Clifford algebra multivectors in MATLAB. It is designed to handle numerical computations with matrices as far as these are defined for matrices of multivectors. The toolbox is designed to work in the same way as MATLAB's own functions by overloading standard MATLAB functions with Clifford multivector versions. The toolbox can compute with any Clifford algebra with signature (p,q,r) but only with one algebra at a time. It is possible to iterate over algebras (switching between algebras is quite quick) and existing variables are not destroyed when switching to a new algebra (although such variables cannot be used under the new algebra - any attempt to do so is detected and will raise an error).

Homepage: http://clifford-multivector-toolbox.sourceforge.net/
