function [ save_flag ] = save_result( G, describle, where )
%SAVE_RESULT 将图G保持到文件(topo.csv, demand.csv)
% -图G(结构体)应该包含以下几个内容:
%   初赛内容
%       n: 所有的结点数量
%       s: 起始节点
%       t: 终止结点
%       req: 向量, 所有的必须经过结点, 不包括s和t
%       m_dis: 边的邻接矩阵表示, 元素值大于20时表示该边不存在
%   复赛新增内容
%       req2: 向量, tour2所有的必须经过结点, 不包括s和t
%       m_dis2: 重边的邻接矩阵表示, 因为tour2的原因, 程序需要考虑次长的边
% -describle: 将出现在数据文件夹命名中
% -where: 指定文件存放相对于data/的位置路径
%
% 作者: 易惠康
% 日期: 2016-03-25


%% Preparing: 文件路径, 文件名等等

if (nargin < 2)
    describle = 'default';
end

if (nargin < 3)
    where = '..\data\';
end

% 有效边的数量
num_edge = numel(G.m_dis(G.m_dis <= 100));
num_edge = num_edge + numel(G.m_dis(G.m_dis2 <= 100));

file_path = ['case', int2str(G.n)];                             % 点数
file_path = [file_path, '-', int2str(numel(G.req))];            % tour1必须点数
file_path = [file_path, '&', int2str(numel(G.req2))];           % tour2必须点数
file_path = [file_path, '-e(', int2str(num_edge), ')'];         % 边的条数
file_path = [file_path, '-', describle];                        % 描述
%file_path = [file_path, '-', datestr(now, 30)];                % 时间
%file_path = [file_path, '-', int2str(round(rand()*10000))];    % 随机数减少文件名冲突
topo_filename = [where, file_path, '\topo.csv'];                % topo.csv
demand_filename = [where, file_path, '\demand.csv'];            % demand.csv
%result_filename = [where, file_path, '\result_example.csv'];   % 一个可行解

% 创建文件夹
mkdir(where, file_path);

save_flag = 0;

%% 保存 topo.csv

edge_no = zeros(G.n, G.n);  % m_dis矩阵中的边在topo中的编号

topo_cnt = 0;
topo = [];
for i = 1 : G.n
    for j = 1 : G.n
        if (G.m_dis(i, j) <= 100)
            topo = [topo; topo_cnt i-1 j-1 G.m_dis(i, j)];
            edge_no(i, j) = topo_cnt;
            topo_cnt = topo_cnt + 1;
        end
        if (G.m_dis2(i, j) <= 100)
            topo = [topo; topo_cnt i-1 j-1 G.m_dis2(i, j)];
            topo_cnt = topo_cnt + 1;
        end
    end
end

dlmwrite(topo_filename, topo);

% mark flag
save_flag = 1;

%% 保存 demand.csv

file = fopen(demand_filename, 'wt');

% tour1
if (~isempty(G.req))
    str_req = [];
    for i = 1 : numel(G.req)-1
        str_req = [str_req int2str(G.req(i)-1) '|'];
    end
    str_req = [str_req int2str(G.req(end)-1)];
else
    str_req = 'NA';
end

str_st_req = ['1,', int2str(G.s-1) ',' int2str(G.t-1) ',' str_req];

fprintf(file, '%s\n', str_st_req);

% tour2
if (~isempty(G.req2))
    str_req = [];
    for i = 1 : numel(G.req2)-1
        str_req = [str_req int2str(G.req2(i)-1) '|'];
    end
    str_req = [str_req int2str(G.req2(end)-1)];
else
    str_req = 'NA';
end

str_st_req = ['2,', int2str(G.s-1) ',' int2str(G.t-1) ',' str_req];
fprintf(file, '%s\n', str_st_req);

% close file
fclose(file);

% mark flag
save_flag = 2;


% %% 保存可行解
% 
% str_tour = int2str(edge_no(G.tour(1), G.tour(2)));
% for i = 2 : G.n-1
%     str_tour = [str_tour, '|', int2str(edge_no(G.tour(i), G.tour(i+1)))];
% end
% 
% % 写入文件
% file = fopen(result_filename, 'wt');
% fprintf(file, '%s\n%s\n', str_tour, str_tour);
% fclose(file);
% 
% % mark flag
% save_flag = 3;


%% print

fprintf('save graph to folder "%s" successfully.\n', file_path);

end

