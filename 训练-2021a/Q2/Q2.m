clc;clear;close all;
load NodeInfo
LocOld=NodeLoc;

%��ת����ϵ
NodeLoc=xz(NodeLoc);

%��ͼ
figure('color','w');
figure(1);
scatter3(LocOld(:,1),LocOld(:,2),LocOld(:,3),'r.')
axis([-320 320 -320 320 -320 0]);
axis equal
title('ԭ����ϵ')

figure('color','w');
figure(2)
scatter3(NodeLoc(:,1),NodeLoc(:,2),NodeLoc(:,3),'b.');
axis([-320 320 -320 320 -320 0]);
axis equal
title('��ת����ϵ��')


%��ת��Ϳ���������һ��ģ����
[detall,LocNew,ff,Loc_ji]=Update(NodeLoc);

%��������ϵ�Ļ�ԭ
LocNew=hy(LocNew);
peak=[0,0,-300.8446]; %�����߶�������ת��
peak=hy(peak);

%�޳�300m��ĵ�
LocNew2=LocNew;
for ii=1:NodeNum
    if Loc_ji(ii,3)==0
       LocNew2(ii,:)=0;
    end
end
LocNew2(all(LocNew2==0,2),:)=[];%ɾ��ȫ0��
%��ͼ
figure(3)
figure('color','w');
scatter3(LocOld(:,1),LocOld(:,2),LocOld(:,3),'b.')
hold on
%��������ͼ���ó�
% x=LocNew2(:,1);
% y=LocNew2(:,2);
% z=LocNew2(:,3);
% [X,Y,Z]=griddata(x,y,z,linspace(min(x),max(x))',linspace(min(y),max(y)),'v4');%��ֵ
% mesh(X,Y,Z)
scatter3(LocNew2(:,1),LocNew2(:,2),LocNew2(:,3),'y')
axis([-320 320 -320 320 -320 0]);
hold on;
tu=[peak;[0,0,0]];
plot3(tu(:,1),tu(:,2),tu(:,3),'y','Linewidth',1.2);
axis equal
grid off
title('��׼̬����ɫ�����������򣨻�ɫ��')

figure('color','w');clf;hold on;
PlotModel(LocNew,MeshGrid,'y');
PlotModel(LocOld,MeshGrid,'b');
title('��׼̬����ɫ�������������棨��ɫ��')

%300m��������Χ
detall2=detall;
for ii=1:NodeNum
    if Loc_ji(ii,3)==0
       detall2(ii,:)=0;
    end
end
detall2(all(detall2==0,2),:)=[];%ɾ��ȫ0��
figure('color','w');
x=1:length(detall2);
plot(x,detall2');
ylabel('������(m)')

% save NodeInfo2




