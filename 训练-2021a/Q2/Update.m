function [detall,LocNew,ff,Loc_ji]=Update(NodeLoc)
NodeNum=size(NodeLoc,1);%记录主索节点个数，size（n,1）返回行数
R=abs(min(NodeLoc(:,3)));%记录基准抛物面最低点的z值
F=0.466*R;
min_all=9e10;%预赋值所有伸缩量的平方和的开根，用于比小
LocNew=zeros(NodeNum,3);
rou=zeros(NodeNum,1);

  %将节点三维直角坐标转化成相应的二维极坐标
Loc_ji=zeros(NodeNum,3);
for ii=1:NodeNum
  Loc_ji(ii,1)=atan(norm(NodeLoc(ii,1:2))/abs(NodeLoc(ii,3)));%θ，表示节点与球心间的连线和Z坐标轴的夹角
  Loc_ji(ii,2)=norm(NodeLoc(ii,:));%ρ，% 表示节点与球心间的距离
end

%焦距遍历
for f=135:0.001:145
%找出300m口径内的点
z=150^2/(4*f)-f-(R-f);%边界点的z坐标
xita=asin(150/sqrt(150^2+z^2));%推导公式
%通过θ与抛物线方程找到新的节点坐标（θ，ρ），再还原成三维直角坐标
detal=zeros(NodeNum,1);%伸缩量
for ii=1:NodeNum
  if  Loc_ji(ii,1)>xita
      Loc_ji(ii,3)=0;%判断是否在300m内，0为不在
  else 
      Loc_ji(ii,3)=1;
  end
    a=cos(pi/2-Loc_ji(ii,1))^2/(4*f);%推导公式的求解
    b=sin(pi/2-Loc_ji(ii,1));
    c=-f-(R-F);
    rou(ii)=(-b+sqrt(b^2-4*a*c))/(2*a);%只保留正解
    rou(1)=-c;%A0节点在正下方，x、y坐标为0，不能用二次方程公式求解
    detal(ii)=Loc_ji(ii,2)-rou(ii);
end
detal(Loc_ji(:,3)==0)=0;%不考虑不在300m内的点
if norm(detal)<min_all
    min_all=norm(detal);%判断条件
    for ii=1:NodeNum
       LocNew(ii,:)=(Loc_ji(ii,2)-detal(ii))/Loc_ji(ii,2).*NodeLoc(ii,:);%更新坐标，伸缩方向各坐标成比例
       detall=detal;
       ff=f;
    end
end
end
end