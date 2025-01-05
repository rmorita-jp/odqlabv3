clear
if strcmp(con,'ff')==1


%G1(sからzの伝達関数),G2(rからzの伝達関数)
sys_G1 = ss(G.a, G.b2, G.c1, G.d1, 0.1);
sys_G2 = ss(G.a, G.b1+G.b2*G.d2, G.c1, G.d1, 0.1);
tf_G1 = tf(sys_G1);
tf_G2 = tf(sys_G2);

%% G1の伝達関数の因数分解した形を出す
% 零点、極、ゲインを計算
[zeros, poles, K] = zpkdata(tf_G1, 'v');

% 零点-極-ゲイン形式で伝達関数を表示
sys_zpk_G1 = zpk(zeros, poles, K);
disp('因数分解された伝達関数:');
disp(sys_zpk_G1);

%% G1=F1*F2にする(F1:最小位相系，F2:非最小位相系) 
% 零点を分類して直列分解
unstable_zeros = zeros(abs(zeros) > 1); % 不安定零点 (絶対値1より大きい)
stable_zeros = zeros(abs(zeros) <= 1);    % 安定零点 (絶対値1以下)

% 条件に基づいて分解
if isempty(unstable_zeros)
    % 条件 1: 不安定零点がない場合
    F1 = tf(sys_zpk_G1); % F1はG1そのもの
    F2 = tf(1);          % F2は1
elseif numel(unstable_zeros) == 1
    % 条件 3: 不安定零点が1つの場合
    a = unstable_zeros(1); % 不安定零点
    F1 = zpk(stable_zeros, poles, K, tf_G1.Ts); % 安定零点のみ
    F2 = zpk([a], [1], 1, tf_G1.Ts);            % 不安定零点を分離
elseif numel(unstable_zeros) == 2 && sign(unstable_zeros(1)) ~= sign(unstable_zeros(2))
    % 条件 4: 不安定零点が2つで異符号の場合
    a1 = unstable_zeros(1); % 不安定零点1
    a2 = unstable_zeros(2); % 不安定零点2
    F1 = zpk(stable_zeros, poles, K, tf_G1.Ts); % 安定零点のみ
    F2 = zpk([a1, a2], [1, 1], 1, tf_G1.Ts);    % 不安定零点を分離
else
    % 条件 5: それ以外の場合
    disp('The decomposition is not supported for this case.');
    return;
end

% 分解結果を表示
disp('F1 (stable part):');
disp(F1);
disp('F2 (unstable part):');
disp(F2);

% 検算: F1 * F2 が G1 に等しいか確認
disp('Verification (F1 * F2 should equal G1):');
disp(F1 * F2);

end