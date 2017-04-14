clearvars; close all;
%%
Results=[]; name = input('name? ', 's');
path = ['/Users/Anthony/Desktop/Louis/Microscope/',name];
allresults = rdir([path,'/**/*.csv']);
%%
for i = 1:length(allresults)
    %% Importing dataset
    Result = ImportFileCsv(allresults(i).name);
    clear FilName
    %% Moving columns to fit the next function:
    %Result(:,15)=Result(:,13);  %length
    Result(:,13)=Result(:,8);   %foci
    Result(:,12)=Result(:,11);  %area
    Result(:,10)=Result(:,6);   %fluomed
    Result(:,11)=Result(:,5);   %fluomean
    Result(:,14)=i;
    Results = [Results;Result];
end
%%
ana=0;
if length(allresults)>1
    ana = input([num2str(length(allresults)), ' replicates found,',...
        'take all data or just one? (0 for all): ']);
end

DataPlots(Results,name,path,length(allresults));

