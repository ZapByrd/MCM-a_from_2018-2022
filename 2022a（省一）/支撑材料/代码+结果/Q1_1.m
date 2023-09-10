% 考虑四种力，静水恢复力为水线面积
% 定常阻尼系数
clear;clc;close all;
w=1.4005;  %波浪频率
m_a=1335.535;%附加质量
c=656.3616;%兴波阻尼系数
c_p=10000;% 直线阻尼系数
f=6250;    %垂荡激励力振幅
dt=0.2;
t0=0:dt:180;
z=Chui(w,m_a,c,c_p,f);
% 绘图
figure(1)
subplot(2,1,1);plot(t0,z(:,1),'LineWidth',0.8)
title('浮子');ylabel('位移(m)');hold on;
x=z(:,3)-z(:,1);                                                %相对位移(振子-浮子)
plot(t0,x,'m');legend('浮子位移','相对位移')
set(gcf,'Color','w');grid on
subplot(2,1,2);plot(t0,z(:,3),'r','LineWidth',0.8)
title('振子');xlabel('时间(s)');ylabel('位移(m)')
legend('振子位移');grid on
figure(2)
subplot(2,1,1);plot(t0,z(:,2),'LineWidth',0.8)
title('浮子');ylabel('速度(m/s)');hold on;
v=z(:,4)-z(:,2);                                                  %相对速度(振子-浮子)
plot(t0,v,'m');legend('浮子速度','相对速度')
set(gcf,'Color','w');grid on
subplot(2,1,2);plot(t0,z(:,4),'r','LineWidth',0.8)
legend('振子速度');grid on
title('振子');xlabel('时间(s)');ylabel('速度(m/s)')
 result=[t0',z];
 xlswrite('result1-1.xlsx',result,'sheet1','A3:E903')
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