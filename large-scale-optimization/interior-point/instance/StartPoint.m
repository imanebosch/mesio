function [X,L,S] = StartPoint(A, b, c, w)

if ~exist('w','var') 
  w =10;
end

[m,n]= size(A); 
options.MaxFunEvals = 30000;

%P1
%--------------------
Aeq = A;
beq = b;
c = c;
A = [];
b = [];
lb=[];
ub=[];
nonlcon = [];


x0 = ones(n,1)*w;
fun = @(x)x'*x;
sol1 = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);


%P2
%--------------------
Aeq=[Aeq' eye(n)];
beq=c;
e2 = [zeros(m,1) 
    ones(n,1)];

options.MaxFunEvals = 30000;

fun = @(x)(e2.*x)'*(e2.*x);
x0 = ones(m+n,1)*w;
sol2 = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

%Correctors
%--------------------

deltax = max(-(3/2)*min(sol1),0);
deltas = max(-(3/2)*min(sol2(m+1:m+n)),0);

xstart = sol1 + deltax*ones(n,1);
sstart = sol2(m+1:m+n) + deltas*ones(n,1);
lambdastart = sol2(1:m);

deltax = (1/2)*((xstart'* sstart)/(ones(n,1)'*sstart));
deltas = (1/2)*((xstart'* sstart)/(ones(n,1)'*xstart));

xstart = xstart + deltax*ones(n,1);
sstart = sstart + deltas*ones(n,1);

X=xstart;
L=lambdastart;
S=sstart;
end





