function z=ZDT4(x)
n=numel(x);
f1=x(1);
sum=0;
for i=2:n
    sum = sum+(x(i)^2-10*cos(4*pi*x(i)));
end
g=1+(n-1)*10+sum;
f2=g*(1-(f1/g)^0.5);
z=[f1
    f2];
end