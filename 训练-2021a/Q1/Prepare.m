%准备工作，找出三角板、节点、节点坐标的调用关系，即MeshGrid、Node_ID、NodeLoc
clear;clc;close all;

%载入节点数据，[num,txt]=xlsread('xxx')
[NodeLoc,NodeId1]=xlsread('附件1.csv');
[NodeLoc2,NodeId2]=xlsread('附件2.csv');
[~,NodeId3]=xlsread('附件3.csv');
R=abs(min(NodeLoc(:,3)));%记录离原点（球心）最远的坐标点
f=0.466;%焦距
NodeNum=size(NodeLoc,1);%记录主索节点个数，size（n,1）返回行数
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



save NodeInfo NodeLoc  NodeLoc2 NodeId1 NodeId2 ...
    NodeId3 Node_ID MeshGrid NodeNum R f 
