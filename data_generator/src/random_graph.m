function [ G ] = random_graph( n, reqs, reqs2, dout)
%RANDOM_GRAPH 生成一个n个节点, reqs个必经节点, dout的平均初度的一个图
% 本脚本生成的随机图保证有解; 因为边是用邻接矩阵存的, 所以也没有重边
%
% *******复赛新增********
% reqs2: tour2的必须结点数
% m_dis2: 重边的第二条
% tour: 一条从s到t的tour(结点序), 该tour既是tour1的可行解, 也是tour2的可行解
%
% 作者: 易惠康
% 日期: 2016-03-25
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

% 保证tour1, tour2有解
rp = randperm(n-2)+2;
rand_eweight = floor(100 * rand(1, n-1));
G.tour = [1 rp 2];
for i = 1 : n - 1
    add_edge(G.tour(i), G.tour(i+1), rand_eweight(i));
end

% 纠正出度
for i = 1 : n
    for j = 1 : n
        if G.m_dis(i, j) < max_weight
            degree(i) = degree(i) - 1;
            m = m - 1;
        end
        if G.m_dis2(i, j) < max_weight
            degree(i) = degree(i) - 1;
            m = m - 1;
        end
    end
end


%% 得到随机边

% 每个节点i复制成degree(i)倍组成node_list
node_cnt = 0;
node_list = zeros(1, m);
for i = 1 : n
    node_list(node_cnt+1 : node_cnt+degree(i)) = i;
    node_cnt = node_cnt + degree(i);
end

% 打乱node_list, 并使得node_list中首元为s, 末元为t
node_list = node_list(randperm(m));
for i = m:-1:1  % 交换一个元素使node_list中首元为s
    if (node_list(1) == G.s)
        break;
    end
    if (node_list(i) == G.s)
        node_list(i) = node_list(1);
        node_list(1) = G.s;
    end
end
for i = 1:m     % 交换一个元素使node_list中末元为t
    if (node_list(end) == G.t)
        break;
    end
    if (node_list(i) == G.t)
        node_list(i) = node_list(end);
        node_list(end) = G.t;
    end
end

%连边
rand_eweight = ceil(100 * rand(1, m-1));
for i = 1 : m - 1
    if (node_list(i) ~= node_list(i+1)) % 这里是为什么产生自环的原因
        add_edge(node_list(i), node_list(i+1), rand_eweight(i));
    end
end


%% 打乱节点编号

G = shuffle(G);

    function add_edge(u, v, w)
        if (G.m_dis(u,v) == max_weight)
            G.m_dis(u, v) = w;
        else
            G.m_dis2(u, v) = w;
        end
    end
end