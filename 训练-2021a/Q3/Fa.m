%返回三角面板反射法向量
function V=Fa(L1,L2,L3)
   V=cross((L1-L2),(L2-L3));
end