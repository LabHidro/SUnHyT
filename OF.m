function [w]=OF(x,y)

z=(y-(x(1:size(y,1)))).^2;
v=sum(y)/(size(y,1)+1);
q=(y-v).^2;
w=-(1-(sum(z)/sum(q)));

end