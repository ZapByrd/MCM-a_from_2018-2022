 %进行坐标系的还原,找焦点坐标
clear,clc;
load NodeInfo
load NodeInfo2
 load LocNew1
MeshNum=4300;
number=0;
for ii=1:MeshNum
   if (Loc_ji(MeshGrid(ii,1),3)==0)||(Loc_ji(MeshGrid(ii,2),3)==0)||(Loc_ji(MeshGrid(ii,3),3)==0)
       MeshGrid(ii,:)=[0,0,0];
   end 
end
 MeshGrid(all(MeshGrid==0,2),:)=[];%删除全零行
 MeshNum=length(MeshGrid);
F=0.466*300.4;
focus=[0,0,-300.4+F];
focus=hy(focus);
for ii=1:MeshNum
    n=1e4;
    nmd1=unifrnd(0,1,[1,n]);
    nmd2=unifrnd(0,1,[1,n]);
    p1=LocOld(MeshGrid(ii,1),:);
    p2=LocOld(MeshGrid(ii,2),:);
    p3=LocOld(MeshGrid(ii,3),:);
   for jj=1:1e4
    [XX,YY,ZZ]=Carol(p1,p2,p3,nmd1(jj),nmd2(jj));%随机点e的坐标,也是定点
    V=[XX,YY,ZZ];
    
    t=(norm(focus)^2-sum([XX,YY,ZZ].*focus))/sum(V.*focus);
        x=XX+V(1)*t;
    y=YY+V(2)*t;
    z=ZZ+V(3)*t;
    D=norm([focus(1)-x,focus(2)-y,focus(3)-z]);%交点与焦点距离
    if D<0.5
        number=number+1;
    end
   end
end
rate=number/(n*MeshNum)

