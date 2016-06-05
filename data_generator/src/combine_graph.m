function [ g ] = combine_graph( g1, g2, extra_edge)
%COMBING_GRAPH 将两个图合并起来

% 结点编号: 结点规模, 起点, 终点
g.n = g1.n + g2.n;
g.s = g1.s;
g.t = g2.t + g1.n;

% 两条路的必须点
g.req = [g1.req, g2.req + g1.n];
g.req2 = [g1.req2, g2.req2 + g1.n];
if (numel(g.req) > 100)
    rp = randperm(numel(g.req), 100);
    g.req = g.req(rp);
end
if (numel(g.req2) > 100)
    rp = randperm(numel(g.req2), 100);
    g.req2 = g.req2(rp);
end

% 距离矩阵1
g.m_dis = ones(g.n, g.n) * 10000;
g.m_dis(1:g1.n, 1:g1.n) = g1.m_dis;
g.m_dis(g1.n+1:end, g1.n+1:end) = g2.m_dis;
g.m_dis(g1.t, g2.s + g1.n) = 1; %ceil(100 * rand()); % 连接第一个图的终点和第二个图的起点

% 距离矩阵2
g.m_dis2 = ones(g.n, g.n) * 10000;
g.m_dis2(1:g1.n, 1:g1.n) = g1.m_dis2;
g.m_dis2(g1.n+1:end, g1.n+1:end) = g2.m_dis2;
g.m_dis2(g1.t, g2.s + g1.n) = 100; %ceil(100 * rand()); % 连接第一个图的终点和第二个图的起点(连两次才能保证有解性)

% 添加额外的边(仅g1中的结点指向g2中的结点)
if exist('extra_edge', 'var')
    for i = 1 : g1.n
        ei = g1.m_dis(i, :);
        ei2 = g1.m_dis2(i, :);
        dout = numel(ei(ei <= 100));
        dout = dout + numel(ei2(ei2 <= 100));
        rp = randperm(g2.n);
        for j = rp
            if (dout == 100)
                break;
            end
            if (i == j || g.m_dis(i, j + g1.n) <= 100)
                continue;
            end
            g.m_dis(i, g1.n + j) = ceil(100 * rand());
            dout = dout + 1;
        end
    end
end


% 重新打乱编号
% shuffle(g);

end

