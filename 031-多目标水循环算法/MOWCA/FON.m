function Feval=FON(x)

global nvars

a=0;
b=0;
for i=1:nvars
    a=a+(x(i)-(1/8^0.5))^2;
    b=b+(x(i)+(1/8^0.5))^2;
end
f1=1-exp(-a);
f2=1-exp(-b);

Feval=[f1;f2];

end