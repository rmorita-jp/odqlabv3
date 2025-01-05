function Hk = odqhnkl(x,T,m,p)
%ODQHNKL Compute block hankel matrix from inpulse response matrix of ODQ
%
%This function is not to use alone.
%Please use 'ODQREAL'.
%
%See also odqreal.

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

disp('Computing SVD...')
pause(0.1)

Tdash=floor(T/2)+1;

%%%%%making Block Hankel matrix%%%%%
for i=1:m*T
    row_H( i , 1:m ) = x( 2+(i-1)*m : 1+i*m );
end

for i=1:Tdash
    Hk.H( 1:m*Tdash , (i-1)*m+1:i*m ) = row_H( (i-1)*m+1:(i+Tdash-1)*m , : );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%Singular Value Decomposition%%%%%
[Hk.Wo Hk.S Hk.Wc] = svd( Hk.H );
Hk.Wc = Hk.Wc';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%verify%%%%%%%%%%
if norm(Hk.H-Hk.Wo*Hk.S*Hk.Wc,inf)/norm(Hk.H)>10^(-2)
    error('Oops! SVD is failed. Abort Program.')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%