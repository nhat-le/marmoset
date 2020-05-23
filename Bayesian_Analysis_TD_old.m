%% Bayesian Analysis TD
clear all
LongTrialThreshold = 150; ShortTrialThreshold = 0; SequenceLengthThreshold = 0;
LSd = []; LSrt = []; LLd = []; LLrt = []; SSd = []; SSrt = []; SLd = []; SLrt = [];
%% Naive %%
DataC = {'C521_2019.json','C522_2019.json','C523_2019.json','C524_2019.json','C529_2019.json','C530_2019.json','C603_2019.json',...
    'C604_2019.json','C605_2019.json','C606_2019.json','C607_2019.json','C610_2019.json','C611_2019.json','C612_2019.json','C613_2019.json','C614_2019.json','C618_2019.json',...
    'C620_2019.json','C621_2019.json','C624_2019.json','C625_2019.json','C626_2019.json','C627_2019.json','C701_2019.json','C702_2019.json' ...
    ,'C705_2019.json','C708_2019.json','C709_2019.json','C710_2019.json','C712_2019.json','C715_2019.json','C716_2019.json'};
DataB = {'B521_2019.json','B522_2019.json','B523_2019.json','B524_2019.json','B529_2019.json','B530_2019.json','B603_2019.json',...
    'B604_2019.json','B605_2019.json','B606_2019.json','B607_2019.json','B610_2019.json','B611_2019.json','B612_2019.json','B613_2019.json','B614_2019.json','B618_2019.json',...
    'B620_2019.json','B621_2019.json','B624_2019.json','B625_2019.json','B626_2019.json','B627_2019.json','B701_2019.json','B702_2019.json' ...
    ,'B705_2019.json','B708_2019.json','B709_2019.json','B710_2019.json','B712_2019.json','B715_2019.json','B716_2019.json'};
%% Expert %%
% DataC = {'C717_2019.json','C718_2019.json','C725_2019.json' ...
%     ,'C726_2019.json','C729_2019.json','C730_2019.json','C813_2019.json','C815_2019.json','C816_2019.json','C827.json','C828.json','C829.json','C830.json','C904.json','C905.json'...
%     ,'C906.json','C909.json','C910.json','C911.json','C912.json','C913.json','C917.json','C918.json','C919.json','C920.json','C1118.json','C1119.json','C1120.json','C1121.json','C1122.json' ... 
%     ,'C1125.json','C1126.json','C1127.json','C1210.json','C1211.json','C1212.json','C1213.json','C1216.json','C1217.json','C1218.json','C114.json','C115.json','C116.json','C117.json','C121.json','C122.json','C123.json'};
% DataB = {'B717_2019.json','B718_2019.json','B725_2019.json' ...
%     ,'B726_2019.json','B729_2019.json','B730_2019.json','B813_2019.json','B815_2019.json','B816_2019.json','B827.json','B828.json','B829.json','B830.json','B904.json','B905.json' ... 
%     ,'B906.json','B909.json','B910.json','B911.json','B912.json','B913.json','B917.json','B918.json','B919.json','B920.json','B1118.json','B1119.json','B1120.json','B1121.json','B1122.json' ...
%     ,'B1125.json','B1126.json','B1127.json','B1210.json','B1211.json','B1212.json','B1213.json','B1216.json','B1217.json','B1218.json','B114.json','B115.json','B116.json','B117.json','B121.json','B122.json','B123.json'};
%% ExpertE %%
% DataC = {'C717_2019.json','C718_2019.json','C725_2019.json' ...
%     ,'C726_2019.json','C729_2019.json','C730_2019.json','C813_2019.json','C815_2019.json','C816_2019.json','C827.json','C828.json','C829.json','C830.json','C904.json','C905.json'...
%     ,'C906.json','C909.json','C910.json','C911.json','C912.json','C913.json','C917.json','C918.json','C919.json','C920.json','C1118.json','C1119.json','C1120.json','C1121.json','C1122.json' ... 
%     ,'C1125.json','C1126.json','C1127.json','C1210.json','C1211.json','C1212.json'};
% DataB = {'B717_2019.json','B718_2019.json','B725_2019.json' ...
%     ,'B726_2019.json','B729_2019.json','B730_2019.json','B813_2019.json','B815_2019.json','B816_2019.json','B827.json','B828.json','B829.json','B830.json','B904.json','B905.json' ... 
%     ,'B906.json','B909.json','B910.json','B911.json','B912.json','B913.json','B917.json','B918.json','B919.json','B920.json','B1118.json','B1119.json','B1120.json','B1121.json','B1122.json' ...
%     ,'B1125.json','B1126.json','B1127.json','B1210.json','B1211.json','B1212.json'};
% DataC = {'C827.json','C828.json','C829.json','C830.json','C904.json','C905.json'...
%     ,'C906.json','C909.json','C910.json','C911.json','C912.json','C913.json','C917.json','C918.json','C919.json','C920.json','C1118.json','C1119.json','C1120.json','C1121.json','C1122.json' ... 
%     ,'C1125.json','C1126.json','C1127.json','C1210.json','C1211.json'};
% DataB = {'B827.json','B828.json','B829.json','B830.json','B904.json','B905.json' ... 
%     ,'B906.json','B909.json','B910.json','B911.json','B912.json','B913.json','B917.json','B918.json','B919.json','B920.json','B1118.json','B1119.json','B1120.json','B1121.json','B1122.json' ...
%     ,'B1125.json','B1126.json','B1127.json','B1210.json','B1211.json'};
%% ExpertL %%
% DataC = {'C1212.json','C1213.json','C1216.json','C1217.json','C1218.json','C114.json','C115.json','C116.json','C117.json','C121.json','C122.json','C123.json'};
% DataB = {'B1212.json','B1213.json','B1216.json','B1217.json','B1218.json','B114.json','B115.json','B116.json','B117.json','B121.json','B122.json','B123.json'};


% DataC = {'C521_2019.json','C522_2019.json','C523_2019.json','C524_2019.json','C529_2019.json','C530_2019.json','C603_2019.json',...
%     'C604_2019.json','C605_2019.json','C606_2019.json','C607_2019.json','C610_2019.json','C611_2019.json','C612_2019.json','C613_2019.json','C614_2019.json','C618_2019.json',...
%     'C620_2019.json','C621_2019.json','C624_2019.json','C625_2019.json','C626_2019.json','C627_2019.json','C701_2019.json','C702_2019.json' ...
%     ,'C705_2019.json','C708_2019.json','C709_2019.json','C710_2019.json','C712_2019.json','C715_2019.json','C716_2019.json','C717_2019.json','C718_2019.json','C725_2019.json' ...
%     ,'C726_2019.json','C729_2019.json','C730_2019.json','C813_2019.json','C815_2019.json','C816_2019.json','C827.json','C828.json','C829.json','C830.json','C904.json','C905.json'...
%     ,'C906.json','C909.json','C910.json','C911.json','C912.json','C913.json','C917.json','C918.json','C919.json','C920.json','C1118.json','C1119.json','C1120.json','C1121.json','C1122.json' ... 
%     ,'C1125.json','C1126.json','C1127.json','C1210.json','C1211.json','C1212.json','C1213.json','C1216.json','C1217.json','C1218.json','C114.json','C115.json','C116.json','C117.json','C121.json','C122.json','C123.json'};
% DataB = {'B521_2019.json','B522_2019.json','B523_2019.json','B524_2019.json','B529_2019.json','B530_2019.json','B603_2019.json',...
%     'B604_2019.json','B605_2019.json','B606_2019.json','B607_2019.json','B610_2019.json','B611_2019.json','B612_2019.json','B613_2019.json','B614_2019.json','B618_2019.json',...
%     'B620_2019.json','B621_2019.json','B624_2019.json','B625_2019.json','B626_2019.json','B627_2019.json','B701_2019.json','B702_2019.json' ...
%     ,'B705_2019.json','B708_2019.json','B709_2019.json','B710_2019.json','B712_2019.json','B715_2019.json','B716_2019.json','B717_2019.json','B718_2019.json','B725_2019.json' ...
%     ,'B726_2019.json','B729_2019.json','B730_2019.json','B813_2019.json','B815_2019.json','B816_2019.json','B827.json','B828.json','B829.json','B830.json','B904.json','B905.json' ... 
%     ,'B906.json','B909.json','B910.json','B911.json','B912.json','B913.json','B917.json','B918.json','B919.json','B920.json','B1118.json','B1119.json','B1120.json','B1121.json','B1122.json' ...
%     ,'B1125.json','B1126.json','B1127.json','B1210.json','B1211.json','B1212.json','B1213.json','B1216.json','B1217.json','B1218.json','B114.json','B115.json','B116.json','B117.json','B121.json','B122.json','B123.json'};

Allp = []; Allc = []; Allz = []; AllhrRT = [];

RTmax = 1.1; RTmin = 0.01; % C: 0.1 - 1.1 % B:0 - 1.2
Durmax = 4; Durmin = .5;

monkey = 1; bin = 1; iti = 14; 

for i = 1:length(DataC)-(bin-1)
%     i = 22;
for l = 1:1
if bin == 3
    if monkey == 0
 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});
 [SS3,LS3,LL3,LLd3,SSd3,LSd3,SL3,SLd3,iti3,OrderedTrialDur3,OrderedAllTrialsRT3,d3,rt3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+2});

Alld = [d1 d2 d3];
Allrt = [rt1 rt2 rt3];
    elseif monkey == 1
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});
 [SSb3,LSb3,LLb3,LLdb3,SSdb3,LSdb3,SLb3,SLdb3,itib3,OrderedTrialDurb3,OrderedAllTrialsRTb3,db3,rtb3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+2});


Alld = [db1 db2 db3];
Allrt = [rtb1 rtb2 rtb3];
    elseif monkey == 2
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});
 [SSb3,LSb3,LLb3,LLdb3,SSdb3,LSdb3,SLb3,SLdb3,itib3,OrderedTrialDurb3,OrderedAllTrialsRTb3,db3,rtb3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+2});

 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});
 [SS3,LS3,LL3,LLd3,SSd3,LSd3,SL3,SLd3,iti3,OrderedTrialDur3,OrderedAllTrialsRT3,d3,rt3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+2});


Alld = [d1 d2 d3 db1 db2 db3];
Allrt = [rt1 rt2 rt3 rtb1 rtb2 rtb3];
    end
end
if bin == 2
        if monkey == 0
 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});


Alld = [d1 d2 ];
Allrt = [rt1 rt2 ];
        elseif monkey == 1
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});


Alld = [db1 db2 ];
Allrt = [rtb1 rtb2];
        elseif monkey == 2
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});

 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});


Alld = [d1 d2 db1 db2 ];
Allrt = [rt1 rt2 rtb1 rtb2 ];
        end
end
if bin == 1
      if monkey == 0
 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});


Alld = [d1  ];
Allrt = [rt1 ];
        elseif monkey == 1
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});

StimulusDurations = [SSdb1 LSdb1 LLdb1 SLdb1];
ReactionTimes = [SSb1 LSb1 LLb1 SLb1];
Alld = [db1 ];
Allrt = [rtb1 ];
        elseif monkey == 2
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});

 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});


Alld = [d1 db1 ];
Allrt = [rt1 rtb1];
      end
end
if bin == 4
          if monkey == 0
 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});
 [SS3,LS3,LL3,LLd3,SSd3,LSd3,SL3,SLd3,iti3,OrderedTrialDur3,OrderedAllTrialsRT3,d3,rt3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+2});
 [SS4,LS4,LL4,LLd4,SSd4,LSd4,SL4,SLd4,iti4,OrderedTrialDur4,OrderedAllTrialsRT4,d4,rt4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+3});

Alld = [d1 d2 d3 d4 ];
Allrt = [rt1 rt2 rt3 rt4 ];
elseif monkey == 1
[SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});
 [SSb3,LSb3,LLb3,LLdb3,SSdb3,LSdb3,SLb3,SLdb3,itib3,OrderedTrialDurb3,OrderedAllTrialsRTb3,db3,rtb3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+2});
 [SSb4,LSb4,LLb4,LLdb4,SSdb4,LSdb4,SLb4,SLdb4,itib4,OrderedTrialDurb4,OrderedAllTrialsRTb4,db4,rtb4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+3});

Alld = [ db1 db2 db3 db4];
Allrt = [ rtb1 rtb2 rtb3 rtb4];
elseif monkey == 2
[SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});
 [SSb3,LSb3,LLb3,LLdb3,SSdb3,LSdb3,SLb3,SLdb3,itib3,OrderedTrialDurb3,OrderedAllTrialsRTb3,db3,rtb3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+2});
 [SSb4,LSb4,LLb4,LLdb4,SSdb4,LSdb4,SLb4,SLdb4,itib4,OrderedTrialDurb4,OrderedAllTrialsRTb4,db4,rtb4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+3});

 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});
 [SS3,LS3,LL3,LLd3,SSd3,LSd3,SL3,SLd3,iti3,OrderedTrialDur3,OrderedAllTrialsRT3,d3,rt3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+2});
 [SS4,LS4,LL4,LLd4,SSd4,LSd4,SL4,SLd4,iti4,OrderedTrialDur4,OrderedAllTrialsRT4,d4,rt4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+3});


Alld = [d1 d2 d3 d4 db1 db2 db3 db4];
Allrt = [rt1 rt2 rt3 rt4 rtb1 rtb2 rtb3 rtb4];
end
end
if bin == 5
            if monkey == 0
 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});
 [SS3,LS3,LL3,LLd3,SSd3,LSd3,SL3,SLd3,iti3,OrderedTrialDur3,OrderedAllTrialsRT3,d3,rt3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+2});
 [SS4,LS4,LL4,LLd4,SSd4,LSd4,SL4,SLd4,iti4,OrderedTrialDur4,OrderedAllTrialsRT4,d4,rt4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+3});
 [SS5,LS5,LL5,LLd5,SSd5,LSd5,SL5,SLd5,iti5,OrderedTrialDur5,OrderedAllTrialsRT5,d5,rt5] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+4});


Alld = [d1 d2 d3 d4 d5 ];
Allrt = [rt1 rt2 rt3 rt4 rt5 ];
            elseif monkey == 1
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});
 [SSb3,LSb3,LLb3,LLdb3,SSdb3,LSdb3,SLb3,SLdb3,itib3,OrderedTrialDurb3,OrderedAllTrialsRTb3,db3,rtb3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+2});
 [SSb4,LSb4,LLb4,LLdb4,SSdb4,LSdb4,SLb4,SLdb4,itib4,OrderedTrialDurb4,OrderedAllTrialsRTb4,db4,rtb4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+3});
 [SSb5,LSb5,LLb5,LLdb5,SSdb5,LSdb5,SLb5,SLdb5,itib5,OrderedTrialDurb5,OrderedAllTrialsRTb5,db5,rtb5] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+4});


Alld = [db1 db2 db3 db4 db5];
Allrt = [ rtb1 rtb2 rtb3 rtb4 rtb5];
            elseif monkey == 2
 [SSb1,LSb1,LLb1,LLdb1,SSdb1,LSdb1,SLb1,SLdb1,itib1,OrderedTrialDurb1,OrderedAllTrialsRTb1,db1,rtb1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i});
 [SSb2,LSb2,LLb2,LLdb2,SSdb2,LSdb2,SLb2,SLdb2,itib2,OrderedTrialDurb2,OrderedAllTrialsRTb2,db2,rtb2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+1});
 [SSb3,LSb3,LLb3,LLdb3,SSdb3,LSdb3,SLb3,SLdb3,itib3,OrderedTrialDurb3,OrderedAllTrialsRTb3,db3,rtb3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+2});
 [SSb4,LSb4,LLb4,LLdb4,SSdb4,LSdb4,SLb4,SLdb4,itib4,OrderedTrialDurb4,OrderedAllTrialsRTb4,db4,rtb4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+3});
 [SSb5,LSb5,LLb5,LLdb5,SSdb5,LSdb5,SLb5,SLdb5,itib5,OrderedTrialDurb5,OrderedAllTrialsRTb5,db5,rtb5] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataB{i+4});

 [SS1,LS1,LL1,LLd1,SSd1,LSd1,SL1,SLd1,iti1,OrderedTrialDur1,OrderedAllTrialsRT1,d1,rt1] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i});
 [SS2,LS2,LL2,LLd2,SSd2,LSd2,SL2,SLd2,iti2,OrderedTrialDur2,OrderedAllTrialsRT2,d2,rt2] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+1});
 [SS3,LS3,LL3,LLd3,SSd3,LSd3,SL3,SLd3,iti3,OrderedTrialDur3,OrderedAllTrialsRT3,d3,rt3] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+2});
 [SS4,LS4,LL4,LLd4,SSd4,LSd4,SL4,SLd4,iti4,OrderedTrialDur4,OrderedAllTrialsRT4,d4,rt4] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+3});
 [SS5,LS5,LL5,LLd5,SSd5,LSd5,SL5,SLd5,iti5,OrderedTrialDur5,OrderedAllTrialsRT5,d5,rt5] = funcSequencesNew(LongTrialThreshold,ShortTrialThreshold,iti,SequenceLengthThreshold, DataC{i+4});

Alld = [d1 d2 d3 d4 d5 db1 db2 db3 db4 db5];
Allrt = [rt1 rt2 rt3 rt4 rt5 rtb1 rtb2 rtb3 rtb4 rtb5];
            end
end
end

for k = 1:1
idx = find(Allrt(1,:) <= 0.3);
idx1 = find(Allrt(2,:) <= 0.3);
length(idx)+length(idx1);

%%%%% Too Long or Too Short Duration Trials %%%%%
Alld1 = Alld(1,:); Alld2 = Alld(2,:);
Allrt1 = Allrt(1,:); Allrt2 = Allrt(2,:);
idx = find(Alld1 > Durmax);
Alld1(idx) = 0; Alld2(idx) = 0;
idx1 = find(Alld2 > Durmax);
Alld1(idx1) = 0; Alld2(idx1) = 0;
Allrt1(idx) = 0; Allrt1(idx1) = 0; 
Allrt2(idx) = 0; Allrt2(idx1) = 0;
Alld1(Alld1==0) = []; Alld2(Alld2==0) = []; Allrt1(Allrt1==0) = []; Allrt2(Allrt2==0) = [];
Alld = [Alld1;Alld2]; Allrt = [Allrt1;Allrt2];

Alld1 = Alld(1,:); Alld2 = Alld(2,:);
Allrt1 = Allrt(1,:); Allrt2 = Allrt(2,:);
idx = find(Alld1 < Durmin);
Alld1(idx) = 0; Alld2(idx) = 0;
idx1 = find(Alld2 < Durmin);
Alld1(idx1) = 0; Alld2(idx1) = 0;
Allrt1(idx) = 0; Allrt1(idx1) = 0; 
Allrt2(idx) = 0; Allrt2(idx1) = 0;
Alld1(Alld1==0) = []; Alld2(Alld2==0) = []; Allrt1(Allrt1==0) = []; Allrt2(Allrt2==0) = [];
Alld = [Alld1;Alld2]; Allrt = [Allrt1;Allrt2];

%%%%% Too Long or Too Short RT Trials %%%%%
Alld1 = Alld(1,:); Alld2 = Alld(2,:);
Allrt1 = Allrt(1,:); Allrt2 = Allrt(2,:);
idx = find(Allrt1 > RTmax);
Alld1(idx) = 0; Alld2(idx) = 0;
idx1 = find(Allrt2 > RTmax);
Alld1(idx1) = 0; Alld2(idx1) = 0;
Allrt1(idx) = 0; Allrt1(idx1) = 0; 
Allrt2(idx) = 0; Allrt2(idx1) = 0;
Alld1(Alld1==0) = []; Alld2(Alld2==0) = []; Allrt1(Allrt1==0) = []; Allrt2(Allrt2==0) = [];
Alld = [Alld1;Alld2]; Allrt = [Allrt1;Allrt2];

Alld1 = Alld(1,:); Alld2 = Alld(2,:);
Allrt1 = Allrt(1,:); Allrt2 = Allrt(2,:);
idx = find(Allrt1 < RTmin);
Alld1(idx) = 0; Alld2(idx) = 0;
idx1 = find(Allrt2 < RTmin);
Alld1(idx1) = 0; Alld2(idx1) = 0;
Allrt1(idx) = 0; Allrt1(idx1) = 0; 
Allrt2(idx) = 0; Allrt2(idx1) = 0;
Alld1(Alld1==0) = []; Alld2(Alld2==0) = []; Allrt1(Allrt1==0) = []; Allrt2(Allrt2==0) = [];
Alld = [Alld1;Alld2]; Allrt = [Allrt1;Allrt2];
end

end

N = size(Alld(1,:));
sd_previous = Alld(1,:);

% Mapping from reaction time to 'expected' stimulus duration 
x = Allrt(2,:); y = Alld(2,:); 
sd_expectedCurrent = zeros(N);
sd_estimatedCurrent = zeros(N);
blur = 0.15;
for i = 1:N(2)
    rt_current = x(i);
    indices = nonzeros(abs(x - rt_current) < blur);
    sd_estimated = mean(y(indices));
    %  0.5 expect + 0.5 exact = estimated
    sd_expectedCurrent(i) = 2*sd_estimated - y(i);
    sd_estimatedCurrent(i) = sd_estimated;
end

% figure;
% plot(y,sd_estimatedCurrent,'.');
% plot(y,sd_expectedCurrent,'.');
% ylabel('expected sd');
% xlabel('actual sd');
% box off
% axis tight
% axis square
% set(gca,'FontSize', 18);

% plot(sd_expectedCurrent, sd_estimatedCurrent,'.')

%% Setting up the least-squares problem
b = sd_expectedCurrent - sd_previous;
A = ones(N(2),2);
A(:,2) = 1* sd_previous;
%% Solving it
X = inv(A'*A) *A' * b';
delta_opt = X(1);
lambda_opt = X(2);
%% Deriving the parameters
alpha_opt = lambda_opt/(1-lambda_opt);
mu_0_opt = delta_opt/lambda_opt;


%% Hazard Calculation
for k = 1:1
    
global PHI
PHI = 0.26;

%% Theoretical hazard rate
pmax = 2.5;
pmin = 0.5;
nbins = 5000;
dt = 3/nbins;
t = linspace(0, 10, nbins);

% alpha = 1;

%% Obtain updated density function / updated mean for gaussian 
d = (pmax - pmin)/1000;
x = [0.5:d:2.5];
% 
staticmean = 1.5; % static prior with a mean in the middle of the intended dist (for now).
pdfC = (alpha / (1+alpha)) * staticmean; % contribution of static mean to update
PriorC = (1 / (1+alpha)) * prev; % contribution of prior to update
Updatedmu = pdfC + PriorC; % calculate new gaussian mean
sigma = 1; % set at 1 for now until I add noise to stop sigma from shrinking with more priors.
% create new pdf's from updated means of gaussians.
for i = 1:numel(Updatedmu)
Updatedmu(i)
y = normpdf(x,Updatedmu(i),sigma);
%     figure; plot(y)
end 

%% Convert y to scaled probability

% prior
% (alpha / (1+alpha))
% (1 / (1+alpha))
% variance

f = ones(1, numel(t)) * 0.5;
f(t < pmin | t > pmax) = 0;

% Hazard rate
h = 1 ./ (pmax - t);
h(t < pmin | t > pmax) = 0;

%% Subjective hazard rate
% Make a basis and convolve to get 'blurred' density
fs = zeros(1, length(t)); %subjective hazard array
for l = 1:numel(t)
    r = 1 / PHI / t(l) / sqrt(2*pi) * exp(-(t - t(l)).^2 / 2 / PHI^2 / t(l)^2);
    fs(l) = r * f' * dt;
end

% Normalize
fs = fs / (nansum(fs) * dt);

% Cumulative
fs_cum = cumsum(fs(2:end)) * dt;

%% Subjective hazard
hs = fs(2:end) ./ (1 - fs_cum);

tvals = t(2:end-1);
hsvals = hs(1:end-1);
maxhs = findpeaks(hsvals);
hsvals = hsvals ./ maxhs;

hr = interp1(tvals, hsvals, Alld(2,:));
end














