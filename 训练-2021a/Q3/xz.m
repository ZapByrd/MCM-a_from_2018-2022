%坐标系旋转
%先绕z轴顺旋转alpha=36.795°(右手螺旋)
%再绕y轴顺旋转（90-bata）度
function [XZ]=xz(NodeLoc)
  alpha=36.795;       %单位为角度
  bata=78.169;
  [m,n]=size(NodeLoc);%返回行数、列数
 XZ=zeros(m,n);
  a=-alpha/180*pi;
 b=-(90-bata)/180*pi;
 Hz=[cos(a),-sin(a),0;sin(a),cos(a),0;0,0,1];%旋转矩阵
 Hy=[cos(b),0,sin(b);0,1,0;-sin(b),0,cos(b)];
%Hx=[1,0,0;0,cos(b),-sin(b);0,sin(b),cos(b)];
 for i=1:m
    XZ(i,:)=Hz*NodeLoc(i,:)';
    XZ(i,:)=Hy*XZ(i,:)';
 end
end