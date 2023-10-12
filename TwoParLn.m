function [w]=TwoParLn(Pa)
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


for t=1:bt
    %h(t)=(1/sqrt(2*pi)*Pa(1)*t)*exp((-(log(t)-Pa(2))^2)/2*Pa(1)^2);
    h(t)=(1/(sqrt(2*pi)*Pa(1)*t))*exp((-(log(t)-Pa(2))^2)/(2*Pa(1)^2));
end

H=PMatrix*h';
Hidrograma=H(1:size(Evento,1));
[w]=OF(Hidrograma,Evento(:,4));

stat = [stat ;[Pa(1) Pa(2) -w]];

if calib_flag == 1
save('data\data_base\Calibration\temp\Hidrograma','Hidrograma');
elseif valid_flag == 1
save('data\data_base\Validation\temp\Hidrograma','Hidrograma'); 
elseif ungauged_flag == 1
save('data\data_base\Ungauged\temp\Hidrograma','Hidrograma');
end

end