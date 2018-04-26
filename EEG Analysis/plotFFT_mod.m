function [xlabs,output] = plotFFT_mod(data,sr,varargin)
% function plotFFT(data,sr,varargin)
%
% FFTs data over the first dimension and plots the absolute value of the
% Fourier coefficients.  For calculating a steady-state response across 
% trials, use plotSSR.m instead. Alternatively, you can plot the power 
% spectrum (which should not include stationary signals like an SSR) using
% use plotPowerSpec.m
%
% Required Arguments
%   data - time by channel data array
%   sr - sampling rate
% 
% Optional Arguments:
%   frange - the frequency range to plot. [0 50]
%   badchans - bad channels to zero out. [ ]
%   avgchans - flag to average the Fourier coefficient's magnitudes across 
%              channels. DEFAULT=0
%   linestyle - linestyle options eg 'b--'
%
% Version History:
%   1.0 - Written by Cort Horton 
%   1.1 - Updated all FFT and spectra code to be valid. Oops. 7/16/13 

if nargin < 2; error('Insufficient arguments'); end;
if ndims(data) > 2; error('ndims(data) > 2. Use plotSSR or plotPowerSpectrum instead'); end;

% Parse inputs;
[~,badchans,frange,avgchans,linestyle,snr,snrwidth] = ...
    parsevar(varargin,'badchans',[],'frange',[0 50],'avgchans',0,'linestyle',[],'snr',0,'snrwidth',0);

data=ndetrend(data);

nsamps=size(data,1);
tlength=nsamps/sr;
df=1/tlength;
xlabs=(1/tlength:1/tlength:frange(2));
nbins=length(xlabs);

fcoefs=fft(data)/nsamps;
fcoefs=2*abs(fcoefs((1:nbins)+1,:,:));
fcoefs(:,badchans,:)=0;
output = fcoefs;

if avgchans; fcoefs=mean(fcoefs,2); end;

if snr
    if frange(1)<snrwidth+df; frange(1)=snrwidth+df; end;
    snrs=nan(size(fcoefs));
    
    % Calculate SNR over frange
    for bin=round(tlength*frange(1)):round(tlength*frange(2))-round(snrwidth*tlength)
        snrs(bin,:)=fcoefs(bin,:)./mean(fcoefs([bin-round(snrwidth*tlength):bin-1 bin+1:bin+round(snrwidth*tlength)],:));
    end
    output = snrs;
end
end

% if isempty(linestyle)
%     cortplotx(xlabs,fcoefs);
% else
%     cortplotx(xlabs,fcoefs,linestyle);
% end

% xlim(frange);
% xlabel('Frequency (Hz)','fontsize',14);
% ylabel('Amplitude (\muV)','fontsize',14);
% title('Fourier Transform','fontsize',18);