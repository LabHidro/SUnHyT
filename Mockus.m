function [w]=Mockus(P)
global bt stat calib_flag valid_flag ungauged_flag;
if calib_flag == 1
load('data\data_base\Calibration\temp\PMatrix','PMatrix');
load('data\data_base\Calibration\temp\Evento','Evento');
elseif valid_flag == 1
load('data\data_base\Validation\temp\PMatrix','PMatrix');
load('data\data_base\Validation\temp\Evento','Evento'); 
elseif ungauged_flag == 1
load('data\data_base\Ungauged\temp\PMatrix','PMatrix');
load('data\data_base\Ungauged\temp\Evento','Evento');
end

tp=0.6*P(1); 

for t=1:bt
    h(t)=exp(P(2))*((t/tp)^P(2))*exp(-P(2)*(t/tp));
end

h=h/sum(h);
H=PMatrix*h';

Hidrograma=H(1:size(Evento,1));
[w]=OF(Hidrograma,Evento(:,4));

if calib_flag == 1
save('data\data_base\Calibration\temp\Hidrograma','Hidrograma');
elseif valid_flag == 1
save('data\data_base\Validation\temp\Hidrograma','Hidrograma'); 
elseif ungauged_flag == 1
save('data\data_base\Ungauged\temp\Hidrograma','Hidrograma');
end

stat = [stat ;[P(1) P(2) -w]];

end
