%% 粒子群算法求解
%% 初始化种群
clear;clc;close all;
N=25;                         % 初始种群个数
d=2;                            % 可行解维数,即自变量个数
ger=100;                     % 最大迭代次数
lim_alpha=[0,1e5];            % 位置坐标范围,即自变量范围
lim_a=[0,1];
vlimit=[-0.5,0.5];     % 设置速度限制
w=0.7;                        % 惯性权重
c1=2;                        % 自我学习因子
c2=2;                       % 群体学习因子
x(:,1)=lim_alpha(1)+(lim_alpha(2)-lim_alpha(1)).*rand(N,1);%初始种群的位置
x(:,2)=lim_a(1)+(lim_a(2)-lim_a(1)).*rand(N,1);
v=rand(N,d);                   % 初始种群的速度
x_best=x;                          % 每个个体的历史最佳位置
xp_best=zeros(1,d);        % 种群的历史最佳位置
fx_best=ones(N,1);   % 每个个体的历史最佳适应度
fxp_best=0;                    % 种群历史最佳适应度
P_best=[];
%% 群体更新
iter=1;
record=zeros(ger,1);          % 记录器
while iter<=ger
    for i=1:N
        fx(i)=f(x(i,1),x(i,2)) ;% 个体当前适应度
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
    v=v*w+c1*rand*(x_best-x)+c2*rand*(repmat(xp_best, N, 1)-x);% 速度更新
    % 边界速度处理
    v(v>vlimit(2))=vlimit(2);
    v(v<vlimit(1))=vlimit(1);
    x=x+v;% 位置更新
    % 边界位置处理
    a=x(:,1);b=x(:,2);
    a(a>lim_alpha(2))=lim_alpha(2);
    a(x<lim_alpha(1))=lim_alpha(1);
    b(b>lim_a(2))=lim_a(2);
    b(b<lim_a(1))=lim_a(1);
    record(iter)=fxp_best;%最大值记录
    iter=iter+1;
end
%输出
disp(['最大输出功率：',num2str(fxp_best)]);
disp(['对应的比例系数和幂指数：',num2str(xp_best)]);
figure(1)
plot(record,'.-');title('最大输出功率进化过程')  
set(gca,'Fontsize',16);set(gcf,'Color','w');grid on
xlabel('迭代次数');ylabel('最大输出功率(w)')
function P=f(alpha,a)
m_a=1165.992;
w=2.2143;
c=167.8395;
f=4890;
m1=4866;%浮子质量
m2=2433;  %振子质量
k=80000; %弹簧系数
rou=1025;
g=9.8;
r=1.0;
A0=pi*r^2;   %横截面积
dt=0.2;
t0=0:dt:180;
[t,z]=ode45(@(t,z)[z(2);(f*cos(w*t)-c*z(2)-rou*g*A0*z(1)+alpha*abs(z(2)-z(4))^a*(z(4)-z(2))+k*(z(3)-z(1)))/(m1+m_a);...
    z(4);(alpha*abs(z(2)-z(4))^a*(z(2)-z(4))+k*(z(1)-z(3)))/m2],t0,[0,0,0,0]);
n=length(t0);
Dv=z(:,4)-z(:,2);%相对速度，振子-浮子
c_p=alpha*abs(z(:,2)-z(:,4)).^a;
P=1/2*sum(c_p.*Dv.^2)/n;
end
