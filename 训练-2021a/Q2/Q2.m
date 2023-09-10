clc;clear;close all;
load NodeInfo
LocOld=NodeLoc;

%旋转坐标系
NodeLoc=xz(NodeLoc);

%绘图
figure('color','w');
figure(1);
scatter3(LocOld(:,1),LocOld(:,2),LocOld(:,3),'r.')
axis([-320 320 -320 320 -320 0]);
axis equal
title('原坐标系')

figure('color','w');
figure(2)
scatter3(NodeLoc(:,1),NodeLoc(:,2),NodeLoc(:,3),'b.');
axis([-320 320 -320 320 -320 0]);
axis equal
title('旋转坐标系后')


%旋转后就可以套用问一的模型了
[detall,LocNew,ff,Loc_ji]=Update(NodeLoc);

%进行坐标系的还原
LocNew=hy(LocNew);
peak=[0,0,-300.8446]; %抛物线顶点坐标转化
peak=hy(peak);

%剔除300m外的点
LocNew2=LocNew;
for ii=1:NodeNum
    if Loc_ji(ii,3)==0
       LocNew2(ii,:)=0;
    end
end
LocNew2(all(LocNew2==0,2),:)=[];%删除全0行
%绘图
figure(3)
figure('color','w');
scatter3(LocOld(:,1),LocOld(:,2),LocOld(:,3),'b.')
hold on
%曲面网格图（好丑）
% x=LocNew2(:,1);
% y=LocNew2(:,2);
% z=LocNew2(:,3);
% [X,Y,Z]=griddata(x,y,z,linspace(min(x),max(x))',linspace(min(y),max(y)),'v4');%插值
% mesh(X,Y,Z)
scatter3(LocNew2(:,1),LocNew2(:,2),LocNew2(:,3),'y')
axis([-320 320 -320 320 -320 0]);
hold on;
tu=[peak;[0,0,0]];
plot3(tu(:,1),tu(:,2),tu(:,3),'y','Linewidth',1.2);
axis equal
grid off
title('基准态（蓝色）与照明区域（黄色）')

figure('color','w');clf;hold on;
PlotModel(LocNew,MeshGrid,'y');
PlotModel(LocOld,MeshGrid,'b');
title('基准态（蓝色）与理想抛物面（黄色）')

%300m内伸缩范围
detall2=detall;
for ii=1:NodeNum
    if Loc_ji(ii,3)==0
       detall2(ii,:)=0;
    end
end
detall2(all(detall2==0,2),:)=[];%删除全0行
figure('color','w');
x=1:length(detall2);
plot(x,detall2');
ylabel('伸缩量(m)')

% save NodeInfo2




