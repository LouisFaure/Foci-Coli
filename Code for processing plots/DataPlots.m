function DataPlots(Result,name,path,n)
%% Plotting data
% Perform 4 plots:
% 1. Histogram showing frequency of cells compared to number of foci
% 2. Bar plot pKatG fluorescence vs number of foci
% 3. Bar plot Cell Area (AU) vs number of foci
% 4. Scatter plot mean fluorescence vs Cell Area (AU)
set(0,'defaulttextinterpreter','latex');
%% Formatting data for histogram
set(0,'DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight', 'bold');

if iscell(Result)
    medianrfp = cell2mat(Result(:,10)); areacell = cell2mat(Result(:,12));
    foci = cell2mat(Result(:,13));
else
    medianrfp = Result(:,10); areacell = Result(:,12); 
    foci = Result(:,13); meanrfp = Result(:,11);
end
%% 1
f1=figure(); subplot(1,2,1);
histogram(foci,'Normalization','probability','LineWidth',2); 
set(gca,'linewidth',2)
ylabel('\textbf{Frequency}'); xlabel('\textbf{Number of foci per cell}');
set(gca,'xtick', 0:max(foci)); [c,pcor] = corr(areacell,meanrfp);

subplot(1,2,2); scatter(areacell,meanrfp); 
set(gca,'linewidth',2); xlabel('\textbf{Cell Area (AU)}'); 
ylabel(['\textbf{', name, ' mean fluorescence per cell (RFU)}']);
legend(['Correlation: ',num2str(c) 10 'p = ',num2str(pcor)]); 
f1.Position(end-1) = 560*2;

%% Formatting data for computing means and stds for barplots
means = unique(foci); stds = unique(foci);
areaM = unique(foci); areaS = unique(foci); 
cellnumber = unique(foci); j = 1;
for i = unique(foci)'
%     means(j,2) = mean(medianrfp(foci==i));
%     stds(j,2) = std(medianrfp(foci==i));
%     areaM(j,2) = mean(areacell(foci==i));
%     areaS(j,2) = std(areacell(foci==i));
    cellnumber(j,2) = sum(foci==i);
    j = j+1;
end

%% Statistical tests
[h1,p1] = ttest2(meanrfp(foci==0),meanrfp(foci>0));
[pr1,hr1] = ranksum(meanrfp(foci==0),meanrfp(foci>0));
[h2,p2] = ttest2(areacell(foci==0),areacell(foci>0));
[pr2,hr2] = ranksum(areacell(foci==0),areacell(foci>0));
%% Boxplots or Scatter (MJ)
f2 = figure();
subplot(1,2,1);

boxplot(meanrfp,foci);
set(findobj(gca,'type','line'),'linew',2); set(gca,'linew',2);
ylabel(['\textbf{',name, ' mean fluorescence per cell (RFU)}']);
xlabel('\textbf{\begin{tabular}{c}Number of foci per cell \\ (Number of cells)\end{tabular}}');
xlab = cellfun(@num2str,num2cell(cellnumber),'UniformOutput',0);
Xlab = cell(length(xlab),1);
for i = 1:length(xlab)
    Xlab{i} = strcat('\textbf{\begin{tabular}{c}',...
        xlab{i,1},'\\(',xlab{i,2},...
        ')\end{tabular}}');
end
set(gca,'XTickLabel', Xlab,'TickLabelInterpreter', 'latex');
scale = input('Rescaling(put 0 if no change needed): ');
if scale~=0, ymin = ylim; ylim([ymin(1) scale]); end

subplot(1,2,2);boxplot(meanrfp,foci>0);
set(findobj(gca,'type','line'),'linew',2); set(gca,'linew',2);
xlabel('\textbf{\begin{tabular}{c}Number of foci per cell \\ (Number of cells)\end{tabular}}');
if scale~=0, ymin = ylim; ylim([ymin(1) scale]); end
Xlab2 = cell(2,1);
Xlab2{1} = strcat('\textbf{\begin{tabular}{c}0\\(',...
    num2str(cellnumber(1,2)),')\end{tabular}}');
Xlab2{2} = strcat('\textbf{\begin{tabular}{c}More than 0\\(',...
    num2str(sum(cellnumber(2:end,2))),')\end{tabular}}');
set(gca,'XTickLabel', Xlab2,'TickLabelInterpreter', 'latex');

% Add significance bar
if h1 && hr1==0 || h1==0 && hr1  || h1 && hr1
    yt = get(gca, 'YTick'); axis([xlim    0  ceil(max(yt)*1.2)])
    xt = get(gca, 'XTick');hold on;
    plot(mean(xt),max(yt)*1.15,'*k','MarkerSize',10);
    plot(xt,[1 1]*max(yt)*1.1,'-k','LineWidth',2);
    hold off
end
if h1 && hr1==0, lg=legend(['TTest p = ',num2str(p1)]);
elseif h1==0 && hr1, lg=legend(['Wilcoxon p = ',num2str(pr1)]);
elseif h1 && hr1, lg=legend(['TTest p = ',num2str(p1) 10 ...
        'Wilcoxon p = ',num2str(pr1)]);
end

lg.Location = 'south';
f2.Position(end-1) = 560*2;

f3 = figure();
subplot(1,2,1);boxplot(areacell,foci);
set(findobj(gca,'type','line'),'linew',2); set(gca,'linew',2);
ylabel('\textbf{Cell Area (AU)}');
xlabel('\textbf{\begin{tabular}{c}Number of foci per cell \\ (Number of cells)\end{tabular}}');
xlab = cellfun(@num2str,num2cell(cellnumber),'UniformOutput',0);
Xlab = cell(length(xlab),1);
for i = 1:length(xlab)
    Xlab{i} = strcat('\textbf{\begin{tabular}{c}',...
        xlab{i,1},'\\(',xlab{i,2},...
        ')\end{tabular}}');
end
set(gca,'XTickLabel', Xlab,'TickLabelInterpreter', 'latex');
scale = input('Rescaling(put 0 if no change needed): ');
if scale~=0, ymin = ylim; ylim([ymin(1) scale]); end

subplot(1,2,2);boxplot(areacell,foci>0);
set(findobj(gca,'type','line'),'linew',2); set(gca,'linew',2);
xlabel('\textbf{\begin{tabular}{c}Number of foci per cell \\ (Number of cells)\end{tabular}}');
if scale~=0, ymin = ylim; ylim([ymin(1) scale]); end
Xlab2 = cell(2,1);
Xlab2{1} = strcat('\textbf{\begin{tabular}{c}0\\(',...
    num2str(cellnumber(1,2)),')\end{tabular}}');
Xlab2{2} = strcat('\textbf{\begin{tabular}{c}More than 0\\(',...
    num2str(sum(cellnumber(2:end,2))),')\end{tabular}}');
set(gca,'XTickLabel', Xlab2,'TickLabelInterpreter', 'latex');

% Add significance bar
if h2 && hr2==0 || h2==0 && hr2  || h2 && hr2
    yt = get(gca, 'YTick'); axis([xlim    0  ceil(max(yt)*1.2)])
    xt = get(gca, 'XTick');hold on;
    plot(mean(xt),max(yt)*1.15,'*k','MarkerSize',10);
    plot(xt,[1 1]*max(yt)*1.1,'-k','LineWidth',2);
    hold off
end
if h2 && hr2==0, lg=legend(['TTest p = ',num2str(p2)]);
elseif h2==0 && hr2, lg=legend(['Wilcoxon p = ',num2str(pr2)]);
elseif h2 && hr2, lg=legend(['TTest p = ',num2str(p2) 10 ...
        'Wilcoxon p = ',num2str(pr2)]);
end
lg.Location = 'south';
f3.Position(end-1) = 560*2;

%% Virtual Sorting
maxi=0;
f4=figure; subplot(1,2,2);
h1=histogram(meanrfp,'Normalization','probability','LineWidth',2);
set(gca,'linewidth',2);
xlabel(['\textbf{', name, ' mean fluorescence per cell (RFU)}']);

subplot(1,2,1);
for i=1:max(Result(:,14))
    meanrfp = Result(Result(:,14)==i,11);foci = Result(Result(:,14)==i,13);
    [B,I] = sort(meanrfp);
    SortedFoci = foci(I); tails = round(length((meanrfp))/10);
    low_tail = SortedFoci(1:tails+1); 
    high_tail = SortedFoci(end-tails:end);
    for j=0:max([low_tail;high_tail])
        countings(1,j+1,i)=sum(low_tail==j)/(tails+1);
        countings(2,j+1,i)=sum(high_tail==j)/(tails+1);
    end
    countingspooled(1,1,i)=sum(low_tail==0)/(tails+1);
    countingspooled(1,2,i)=sum(low_tail>0)/(tails+1);
    countingspooled(2,1,i)=sum(high_tail==0)/(tails+1);
    countingspooled(2,2,i)=sum(high_tail>0)/(tails+1);
    maxi = max([maxi;low_tail;high_tail]); ncell(i) = sum(Result(:,14)==i);
    histogram(meanrfp,'Normalization','probability',...
        'BinWidth',h1.BinWidth,'LineWidth',2);
    hold on;
end
xlabel(['\textbf{', name, ' mean fluorescence per cell (RFU)}']); 
ylabel('\textbf{Frequency}'); set(gca,'linewidth',2);
colorList = get(gca,'ColorOrder');
f4.Position(end-1) = 560*2;


f5 = figure;
meanexpco = squeeze(mean(permute(countings,[3,1,2])));
stdexpco = squeeze(std(permute(countings,[3,1,2])));

meanexpco2 = squeeze(mean(permute(countingspooled,[3,1,2])));
stdexpco2 = squeeze(std(permute(countingspooled,[3,1,2])));

% subplot(1,2,1);
% [hBox hErr] = barwitherr(stdexpco',meanexpco','linewidth',2); ylim([0 1]);
% legend('Low End (10%)','High End (10%)'); ylabel('\textbf{Frequency}');
% xlabel('\textbf{Number of foci per cell}'); set(gca,'XTickLabel', 0:maxi);
% set(hErr(:), 'LineWidth', 2);set(gca,'linewidth',2);

subplot(1,2,2);
[hBox hErr] = barwitherr(stdexpco2',meanexpco2','linewidth',2); ylim([0 1]);
%legend('Low End (10%)','High End (10%)'); ylabel('Frequency');
xlabel('\textbf{Number of foci per cell}'); set(gca,'XTickLabel',{'0','more than 0'});
set(hErr(:), 'LineWidth', 2);hold on;set(gca,'linewidth',2);
hBox(1).FaceColor
hBox(1).FaceColor = colorList(1,:); hBox(2).FaceColor = colorList(3,:);
hBox(1).FaceAlpha = 0.6; hBox(2).FaceAlpha = 0.6;


%TTest
expco2 = permute(countingspooled,[3,1,2]);
[h3,p3]=ttest2(expco2(:,1,1),expco2(:,2,1));
if h3
    yt = get(gca, 'YTick'); ylim([0 round(max(max(max(expco2))),1)*1.2])
    xt = get(gca, 'XTick');hold on;
    s = plot(mean(xt),round(max(max(max(expco2))),1)*1.15,'*k', 'MarkerSize',10);
    plot(xt,[1 1]*round(max(max(max(expco2))),1)*1.1,'-k','LineWidth',2);
    hold off
    legend(s,['TTest' 10 'p = ',num2str(round(p3,3))],'Location','south');
end


n=1;


if n==1,
    meanrfp = Result(:,11);foci = Result(:,13);
    [B,I] = sort(meanrfp); SortedFoci = foci(I); 
    tails = round(length(foci)/10);
    low_tail = SortedFoci(1:tails+1); high_tail = SortedFoci(end-tails:end);
    subplot(1,2,1);
    h2=histogram(B(1:tails+1),'BinWidth',h1.BinWidth,'LineWidth',2);hold on;
    histogram(B(tails+2:end-tails-1),'BinWidth',h1.BinWidth,'LineWidth',2);
    histogram(B(end-tails:end),'BinWidth',h1.BinWidth,'LineWidth',2);
    set(gca,'linewidth',2);
    legend('Low End (10%)', '80%','High End (10%)');
    xlabel(['\textbf{', name, ' mean fluorescence per cell (RFU)}']); 
    ylabel('\textbf{Cell count}'); 
    countings = []; countingspooled = [];
    maxi = max([low_tail;high_tail]);
    for i=0:maxi
        countings(1,i+1)=sum(low_tail==i)/(tails+1);
        countings(2,i+1)=sum(high_tail==i)/(tails+1);
    end
    coutingspooled(1,1)=sum(low_tail==0)/(tails+1);
    coutingspooled(1,2)=sum(low_tail>0)/(tails+1);
    coutingspooled(2,1)=sum(high_tail==0)/(tails+1);
    coutingspooled(2,2)=sum(high_tail>0)/(tails+1);
    meanexpco = countings;meanexpco2 = coutingspooled;
    f6 = figure;
    subplot(1,2,1); b1=bar(0:maxi,countings','linewidth',2);
    legend('Low End (10%)','High End (10%)'); ylabel('\textbf{Frequency}'); 
    xlabel('\textbf{Number of foci per cell}');ylim([0 1]);set(gca,'linewidth',2);
    subplot(1,2,2); b2=bar(coutingspooled','linewidth',2); 
    legend('Low End (10%)','High End (10%)'); 
    xlabel('\textbf{Number of foci per cell}');set(gca,'linewidth',2);
    set(gca,'XTickLabel',{'0','more than 0'});ylim([0 1]);
    b1(1).FaceColor = colorList(1,:); b1(2).FaceColor = colorList(3,:);
    b2(1).FaceColor = colorList(1,:); b2(2).FaceColor = colorList(3,:);
    b1(1).FaceAlpha = 0.6; b1(2).FaceAlpha = 0.6;
    b2(1).FaceAlpha = 0.6; b2(2).FaceAlpha = 0.6;
    [hc,pc, chi2stat,df] = prop_test([sum(low_tail==0) sum(high_tail==0)],...
        [length(low_tail) length(high_tail)],false)
    if hc
        yt = get(gca, 'YTick'); ylim([0 round(max(max(max(expco2))),1)*1.2])
        xt = get(gca, 'XTick');hold on;
        s = plot(mean(xt),round(max(max(max(expco2))),1)*1.15,'*k', 'MarkerSize',10);
        plot(xt,[1 1]*round(max(max(max(expco2))),1)*1.1,'-k','LineWidth',2);
        hold off
        legend(s,['Chi-Square' 10 'p = ',num2str(pc)],'Location','south');
    end
    
    f7 = figure;
    subplot(1,2,1); b1=bar(0:maxi,countings'.*tails,'linewidth',2);
    legend('Low End (10%)','High End (10%)'); ylabel('\textbf{Cell count}'); 
    xlabel('\textbf{Number of foci per cell}');set(gca,'linewidth',2);
    subplot(1,2,2); b2=bar(coutingspooled'.*tails,'linewidth',2); 
    legend('Low End (10%)','High End (10%)'); 
    xlabel('\textbf{Number of foci per cell}');set(gca,'linewidth',2);
    set(gca,'XTickLabel',{'0','more than 0'});
    b1(1).FaceColor = colorList(1,:); b1(2).FaceColor = colorList(3,:);
    b2(1).FaceColor = colorList(1,:); b2(2).FaceColor = colorList(3,:);
    b1(1).FaceAlpha = 0.6; b1(2).FaceAlpha = 0.6;
    b2(1).FaceAlpha = 0.6; b2(2).FaceAlpha = 0.6;
    if hc
        yt = get(gca, 'YTick'); ylim([0 ...
            ceil(max(max(max(coutingspooled'.*tails))))*1.2])
        xt = get(gca, 'XTick');hold on;
        s = plot(mean(xt),ceil(max(max(max(coutingspooled'.*tails))))*1.15,...
            '*k', 'MarkerSize',10);
        plot(xt,[1 1]*ceil(max(max(max(coutingspooled'.*tails))))*1.1,...
            '-k','LineWidth',2);
        hold off
        legend(s,['Chi-Square' 10 'p = ',num2str(pc)],'Location','south');
    end
else

end
f5.Position(end-1) = 560*2;
f6.Position(end-1) = 560*2;
f7.Position(end-1) = 560*2;

cd(path)
set(f1,'PaperPositionMode','auto'); set(f2,'PaperPositionMode','auto');
set(f3,'PaperPositionMode','auto'); set(f4,'PaperPositionMode','auto');
set(f5,'PaperPositionMode','auto'); set(f6,'PaperPositionMode','auto');
set(f7,'PaperPositionMode','auto');

savefig(f1,'f1');savefig(f2,'f2');savefig(f3,'f3');
savefig(f4,'f4');savefig(f5,'f5');savefig(f6,'f6');savefig(f7,'f7');

hgexport(f1,'fig1'); hgexport(f2,'fig2'); hgexport(f3,'fig3');
hgexport(f4,'f4'); hgexport(f5,'fig5'); hgexport(f6,'fig6');hgexport(f7,'fig7');


print(f1,'f1','-dpng'); print(f2,'f2','-dpng'); print(f3,'f3','-dpng');
print(f4,'fig4','-dpng'); print(f5,'f5','-dpng'); print(f6,'f6','-dpng');
print(f7,'f7','-dpng');


[h,p] = kstest(meanrfp)