clear all;clc;close all;

%载入节点数据
% [NodeLoc,NodeId1]=xlsread('附件1.csv');
% [NodeLoc2,NodeId2]=xlsread('附件2.csv');
% [~,NodeId3]=xlsread('附件3.csv');
% save NodeInfo NodeLoc NodeId1 NodeLoc2 NodeId2 NodeId3
load NodeInfo


NodeNum=size(NodeLoc,1);
R=abs(min(NodeLoc(:,3)));
f=0.466;
MaxMove=0.6;

%对坐标系进行旋转
rad=pi/180;
alpha= 36.795*rad;
beta= (90-78.169)*rad;
rat_mat1=[cos(alpha) sin(alpha) 0 0;-sin(alpha) cos(alpha) 0 0;0 0 1 0;0 0 0 1;];
rat_mat2=[cos(beta) 0 -sin(beta) 0;0 1 0 0;sin(beta)  0 cos(beta) 0 ;0 0 0 1;];
rat_mat2I=[cos(-beta) 0 -sin(-beta) 0;0 1 0 0;sin(-beta)  0 cos(-beta) 0 ;0 0 0 1;];
rat_mat1I=[cos(-alpha) sin(-alpha) 0 0;-sin(-alpha) cos(-alpha) 0 0;0 0 1 0;0 0 0 1;];
ratmat12=rat_mat1*rat_mat2;
ratmat12I=rat_mat2I*rat_mat1I;
NodeLocr=NodeLoc;NodeLocr(:,3)=NodeLocr(:,3)+R;NodeLocr(:,4)=1;
NodeLocr=NodeLocr*ratmat12;

[~,Indmid]=min(NodeLocr(:,3));
NodeLocOffset=NodeLocr(Indmid,1:3);
NodeLocr(:,1)=NodeLocr(:,1)-NodeLocOffset(1);
NodeLocr(:,2)=NodeLocr(:,2)-NodeLocOffset(2);
NodeLocr(:,3)=NodeLocr(:,3)-NodeLocOffset(3)-R;

MeshNum=size(NodeId3,1)-1;
MeshGrid=zeros(MeshNum,3);
for ii=1:NodeNum
    NodeId1Name=NodeId1{ii+1,1};
    Row=NodeId1Name(1)-'A'+1;
    Col=str2double(NodeId1Name(2:end))+1;
    Node_ID(Row,Col)=ii;
end

for ii=1:MeshNum
    for jj=1:3
        NodeId1Name=NodeId3{ii+1,jj};
        Row=NodeId1Name(1)-'A'+1;
        Col=str2double(NodeId1Name(2:end))+1;
        MeshGrid(ii,jj)=Node_ID(Row,Col);
    end
end
 
TargetLoc=NodeLocr(:,1:3);
RealLoc=NodeLocr(:,1:3);
moveDisR=zeros(1,NodeNum);
for ii=1:NodeNum
    LocOld=NodeLocr(ii,1:3); 
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
TargetLocr=TargetLoc;
TargetLocr(:,3)=TargetLocr(:,3)+R+NodeLocOffset(3);
TargetLocr(:,2)=TargetLocr(:,2)+NodeLocOffset(2);
TargetLocr(:,1)=TargetLocr(:,1)+NodeLocOffset(1);
TargetLocr(:,4)=1;TargetLocr=TargetLocr*ratmat12I;
TargetLocr(:,3)=TargetLocr(:,3)-R;
RealLocr=RealLoc;
RealLocr(:,3)=RealLocr(:,3)+R+NodeLocOffset(3);
RealLocr(:,2)=RealLocr(:,2)+NodeLocOffset(2);
RealLocr(:,1)=RealLocr(:,1)+NodeLocOffset(1);
RealLocr(:,4)=1;RealLocr=RealLocr*ratmat12I;
RealLocr(:,3)=RealLocr(:,3)-R;
 
figure(1);clf;hold on;
plot3(NodeLoc(:,1),NodeLoc(:,2),NodeLoc(:,3),'r.');
plot3(TargetLocr(:,1),TargetLocr(:,2),TargetLocr(:,3),'k.');
plot3(RealLocr(:,1),RealLocr(:,2),RealLocr(:,3),'b.');
legend('基准态','理想抛物面','调整后');
axis([-320 320 -320 320 -320 0]);
axis equal

figure(2);clf;hold on;
PlotModel(NodeLoc,MeshGrid,'b');
PlotModel(TargetLocr,MeshGrid,'r');
title('基准态（蓝色）与理想抛物面（红色）')

figure(3);clf;hold on;
PlotModel(NodeLoc,MeshGrid,'b');
PlotModel(RealLocr,MeshGrid,'r');
title('基准态（蓝色）与调整后抛物面（红色）')

figure(4);clf;hold on;
PlotModel(TargetLocr,MeshGrid,'b');
PlotModel(RealLocr,MeshGrid,'r');
title('理想抛物面（蓝色）与调整后抛物面（红色）');


fid=fopen('附件4.csv','wt');
fprintf(fid,'对应主索节点编号,伸缩量（米）\n');
for ii=1:NodeNum
   fprintf(fid,'%s,',NodeId1{ii+1,1});
   fprintf(fid,'%0.4f,\n',moveDisR(ii));  
end
fclose(fid);
save res2