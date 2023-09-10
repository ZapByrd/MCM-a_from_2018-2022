%两点之间距离函数,size(A)=size(B)=[1,3]
function x=side(A,B)
  x=sqrt((A(1)-B(1))^2+ (A(2)-B(2))^2+ (A(3)-B(3))^2) ;
end