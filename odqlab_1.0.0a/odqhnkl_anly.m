function H=odqhnkl_anly(Q)

nG = size(Q.a,1); %Q‚ÌŽŸŒ³
m  = size(Q.b1,2); %“ü—Í‚Ì”

Tdash = floor(nG/2)+1;


H2k = Q.c*Q.b2;
row_H = H2k;
for k=1:nG
    H2k = Q.c*(Q.a+Q.b2*Q.c)^k*Q.b2;
    row_H = [row_H; H2k];
end

for i=1:Tdash
    H.H(1:m*Tdash, (i-1)*m+1:i*m) = row_H((i-1)*m+1:(i+Tdash-1)*m, :);
end

[H.Wo H.S H.Wc] = svd( H.H );
H.Wc = H.Wc';

if norm(H.H-H.Wo*H.S*H.Wc,inf)/norm(H.H)>10^(-2)
    error('SVD is failed')
end

%hist(diag(H.S))
