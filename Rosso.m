function [w]=Rosso(v)
global bt stat calib_flag valid_flag ungauged_flag;
if calib_flag == 1
load('data\data_base\Calibration\temp\PMatrix','PMatrix');
load('data\data_base\Calibration\temp\Evento','Evento');
load('data\data_base\Calibration\temp\Law','Law');
elseif valid_flag == 1
load('data\data_base\Validation\temp\PMatrix','PMatrix');
load('data\data_base\Validation\temp\Evento','Evento');
load('data\data_base\Validation\temp\Law','Law'); 
elseif ungauged_flag == 1
load('data\data_base\Ungauged\temp\PMatrix','PMatrix');
load('data\data_base\Ungauged\temp\Evento','Evento');
load('data\data_base\Ungauged\temp\Law','Law');
end

Law(1)=Law(1)*1000;
Pa(1)=(3.29*(Law(3)/Law(4))^0.78)*Law(2)^0.07;
Pa(2)=0.7*(Law(4)/(Law(3)*Law(2))^0.48)*(Law(1)/v);

for t=1:bt
    h(t)=(1/Pa(1))*((t/Pa(1))^(Pa(2)-1))*(1/gamma(Pa(2)))*exp(-(t/Pa(1)));
end

H=PMatrix*h';
Hidrograma=H(1:size(Evento,1));
[w]=OF(Hidrograma,Evento(:,4));

stat = [stat ;[v -w]];

if calib_flag == 1
save('data\data_base\Calibration\temp\Hidrograma','Hidrograma');
elseif valid_flag == 1
save('data\data_base\Validation\temp\Hidrograma','Hidrograma'); 
elseif ungauged_flag == 1
save('data\data_base\Ungauged\temp\Hidrograma','Hidrograma');
end

end