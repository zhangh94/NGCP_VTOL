function [ aircraft ] = GrabData(filename)
%GRABDATA Function to import and obtain design data from DesignData.csv
%   Inputs
%       filename - relative path to DesignData.csv
% 
%   Outputs
%       aircraft - struct containing imported design data

fid = fopen(filename);
if (fid <= 0 ); error('Error: Filename input does not exist for GrabData'); end

% scan text line by line
rawData = textscan(fid,'%s','Delimiter','\n');
rawData = rawData{1};

% separate by comma
splitData = regexp(rawData,'\t','split');

% store all valid entries
for i1 = 2:length(splitData)
    if (length(splitData{i1}) > 1 && ~isempty(splitData{i1}{2}))
       aircraft.(strtrim(splitData{i1}{1})) =  str2double(splitData{i1}{2});
    end
end
fclose(fid);
end

