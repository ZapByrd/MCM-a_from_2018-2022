clc,clear;
load NodeInfo
%save MeshGrid MeshGrid
load MeshGrid
figure(1)
plot3(NodeLoc(:,1),NodeLoc(:,2),NodeLoc(:,3),'r')
a=-36.795/180*pi;
b=-(90-78.169)/180*pi;
Hz=[cos(a),-sin(a),0;sin(a),cos(a),0;0,0,1];
Hy=[cos(b),0,sin(b);0,1,0;-sin(b),0,cos(b)];
%Hx=[1,0,0;0,cos(b),-sin(b);0,sin(b),cos(b)];
[m,n]=size(NodeLoc);
XZ=zeros(m,n);
for i=1:m   
    XZ(i,:)=Hz*NodeLoc(i,:)';
    XZ(i,:)=Hy*XZ(i,:)';%XZ旋转后基准态的坐标    
end
figure(2)
plot3(XZ(:,1),XZ(:,2),XZ(:,3),'b')
xlabel('x轴'); ylabel('y轴'); zlabel('z轴'); % 加上坐标轴的标签
hold on

ff=140.431;
figure(2)
plot3(XZ(:,1),XZ(:,2),XZ(:,3),'b')
hold on
x=-150:1:150;
y=-150:1:150;
[x,y]=meshgrid(x,y);
z=(x.^2+y.^2)/(4*ff)-300.8446;
plot3(x,y,z,'r')
xlabel('x轴'); ylabel('y轴'); zlabel('z轴'); % 加上坐标轴的标签

%此时顶点坐标为(0,0,-3000.8446)
t5=[0,0,-300.8446]';
a=36.795/180*pi;%还原
b=(90-78.169)/180*pi;
Hz=[cos(a),-sin(a),0;sin(a),cos(a),0;0,0,1];
Hy=[cos(b),0,sin(b);0,1,0;-sin(b),0,cos(b)];
tr=Hy*t5; 
tr=Hz*tr ;%还原后的顶点坐标




JZ=XZ;%XZ旋转后坐标赋值给基准态

%load Loc_ji
%ID=[1:1:2226]';
%ID(Loc_ji(:,3)==0,:)=[];%保留点对应的编号
%JZ(Loc_ji(:,3)==0,:)=[];%将不在300米内的点删去
[m,n]=size(JZ);

%XZ旋转后基准态的坐标转化为球坐标,先求第5步 

JZ_Q=zeros(m,n);%基准态球坐标
for i=1:m
    x=XZ(i,1);y=XZ(i,2);z=XZ(i,3);
    cita=atan(y/x);
    rou=sqrt(x^2+y^2+z^2);
    fai=acos(z/rou);
    JZ_Q(i,:)=[cita,fai,rou];
end

LX=zeros(m,3);%理想抛物面坐标
LX_Q=zeros(m,3);%理想抛物面坐标
%在抛物面z=(x.^2+y.^2)/(4*ff)-300.8446;找到对应节点
for i=1:m%筛选出300内的点后，把2226改成点的个数
    cita=JZ_Q(i,1);fai=JZ_Q(i,2);
    rou=Lrou(fai);%旋转抛物面rou值的确定
    x=rou*sin(fai)*cos(cita);
    y=rou*sin(fai)*sin(cita);
    z=rou*cos(fai);
    %z1=(x^2+y^2)/561.724-300.8446%检验
    LX(i,:)=[x,y,z];
    LX_Q(i,:)=[cita,fai,rou];
end
format short g


%伸缩相差量6、7向上为负
cha=zeros(m,1);
load Net

B=zeros(4300,3);
load bc
load MeshGrid
