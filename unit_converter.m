function [Evento,Hidrograma] = unit_converter(Evento,Hidrograma,A,dT)
%********************************************************************       
% Standardization of the unit system
%
% Evento(:,1)       [mm]
% Evento(:,2)       [m^3/s]
Evento(:,2)=((Evento(:,2)/(A*10^6))*1000)*dT; % [m^3/s] to [mm]
% Evento(:,3)       [m^3/s]
Evento(:,3)=((Evento(:,3)/(A*10^6))*1000)*dT; % [m^3/s] to [mm]
% Evento(:,4)       [mm]
% Hidrograma        [mm]

%*********************************************************************
% Conversion from [mm] to [m^3/s]
%*********************************************************************
%             |-----------m^3 -------------|
%             |       mm   |/|m/mm|*|  m^2 |/|s|
Evento(:,2:4)=(Evento(:,2:4)./1000)*(A*10^6)/dT;    %[mm] to [m^3/s]
Hidrograma = (Hidrograma./1000)*(A*10^6)/dT;        %[mm] to [m^3/s]
Hidrograma = Hidrograma+Evento(:,3);                      %[m^3/s]
%**********************************************************************
                
end