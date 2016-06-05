function [ G ] = dag_graph( n, reqs, reqs2, dout)
%RANDOM_GRAPH 生成一个n个节点, reqs个必经节点, dout的平均初度的一个图
% 本脚本生成的随机图保证有解; 因为边是用邻接矩阵存的, 所以也没有重边
%
% *******复赛新增********
% reqs2: tour2的必须结点数
% m_dis2: 重边的第二条
% tour: 一条从s到t的tour(结点序), 该tour既是tour1的可行解, 也是tour2的可行解
%
% 作者: 易惠康
% 日期: 2016-05-19
%
% 问题记录: 有一定概率会生成自环, 这里只做简单的去除自环操作, 这样会略使得有效边数减少

%% 初始化与准备

if (reqs + reqs2 > n - 2)
    disp('|v*| + |v**| > n-2...');
    exit;
end

max_weight = 10000;
max_dout = 20;

m = n * dout;

G.n = n;
G.s = 1;
G.t = 2;

rp = randperm(reqs + reqs2);
G.req = 2 + rp(1:reqs);
G.req2 = 2 + rp(reqs+1:end);

G.m_dis = max_weight * ones(n, n);
G.m_dis2 = max_weight * ones(n, n);


% 各节点的度(平均为dout, 服从高斯分布)
if (dout == max_dout || dout == 1)
    degree = dout * ones(1, n);
else
    sigma = min([(max_dout-dout)*0.25, (dout-1)*0.25]); % 高斯分布标准差
    degree = round(normrnd(dout, sigma, 1, n));
    degree(degree <= 0) = 1;
    degree(degree > max_dout) = max_dout;
    while (sum(degree) ~= m)
        degree = round(normrnd(dout, sigma, 1, n));
        degree(degree <= 0) = 1;
        degree(degree > max_dout) = max_dout;
    end
end

%% 保证有解边

rp = [1 randperm(n-2)+2 2];
for i = 1 : n - 1
    add_edge(rp(i), rp(i+1), ceil(100*rand()));
    degree(rp(i)) = degree(rp(i)) - 1;
end

%% 其它边
for i = 1 : n-1
    x = rp(i);
    neibor = rp(i + randperm(n - i, min(degree(x), n-i)));
    degree(x) = degree(x) - numel(neibor);
    for y = neibor
        add_edge(x, y, ceil(100*rand()));
        if (degree(x) > 0 && rand() > 0.35)
            add_edge(x, y, ceil(100*rand()));
            degree(x) = degree(x) - 1;
        end
    end
end


% G = shuffle(G);


    function add_edge(u, v, w)
%         fprintf('edge: %d %d %d\n', u, v, w);
        if (G.m_dis(u,v) == max_weight)
            G.m_dis(u, v) = w;
        else
            G.m_dis2(u, v) = w;
        end
    end
end

