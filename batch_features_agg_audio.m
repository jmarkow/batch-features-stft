function batch_features_stft()
% copies audio data from nervecut birds, finds last suitable pre and earliest suitable post
%


% get options

[options,dirs]=batch_features_preflight;

% gather dates, copy only mic data (stitch too?)
%

listing=robofinch_dir_recurse(pwd,'aggregated_data.mat');

if isempty(listing)
	return;
end

tmp=regexp(listing(1).name,'((\d+-)+\d+)','match');
date_number=datenum(tmp);
tmp=regexp(listing(1).name,filesep,'split');
birdid=tmp{end-7};

storedir=fullfile(dirs.agg_dir,dirs.stft_dir,[ birdid '_' datestr(date_number,'yyyy-mm-dd') ]);

if ~exist(storedir,'dir')
	mkdir(storedir);
end

agg_audio.data=[];
agg_audio.fs=25e3;
agg_audio.date=date_number;

for i=1:length(listing)
	disp([listing(i).name]);
	vars=whos('-file',listing(i).name);
	varnames={vars(:).name};
	if ~strcmp(varnames,'MIC_DATA')
  	tmp=load(listing(i).name,'agg_audio');
		agg_audio.fs=tmp.agg_audio.fs;
		agg_audio.data=[ agg_audio.data tmp.agg_audio.data ];
	else
		disp('Legacy...')
		load(listing(i).name,'MIC_DATA')
		agg_audio.data=[ agg_audio.data MIC_DATA ];
	end
end

save(fullfile(storedir,['mic_data.mat']),'agg_audio','-v7.3');
