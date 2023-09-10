clear;clc;close all;
m1=4866;%浮子质量
m2=2433;  %振子质量
m_a=1165.992;
w=2.2143;
c=167.8395;
f=4890;
dt=0.2;
t0=0:dt:180;
n=length(t0);
dc=10;   %步长调整
X_c=0:dc:1e5;
ii=1;
for c_p=0:dc:1e5   %直线阻尼常数遍历搜索
    z=Chui(w,m_a,c,c_p,f);
    Dv=z(:,4)-z(:,2);%相对速度，振子-浮子
    P(ii)=1/2*c_p*sum(Dv.^2)/n;
    ii=ii+1;
end
figure(1)
plot(X_c,P,'LineWidth',1.2)
set(gca,'Fontsize',16,'Ylim',[0,130]);set(gcf,'Color','w');grid on
xlabel('直线阻尼系数(N m/s)');ylabel('平均输出功率(w)')
[P_max,q]=max(P);%最大平均输出功率
disp('最佳阻尼系数：')
c_best=X_c(q)  
disp('最大输出功率：')
P_max
function z=Chui(w,m_a,c,c_p,f)
m1=4866;%浮子质量
m2=2433;  %振子质量
k=80000; %弹簧系数
rou=1025;
g=9.8;
r=1.0;
A0=pi*r^2;   %横截面积
dt=0.2;
t0=0:dt:180;
[~,z]=ode45(@(t,z)[z(2);(f*cos(w*t)-c*z(2)-rou*g*A0*z(1)+c_p*(z(4)-z(2))+k*(z(3)-z(1)))/(m1+m_a);...
    z(4);(c_p*(z(2)-z(4))+k*(z(1)-z(3)))/m2],t0,[0,0,0,0]);
end