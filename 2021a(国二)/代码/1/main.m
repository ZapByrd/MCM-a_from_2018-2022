clear;clc;close all;

%载入节点数据，[num,txt]=xlsread('xxx')
% [NodeLoc,NodeId1]=xlsread('附件1.csv');
% [NodeLoc2,NodeId2]=xlsread('附件2.csv');
% [~,NodeId3]=xlsread('附件3.csv');
% save NodeInfo NodeLoc NodeId1 NodeLoc2 NodeId2 NodeId3
load NodeInfo


NodeNum=size(NodeLoc,1);%记录主索节点个数，size（n,1）返回行数
R=abs(min(NodeLoc(:,3)));%记录离原点（球心）最远的坐标点
f=0.466;%焦距
MaxMove=0.6;%促动器最大伸缩量

MeshNum=size(NodeId3,1)-1;%记录反射面板个数
MeshGrid=zeros(MeshNum,3);%预分配理想矩阵与反射面板中节点一一对应

%使节点编号（Node_ID）与坐标值(NodeLoc)一一对应，如E426，Node_ID（5，427）=2222，则坐标值为Nodeloc(2222)
for ii=1:NodeNum%乱序节点遍历
    NodeId1Name=NodeId1{ii+1,1};%对应节点编号
    Row=NodeId1Name(1)-'A'+1;%首字母编号转化为数字编号，A为1，B为2...
    Col=str2double(NodeId1Name(2:end))+1;%后边数字编号转化为数值格式，注意0为1，1为2...
    Node_ID(Row,Col)=ii;%使NodeLoc中每一行坐标对应其节点编号
end

%使三角面板（MeshGrid）与节点编号（Node_ID）一三对应
for ii=1:MeshNum%三角反射面板遍历
    for jj=1:3
        NodeId1Name=NodeId3{ii+1,jj};%对应三角面板中某一个节点
        Row=NodeId1Name(1)-'A'+1;
        Col=str2double(NodeId1Name(2:end))+1;
        MeshGrid(ii,jj)=Node_ID(Row,Col);
    end
end

save MeshGrid.mat


TargetLoc=NodeLoc;%理想抛物面
RealLoc=NodeLoc;    %工作抛物面
moveDisR=zeros(1,NodeNum);%预分配移动坐标矩阵与节点一一对应
for ii=1:NodeNum%乱序节点遍历
    LocOld=NodeLoc(ii,:); %储存对应节点初始坐标
    [LocNew]=locSfun(LocOld,R,f);
    TargetLoc(ii,:)=LocNew;
    moveDis=norm(LocOld-LocNew);
    if (moveDis>0)
        MovDir=LocNew-LocOld;
        MovDir=MovDir/norm(MovDir);
        
        if (moveDis<MaxMove)
            RealLoc(ii,:)=LocNew;
        else
            moveDis=0.6;
            RealLoc(ii,:)=LocOld+MovDir*MaxMove;
        end
        
        LocDir=LocOld/norm(LocOld);
        movesign=-sign(MovDir*LocDir');
        moveDisR(ii)=movesign*moveDis;
    end
end
figure(1);clf;hold on;
plot3(NodeLoc(:,1),NodeLoc(:,2),NodeLoc(:,3),'r.');
plot3(TargetLoc(:,1),TargetLoc(:,2),TargetLoc(:,3),'k.');
plot3(RealLoc(:,1),RealLoc(:,2),RealLoc(:,3),'b.');
legend('基准态','理想抛物面','调整后');
axis([-320 320 -320 320 -320 0]);
axis equal

figure(2);clf;hold on;
PlotModel(NodeLoc,MeshGrid,'b');
PlotModel(TargetLoc,MeshGrid,'r');
title('基准态（蓝色）与理想抛物面（红色）')

figure(3);clf;hold on;
PlotModel(NodeLoc,MeshGrid,'b');
PlotModel(RealLoc,MeshGrid,'r');
title('基准态（蓝色）与调整后抛物面（红色）')

figure(4);clf;hold on;
PlotModel(TargetLoc,MeshGrid,'b');
PlotModel(RealLoc,MeshGrid,'r');
title('理想抛物面（蓝色）与调整后抛物面（红色）')

%创新点:
%1.形成两套二维矩阵编码（Node_ID）与（MeshGrid），编码表中的每个数字对应一个节点编号，通过其可在（NodeLoc）中找到对应坐标；




