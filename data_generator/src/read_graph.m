function [ g ] = read_graph( f_path )
%READ_GRAPH 此处显示有关此函数的摘要
%   此处显示详细说明

% 读入topo文件
topo_file = fopen([f_path, '/topo.csv'], 'r');
edge = fscanf(topo_file, '%d,%d,%d,%d\n');
edge = reshape(edge, [4, floor(numel(edge)/4)])';
edge = edge(:, 2:end);
fclose(topo_file);

m = size(edge, 1);
edge(:, 1:2) = edge(:, 1:2) + 1;
n = max(max(edge(:, 1:2)));
g = struct;

% 结点数
g.n = n;

% 距离矩阵
g.m_dis = ones(n, n) * 100000;
g.m_dis2 = ones(n, n) * 100000;
cnt = zeros(n, n);
for i = 1 : m
    cnt(edge(i, 1), edge(i, 2)) = cnt(edge(i, 1), edge(i, 2)) + 1;
    if edge(i, 3) < g.m_dis(edge(i, 1), edge(i, 2))
        g.m_dis2(edge(i, 1), edge(i, 2)) = g.m_dis(edge(i, 1), edge(i, 2));
        g.m_dis(edge(i, 1), edge(i, 2)) = edge(i, 3);
    elseif edge(i, 3) < g.m_dis2(edge(i, 1), edge(i, 2))
        g.m_dis2(edge(i, 1), edge(i, 2)) = edge(i, 3);
    end
end

% 读入demand.csv文件
demand_file = fopen([f_path, '/demand.csv'], 'r');
demand_str = fscanf(demand_file, '%s\n');

% s && t
p = pos_of(demand_str, ',');
demand_str = demand_str(p+1:end); % 去掉第一个路径编号

p = pos_of(demand_str, ',');
g.s = str2num(demand_str(1:p-1))+1;
demand_str = demand_str(p+1:end); % s

p = pos_of(demand_str, ',');
g.t = str2num(demand_str(1:p-1))+1;
demand_str = demand_str(p+1:end); % t

% req
g.req = [];
r_end = pos_of(demand_str, ',');
req_str = [demand_str(1:r_end-2), '|'];
if numel(find(req_str == 'N')) == 0
    while (length(req_str) > 1)
        p = pos_of(req_str, '|');
        r = str2num(req_str(1:p-1));
        g.req = [g.req, r+1];
        req_str = req_str(p+1:end);
    end
end
demand_str = demand_str(r_end+1:end);

% % 去掉多余的数据
p = pos_of(demand_str, ',');
demand_str = demand_str(p+1:end); % 去掉s
p = pos_of(demand_str, ',');
demand_str = demand_str(p+1:end); % 去掉t

% req2
g.req2 = [];
req_str = [demand_str, '|'];
if numel(find(req_str == 'N')) == 0
    while (length(req_str) > 1)
        p = pos_of(req_str, '|');
        r = str2num(req_str(1:p-1));
        g.req2 = [g.req2, r+1];
        req_str = req_str(p+1:end);
    end
end


fclose(demand_file);



g.s = round(g.s);
g.t = round(g.t);
g.m_dis = round(g.m_dis);
g.m_dis2 = round(g.m_dis2);
g.req = round(g.req);
g.req2 = round(g.req2);


    function pos = pos_of(str, sign)
        % fprintf('str=%s, sign=%s\n', str, sign);
        all_pos = find(str == sign);
        pos = all_pos(1);
    end

end

