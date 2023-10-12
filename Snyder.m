function [w]=Snyder(P)
global bt stat calib_flag valid_flag ungauged_flag;
if calib_flag == 1
load('data\data_base\Calibration\temp\PMatrix','PMatrix');
load('data\data_base\Calibration\temp\Evento','Evento');
load('data\data_base\Calibration\temp\P_Fisi','P_Fisi');
elseif valid_flag == 1
load('data\data_base\Validation\temp\PMatrix','PMatrix');
load('data\data_base\Validation\temp\Evento','Evento');
load('data\data_base\Validation\temp\P_Fisi','P_Fisi'); 
elseif ungauged_flag == 1
load('data\data_base\Ungauged\temp\PMatrix','PMatrix');
load('data\data_base\Ungauged\temp\Evento','Evento');
load('data\data_base\Ungauged\temp\P_Fisi','P_Fisi');
end

tp=P(1)*(P_Fisi(1)*P_Fisi(2))^0.3;
beta=1.09*P(2);

Pa(1)=(7/6)+(2*pi*beta^2);
Pa(2)=tp/(Pa(1)-1);

for t=1:bt
    h(t)=(1/Pa(1))*((t/Pa(1))^(Pa(2)-1))*(1/gamma(Pa(2)))*exp(-(t/Pa(1)));
end

H=PMatrix*h';
Hidrograma=H(1:size(Evento,1));
[w]=OF(Hidrograma,Evento(:,4));

stat = [stat ;[P(1) P(2) -w]];

if calib_flag == 1
save('data\data_base\Calibration\temp\Hidrograma','Hidrograma');
elseif valid_flag == 1
save('data\data_base\Validation\temp\Hidrograma','Hidrograma'); 
elseif ungauged_flag == 1
save('data\data_base\Ungauged\temp\Hidrograma','Hidrograma');
end

end