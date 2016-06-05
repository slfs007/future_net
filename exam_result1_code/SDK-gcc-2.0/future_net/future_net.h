#ifndef _FUTURE_NET_H
#define _FUTURE_NET_H

/********************************** include ********************************/
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <math.h>
#include <ctype.h>
#include "lib_record.h"
#include "lib_io.h"


/********************************** macro ********************************/
//#define PRELIMINARY 				//定义了就代表跑初赛代码
#ifdef PRELIMINARY
	#define RW_LINE_NUM 1
#else
	#define RW_LINE_NUM 2
	#define SEMI_FINAL 				//定义了就代表跑复赛代码
#endif

#define MaxV 			2000						//所有node的数量上限
#define MaxV2 			MaxV*2						//所有node的数量上限
#define MaxEOut 		20							//node的出度上限
#define MaxEdge 		MaxV*MaxEOut				//可达边的数量上限
#define MaxReachCost	100							//=max(V.cost[][]),可达边的最大权			
#define SubUnReachCost	(MaxReachCost*MaxV + 1)		//=MaxReachCost*(V.num+1),可达边构造成的-假的不可达边权重		
#define intUnReachCost	(SubUnReachCost*(MaxV + 1))
const long long UnReachCost=(SubUnReachCost*(MaxV + 1));//=SubUnReachCost*(V.num+1)//不可达边的权重20w或4ww,int:2^31=21ww

#define False 			0
#define True  			1

//c++11:字符串跟变量连接的时候,必须增加一个空格才行
#define Print						printf		//(...)//
#define str(var,type) 				#var" = "#type
#define printf_1var(v0,type) 		Print(str(v0,type)"\n",v0)
#define printf_2var(v0,v1,type) 	Print(str(v0,type)"," str(v1,type)"\n",v0,v1)
#define printf_3var(v0,v1,v2,type) 	Print(str(v0,type)"," str(v1,type)"," str(v2,type)"\n",v0,v1,v2)
#define PRINT_ERR(format, ...)		{Print( format, ##__VA_ARGS__); exit(0);}
#define GetMin(a, b) 				((a) < (b) ? (a):(b))
#define GetMax(a, b) 				((a) > (b) ? (a):(b))


/********************************** 外部声明 ********************************/
class Graph
{	
public:
	int num;					//number of nodes in V
	int cost[MaxV][MaxV];		//两点之间最短路径
	int id[MaxV][MaxV];			//两点之间最短路径ID
	int subCost[MaxV][MaxV];	//两点之间第二短路径
	int subId[MaxV][MaxV];		//两点之间第二短路径ID

	void initial(char *topo[MAX_EDGE_NUM], int edge_num);		//used in route()
	void setCost();				//used in initial()
};

class Road
{
public:
	static Graph *Gp;					//两条路共用的Graph的地址
	static int s,t;						//两条路共用的source,destination
	static long long roadCostSum[3];	//两条路的路径和
	static int reIdCn;					//两条路重复边个数的当前值
	static int reIdList[MaxV];			//[0][1]是最新和上一次,reIdList是重复的边的id数组
	
	int num,numInit;					//环路中当前必经点的数量,和初始化必经点数量,tsp每次的重复点数,加入重复点时备份变量
	int list[MaxV2];		//环路中当前必经点的id数组,加入重复点时备份
	
	//for HuaWei road
	int VuseCn[MaxV];					//环路用到的所有点用的次数
	unsigned char isMustInit[MaxV];		//所有点是否是must点的初始化flag
	int Vtour[MaxV],VtourCn;			//s->t路径中当前所有点(必经+非必经)顺序和数量
	int VtourCost[MaxV];				//s->t路径中当前所有点(必经+非必经)向后权值(最后点t没有)
	int VtourId[MaxV];					//s->t路径中当前所有点(必经+非必经)向后边ID(最后点t没有)
	long long roadCost[3];				//s->t路径和,[0][1]是最新和上一次
	
	void initial(char *demand,Graph *Gp);				//used in route();
	static void setReIdList(Road *Rp,Road *Rpo);		//used in route();
};

#endif
