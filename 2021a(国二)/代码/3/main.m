clear;clc;close all;

%载入第二题调整后的节点数据
load res2

%继续第二部分
fid=fopen('理想抛物面顶点坐标.csv','wt');
fprintf(fid,'X坐标（米）,Y坐标（米）,Z坐标（米）\n');
for ii=1:NodeNum 
   fprintf(fid,'%0.4f,%0.4f,%0.4f,\n',TargetLocr(ii,1),TargetLocr(ii,2),TargetLocr(ii,3));  
end
fclose(fid);
fid=fopen('调整后主索节点编号及坐标.csv','wt');
fprintf(fid,'X坐标（米）,Y坐标（米）,Z坐标（米）\n');
for ii=1:NodeNum 
   fprintf(fid,'%0.4f,%0.4f,%0.4f,\n',RealLocr(ii,1),RealLocr(ii,2),RealLocr(ii,3));  
end
fclose(fid);

% 第三部分
minDis=1;
MeshMidLoc=NodeLoc(Indmid,:);
InputDir=-[-cos(alpha) sin(alpha) 1/sin(beta)];InputDir=InputDir/norm(InputDir);


GcLoc=[0 0 (R*f)];
GcLoc=GcLoc+NodeLocOffset;
GcLoc=[GcLoc 1];
GcLoc=GcLoc*ratmat12I;
GcLoc(4)=[];
GcLoc(3)=GcLoc(3)-R;

MeshMidLocDir=MeshMidLoc-GcLoc;
MeshMidLocDir=MeshMidLocDir/norm(MeshMidLocDir);

refmj1=0; 
MeshGrid2=MeshGrid;
figure(1);clf;hold on;
plot3(GcLoc(:,1),GcLoc(:,2),GcLoc(:,3),'kx','markersize',10)
 view([0 0 1])
axis equal
for ii=1:MeshNum
    MeshLoc1=TargetLocr(MeshGrid(ii,1),1:3);
    MeshLoc2=TargetLocr(MeshGrid(ii,2),1:3);
    MeshLoc3=TargetLocr(MeshGrid(ii,3),1:3);
    
    [fdir,mj,mdloc]=meshrefcal(MeshLoc1,MeshLoc2,MeshLoc3);
    Dis=norm(GcLoc-mdloc);
    OutDir=GcLoc-mdloc;
    OutDir=OutDir/norm(OutDir);
    if (fdir*InputDir'>0)
        fdir=-fdir;
    end 
    if (MeshMidLocDir*(-OutDir')>cos(pi/3))
        refdir=Jmdir(-InputDir,fdir);
        Ang=acos(refdir*OutDir');
        MDis=Ang*Dis;
        Rm=sqrt(mj/pi);
        Loc1=[mdloc;mdloc+refdir*180];
        plot3(Loc1(:,1),Loc1(:,2),Loc1(:,3),'-M');
        if (Rm+minDis>MDis)
            refmj1=refmj1+mj*(-fdir*InputDir');
        end
        MeshGrid2(ii,4)=1;
    else
        Ang(ii)=inf;
    end
    aa=1; 
end
PlotModel2(RealLocr,MeshGrid2,{'b','r'});
title('理想抛物面 红—有效反射区 粉-反射路径');

refmj2=0;
figure(2);clf;hold on;
plot3(GcLoc(:,1),GcLoc(:,2),GcLoc(:,3),'kx','markersize',10)
 view([0 0 1])
axis equal
for ii=1:MeshNum
    MeshLoc1=RealLocr(MeshGrid(ii,1),1:3);
    MeshLoc2=RealLocr(MeshGrid(ii,2),1:3);
    MeshLoc3=RealLocr(MeshGrid(ii,3),1:3);
    
    [fdir,mj,mdloc]=meshrefcal(MeshLoc1,MeshLoc2,MeshLoc3);
    Dis=norm(GcLoc-mdloc);
    OutDir=GcLoc-mdloc;
    OutDir=OutDir/norm(OutDir);
    if (fdir*InputDir'>0)
        fdir=-fdir;
    end 
    if (MeshMidLocDir*(-OutDir')>cos(pi/3))
        refdir=Jmdir(-InputDir,fdir);
        Ang=acos(refdir*OutDir');
        MDis=Ang*Dis;
        Rm=sqrt(mj/pi);
        Loc1=[mdloc;mdloc+refdir*180];
        plot3(Loc1(:,1),Loc1(:,2),Loc1(:,3),'-M');
        if (Rm+minDis>MDis)
            refmj2=refmj2+mj*(-fdir*InputDir');
        end
        MeshGrid2(ii,4)=1;
    else
        Ang(ii)=inf;
    end
    aa=1; 
end
PlotModel2(RealLocr,MeshGrid2,{'b','r'});
title('实际调制抛物面 红—有效反射区 粉-反射路径');

Areaall=R^2*pi;
Areaall=InputDir*[0 0 -1]'*Areaall;
fprintf('当前角度下总有效面积%dm^2\n理想抛物面等效面积%dm^2\n实际调制抛物面等效面积%dm^2\n',Areaall,refmj1,refmj2);