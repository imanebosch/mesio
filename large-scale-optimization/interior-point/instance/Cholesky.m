function [D,L] = Cholesky(A)

[m,n] = size(A); 
L = sparse(diag(ones(m,1)));
D = sparse(zeros(m,1));
zero = 1e-16;

for j = 1:m
     c = A(j,j)-D'*(L(j,:)'.*L(j,:)');
     if (c>zero)
        D(j)=c;
     else
        D(j)=10^68;
     end
     
     for i = (j+1):m
         L(i,j)=(A(i,j)-D'*(L(i,:)'.*L(j,:)'))/D(j);
     end
end

end



 
