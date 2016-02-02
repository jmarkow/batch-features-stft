function batch_features_stft_all()
%
%
%
%




[options,dirs]=batch_features_preflight;

% gather dates, copy only mic data (stitch too?)

listing=robofinch_dir_recurse(pwd,'*.mat');

%

for i=1:length(listing)

  [pathname,filename,ext]=fileparts(listing(i).name);

  % storefile

  savefile=fullfile(pathname,'stft_features.mat');

  vars=whos('-file',listing(i).name);
	varnames={vars(:).name};

  if ~strcmp(varnames,'agg_audio')
    warning('%s did not contain variable agg_audio',listing(i).name);
    continue;
  end

  load(listing(i).name,'agg_audio');

  [stft.mat,stft.f,stft.t,stft.parameters]=batch_features_stft(agg_audio.data,agg_audio.fs);

end
