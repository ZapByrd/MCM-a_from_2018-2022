clear;clc;close all;
load NodeInfo

%将节点三维直角坐标转化成相应的二维极坐标
Loc_ji=zeros(NodeNum,3);
for ii=1:NodeNum
  Loc_ji(ii,1)=atan(norm(NodeLoc(ii,1:2))/abs(NodeLoc(ii,3)));%θ，表示节点与球心间的连线和Z坐标轴的夹角
  Loc_ji(ii,2)=norm(NodeLoc(ii,:));%ρ，% 表示节点与球心间的距离
end

%更新坐标
[detall,LocNew,ff]=Update(NodeLoc);

%绘图
figure('color','w');
figure(1);clf;hold on;
PlotModel(LocNew,MeshGrid,'y');
PlotModel(NodeLoc,MeshGrid,'b');
title('基准态（蓝色）与理想抛物面（黄色）')

% 300m内伸缩范围
detall2=detall;
for ii=1:NodeNum
    if Loc_ji(ii,3)==0
       detall2(ii,:)=0;
    end
end
detall2(all(detall2==0,2),:)=[];%删除全0行
figure('color','w');
x=1:length(detall2);
plot(x,detall2')
ylabel('伸缩量(m)')


%输出
format short
disp('搜寻到焦距')
ff
disp('搜寻到顶点z坐标为')
peak=LocNew(1,3)

