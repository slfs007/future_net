% 用来合并graph的脚本

combine_path = '../combine/';
graph_folders = dir(combine_path);
graph_folders = graph_folders(3:end);
n = size(graph_folders, 1);

if n > 1
    g1 = read_graph([combine_path, graph_folders(1).name]);
    for i = 2 : n
        g2 = read_graph([combine_path, graph_folders(i).name]);
        g1 = combine_graph(g1, g2);
    end
    save_result(g1, 'combine_man234234_chen', combine_path);
end


% combine_path = '../combine/';
% ppt_path = '../case1/';
% man_path = '../case2/';
% chen_path = '../case3/';
% 
% ppt_name = dir(ppt_path);
% man_name = dir(man_path);
% chen_name = dir(chen_path);
% ppt_name = ppt_name(3:end);
% man_name = man_name(3:end);
% chen_name = chen_name(3:end);
% 
% if n > 1
% -    g1 = read_graph([combine_path, graph_folders(1).name]);
% -    for i = 2 : n
% -        g2 = read_graph([combine_path, graph_folders(1).name]);
% -        g1 = combine_graph(g1, g2);
% -    end
% -    save_result(g1, 'combine', combine_path);
% -end
% 
% % 合任意ppt & man
% for i = 1 : numel(ppt_name)
%     g0 = read_graph([ppt_path, ppt_name(i).name]);
%     for j = 1 : numel(man_name)
%         g1 = read_graph([man_path, man_name(j).name]);
%         g2 = combine_graph(g0, g1);
%         save_result(g2, ['combine(ppt', num2str(i), ',man', num2str(j), ')'], combine_path);
%     end
% end
% 
% % 合ppt & chen
% for i = 1 : numel(ppt_name)
%     g0 = read_graph([ppt_path, ppt_name(i).name]);
%     for j = 1 : numel(chen_name)
%         g1 = read_graph([chen_path, chen_name(j).name]);
%         g2 = combine_graph(g0, g1);
%         save_result(g2, ['combine(ppt', num2str(i), ',chen)'], combine_path);
%     end
% end
% 
% % 合并man & chen
% for i = 1 : numel(man_name)
%     g0 = read_graph([man_path, man_name(i).name]);
%     for j = 1 : numel(chen_name)
%         g1 = read_graph([chen_path, chen_name(j).name]);
%         g2 = combine_graph(g0, g1);
%         save_result(g2, ['combine(man', num2str(i), ',chen)'], combine_path);
%     end
% end