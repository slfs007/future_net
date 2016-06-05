#include "future_net.h"


//initial static variables in class Road
Graph* Road::Gp;
int Road::s = 0, Road::t = 0;
int Road::reIdCn = 0;
int Road::reIdList[MaxV] = {0};
long long Road::roadCostSum[3] = {intUnReachCost,intUnReachCost,intUnReachCost};


/*************************************************************************
*  函数名称：Road::initial
*  功能说明：解析输入文件的两行数据，demand为要求通过V'的二维维数组
*  参数说明：filename是路径信息文件名
*  函数返回：无
*  修改时间：2016-4-26
*************************************************************************/
void Road::initial(char *demand,Graph *Gp)
{
	//initial Gp
	Road::Gp = Gp;
	//initial s,t,list
#ifdef PRELIMINARY	//初赛
	if(RW_LINE_NUM+1 == sscanf(demand,"%d,%d,%d",&this->s,&this->t,list + (++numInit)))
#else				//复赛
	int tmp;
	if(RW_LINE_NUM+1 == sscanf(demand,"%d,%d,%d,%d",&tmp,&this->s,&this->t,list + (++numInit)))
#endif
	{	//P' only contains {s,t}
		list[0] = this->s;
		list[1] = this->t;
	}
	else
	{
		list[0] = this->s;
		numInit++;
		//set list={s,V'}
		for(int i = 0,str_len = strlen(demand); i < str_len; i++)
			if(demand[i] == '|')
				if(1 != sscanf(demand+i+1,"%d",list+(numInit++)))
					numInit--;
		list[numInit] = this->t;
	}
	//initial isMustinit
	for(int i = 0; i < numInit; i++)
		isMustInit[list[i]] = True;
	isMustInit[this->t] = True;
}



/*************************************************************************
*  函数名称：Road::setReIdList
*  功能说明：记录Road[0]和Road[1]重复的边数个数和id,同时计算roadCostSum
*  参数说明：无
*  函数返回：无
*  修改时间：2016-4-26
*************************************************************************/
void Road::setReIdList(Road *Rp,Road *Rpo)
{
	//计算reIdCn、reIdList
	reIdCn = 0;
	for(int i = 0;i < Rp->VtourCn - 1;i++)
		for(int j = 0;j < Rpo->VtourCn - 1;j++)
			if(Rp->VtourId[i] == Rpo->VtourId[j])
			{
				reIdList[reIdCn++] = Rp->VtourId[i];
				break;
			}
	//计算roadCostSum
	roadCostSum[2] = roadCostSum[1];
	roadCostSum[1] = roadCostSum[0];
	roadCostSum[0] = Rp->roadCost[0] + Rpo->roadCost[0];
	//printf info
	//Print("Road now  repeat cost =%5d,%9lld,\t\t\t%9lld,%9lld\n",reIdCn,roadCostSum[0],Road0.roadCost[0],Road1.roadCost[0]);
	//Print("Road last repeat cost =%5d,%9lld,\t\t\t%9lld,%9lld\n",reIdCn,roadCostSum[1],Road0.roadCost[1],Road1.roadCost[1]);
	//Print("Road lasttrepeat cost =%5d,%9lld,\t\t\t%9lld,%9lld\n",reIdCn,roadCostSum[2],Road0.roadCost[2],Road1.roadCost[2]);
}
