%坐标系还原
%再绕y轴逆旋转（90-bata）度
%先绕z轴逆旋转alpha=36.795°(右手螺旋)
function [HY]=hy(LocNew)
  alpha=36.795;       %单位为角度
  bata=78.169;
   [m,n]=size(LocNew);%返回行数、列数
  HY=zeros(m,n);
  a=alpha/180*pi;%还原
b=(90-bata)/180*pi;
Hz=[cos(a),-sin(a),0;sin(a),cos(a),0;0,0,1];
Hy=[cos(b),0,sin(b);0,1,0;-sin(b),0,cos(b)];
for i=1:m  
    HY(i,:)=Hy*LocNew(i,:)';
    HY(i,:)=Hz*HY(i,:)';
end
end