function [LocNew]=locSfun(Locori,R,F)
Ang=atan(norm(Locori(1:2))/abs(Locori(3)));%表示节点与球心间的连线和Z坐标轴的夹角，其中norm为范数，取向量的模数，如norm([3,4])=5
if (Ang~=0)%此时天体位置坐标的beta不等于0，普遍情况
    a=1/(4*F*R);
    b=1/tan(Ang);
    c=-R;
    
    x1=(-b+sqrt(b^2-4*a*c))/(2*a);
    x2=(-b-sqrt(b^2-4*a*c))/(2*a);
    if (x2>0)
        x=x2;
    else
        x=x1;
    end
    LocNew=Locori(1:2)/norm(Locori(1:2))*x;
    Locz=x*x/(4*F*R)-R;
    LocNew=[LocNew Locz];
else
    LocNew=Locori;
end
