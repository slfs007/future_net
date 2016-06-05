#include "lib_io.h"
#include "lib_time.h"
#include "stdio.h"
#include "future_net.h"

Graph G;
Road Road0,Road1;
void exam_result(const char * const topofile,const char * const resultfile,int mode);


int main(int argc, char *argv[])
{	
	//SDK读入=90ms
    char *topo[MAX_EDGE_NUM];
    int edge_num;
    char *demand[MAX_DEMAND_NUM];
    int demand_num;

    char *topo_file = argv[1];
    edge_num = read_file(topo, MAX_EDGE_NUM, topo_file);
    if (edge_num == 0)
    {
        Print("Please input valid topo file.\n");
        return -1;
    }
    char *demand_file = argv[2];
    demand_num = read_file(demand, MAX_DEMAND_NUM, demand_file);
    if (demand_num != MAX_DEMAND_NUM)
    {
        Print("Please input valid demand file.\n");
        return -1;
    }
	
	//生成检查result.csv文件合法性和路径信息的程序
	//程序如果带5个参数(第一个是文件名)就输出具体的信息,否则只输出重复边个数和权值
	G.initial(topo,edge_num);
	Road0.initial(demand[0],&G);
	Road1.initial(demand[1],&G);
	exam_result(argv[1],argv[3],(argc==5));
	return 0;
}


/*************************************************************************
*  函数名称:exam_result
*  功能说明:解析result.csv数据是否合理,合理就输出路径信息,不合理输出不合理的理由
*  参数说明:mode:0,"Simple";1,"Complex"
*  函数返回:无
*  修改时间:2016-3-27
*************************************************************************/
class Link
{
public:
	int v1,v2,cost;
	Link(){v1 = v2 = cost = 0;};
	
	void initial(int v1,int v2,int cost)
	{
		this->v1 = v1;
		this->v2 = v2;
		this->cost = cost;
	};
};
Link link[MaxEdge];
void setVtour(Road *Rp,int id,int lastV2);
inline void examIsNA(char *result0);
inline void examIsRodeBreak(int lastV2,int id);
inline void examIsExist(int id);

void exam_result(const char * const topo_file,const char * const result_file,int isComplex)
{
	int id,lastV2;
	Road *Rp;
	
	//read result from result.csv
	char *result[MAX_DEMAND_NUM];
    int result_num = read_file(result, RW_LINE_NUM, result_file);
    if (result_num != RW_LINE_NUM)
	{
		examIsNA(result[0]);
		PRINT_ERR("Please input valid result file.\n");
	}
	
	//read link:v1,v2,cost
	FILE *fp = fopen(topo_file, "r");
    while (!feof(fp))
	{
		int linkId,v1,v2,cost;
        if(4 != fscanf(fp,"%d,%d,%d,%d",&linkId,&v1,&v2,&cost))	continue;
		link[linkId].initial(v1,v2,cost);
    }
	fclose(fp);
	
	//exam if the two road valid
	//exam NA
	examIsNA(result[0]);
	for(int j = 0;j < RW_LINE_NUM;j++)
	{	
		if(j == 0)	Rp = &Road0;	else if(j == 1)	Rp = &Road1;
		//************************************************** exam start **********************************************
		//exam if the first link exist
		if(isComplex)	Print("start exam road%d : \n",j);
		sscanf(result[j],"%d",&id);
		examIsExist(id);
		
		//exam if the start node is valid
		if(link[id].v1 != Road::s)	PRINT_ERR("Start node error : now is %d, should be %d\n", link[id].v1, Road::s);
		setVtour(Rp,id,lastV2);
		lastV2 = link[id].v2;
		
		//exam other links
		for(int i = 0,str_len = strlen(result[j]); i < str_len; i++)
			if(result[j][i] == '|')
			{
				//exam if link exist
				sscanf(result[j]+i+1,"%d",&id);
				examIsExist(id);
				//exam if this start node is last edge's end node
				examIsRodeBreak(lastV2,id);
				setVtour(Rp,id,lastV2);
				lastV2 = link[id].v2;
			}
		
		//exam the last node
		if(lastV2 != Road::t)	PRINT_ERR("End node error : now is %d,should be %d\n", lastV2, Road::t);
		if(Rp->VuseCn[Road::t]++ >= 1)	PRINT_ERR("End node %d is used 2 times\n",Road::t);
		Rp->Vtour[Rp->VtourCn++] = lastV2;
		
		//exam if all must-nodes is visited
		int isFirstFind = 1;
		for(int i = 0;i < Rp->numInit + 1;i++)
			if(Rp->VuseCn[Rp->list[i]] == 0)
			{
				if(isFirstFind)
				{
					Print("/**************************** Must-node is not visited error >>> *******************************/\n");
					isFirstFind = 0;
					Print("Must-node is not visited : ");
				}
				Print("%d,",Rp->list[i]);
			}
		if(!isFirstFind)
			Print("\n/**************************** Must-node is not visited error >>> *******************************/\n");
		//************************************************** exam end **********************************************
		//************************************************** ouput start**********************************************
		//ouput cost(simple mode)
		Road::roadCostSum[0] += Rp->roadCost[0];
		if(!isComplex)
		{
			#ifdef SEMI_FINAL
				Print("%5lld\t",Rp->roadCost[0]);
			#else
				Print("%lld\n",Rp->roadCost[0]);
			#endif
			continue;
		}
		Print("road%d cost = %lld\n",j,Rp->roadCost[0]);
		//ouput non-must-nodes
		Print("non-must node : ");
		for(int i = 0;i < Rp->VtourCn;i++)
			if(Rp->isMustInit[Rp->Vtour[i]] == False)
				Print("%d,",Rp->Vtour[i]);
		Print("\n");
		//output other infomation
		Print("Nodes:(in each line,first and last is must,other is not.LinkId is in[],length is in())");
		for(int i = 0; i < Rp->VtourCn - 1; i++)
		{
			int v1 = Rp->Vtour[i],v2 = Rp->Vtour[i+1];
			if(Rp->isMustInit[v1] == True)
				Print("\n%3d", v1);
			else
				Print("-->[%4d(%2d)]-->%3d",Rp->VtourId[i-1],Rp->VtourCost[i-1],v1);
			if(Rp->isMustInit[v2] == True)
				Print("-->[%4d(%2d)]-->%3d",Rp->VtourId[i],Rp->VtourCost[i],v2);
		}
		Print("\n\n");
	}
	//输出解得路径
	//for(int i = 0; i < Rp->VtourCn; i++)
	//{
	//	int v1 = Rp->Vtour[i];
	//	Print("%d,", v1);
	//}Print("\n");
#ifdef SEMI_FINAL
	Road::setReIdList(&Road0,&Road1);
	if(!isComplex)
	{
		Print("%5d\t%5lld\n",Road::reIdCn,Road::roadCostSum[0]);
		return ;
	}
	Print("Repeated edge count = %d\n",Road::reIdCn);
	Print("Two roads cost sum = %5lld\n",Road::roadCostSum[0]);
	if(Road::reIdCn >= 1)
	{
		Print("repeated edge is : ");
		for(int i = 0;i < Road::reIdCn;i++)
			Print("%d,",Road::reIdList[i]);
	}
	Print("\n");
#endif
	//************************************************** ouput end **********************************************
}

inline void examIsNA(char *result0)
{
	int cn = 0;
	//isalnum:检查参数c是否为英文字母或阿拉伯数字，在标准c中相当于使用“isalpha(c) || isdigit(c)”做测试
	while(!isalnum(result0[cn]))
		cn++;
	//isalpha:检查参数c是否为英文字母，在标准c中相当于使用“isupper(c)||islower(c)”做测试
	if(isalpha(result0[cn]))
		PRINT_ERR("NA\n");
}

inline void examIsExist(int id)
{
	if(id >= MaxEdge || (link[id].v1==0 && link[id].v2==0))
		PRINT_ERR("linkID %d does not exist\n",id);
};

inline void examIsRodeBreak(int lastV2,int id)
{
	if(lastV2 != link[id].v1)
		PRINT_ERR("Rode break : locate at link %d,last node is %d,should be %d\n",id,lastV2,link[id].v1);
}

void setVtour(Road *Rp,int id,int lastV2)
{
	Rp->roadCost[0] += link[id].cost;
	if(Rp->VuseCn[link[id].v1]++ >= 1)
		PRINT_ERR("Node %d is used >=2 times : locate at link %d,last node is %d\n",link[id].v1,id,lastV2);
	Rp->Vtour[Rp->VtourCn] = link[id].v1;
	Rp->VtourCost[Rp->VtourCn] = link[id].cost;	
	Rp->VtourId[Rp->VtourCn] = id;
	//printf_3var(Rp->Vtour[Rp->VtourCn],Rp->VtourCost[Rp->VtourCn],Rp->VtourId[Rp->VtourCn],%d);
	Rp->VtourCn++;
}
