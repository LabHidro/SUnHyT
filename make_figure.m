function make_figure(UHName,xlabel_,ylabel_,BF_flag)
global calib_flag valid_flag ungauged_flag;
if calib_flag ==1
    global obj_val;
    ef = obj_val;
    load('data\data_base\Calibration\Results\Evento','Evento')
    load('data\data_base\Calibration\Results\Hidrograma','Hidrograma')
elseif valid_flag == 1
    global NSE_valid;
    ef = NSE_valid;
    load('data\data_base\Validation\Results\Evento','Evento')
    load('data\data_base\Validation\Results\Hidrograma','Hidrograma')
elseif ungauged_flag == 1
    load('data\data_base\Ungauged\Results\Evento','Evento')
end

figure

if ungauged_flag == 1
    
    subplot (3,1,2:3)
    if BF_flag == 0
        %Evento
        plot(Evento(:,2),'k','LineWidth',1);
        legend('Simulated')        
    else
        plot(Evento(:,2),'k','LineWidth',1);
        hold on
        plot(Evento(:,3),'k--','LineWidth',1);
        legend('Simulated','Baseflow')
    end
    xlabel(xlabel_)
    ylabel(ylabel_)
    
    subplot(3,1,1)
    pbar = bar(Evento(:,1),'FaceColor',[0.7 0.7 0.7]);
    set (gca,'Ydir','reverse')
    set(gca,'xticklabel',{[]})
    ylabel('Precipitation (mm)')
    title(UHName)
    
else
    subplot (3,1,2:3)
    if BF_flag == 0
        %Evento
        plot(Evento(:,2),'k','LineWidth',1);
        hold on
        plot(Hidrograma,'Color',[0.5 0.5 0.5],'LineWidth',0.5)
        legend('Observed','Simulated')
        
    else
        plot(Evento(:,2),'k','LineWidth',1);
        hold on
        plot(Evento(:,3),'k--','LineWidth',1);
        plot(Hidrograma,'Color',[0.5 0.5 0.5],'LineWidth',0.5)
        legend('Observed','Baseflow','Simulated')
    end
    xlabel(xlabel_)
    ylabel(ylabel_)
    
    subplot(3,1,1)
    pbar = bar(Evento(:,1),'FaceColor',[0.7 0.7 0.7]);
    set (gca,'Ydir','reverse')
    set(gca,'xticklabel',{[]})
    ylabel('Precipitation (mm)')
    title([UHName ' (NSE = ' num2str(ef) ')'])
    
end