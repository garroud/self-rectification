function fileList = getAllFiles(dirName,formats)
    % returns all files with extension listed in "formats",
    % recursing through subfolders
    
    fileList = getAllFilesRec(dirName);
    exts = regexp(fileList,'[^.]*$','match');
    exts = cat(1,exts{:});
    fileList = fileList(ismember(lower(exts),formats));
end


function fileList = getAllFilesRec(dirName)
    
    % Author: anonymous from http://stackoverflow.com
    
    dirData = dir(dirName);      %# Get the data for the current directory
    dirIndex = [dirData.isdir];  %# Find the index for directories
    fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
            fileList,'UniformOutput',false);
    end
    subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
    validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
    %#   that are not '.' or '..'
    for iDir = find(validIndex)                  %# Loop over valid subdirectories
        nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
        fileList = [fileList; getAllFilesRec(nextDir)];  %# Recursively call getAllFiles
    end
    
end
