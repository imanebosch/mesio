function [X,Z,K] = Mehrotra(A, b, c, x, lambda, s, gap, weight)

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
    rxs = x.*s;
    I = eye(m);
    mu = x'*s/n;

    %Main loop while not solution
    %----------------------------
    while (((norm(rc)/(1+norm(c)))> gap || (norm(rb)/(1+norm(b)))> gap || (mu > gap)) & k < 500)
        %compute the affine direction

            %matrix Theta
            Theta=sparse(diag(x.*is));
            AThA=sparse(A*Theta*A' + eps*I);
            P = colamd(AThA);
            AThA_Chol = chol(AThA(P,P));
            righ_hand = -rb + A*(-x.*is.*rc + is.*rxs);

            %direction affine, %hem d'aplicar choleski
            daflam(P) = AThA_Chol\(AThA_Chol'\righ_hand(P));
            daflam = daflam(:);
            dafs = -rc - A'*daflam;
            dafx = -is.*rxs - x.*is.*dafs;

            affdir = [dafx
                      daflam
                      dafs];

            %alphas p and d affine (repassar) logica de alphas
            alphas = -x./dafx;
            alpha_p_aff = min([alphas(alphas>=zero) ;1]);


            alphas = -s./dafs;
            alpha_d_aff = min([alphas(alphas >= zero);1]);

            %mu affine, mu and sigma
            mu_aff = (x + alpha_p_aff*dafx)'*(s + alpha_d_aff*dafs)/n;
            sigma = (mu_aff/mu)^3;

            %center corrector direction falta cholesky
            rb = zeros(m,1);
            rc = zeros(n,1);
            rxs = - sigma*mu*e + dafx.*dafs;
            righ_hand = -rb + A*(-x.*is.*rc + is.*rxs);

            dcclam(P) = AThA_Chol\(AThA_Chol'\righ_hand(P));
            dcclam = dcclam(:);
            dccs = -rc - A'*dcclam;
            dccx = -is.*rxs - x.*is.*dccs;

            ccdir = [dccx
                      dcclam
                      dccs];

            %direction
            direction = ccdir + affdir;

            %alphas p and d
            alphas = -x./direction(1:n);
            alpha_p = min(1, rho*min(alphas(alphas>=zero)));

            alphas = -s./direction(n+m+1:2*n+m);
            alpha_d = min(1, rho*min(alphas(alphas>=zero)));

            %new point x
            x = x + alpha_p*direction(1:n);
            s = s + alpha_d*direction(n+m+1:2*n+m);
            lambda = lambda + alpha_d*direction(n+1:n+m);

            %update iteration number
            k = k +1;

            %update values
            mu = x'*s/n;
            rc = A'*lambda + s - c;
            rb = A*x - b;
            rxs = x.*s;
            is = 1./s;
    %End main loop is condition satisfied
    %------------------------------------
    end

    Z = c'*x;
    X = x;
    K = k;

end
