function G=compg(P,K,con)
%COMPG Compute system G
%
%G = COMPG(P,K,CON) computes the state space representation of G.
%G is combination form of a plant P and a controller K.
%
%P is a sturucture object representing the state-space model of the plant
%below,
%     Xp(k+1) = P.a  * Xp(k) + P.b * v(k)
%       z(k)  = P.c1 * Xp(k)
%       y(k)  = P.c2 * Xp(k)
%
%K is a sturucture object representing the state-space model of the
%controller below,
%     Xk(k+1) = K.a * Xk(k) + K.b1 * r(k) + K.b2 * y(k)
%       u(k)  = K.c * Xk(k) + K.d1 * r(k) + K.d2 * y(k)
%
%CON is a string representing connection between P, K, and the quantizer.
%Three types of connection below you can set.
%   'ff'   Feedforward system
%             +-----+  v  +-----+    
%       u --->|  Q  |---->|  P  |---> z 
%             +-----+     +-----+    
%
%   'fbiq'   Feedback system with input quantizer
%             +-------+     +-------+     +-------+     
%       r --->|       |  u  |       |  v  |       |---> z
%             |   K   |---->|   Q   |---->|   P   |     
%          +->|       |     |       |     |       |--+  
%          |  +-------+     +-------+     +-------+  |y 
%          +-----------------------------------------+  
%
%   'fboq'   Feedback system with output quantizer
%             +-------+           +-------+     
%       u --->|       |           |       |---> z 
%             |   K   |---------->|   P   |     
%          +->|       |           |       |--+  
%         v|  +-------+  +-----+  +-------+  |u
%          +-------------|  Q  |<------------+  
%                        +-----+              
%
%See also odq, odqreal, odqcost.

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

%%%%%%%%%%correct parameters%%%%%%%%%%
if (isfield(P,'a')==0 || isequal(P.a,0)==1)
    P.a  = zeros( size(P.b,1) );
end
if (isfield(K,'b1')==0)                                     %for simulation
    K.b1 = [];
end
if (isfield(K,'d1')==0)
    K.d1 = [];
end
if (isfield(K,'d2')==0 || isequal(K.d2,0)==1)
    K.d2 = zeros( size(P.b,2) , size(P.c2,1) );
end
if (isfield(K,'c')==0 || isequal(K.c,0)==1)
    K.a  = [];
    K.b2 = zeros(    0         , size(P.c2,1) );
    K.c  = zeros( size(P.b,2) ,     0         );
else
    if (isfield(K,'a')==0 || isequal(K.a,0)==1)
        K.a  = zeros( size(K.c,2) );
    end
    if (isfield(K,'b2')==0 || isequal(K.b2,0)==1)
        K.b2 = zeros( size(K.c,2) , size(P.c2,1) );
    end
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    +-----+   +-----+    %
% -->|  Q  |-->|  P  |--> %
%    +-----+   +-----+    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(con,'ff')==1
    G.a  = P.a;
    G.b1 = 0;                                               %for simulation
    G.b2 = P.b;
    G.c1 = P.c1;
    G.c2 = zeros( size(G.b2,2),size(G.b2,1) );              %for simulation
    G.d1 = 0;                                               %for simulation
    G.d2 = eye();                                           %for simulation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     +-----+   +-----+   +-----+     %
% --->|     |   |     |   |     |---> %
%     |  K  |-->|  Q  |-->|  P  |     %
%  +->|     |   |     |   |     |--+  %
%  |  +-----+   +-----+   +-----+  |  %
%  +-------------------------------+  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(con,'fbiq')==1
    G.a  = [  P.a     zeros( size(P.a,1) , size(K.a,2) ) ;
            K.b2*P.c2    K.a                             ];
    G.b1 = [ zeros( size(P.a,1),size(K.b1,2) ) ;
              K.b1                             ];           %for simulation
    G.b2 = [   P.b                            ;
             zeros( size(K.a,1),size(P.b,2) ) ];
    G.c1 = [ P.c1 zeros( size(P.c1,1) , size(K.a,2) ) ];
    G.c2 = [ K.d2*P.c2 K.c ];
    G.d1 = 0;                                               %for simulation
    G.d2 = K.d1;                                            %for simulation  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     +-----+           +-----+     %
% --->|     |           |     |---> %
%     |  K  |---------->|  P  |     %
%  +->|     |           |     |--+  %
%  |  +-----+  +-----+  +-----+  |  %
%  +-----------|  Q  |<----------+  %
%              +-----+              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(con,'fboq')==1
    G.a  = [  P.a                            P.b*K.c ;
            zeros( size(K.a,1),size(P.a,2) )   K.a   ];
    G.b1 = [ P.b*K.d1 ;
               K.b1   ];                                    %for simulation
    G.b2 = [ P.b*K.d2 ;
               K.b2   ];
    G.c1 = [ P.c1 zeros( size(P.c1,1), size(K.a,2) ) ];
    G.c2 = [ P.c2 zeros( size(P.c2,1), size(K.a,2) ) ];
    G.d1 = 0;                                               %for simulation
    G.d2 = 0;                                               %for simulation
    
%%%%%%%%%%OTHER%%%%%%%%%%
else
    error('illigal form')
end
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%finalize%%%%%
if isempty(G.b1)==1
    G.b1=0;
end
if isempty(G.d1)==1
    G.d1=0;
end
if isempty(G.d2)==1
    G.d2=0;
end
%%%%%%%%%%%%%%%%%%