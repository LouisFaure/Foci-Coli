cd(uigetdir);delete('*thumb*');delete('*.nd');
TRANS=dir('*TRANS*'); RFP=dir('*RFP*'); YFP=dir('*YFP*');
%string = input('Name? ','s');
%mkdir('02');cd('02');%mkdir(string);cd(string);
mkdir('TRANS');mkdir('RFP');mkdir('YFP');
name = strsplit(pwd,'/');
%%
for i = 1:length(TRANS)
    movefile(TRANS(i).name,['TRANS/' name{end} ...
        '_100ms_TRANS_100X_' num2str(i) '.TIFF']);
    movefile(YFP(i).name,['YFP/' name{end} ...
        '_2s_YFP_100X_' num2str(i) '.TIFF']);
    movefile(RFP(i).name,['RFP/' name{end} ...
        '_2s_RFP_100X_' num2str(i) '.TIFF']);
end