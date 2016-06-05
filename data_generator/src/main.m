%% 开始, 准备
% 此脚本为数据生成的总入口
% 作者: 易惠康
% 日期: 2016-03-25
% ********************************注意*************************************
% 不要轻易取消对所有的循环体的注释, 这样会生成大量的数据, 务必按需使用.
% *************************************************************************

clear;
clc;

%% 一个例子

G_example.n = 6;
G_example.s = 1;
G_example.t = 4;
G_example.req = [1];
G_example.req2 = [2];
G_example.m_dis = [200 1 200 200 200 1;
                   200 200 1 200 1 200;
                   200 200 200 1 200 200;
                   200 200 200 200 200 200;
                   200 200 200 1 200 200;
                   200 200 1 200 200 200];
G_example.m_dis2 = 200 * ones(6, 6);
G_example.tour = 1:6;
% 所有matlab代码中下标从1开始, 但**注意**, 保存到csv后, 下标从0开始, 即仅save_result处需要处理下标问题.
% save_result(G_example, 'example');

% 生成超小数据

% file_folder = '..\data\case-mini\';
% 
% for n = 5:10
%     for reqs = 0:4
%         for reqs2 = 0:4
%             if (reqs + reqs2 > n-2)
%                 continue;
%             end
%             for dout = 2:n
%                 g = random_graph(n, reqs, reqs2, dout);
%                 save_result(g, 'mini', file_folder);
%             end
%         end
%     end
% end

% 生成一些小数据

% file_folder = '..\data\case-small\';
% 
% for n = 25 : 5 : 40
%     req_end = floor((n-2)/2);
%     req_step = min(floor(req_end/2), 10);
%     for reqs = 0 : req_step : req_end
%         for reqs2 = 0 : req_step : req_end
%             for dout = 6:2:12
%                 g = random_graph(n, reqs, reqs2, dout);
%                 save_result(g, 'small', file_folder);
%             end
%         end
%     end
% end % 数据组数: 4*3*3*2 = 72 组

% 生成一些终极数据

file_folder = '..\data\case-dag\';

for n = 1 : 2       % 有点慢...
    g = dag_graph(2000, 100, 100, 20);
    save_result(g, ['ultimate_dag', num2str(n)], file_folder);
end % 数据组数: 5组


