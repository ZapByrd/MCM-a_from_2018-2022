%输入各材料厚度，返回温度分布
%t=5400s，T_en=75，T_r=37;
function [T]=qiujie(L1,L2,L3,L4,h1,h2,T_en,tt)
T_r=37;
rou=[300;862;74.2;1.18];%密度
c=[1377;2100;1726;1005];%比热容
k=[0.082;0.37;0.045;0.028];%热传导率
H=[L1,L2,L3,L4]*1e-3;
X1=H(1);X2=sum(H(1:2));  X3=sum(H(1:3));X4=sum(H);
alpha=k./(rou.*c);
dx=0.0001;%空间步长
x=0:dx:X4;
dt=1;%时间步长
t=0:dt:tt;
r=dt/dx^2.*alpha;
T=zeros(length(x),length(t));
T(:,1)=T_r;%初始条件
%构造A矩阵，分四个区段
A=zeros(round(X4/dx+1));
A1=(1+2*r(1))*eye(round(X1/dx+1))-r(1)*diag(ones(1,round(X1/dx)),1)-r(1)*diag(ones(1,round(X1/dx)),-1);
A2=(1+2*r(2))*eye(round((X2-X1)/dx+1))-r(2)*diag(ones(1,round((X2-X1)/dx)),1)-r(2)*diag(ones(1,round((X2-X1)/dx)),-1);
A3=(1+2*r(3))*eye(round((X3-X2)/dx+1))-r(3)*diag(ones(1,round((X3-X2)/dx)),1)-r(3)*diag(ones(1,round((X3-X2)/dx)),-1);
A4=(1+2*r(4))*eye(round((X4-X3)/dx+1))-r(4)*diag(ones(1,round((X4-X3)/dx)),1)-r(4)*diag(ones(1,round((X4-X3)/dx)),-1);
%不同材料交界处
A1(1,1)=k(1)/dx+h1;
A1(1,2)=-k(1)/dx;
A1(end,end)=(k(1)+k(2))/dx;
A1(end,end-1)=-k(1)/dx;
A2(1,1)=(k(1)+k(2))/dx;
A2(1,2)=-k(2)/dx;
A2(end,end)=(k(2)+k(3))/dx;
A2(end,end-1)=-k(2)/dx;
A3(1,1)=(k(2)+k(3))/dx;
A3(1,2)=-k(3)/dx;
A3(end,end)=(k(3)+k(4))/dx;
A3(end,end-1)=-k(3)/dx;
A4(1,1)=(k(3)+k(4))/dx;
A4(1,2)=-k(4)/dx;
A4(end,end)=k(4)/dx+h2;
A4(end,end-1)=-k(4)/dx;
%合并
A(1:length(A1),1:length(A1))=A1;
A(length(A1):length(A1)+length(A2)-1,length(A1):length(A1)+length(A2)-1)=A2;
A(length(A1)+length(A2)-1:end-length(A4)+1,length(A1)+length(A2)-1:end-length(A4)+1)=A3;
A(end-length(A4)+1:end,end-length(A4)+1:end)=A4;
%追赶法求解
for n=1:length(t)-1
    aa=[0,diag(A,-1)']; bb=diag(A)';cc=diag(A,1)';ff=T(1:end,n);m=length(A);%追赶法
    ff(1)=T_en*h1;
    ff(length(A1))=0;
    ff(length(A1)+length(A2)-1)=0;
    ff(length(A1)+length(A2)+length(A3)-2)=0;
    ff(end)=T_r*h2;
    betal=zeros(1,m);y=zeros(1,m);y(1)=ff(1)/bb(1);d=bb(1);
    for i=2:m
         betal(i-1)=cc(i-1)/d;
         d=bb(i)-aa(i)*betal(i-1);
         y(i)=(ff(i)-aa(i)*y(i-1))/d;
    end
    T(end,n+1)=y(end);
    for i=length(T(:,1))-1:-1:1
        T(i,n+1)=y(i)-betal(i)*T(i+1,n+1);
    end
%     %温度分布动态
%     plot(x,T(:,n+1));
%     getframe;
end
end
