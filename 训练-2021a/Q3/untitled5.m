a=alpha/180*pi;%还原
b=(90-bata)/180*pi;
Hz=[cos(a),-sin(a),0;sin(a),cos(a),0;0,0,1];
Hy=[cos(b),0,sin(b);0,1,0;-sin(b),0,cos(b)];
peak=[0,0,-300.8446];
peak2=Hy*peak';
peak2=Hz*peak2;
for i=1:m  
    XZ(i,:)=Hy*JZ(i,:)';
    XZ(i,:)=Hz*XZ(i,:)';
end
LocNew=XZ;