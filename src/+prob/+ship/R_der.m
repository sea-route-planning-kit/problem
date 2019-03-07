function R_der = R_der(psi)
  R_der = [-sin(psi) -cos(psi) 0;
           cos(psi) -sin(psi)  0;
           0        0         0];
end