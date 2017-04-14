function DataPlotsSingle(Result,name,path)
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


%% Virtual Sorting
maxi=0;
[B,I] = sort(meanrfp); SortedFoci = foci(I); 
tails = round(length(foci)/10);
low_tail = SortedFoci(1:tails+1); high_tail = SortedFoci(end-tails:end);
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
subplot(1,2,1); bar(0:maxi,countings');
legend('Low Tail','High Tail'); ylabel('Frequency'); 
xlabel('Spot Number');ylim([0 1]);
subplot(1,2,2); bar(coutingspooled'); legend('Low Tail','High Tail'); 
ylabel('Frequency'); xlabel('Spot Number');
set(gca,'XTickLabel',{'0','more than 0'});ylim([0 1]);