function [bt]=basetime(Evento)
global BF_flag;
bt=0;
i=1;
cond=1;
if BF_flag == 1
    while cond==1
        if Evento(i,2)-Evento(i,3)>0
            while Evento(i,2)-Evento(i,3)>0
                bt=bt+1;
                i=i+1;
            end
            cond=-1;
        end
        i=i+1;
    end
else
    bt = size(Evento(:,2));
end
end