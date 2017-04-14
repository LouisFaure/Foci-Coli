clearvars; close all;
allresults = rdir('/Users/Anthony/Desktop/Louis/Microscope/**/*.csv');
Results=[];
for i = [4 8:19]
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

AllArea(Results);