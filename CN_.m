function [CN,Ia,PMatrix,Evento]=CN_(Evento,A,dT)
global bt;

Evento(:,4)=((Evento(:,4)/(A*10^6))*1000)*dT; % [m^3/s] to [mm]

EfP=sum(Evento(:,4));
i=1;
while Evento(i+1,4)==0 
    if i < size(Evento(:,4),1)-1
    i=i+1;
    end
end
Ia=sum(Evento(1:i,1));
S=(((sum(Evento(:,1))-Ia)^2)/EfP)-sum(Evento(:,1))+Ia;

CN=25400/(S+254);

P(:,1)=Evento(:,1);
P(1,2)=Evento(1,1);

for i=2:size(Evento,1)
    P(i,2)=P(i-1,2)+P(i,1);
    if P(i,2)>Ia
        P(i,3)=((P(i,2)-Ia)^2)/(P(i,2)-Ia+S);
    else
        P(i,3)=0;
    end
end

P_CN(1,1)=P(1,3);
for i=2:size(Evento,1)
    P_CN(i,1)=P(i,3)-P(i-1,3);
end

i=1;
for j=1:bt
   PMatrix(i:size(Evento,1)+i-1,j)=P_CN(:,1);
   i=i+1;
end

end
