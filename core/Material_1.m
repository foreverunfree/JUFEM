% Isotropic Elasticity, rate- and temperature independent for small deformations
%
% Inputs: 
%  stress [s11 s22 s33 s12 s13 s23]
%  dstrain [e11 e22 e33 e12 e13 e23]
%  properties [E nu]
%
% Outputs: 
%  stress [s11 s22 s33 s12 s13 s23]
%  constitutive_tensor [D1111 D1122 D1133 D1112 D1113 D1123]
%                      [D2211 D2222 D2233 D2212 D2213 D2223]
%                      [D3311 D3322 D3333 D3312 D3313 D3323]
%                      [D1211 D1222 D1233 D1212 D1213 D1223]
%                      [D1311 D1322 D1333 D1312 D1313 D1323]
%                      [D2311 D2322 D2322 D2312 D2313 D2323]

function [stress,constitutive_tensor] = Material_1(stress,dstrain,properties)

	lam = properties(1) * properties(2) / ((1 - 2 * properties(2)) * (1 + properties(2)));
	mu = properties(1) / (2 * (1 + properties(2)));
    
    constitutive_tensor = [2*mu+lam lam lam 0 0 0;
                           lam 2*mu+lam lam 0 0 0;
                           lam lam 2*mu+lam 0 0 0;
                           0 0 0 mu 0 0;
                           0 0 0 0 mu 0;
                           0 0 0 0 0 mu];

	stress = stress + constitutive_tensor * dstrain;

end