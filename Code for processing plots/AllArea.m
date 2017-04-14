function AllArea(Result)
%% Plotting data
% Perform 4 plots:
% 1. Histogram showing frequency of cells compared to number of foci
% 2. Bar plot pKatG fluorescence vs number of foci
% 3. Bar plot cell area vs number of foci
% 4. Scatter plot pKatG fluorescence vs cell area
set(0,'defaulttextinterpreter','latex');
%% Formatting data for histogram
set(0,'DefaultAxesFontSize',14);
if iscell(Result)
    medianrfp = cell2mat(Result(:,10)); areacell = cell2mat(Result(:,12));
    foci = cell2mat(Result(:,13));
else
    medianrfp = Result(:,10); areacell = Result(:,12); 
    foci = Result(:,13); meanrfp = Result(:,11);
end
%% 1
f1=figure();
histogram(foci,'Normalization','probability','LineWidth',2); 
ylabel('\textbf{Frequency}'); xlabel('\textbf{Number of foci per cell}');
set(gca,'xtick', 0:max(foci)); set(gca,'linewidth',2);


%% Formatting data for computing means and stds for barplots
means = unique(foci); stds = unique(foci);
areaM = unique(foci); areaS = unique(foci); 
cellnumber = unique(foci); j = 1;
for i = unique(foci)'
    means(j,2) = mean(medianrfp(foci==i));
    stds(j,2) = std(medianrfp(foci==i));
    areaM(j,2) = mean(areacell(foci==i));
    areaS(j,2) = std(areacell(foci==i));
    cellnumber(j,2) = sum(foci==i);
    j = j+1;
end

%% Statistical tests
[h2,p2] = ttest2(areacell(foci==0),areacell(foci>0));
[pr2,hr2] = ranksum(areacell(foci==0),areacell(foci>0));
%% Boxplots or Scatter (MJ)
f3 = figure();

subplot(1,2,1);boxplot(areacell,foci);
set(findobj(gca,'type','line'),'linew',2); set(gca,'linew',2);
ylabel('\textbf{Cell Area}');
xlabel('\textbf{\begin{tabular}{c}Foci number \\ (Number of cells)\end{tabular}}');
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
xlabel('\textbf{\begin{tabular}{c}Foci number \\ (Number of cells)\end{tabular}}');
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

Path=[uigetdir,'/'];cd(Path);
set(f1,'PaperPositionMode','auto'); set(f3,'PaperPositionMode','auto');
print(f1,'allspots','-dpng'); print(f3,'allareas','-dpng');
hgexport(f1,'allspots'); hgexport(f3,'allareas');