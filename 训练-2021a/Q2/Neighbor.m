%节点的相邻矩阵
%load MeshGrid
Nei_t=zeros(NodeNum,18);
Nei=zeros(NodeNum,7);
Nei(:,1)=1:NodeNum;%自己的节点编号
for ii=1:NodeNum%排节点编号
    m=1;
    for jj=1:MeshNum%找节点编号
        for t=1:3
           if MeshGrid(jj,t)==ii
               Nei_t(ii,m:m+2)=MeshGrid(jj,:);
               m=m+3;
           end
         end       
    end
end

for ii=1:NodeNum
    k=unique(Nei_t(ii,:));%删除重复项
    k(k==0)=[];               %删除多余的0
    k(k==ii)=[];                %删除自己的节点编号
    a=zeros(1,6-length(k));%用于补全空缺，方便合并
    Nei(ii,2:end)=[k,a];
end