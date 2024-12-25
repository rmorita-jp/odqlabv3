function Q = odqanly(G)
%ODQANLY Optimal Dynamic Quantizer with analytic method
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

G.aa = G.a+G.b2*G.c2;    %convert to closed loop

Q.a  = G.aa;
Q.b1 = -G.b2;
Q.b2 = G.b2;
Q.c  = -pinv(G.c1*G.b2)*G.c1*G.aa;