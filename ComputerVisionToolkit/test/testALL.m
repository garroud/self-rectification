
s = RandStream('mt19937ar','Seed',2);
RandStream.setGlobalStream(s);

close all
clear functions

CVT = fileparts(pwd);

testTWO
testREG
testMULTI
testCARVE
testIMG

% find called mfiles
mfiles = inmem('-completenames');
called ={};

% select the ones in home dir
for i =1:size(mfiles,1)
    if  ~isempty(findstr(mfiles{i}, CVT))
        %disp(mfiles{i});
        called = [called ; mfiles{i}];
    end
end

all  = getAllFiles(CVT,{'m'});

disp('These m-files are not covered by test')
setdiff(all, called)
