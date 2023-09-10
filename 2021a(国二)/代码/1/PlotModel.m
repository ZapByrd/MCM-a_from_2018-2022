function PlotModel(coord,facet,c)
  
%number of vertices and facets
%顶点和切面的数量
nvert=size(coord,1);
ntria=size(facet,1);
%coordinates of all vertices
%所有顶点的坐标
xpts = coord(:,1);
ypts = coord(:,2);
zpts = coord(:,3);
%nodes of all facets
%所有切面的坐标
node1 = facet(:,1);
node2 = facet(:,2);
node3 = facet(:,3);
%store node of each vertex to the vind array
%储存vind数组中每个顶点的节点
for i  = 1:ntria
    pts = [node1(i) node2(i) node3(i)];
    vind(i,:) = pts;
end
x = xpts; 	y = ypts; 	z = zpts;
% define X,Y,Z arrays and plot them
%定义X,Y,Z数组并绘画他们
for i = 1:ntria
    X = [x(vind(i,1)) x(vind(i,2)) x(vind(i,3)) x(vind(i,1))];
    Y = [y(vind(i,1)) y(vind(i,2)) y(vind(i,3)) y(vind(i,1))];
    Z = [z(vind(i,1)) z(vind(i,2)) z(vind(i,3)) z(vind(i,1))];
    fill3(X,Y,Z,c)
    if i == 1
        hold on
    end
end
axis square
xlabel('x');  ylabel('y');    zlabel('z');
% This is to avoid both a max and min of zero in any one dimension
%这是为了避免任意一维上的最大值和最小值都为0
xmax = max(xpts); xmin = min(xpts);
ymax = max(ypts); ymin = min(ypts);
zmax = max(zpts); zmin = min(zpts);
dmax = max([xmax ymax zmax]);
dmin = min([xmin ymin zmin]);

% This is to avoid both a max and min of zero in any one dimension
%这是为了避免任意一维上的最大值和最小值都为0
xmax = dmax; 	ymax = dmax; 	zmax = dmax;
xmin = dmin; 	ymin = dmin; 	zmin = dmin;
axis([xmin, xmax, ymin, ymax, zmin, zmax]);
 
