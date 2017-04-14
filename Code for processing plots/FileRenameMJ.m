cd(uigetdir);delete('*thumb*');delete('*.nd');
TRANS=dir('*TRANS*'); RFP=dir('*RFP*'); YFP=dir('*YFP*');
string = input('Name? ','s');
mkdir('02');cd('02');mkdir(string);cd(string);
mkdir('TRANS');mkdir('RFP');mkdir('YFP');cd('..');cd('..');
%%
for i =1:length(TRANS)
    movefile(TRANS(i).name,['02/' string '/TRANS/' string ...
        '_100ms_TRANS_100X_' num2str(i) '.TIFF']);
    movefile(RFP(i).name,['02/' string '/RFP/' string ...
        '_2s_RFP_100X_' num2str(i) '.TIFF']);
    movefile(YFP(i).name,['02/' string '/YFP/' string ...
        '_2s_YFP_100X_' num2str(i) '.TIFF']);
end