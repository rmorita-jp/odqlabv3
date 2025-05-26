function [Q,E] = odqanly(G,connection,d,T)
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

nv_ff = size(G.b2,2);
nz_ff = size(G.c1,1);
nr = size(G.b1,2);
nv = size(G.b2,2);
nz = size(G.c1,1);
nu = size(G.c2,1);

if strcmpi(connection,'ff') && strcmpi(nv_ff,1) && strcmpi(nz_ff,1) 
    sys_G = ss(G.a, G.b2, G.c1, G.d1, 0.1);
    Ts = 0.1; %sampling time
    
    % Transfer function of the system
    tf_G = tf(sys_G);

    % Calculate zeros and poles of the transfer function
    zeros_ = tzero(tf_G);
    poles = pole(tf_G);

    % Identify unstable zeros (|z| > 1)
    unstable_zeros = zeros_(abs(zeros_) > 1);


    % Case 1: No unstable zeros
    if isempty(unstable_zeros)
        %{
        % Count time delay (poles at z=0)
        n_time_delay = sum(poles == 0);
        % Define z as a discrete-time variable
        num = 1;
        den = [1, zeros(1, n_time_delay)];
        G = tf(num,den,Ts);  % Time delay transfer function
        F = tf_G / G;  % Remaining part
        F_ss = ss(F);  % Convert to state-space representation
        B_F = F_ss.B;
        C_F = F_ss.C;

        % Compute quantization error
        E = norm(abs(C_F * B_F),"inf") * d/2;
        %}

        Q.a  = G.aa;
        Q.b1 = -G.b2;
        Q.b2 = G.b2;
        Q.c  = -pinv(G.c1*G.b2)*G.c1*G.aa;

        E = odqcost(G,Q,d,T);


    % Case 2: One unstable zero
    elseif numel(unstable_zeros) == 1
        i = numel(poles) - numel(zeros_);  % Relative order
        if i < 1
            Q = [];
            E = inf;
            return
        end
        a = unstable_zeros(1);  % First unstable zero
        num = [1, -a];
        den = [1, zeros(1, i)];
        G = tf(num,den,Ts);  % Transfer function with unstable zero
        F = minreal(tf_G / G);  % Remaining part, simplified
        F_ss = ss(F);  % Convert to state-space representation
        B_F = F_ss.B;
        C_F = F_ss.C;
        
        % State-space matrices of F
        A_F = F_ss.A;
        D_F = F_ss.D;
    
        % Check conditions
        if abs(C_F * B_F) == 0
          
                disp('C_F * B_F == 0. Could not calculate quantizer.');
          
            Q = [];
            E = inf;
            return
        end
        if D_F ~= 0
            
                disp('D_F ~= 0. Could not calculate quantizer.');
            
            Q = [];
            E = inf;
            return
        end
        
        % Compute quantization error
        E = (1 + abs(a)) * abs(C_F * B_F) * d/2;

        % Construct dynamic quantizer Q
        Q.a = A_F;
        Q.b1 = -B_F;
        Q.b2 = B_F;
        Q.c = -pinv(C_F*B_F)*C_F*A_F;



    % Case 3: Multiple unstable zeros or unsupported cases
    else
        Q = [];
        E = inf;
        
        disp('Unsupported case: multiple unstable zeros or other issues.');
        return
    
    end
    




        

    

elseif (strcmpi(connection,'GQ') || strcmpi(connection,'fbiq') ||strcmpi(connection,'fboq')) && nr==1 && nv==1 && nz==1 && nu==1
    sys_G1 = ss(G.aa, G.b2, G.c1, G.d1, 0.01);
    %sys_G2 = ss(G.a, G.b1+G.b2*G.d2, G.c1, G.d1, 0.1);
    Ts = 0.01;
    
    % Transfer function of the system
    tf_G1 = tf(sys_G1);
    %tf_G2 = tf(sys_G2);

    % Calculate zeros and poles of the transfer function
    %zeros_ = tzero(tf_G1);
    %poles = pole(tf_G1);
    [zeros_, poles, K] = zpkdata(tf_G1,'v');

    % Identify unstable zeros (|z| > 1)
    unstable_zeros = zeros_(abs(zeros_) > 1);


    % Case 1: No unstable zeros
    if isempty(unstable_zeros)
        
        %{
        F2 = pinv(G.c1*G.b2)*tf_G1;  
        F1 = G.c1*G.b2;  % Remaining part
        F1_ss = ss(F1);  % Convert to state-space representation
        F2_ss = ss(F2);
        B_F1 = F1_ss.B;
        C_F1 = F1_ss.C;
        A_F2 = F2_ss.A;
        B_F2 = F2_ss.B;
        C_F2 = F2_ss.C;
        D_F2 = F2_ss.D;

        % Compute quantization error
        sum_CAB = 0;
        for i=1:10000
        sum_CAB = sum_CAB + abs(C_F2*(A_F2)^(i-1)*B_F2);
        end
        E = (abs(D_F2) + sum_CAB)*d/2;
        %}

        Q.a  = G.aa;
        Q.b1 = -G.b2;
        Q.b2 = G.b2;
        Q.c  = -pinv(G.c1*G.b2)*G.c1*G.aa;
        
        E = odqcost(G,Q,d,T);

    % Case 2: One unstable zero
    elseif numel(unstable_zeros) == 1
        a = unstable_zeros(1);  % First unstable zero
        num = [K*1 K*(-a)];
        den = [1 0];
        F2 = tf(num,den,Ts);  % Transfer function with unstable zero
        F1 = minreal(tf_G1 / F2);  % Remaining part, simplified
        F1_ss = ss(F1);  % Convert to state-space representation
        F2_ss = ss(F2);
        B_F1 = F1_ss.B;
        C_F1 = F1_ss.C;
        A_F2 = F2_ss.A;
        B_F2 = F2_ss.B;
        C_F2 = F2_ss.C;
        D_F2 = F2_ss.D;

        % Compute quantization error
        sum_CAB = 0;
        for i=1:10000
        sum_CAB = sum_CAB + abs(C_F2*(A_F2)^(i-1)*B_F2);
        end
        E = (abs(D_F2) + sum_CAB)*d/2;

        % State-space matrices of F
        A_F1 = F1_ss.A;
        D_F1 = F1_ss.D;
    
        % Check conditions
        if abs(C_F1 * B_F1) == 0
            
                disp('C_F * B_F == 0. Could not calculate quantizer.');
            
            Q = [];
            E = inf;
            return
        end
        if D_F1 ~= 0
            
                disp('D_F ~= 0. Could not calculate quantizer.');
            
            Q = [];
            E = inf;
            return
        end
        % Construct dynamic quantizer Q
        Q.a = A_F1;
        Q.b1 = -B_F1;
        Q.b2 = B_F1;
        Q.c = -C_F1*A_F1;




    % Case 3: two unstable zero
    elseif numel(unstable_zeros) == 2 && sign(unstable_zeros(1)) ~= sign(unstable_zeros(2))
        a1 = unstable_zeros(1);  % First unstable zero
        a2 = unstable_zeros(2); % Second unstable zero
        num = [K*1 K*(-a1-a2) K*(-a1)*(-a2)];
        den = [1 0 0];
        F2 = tf(num,den,Ts);  % Transfer function with unstable zero
        F1 = minreal(tf_G1 / F2);  % Remaining part, simplified
        F1_ss = ss(F1);  % Convert to state-space representation
        F2_ss = ss(F2);
        B_F1 = F1_ss.B;
        C_F1 = F1_ss.C;
        A_F2 = F2_ss.A;
        B_F2 = F2_ss.B;
        C_F2 = F2_ss.C;
        D_F2 = F2_ss.D;

        % Compute quantization error
        sum_CAB = 0;
        for i=1:10000
        sum_CAB = sum_CAB + abs(C_F2*(A_F2)^(i-1)*B_F2);
        end
        E = (abs(D_F2) + sum_CAB)*d/2;

        % State-space matrices of F
        A_F1 = F1_ss.A;
        D_F1 = F1_ss.D;
    %{
        % Check conditions
        if abs(C_F1 * B_F1) ~= 1
            
                disp('C_F * B_F ~= 1. Could not calculate quantizer.');
            
            Q = [];
            E = inf;
            return
        end
    %}
        if D_F1 ~= 0
            
                disp('D_F ~= 0. Could not calculate quantizer.');
            
            Q = [];
            E = inf;
            return
        end
        % Construct dynamic quantizer Q
        Q.a = A_F1;
        Q.b1 = -B_F1;
        Q.b2 = B_F1;
        Q.c = -C_F1*A_F1;


     
     % Case 3': three unstable zero
     elseif numel(unstable_zeros) == 3
        a1 = unstable_zeros(1);  % First unstable zero
        a2 = unstable_zeros(2); % Second unstable zero
        a3 = unstable_zeros(3);
        num = [K*1 K*(-a1-a2-a3) K*((-a1)*(-a2)+(-a2)*(-a3)+(-a3)*(-a1)) K*(-a1)*(-a2)*(-a3)];
        den = [1 20.544 171.69 758.05 1681.16];
        F2 = tf(num,den,Ts);  % Transfer function with unstable zero
        F1 = minreal(tf_G1 / F2);  % Remaining part, simplified
        F1_ss = ss(F1);  % Convert to state-space representation
        F2_ss = ss(F2);
        B_F1 = F1_ss.B;
        C_F1 = F1_ss.C;
        A_F2 = F2_ss.A;
        B_F2 = F2_ss.B;
        C_F2 = F2_ss.C;
        D_F2 = F2_ss.D;
        F1_CB = abs(C_F1 * B_F1);

        
        % Compute quantization error
        sum_CAB = 0;
        for i=1:10000
        sum_CAB = sum_CAB + abs(C_F2*(A_F2)^(i-1)*B_F2);
        end
        E = (abs(D_F2) + sum_CAB)*d/2;
        

        % State-space matrices of F
        A_F1 = F1_ss.A;
        D_F1 = F1_ss.D;
    
        % Check conditions
        if abs(C_F1 * B_F1) ~= 1
            
                disp('C_F * B_F ~= 1. Could not calculate quantizer.');
            
            Q = [];
            E = inf;
            return
        end
    
        if D_F1 ~= 0
            
                disp('D_F ~= 0. Could not calculate quantizer.');
            
            Q = [];
            E = inf;
            return
        end
        % Construct dynamic quantizer Q
        Q.a = A_F1;
        Q.b1 = -B_F1;
        Q.b2 = B_F1;
        Q.c = -C_F1*A_F1;
                        

    % Case 3: Multiple unstable zeros or unsupported cases
    else
        Q = [];
        E = inf;
        
        disp('Unsupported case: multiple unstable zeros or other issues.');
        return
    end
else
    Q.a  = G.aa;
    Q.b1 = -G.b2;
    Q.b2 = G.b2;
    Q.c  = -pinv(G.c1*G.b2)*G.c1*G.aa;

    E = odqcost(G,Q,d,T);
end
end