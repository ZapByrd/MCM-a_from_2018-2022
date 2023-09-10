clear;clc;close all;

%����ڵ����ݣ�[num,txt]=xlsread('xxx')
% [NodeLoc,NodeId1]=xlsread('����1.csv');
% [NodeLoc2,NodeId2]=xlsread('����2.csv');
% [~,NodeId3]=xlsread('����3.csv');
% save NodeInfo NodeLoc NodeId1 NodeLoc2 NodeId2 NodeId3
load NodeInfo


NodeNum=size(NodeLoc,1);%��¼�����ڵ������size��n,1����������
R=abs(min(NodeLoc(:,3)));%��¼��ԭ�㣨���ģ���Զ�������
f=0.466;%����
MaxMove=0.6;%�ٶ������������

MeshNum=size(NodeId3,1)-1;%��¼����������
MeshGrid=zeros(MeshNum,3);%Ԥ������������뷴������нڵ�һһ��Ӧ

%ʹ�ڵ��ţ�Node_ID��������ֵ(NodeLoc)һһ��Ӧ����E426��Node_ID��5��427��=2222��������ֵΪNodeloc(2222)
for ii=1:NodeNum%����ڵ����
    NodeId1Name=NodeId1{ii+1,1};%��Ӧ�ڵ���
    Row=NodeId1Name(1)-'A'+1;%����ĸ���ת��Ϊ���ֱ�ţ�AΪ1��BΪ2...
    Col=str2double(NodeId1Name(2:end))+1;%������ֱ��ת��Ϊ��ֵ��ʽ��ע��0Ϊ1��1Ϊ2...
    Node_ID(Row,Col)=ii;%ʹNodeLoc��ÿһ�������Ӧ��ڵ���
end

%ʹ������壨MeshGrid����ڵ��ţ�Node_ID��һ����Ӧ
for ii=1:MeshNum%���Ƿ���������
    for jj=1:3
        NodeId1Name=NodeId3{ii+1,jj};%��Ӧ���������ĳһ���ڵ�
        Row=NodeId1Name(1)-'A'+1;
        Col=str2double(NodeId1Name(2:end))+1;
        MeshGrid(ii,jj)=Node_ID(Row,Col);
    end
end

save MeshGrid.mat


TargetLoc=NodeLoc;%����������
RealLoc=NodeLoc;    %����������
moveDisR=zeros(1,NodeNum);%Ԥ�����ƶ����������ڵ�һһ��Ӧ
for ii=1:NodeNum%����ڵ����
    LocOld=NodeLoc(ii,:); %�����Ӧ�ڵ��ʼ����
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
legend('��׼̬','����������','������');
axis([-320 320 -320 320 -320 0]);
axis equal

figure(2);clf;hold on;
PlotModel(NodeLoc,MeshGrid,'b');
PlotModel(TargetLoc,MeshGrid,'r');
title('��׼̬����ɫ�������������棨��ɫ��')

figure(3);clf;hold on;
PlotModel(NodeLoc,MeshGrid,'b');
PlotModel(RealLoc,MeshGrid,'r');
title('��׼̬����ɫ��������������棨��ɫ��')

figure(4);clf;hold on;
PlotModel(TargetLoc,MeshGrid,'b');
PlotModel(RealLoc,MeshGrid,'r');
title('���������棨��ɫ��������������棨��ɫ��')

%���µ�:
%1.�γ����׶�ά������루Node_ID���루MeshGrid����������е�ÿ�����ֶ�Ӧһ���ڵ��ţ�ͨ������ڣ�NodeLoc�����ҵ���Ӧ���ꣻ




