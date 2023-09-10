%每个面板上随机生成10000个点，并返回坐标
function [x,y,z]=Carol(p1,p2,p3,nmd1,nmd2)
DF=[1-nmd1,nmd1]*[p2;p3];
DE=[1-nmd2,nmd2]*[p1;DF]; %任意点E的坐标
x=DE(1);
y=DE(2);
z=DE(3);
end

