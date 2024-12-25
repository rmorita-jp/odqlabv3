function stb=odqstb(Q)
%ODQSTB Check the stability of Q
%
%If Q is stable, stb=1.
%Otherwise stb=0.
%
%See also odq 

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

if max(abs(eig(Q.a+Q.b2*Q.c)))>1
    stb=0;
else
    stb=1;
end