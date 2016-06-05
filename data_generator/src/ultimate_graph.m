function [ G ] = ultimate_graph( )
%ULTIMATE_GRAPH 生成终极测试样例
% 即2000个点, 100+100个必经结点, 1000*20=20000条有效边
%
% 作者: 易惠康
% 日期: 2016-03-26

%% 参数

n = 2000;
n_v1 = 100;
n_v2 = 100;
max_dout = 20;
max_valid_weight = 100;

%% 先生成随机图(有效边不足1000*20)

G = random_graph(n, n_v1, n_v2, max_dout);


%% 将少的边补上(随机补上, till all node's out degree is 8)

for i = 1 : G.n
    ei = G.m_dis(i, :);
    ei2 = G.m_dis2(i, :);
    dout = numel(ei(ei <= max_valid_weight));
    dout = dout + numel(ei2(ei2 <= max_valid_weight));
    rp = randperm(G.n);
    for j = 1 : G.n
        if (dout == max_dout)
            break;
        end
        if (i == rp(j) || G.m_dis(i, rp(j)) <= max_valid_weight)
            continue;
        end
        G.m_dis(i, rp(j)) = ceil(max_valid_weight * rand());
        dout = dout + 1;
    end
end


end

