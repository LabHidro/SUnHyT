function [w]=Kirkby(Pa)
global bt stat valid_flag calib_flag ungauged_flag;
if calib_flag == 1
load('data\data_base\Calibration\temp\PMatrix','PMatrix');
load('data\data_base\Calibration\temp\Evento','Evento');
load('data\data_base\Calibration\temp\river','river');
load('data\data_base\Calibration\temp\hill','hill');
elseif valid_flag == 1
load('data\data_base\Validation\temp\PMatrix','PMatrix');
load('data\data_base\Validation\temp\Evento','Evento');
load('data\data_base\Validation\temp\river','river');
load('data\data_base\Validation\temp\hill','hill'); 
elseif ungauged_flag == 1
load('data\data_base\Ungauged\temp\PMatrix','PMatrix');
load('data\data_base\Ungauged\temp\Evento','Evento');
load('data\data_base\Ungauged\temp\river','river');
load('data\data_base\Ungauged\temp\hill','hill');
end
vr=Pa(1); %meters/dt
ve=Pa(2); %meters/dt

rio_v=river./vr;
enc_v=hill./ve;
Aux5=rio_v+enc_v;
Aux5(Aux5==0)=NaN;

con=1;
for i=1:bt
[a,~]=find(Aux5 <= i);
tempo(con,1)=size(a,1);
con=con+1;
end

tempo(1,2)=tempo(1,1);
for i=2:size(tempo,1)
    tempo(i,2)=tempo(i,1)-tempo(i-1,1);
end

h=tempo(1:bt,2);

H=PMatrix*(h./sum(h));
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
