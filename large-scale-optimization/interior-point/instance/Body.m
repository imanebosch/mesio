%------------------------------------%
%Problem 596
%------------------------------------

load('596_lp_adlittle.mat')

A = Problem.A;
b = Problem.b;
c = Problem.aux.c;
gap=1.0e-6;

%initial point problem
[x,lambda,s] = StartPoint(A,b,c);

%Newton 
%--------------------------
    %native chol
    [x596n,z596n,k596n] = Newton(A, b, c, x, lambda, s,gap,[]);

    %own cholesky-inf funtion
    [x596nc,z596nc,k596nc] = NewtonChol(A, b, c, x, lambda, s,gap,[]);

%Mehrotra
%--------------------------
    %native chol
    [x596m,z596m,k596m] = Mehrotra(A, b, c, x, lambda, s,gap,[]);

    %own cholesky-inf funtion
    [x596mc,z596mc,k596mc] = MehrotraChol(A, b, c, x, lambda, s,[],[]);

%------------------------------------%
%PROBLEM 597
%------------------------------------%

load('597_lp_afiro.mat')

A = Problem.A;
b = Problem.b;
c = Problem.aux.c;
gap=1.0e-6;

[x,lambda,s] = StartPoint(A,b,c);

%Newton 
%--------------------------
    %native chol
    [x597n,z597n,k597n] = Newton(A, b, c, x, lambda, s,gap,[]);

    %own cholesky-inf funtion
    [x597nc,z597nc,k597nc] = NewtonChol(A, b, c, x, lambda, s,gap,[]);

%Mehrotra
%--------------------------
    %native chol
    [x597m,z597m,k597m] = Mehrotra(A, b, c, x, lambda, s,gap,[]);

    %own cholesky-inf funtion
    [x597mc,z597mc,k597mc] = MehrotraChol(A, b, c, x, lambda, s,gap,[]);

%------------------------------------%
%PROBLEM 598
%------------------------------------%

load('598_lp_agg.mat')

A = Problem.A;
b = Problem.b;
c = Problem.aux.c;
gap=1.0e-6;

%initial point problem
[x,lambda,s] = StartPoint(A,b,c);

%Newton 
%--------------------------
    %native chol
    [x598n,z598n,k598n]  = Newton(A, b, c, x,lambda,s,gap,[]);

    %own cholesky-inf funtion
    [x598nc,z598nc,k598nc]  = NewtonChol(A, b, c, x,lambda,s,gap,[]);

%Mehrotra
%--------------------------
    %native chol
    [x598m,z598m,k598m] = Mehrotra(A, b, c, x, lambda, s,gap,[]);

    %own cholesky-inf funtion
    [x598mc,z598mc,k598mc] = MehrotraChol(A, b, c, x, lambda, s,gap,[]);

%------------------------------------%
%PROBLEM 614
%------------------------------------%

load('614_lp_czprob.mat')

A = Problem.A;
b = Problem.b;
c = Problem.aux.c;
gap=1.0e-6;

%initial point problem
[x,lambda,s] = StartPoint(A,b,c);

%Newton 
%--------------------------
    %native chol
    [x614n,z614n,k614n] = Newton(A, b, c, x, lambda, s ,gap,[]);
    
    %own cholesky-inf funtion
    [x614nc,z614nc,k614nc] = NewtonChol(A, b, c, x, lambda, s ,gap,[]);

%Mehrotra
%--------------------------
    %native chol
    [x614m,z614m,k614m] = Mehrotra(A, b, c, x, lambda, s,gap,[]);
    
    %own cholesky-inf funtion
    [x614mc,z614mc,k614mc] = MehrotraChol(A, b, c, x, lambda, s,gap,[]);
    

    
    