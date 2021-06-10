function [X,Z,K] = NewtonChol(A, b, c, x, lambda, s, gap, weight)

    %parameters
    if isempty(gap) 
        gap = 1.0e-6; %optimality gap
    end    
    if isempty(weight) 
        weight = 20; %weight initial point
    end
    
    k=0; %iteration number
    rho= 0.99; 
    eps = 1e-4;
    zero = 1e-16;
    sigma = 0.1;

    %dimensions of inputs
    [m,n]= size(A); 
    
    %starting point (might be infeasible)
    if isempty(x) 
        x = ones(n,1)*weight;  
    end
    if isempty(s) 
        s = ones(n,1)*weight;
    end
    if isempty(lambda)  
        lambda = ones(m,1)*weight;
    end

    %matrix definitions
    e = ones(n,1);
    is = 1./s;
    xs = x.*s;
    rc = A'*lambda + s - c;
    rb = A*x - b;
    mu = x'*s/n;
    rxs = x.*s - sigma*mu*e;
    I = eye(m);
    

    %Main loop while not solution
    %----------------------------
    while (((norm(rc)/(1+norm(c)))> gap || (norm(rb)/(1+norm(b)))> gap || (mu > gap)) & k < 150) 
        %compute the affine direction

            %matrix Theta
            Theta=sparse(diag(x.*is));
            AThA=sparse(A*Theta*A');
            P = colamd(AThA);
            [D,L] = Cholesky(AThA(P,P));  
            righ_hand = -rb + A*(-x.*is.*rc + is.*rxs);

            %direction affine
            dlam(P) = (diag(D)*L')\(L\righ_hand(P)); 
            dlam = dlam(:);
            ds = -rc - A'*dlam;
            dx = -is.*rxs - x.*is.*ds;

            %alphas p and d    
            alphas = -x./dx;  
            alpha_p = min(1, rho*min(alphas(alphas>=zero)));

            alphas = -s./ds; 
            alpha_d = min(1, rho*min(alphas(alphas>=zero)));

            %new point x
            x = x + alpha_p*dx;
            s = s + alpha_d*ds;
            lambda = lambda + alpha_d*dlam;

            %update iteration number
            k = k +1;

            %update values
            mu = x'*s/n;
            rc = A'*lambda + s - c;
            rb = A*x - b;
            rxs = x.*s - sigma*mu*e;
            is = 1./s;
    
    %End main loop if condition satisfied
    %------------------------------------
    end

    Z = c'*x;
    X = x;
    K = k;

end
      
  
