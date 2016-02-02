function OPTIONS=stan_read_options(FILENAME,varargin)
% script for reading config files/sorting for processing/chopping
% 
% takes logfile as input 
%
%
%

fid=fopen(FILENAME,'r');
readdata=textscan(fid,'%s%[^\n]','commentstyle','#','delimiter','=');
fclose(fid);

OPTIONS=struct();

for i=1:length(readdata{1})
	OPTIONS.(readdata{1}{i})=readdata{2}{i};

	% convert nums and vectors

	tmp=regexp(OPTIONS.(readdata{1}{i}),'^[0-9;.:]+$','match');
	tmp2=regexp(OPTIONS.(readdata{1}{i}),'^\[([0-9;.:]+|([0-9;.:]+ )+[0-9;.:]+)\]$','match');

	if ~isempty(tmp) | ~isempty(tmp2)
		OPTIONS.(readdata{1}{i})=str2num(OPTIONS.(readdata{1}{i}));
	end

end
