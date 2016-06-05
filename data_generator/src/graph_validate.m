function [ flag ] = graph_validate( G )
%GRAPH_VALIDATE 检查图是否合法，即是否符合题意
%
% 作者：易惠康
% 日期：2016-03-27
%
% 注意：不对G的结构完整性进行检查，即默认G结构体有n, s, t, req, m_dis等成员
% 检查的项目有：
% 1. 没有自环
% 2. 出度 <= 8

flag = 0;

%% 检查自环

dis_self = diag(G.m_dis);
if (numel(dis_self(dis_self <= 100)) > 0)
    flag = flag + 1;
end

%% 检查出度

for i = 1 : G.n
    dis_out = G.m_dis(i, :);
    degree_out = numel(dis_out(dis_out <= 20));
    if (degree_out > 20)
        flag = flag + 2;
        break;
    end
end

end

