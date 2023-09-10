%灵敏度分析，对弹簧刚度
clear;clc;close all;
global w m_a c rou g A0 t0 m1 m2 c_p  f
m1=4866;%浮子质量
m2=2433;  %振子质量
m_a=1165.992;
c=167.8395;%兴波阻尼系数
k=80000; %弹簧系数
w=2.2143;
f=4890;
rou=1025;
g=9.8;
r=1.0;
A0=pi*r^2;   %横截面积
dt=0.2;
t0=0:dt:180;
c_p=10000;% 直线阻尼系数
q=0.5:0.01:1.5;
x_k=k*q;
z=lin(k);
y0=P(z);
for ii=1:length(q)
          z=lin(x_k(ii));
         y_k1(ii)=P(z);
       y_k2(ii)=P(z)/y0-1;
end
figure(1)
plot(q*k,y_k1)
title('弹簧刚度k')
xlabel('刚度(N/m)');ylabel('平均功率(w)')
set(gca,'Fontsize',10);set(gcf,'Color','w');grid on
figure(2)
plot(q-1,y_k2)
title('弹簧刚度k')
xlabel('刚度变化率');ylabel('平均功率变化率')
set(gca,'Fontsize',10);set(gcf,'Color','w');grid on

function p=P(z)
n=901;
cp=10000;
Dv=z(:,4)-z(:,2); 
p=1/2*cp*sum(Dv.^2)/n;
end

function z=lin(k)
global  m_a c  rou g A0 t0 m1 m2 c_p w f
[t,z]=ode45(@(t,z)[z(2);(f*cos(w*t)-c*z(2)-rou*g*A0*z(1)+c_p*(z(4)-z(2))+k*(z(3)-z(1)))/(m1+m_a);...
    z(4);(c_p*(z(2)-z(4))+k*(z(1)-z(3)))/m2],t0,[0,0,0,0]);
end