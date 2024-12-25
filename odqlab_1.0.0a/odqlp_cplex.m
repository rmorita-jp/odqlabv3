function [x,exitflag,T,FOPT] = odqlp_cplex(G,T,gamma)
%ODQLP Optimal Dynamic Quantizer with LP
%
%This function is not to use alone.
%Please use 'ODQ'.
%
%See also odq.

% -------------------------------------------------------------------------
% Copyright is with the following author. 
% (C) 2008 Ryosuke Morita, 
%          Kyoto University;
%          Gokasho, Uji, Kyoto 611-0011, Japan
%          morita@robot.kuass.kyoto-u.ac.jp
% -------------------------------------------------------------------------
% Legal Note:
%           
%     (a)  This program is a free software. 
%          
%     (b)  This program is distributed according to GNU General Public
%          License, i.e., it is allowed to use WITHOUT ANY WARRANTY; 
%          without even the implied warranty of
%          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
%          See the GNU General Public License for more details.
% 
% -------------------------------------------------------------------------

%%%%%set parameters%%%%%
if (mod(T,1)~=0)
    error('steptime must be a natural number');
end
if (mod(T,2)==0)
    T=T+1;
end
if (gamma.wv<1)
    error('max gain w->v must be greater than 1');
end

m = size(G.c1*G.b2,2);
p = size(G.c1*G.b2,1);

G.aa = G.a+G.b2*G.c2;    %convert to closed loop
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%initialize%%%%%
if gamma.wv==inf
    vectorf = zeros( 1 + m*m*T + p*m*(T-1) , 1 );
else
    vectorf = zeros( 1 + m*m*T*2 + p*m*(T-1) , 1 );
end
%vectorb = zeros( p + p*m*(T-1)*2 + m + m*m*T*2 , 1 );
%matrixA = zeros( p + p*m*(T-1)*2 + m + m*m*T*2 , 1 + m*m*T + p*m*(T-1) );
%%%%%%%%%%%%%%%%%%%%

vectorf(1)=1;

fprintf('Preprocessing for LP...\n')
pause(0.1)

%%%%%making PHI%%%%%
PHI     = zeros( m*p*(T-1) , m*m*T );   %initialize
PHIdash = zeros( p , m );               %initialize
for i=1:T-1
    PHIdash = kron( G.c1*G.aa^(i-1)*G.b2 , eye(m) );
    for j=i:T-1
        PHI( (j-1)*m*p+1:j*m*p , (j-i)*m*m+1:(j-i+1)*m*m ) = PHIdash;
    end
end
%%%%%%%%%%%%%%%%%%%%

%%%%%making 'matrix -> vector' transposer%%%%%
eye_sumE = kron( ones(1,m*(T-1)) , eye(p) );
eye_sumH = kron( ones(1,m*T) , eye(m) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%finalize%%%%%%%%%%
if gamma.wv==inf
    matrixA = [ -ones( p , 1 )         zeros( p , m*m*T )  eye_sumE                 ;
                zeros( p*m*(T-1) , 1 )   PHI              -eye( m*p*(T-1) )         ;
                zeros( p*m*(T-1) , 1 )  -PHI              -eye( m*p*(T-1) )         ];
else
    matrixA = [ -ones( p , 1 )         zeros( p , m*m*T ) zeros( p , m*m*T )           eye_sumE                 ;
                zeros( p*m*(T-1) , 1 )   PHI              zeros( p*m*(T-1) , m*m*T )  -eye( m*p*(T-1) )         ;
                zeros( p*m*(T-1) , 1 )  -PHI              zeros( p*m*(T-1) , m*m*T )  -eye( m*p*(T-1) )         ;
                zeros( m , 1 )         zeros( m , m*m*T )   eye_sumH                 zeros( m , m*p*(T-1) )     ;
                zeros( m*m*T , 1 )       eye( m*m*T )      -eye( m*m*T )             zeros( m*m*T , m*p*(T-1) ) ;
                zeros( m*m*T , 1 )      -eye( m*m*T )      -eye( m*m*T )             zeros( m*m*T , m*p*(T-1) ) ];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%making C A^k B ,changing matrix to vector%%%%%
CAB = zeros( (T-1)*p , m );             %initialize
el_CAB = zeros( m*p*(T-1) , 1 );        %initialize

for i=1:T-1
    CAkB = G.c1*G.aa^i*G.b2;
    CAB( (i-1)*p+1:i*p , 1:m ) = CAkB;
end

for j=1:p*(T-1)
    for i=1:m
        el_CAB( i+(j-1)*m , 1 ) = CAB( j , i );
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%finalize%%%%%%%%%%
if gamma.wv==inf
    vectorb = [ -abs( G.c1*G.b2 )*ones( m , 1 ) ;
                -el_CAB                         ;
                 el_CAB                         ];
else
    vectorb = [ -abs( G.c1*G.b2 )*ones( m , 1 ) ;
                -el_CAB                         ;
                 el_CAB                         ;
                 (gamma.wv-1)*ones( m , 1 )     ;
                 zeros( m*m*T*2,1 )             ];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%liner programing problem%%%%%%%%%%
fprintf('Solving LP problem(cplex)...\n')
pause(0.1)
[x,FOPT,STATUS]=lp_cplex(1,vectorf,matrixA,vectorb);
exitflag=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
