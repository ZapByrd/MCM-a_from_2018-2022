%% 粒子群算法求解
%% 初始化种群
tic
clear;clc;close all;
global m1 m2 m_a w c c2  f L J1 J_a k_h k2 k L0 V0 g
m1=4866;%浮子质量
m2=2433;  %振子质量
m_a=1091.099;
w=1.9806;  %波浪频率
c=528.5018;
c2=1655.909;
f=1760;
L=2140;    %激励力矩振幅
J1=8.3988e+03;%纵摇惯量
J_a=7142.493;%附加转动惯量
k_h=8890.7;%静水恢复力矩系数
k2=250000;%弹簧抗扭刚度
k=80000;
L0=0.5;
rou=1025;
g=9.8;
r=1.0;
A0=pi*r^2;   %横截面积
V0=rou*g*A0;
N=5;                         % 初始种群个数
d=2;                            % 可行解维数,即自变量个数
ger=50;                     % 最大迭代次数
lim_cp1=[0,1e5];            % 位置坐标范围,即自变量范围
lim_cp2=[0,1e5];
vlimit=[-0.5,0.5];     % 设置速度限制
weight=0.6;                        % 惯性权重
cc1=2;                        % 自我学习因子
cc2=2;                       % 群体学习因子
x(:,1)=lim_cp1(1)+(lim_cp1(2)-lim_cp1(1)).*rand(N,1);%初始种群的位置
x(:,2)=lim_cp2(1)+(lim_cp2(2)-lim_cp2(1)).*rand(N,1);
v=rand(N,d);                   % 初始种群的速度
x_best=x;                          % 每个个体的历史最佳位置
xp_best=zeros(1,d);        % 种群的历史最佳位置
fx_best=ones(N,1);   % 每个个体的历史最佳适应度
fxp_best=0;                    % 种群历史最佳适应度

%% 群体更新
iter=1;
record=zeros(ger,1);          % 记录器
while iter<=ger
    for i=1:N
        fx(i)=ff(x(i,1),x(i,2)) ;% 个体当前适应度
    end
    for i=1:N
        if  fx(i)>fx_best(i)
            fx_best(i)=fx(i);     % 更新个体历史最佳适应度
            x_best(i,:)=x(i,:);   % 更新个体历史最佳位置(取值)
        end
    end
    if   max(fx_best)>fxp_best
        [fxp_best, n]=max(fx_best);   % 更新群体历史最佳适应度
        xp_best=x_best(n, :);              % 更新群体历史最佳位置
    end
    v=v*weight+cc1*rand*(x_best-x)+cc2*rand*(repmat(xp_best, N, 1)-x);% 速度更新
    % 边界速度处理
    v(v>vlimit(2))=vlimit(2);
    v(v<vlimit(1))=vlimit(1);
    x=x+v;% 位置更新
    % 边界位置处理
    a=x(:,1);b=x(:,2);
    a(a>lim_cp1(2))=lim_cp1(2);
    a(x<lim_cp1(1))=lim_cp1(1);
    b(b>lim_cp2(2))=lim_cp2(2);
    b(b<lim_cp2(1))=lim_cp2(1);
    record(iter)=fxp_best;%最大值记录
    iter=iter+1;
end
%输出
disp(['最大输出功率：',num2str(fxp_best)]);
disp(['对应的最优直线和旋转阻尼系数：',num2str(xp_best)]);
figure(1)
plot(record,'.-');grid on
title('最大输出功率进化过程')  
set(gca,'Fontsize',16);set(gcf,'Color','w')
xlabel('迭代次数');ylabel('最大输出功率(w)')
toc

function P=ff(cp1,cp2)
global  w
dt=0.2;
t0=0:dt:180;
[~,u]=ode45(@(t,u)fun(t,u,cp1,cp2),t0,[0,0,0,0,0,0,0,0]);
n=length(t0);
Dv=u(:,4)-u(:,2);%相对速度，振子-浮子
Dw=u(:,8)-u(:,6);%相对角速度，振子-浮子
P=(1/2*cp1*sum(Dv.^2)+1/2*cp2*sum(Dw.^2))/n;
end

function du=fun(t,u,c_p,c_p2)
global m1 m2 m_a w c c2  f L J1 J_a k_h k2 k L0 V0 g 
du=zeros(8,1);
du(1)=u(2);
du(2)=(-c*u(2)-(V0*u(1)*(u(1)>=-1)+V0*(-1)*(u(1)<-1))-c_p*(u(2)-u(4))-k*(u(1)-u(3))+f*cos(w*t))/(m1+m_a);
du(3)=u(4);
du(4)=-c_p/m2*(u(4)-u(2))-k/m2*(u(3)-u(1));
du(5)=u(6);
du(6)=(L*cos(w*t)-(k_h*u(5)+c2*u(6)+k2*(u(5)-u(7))+c_p2*(u(6)-u(8))))/(J1+J_a);  
du(7)=u(8);
du(8)=-(k2*(u(7)-u(5))+c_p2*(u(8)-u(6))+2*m2*(u(4)-u(2))*u(8)*(L0-m2*g/k+u(3)-u(1)))/((0.5-m2*g/k+u(3)-u(1))^2*m2);   
end