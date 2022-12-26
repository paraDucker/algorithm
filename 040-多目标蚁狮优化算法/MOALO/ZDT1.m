function o = ZDT1(x)

o = [0, 0];

dim = length(x);
g = 1 + 9*sum(x(2:dim))/(dim-1);

o(1) = x(1);
o(2) = g*(1-sqrt(x(1)/g));



