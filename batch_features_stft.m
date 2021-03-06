function [FEATURES,F,T,PARAMETERS]=batch_features_stft(DATA,FS,varargin)

% typecast

if ~isa(DATA,'double')
	DATA=double(DATA);
end

len=20;
overlap=18;
padding=[.2 .2];

nparams=length(varargin);

if mod(nparams,2)>0
	error('ephysPipeline:argChk','Parameters must be specified as parameter/value pairs!');
end

for i=1:2:nparams
	switch lower(varargin{i})
		case 'padding'
			padding=varargin{i+1};
		case 'len'
			len=varargin{i+1};
		case 'overlap'
			overlap=varargin{i+1};
	end
end

len=round((len/1e3)*FS);
overlap=round((overlap/1e3)*FS);
nfft=2^nextpow2(len);
padding=round(padding*FS);

[nsamples,ntrials]=size(DATA(padding(1):end-padding(2),:));

% get the time and frequency vectors

[T,F]=zftftb_specgram_dim(nsamples,len,overlap,nfft,FS);

FEATURES=zeros(length(F),length(T),ntrials,'single');

fprintf('\n');
for i=1:ntrials
	fprintf('Trials %i of %i\r',i,ntrials)
	FEATURES(:,:,i)=single(spectrogram(DATA(padding(1):end-padding(2),i),len,overlap,nfft));
end

PARAMETERS.win_size=len;
PARAMETERS.win_nfft=nfft;
PARAMETERS.win_overlap=overlap;
PARAMETERS.padding=padding;
PARAMETERS.fs=FS;
