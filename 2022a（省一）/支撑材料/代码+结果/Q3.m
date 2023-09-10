clear;clc;close all;
global m1 m2 m_a w c c2 c_p c_p2 f L J1 J_a k_h k2 k L0 V0 g
m1=4866;%浮子质量
m2=2433;  %振子质量
m_a=1028.876;
w=1.7152;  %波浪频率
c=683.4558;
c2=654.3383;%纵摇兴波阻尼系数
c_p=10000;
c_p2=1000;% 旋转阻尼系数
f=3640;
L=1690;    %激励力矩振幅
J1=8.3988e+03;%纵摇惯量
J_a=7001.914;%附加转动惯量
k_h=8890.7;%静水恢复力矩系数
k2=250000;%弹簧抗扭刚度
k=80000;
L0=0.5;
rou=1025;
g=9.8;
r=1.0;
A0=pi*r^2;   %横截面积
V0=rou*g*A0;
dt=0.2;
t0=0:dt:180;
[t,u]=ode45(@fun,t0,[0,0,0,0,0,0,0,0]);
%% 绘图
figure(1)
subplot(2,1,1);plot(t0,u(:,1),'b--','LineWidth',0.8)
hold on;plot(t0,u(:,3),'r-','LineWidth',0.2)
legend('浮子位移','振子位移');grid on
set(gcf,'Color','w')
ylabel('位移(m)')
subplot(2,1,2);plot(t0,u(:,2),'b--','LineWidth',0.8)
hold on;plot(t0,u(:,4),'r-','LineWidth',0.2)
legend('浮子速度','振子速度');grid on
set(gcf,'Color','w')
xlabel('时间(s)');ylabel('速度(m/s)')
figure(2)
subplot(2,1,1);plot(t0,u(:,5),'b--','LineWidth',0.8)
hold on;plot(t0,u(:,7),'r-','LineWidth',0.2)
legend('浮子角位移','振子角位移');grid on
set(gcf,'Color','w')
ylabel('角位移(rad)')
subplot(2,1,2);plot(t0,u(:,6),'b--','LineWidth',0.8)
hold on;plot(t0,u(:,8),'r-','LineWidth',0.2)
legend('浮子角速度','振子角速度');grid on
set(gcf,'Color','w')
xlabel('时间(s)');ylabel('角速度(rad/s)')

%% 保存数据
result=[t0',u(:,1),u(:,2),u(:,5),u(:,6),u(:,3),u(:,4),u(:,7),u(:,8)];
xlswrite('result3.xlsx',result,'sheet1','A3:I903')

%% 求解函数
function du=fun(t,u)
global m1 m2 m_a w c c2 c_p c_p2 f L J1 J_a k_h k2 k L0 V0 g
du=zeros(8,1);
du(1)=u(2);
du(2)=(-c*u(2)-(V0*u(1)*(u(1)>=-1)+V0*(-1)*(u(1)<-1))-c_p*(u(2)-u(4))-k*(u(1)-u(3))+f*cos(w*t))/(m1+m_a);
du(3)=u(4);
du(4)=-c_p/m2*(u(4)-u(2))-k/m2*(u(3)-u(1));
du(5)=u(6);
du(6)=(L*cos(w*t)-(k_h*u(5)+c2*u(6)+k2*(u(5)-u(7))+c_p2*(u(6)-u(8))))/(J1+J_a);  
du(7)=u(8);
J2=(0.5-m2*g/k+u(3)-u(1))^2*m2; 
du(8)=-(k2*(u(7)-u(5))+c_p2*(u(8)-u(6))+2*m2*(u(4)-u(2))*u(8)*(L0-m2*g/k+u(3)-u(1)))/J2;   
end