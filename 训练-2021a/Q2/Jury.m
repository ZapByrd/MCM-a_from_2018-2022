clc,clear,close all;
load NodeInfo
load NodeInfo2
MeshNum=4300;
SideOld=zeros(MeshNum,3);%12,13,23
SideNew=zeros(MeshNum,3);
for ii=1:MeshNum
        SideOld(ii,1)=side(LocOld(MeshGrid(ii,1),:),LocOld(MeshGrid(ii,2),:));
        SideOld(ii,2)=side(LocOld(MeshGrid(ii,1),:),LocOld(MeshGrid(ii,3),:));
        SideOld(ii,3)=side(LocOld(MeshGrid(ii,2),:),LocOld(MeshGrid(ii,3),:));
        SideNew(ii,1)=side(LocNew(MeshGrid(ii,1),:),LocNew(MeshGrid(ii,2),:));
        SideNew(ii,2)=side(LocNew(MeshGrid(ii,1),:),LocNew(MeshGrid(ii,3),:));
        SideNew(ii,3)=side(LocNew(MeshGrid(ii,2),:),LocNew(MeshGrid(ii,3),:));
end

%检验相邻点是否超标0.07%
bianhua=(SideNew-SideOld)./SideOld*100;%变化幅度(百分之x)
jury2=zeros(MeshNum,3);
jury2(abs(bianhua)-0.07>0)=1;%超出约束
jury2(abs(bianhua)-0.07<0)=0;%没有超出约束
count=0;%用于统计符合要求的点
for ii=1:MeshNum*3
    if jury2(ii)==0
        count=count+1;
    end
end
rate=count/(MeshNum*3);%所有点的达标率
%记录超标的点
trial=LocNew;
Chao=zeros(MeshNum,1);
for ii=1:MeshNum
        if  jury2(ii,1)==1
            Chao(MeshGrid(ii,1),1)=1;
            Chao(MeshGrid(ii,2),1)=1;
        end
        if  jury2(ii,2)==1
            Chao(MeshGrid(ii,1),1)=1;
            Chao(MeshGrid(ii,3),1)=1;
        end
        if  jury2(ii,3)==1
            Chao(MeshGrid(ii,2),1)=1;
            Chao(MeshGrid(ii,3),1)=1;
        end
end
%保留不达标的点，删除达标的点
for ii=1:NodeNum
    if Chao(ii)==0
    trial(ii,:)=0;
    end
end
trial(all(trial==0,2),:)=[];
%绘制区域图
figure('color','w');clf;hold on;
PlotModel(LocNew,MeshGrid,'y');
PlotModel(LocOld,MeshGrid,'b');
scatter3(trial(:,1),trial(:,2),trial(:,3),'r.');
title('基准态（蓝色）与理想抛物面（黄色）、超标点（红色）')
%300m范围内的达标率
rate2=1-length(trial)/sum(detall~=0);


%检验伸缩量是否超标0.6m
jury1=zeros(MeshNum,3);
jury1(abs(detall)-0.6>0)=1;%超出约束
jury1(abs(detall)-0.6>0)=1;%没有超出约束
