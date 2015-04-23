function [H] = hurwitz(A,degA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [H]=hurwitz(A,degA)                                   %
%%                                                       %
%% MATLAB FUNCTION hurwitz COMPUTE BLOCK  HURWITZ        %
%% MATRIX  H  FOR POLYNOMIAL MATRIX  A, WITH  degA=n     %
%%                                                       %
%% A(s) = A_n*s^n + A_(n-1)*s^(n-1) + ...+ A_1*s + A_o   %
%%                                                       %
%%     [ A_(n-1)  A_(n-3)  A_(n-5)  ...            0   | %
%%     | A_n      A_(n-2)  A_(n-4)  ...            0   | %
%% H = | 0        A_(n-1)  A_(n-3)  A_(n-5)  ...   0   | %
%%     | 0        A_n      A_(n-2)  A_(n-4)  ...   0   | %
%%     | ...      ...      ...      ...      ...   ... | %
%%     | 0        0        0                 ...   A_o ] %
%%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S. Pejchova, November  23rd,  1994                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preliminary steps and initialization                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ar,ac] = polsize(A,degA);

if degA <= 1
    if degA==1
        H = A(:,1:ac);
    else
        H = A;
    end
else
    bl=fix(degA/2)+1;
    Aux1=zeros(ar,bl*ac);
    Aux1=sym(Aux1);
    Aux2=Aux1;
    for i=1:bl
        Aux2(:,(i-1)*ac+1:ac*i)=A(:,((degA+2-2*i)*ac+1):(degA+3-2*i)*ac);
    end
    
    if rem(degA,2)==0
        bl1=bl-1;                                       % even degree
    else
        bl1=bl;                                         % odd degree
    end
    
    for j=1:bl1
        Aux1(:,(j-1)*ac+1:ac*j)=A(:,((degA+1-2*j)*ac+1):(degA+2-2*j)*ac);
    end
    
    Aux3=[Aux1; Aux2];
    if degA >2
        H=[];
        for i=1:(degA-bl1)
            LZ=zeros(2*ar,ac*(i-1));
            RZ=zeros(2*ar,ac*((degA-bl)-(i-1)));
            Aux4=[LZ, Aux3, RZ];
            H = [H; Aux4];
        end
        
        if rem(degA,2)~=0                               % odd degree
            H = [H; zeros(ar,ac*(degA-bl)), Aux1];
        end
    else
        H=Aux3;                                         % degA = 2
    end
    
end

    function [rQ,cQ] = polsize(Q,degQ)
        
        [rQ,cQ] = size(Q);
        
        if degQ < 0
            return
        end
        
        cQ = cQ/(degQ+1);
        
        if abs(round(cQ)-cQ) > 1e-6
            error('polsize: Degree of input inconsistent with number of columns');
        else
            cQ = round(cQ);
        end
        
    end

end