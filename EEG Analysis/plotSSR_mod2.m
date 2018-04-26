function [xlabs, output] = plotSSR_mod(data,sr,varargin)
% function plotSSR(data,sr,varargin)
%
% Plots a Fourier transform of signals that are stationary across trials.
% This assumes that the signals' phases are consistent across trials. It
% can be calcultaed by FFTing the data and averaging the complex Fourier
% coefficients across trials, or alternatively by averaging across trials
% in the time domain, then FFTing the result.
%
% Required Arguments
%   data - time by channel by trial data array
%   sr - sampling rate
%
% Optional Arguments:
%   frange - the frequency range to plot. [0 50]
%   badchans - bad channels to zero out. [ ]
%   avgchans - flag to average the SSR across channels. Note this average is
%              not sensitive to phase differences between channels. DEFAULT=0
%   linestyle - linestyle options eg 'b--'
%   snr - instead of plotting the amplitude of each fourier coefficient,
%          setting the snr flag to 1 plots the ratio of each coefficient to
%          the mean of surrounding bins.
%   snrwidth - the surrounding width in Hz that is used to calculate SNR.
%              The total bins used will be floor(2*width*tlength). If you
%              have multiple SSRs, snrwidth must be smaller than distance
%              in Hz between your responses. Default 2 for tlengths >= 10s,
%              or 4 for tlengths < 10s.
%   logsnr - flag to plot log10(SNR+1) instead of raw SNR
%
% Version History:
%   1.0 - Written by Cort Horton
%   1.1 - Updated all FFT and spectra code to be valid. Oops. 7/16/13

if nargin < 2; error('Insufficient arguments'); end;
if ndims(data) ~=3; error('Data array should be 3 dimensional'); end;

% Parse inputs;
[~,badchans,frange,avgchans,linestyle,snr,snrwidth,logsnr] = ...
    parsevar(varargin,'badchans',[],'frange',[0 50],'avgchans',0,...
    'linestyle',[],'snr',0,'snrwidth',0,'logsnr',0);

data=ndetrend(data);

nsamps=size(data,1);
tlength=nsamps/sr;
df=1/tlength;
xlabs=(df:df:frange(2)+ceil(snrwidth));
nbins=length(xlabs);

fcoefs=fft(data)/nsamps;
fcoefs=mean(fcoefs,3);
fcoefs=2*abs(fcoefs((1:nbins)+1,:,:));

% data=mean(data,3);
% fcoefs(:,badchans)=0;

if avgchans; fcoefs=mean(fcoefs,2); end;

if snr;
    if frange(1)<snrwidth+df; frange(1)=snrwidth+df; end;
    snrs=nan(size(fcoefs));
    
    % Calculate SNR over frange
    for bin=round(tlength*frange(1)):round(tlength*frange(2))
        snrs(bin,:)=fcoefs(bin,:)./mean(fcoefs([bin-round(snrwidth*tlength):bin-1 bin+1:bin+round(snrwidth*tlength)],:));
    end
    output = snrs;
    
    if logsnr; snrs=log10(snrs+1); output = logsnr; end;
    
    if isempty(linestyle)
%         cortplotx(xlabs,snrs);
    else
%         cortplotx(xlabs,snrs,linestyle);
    end
    
    if logsnr
%         ylabel('log10(SNR+1)','fontsize',14);
%         title('Log SNRs of Steady-State Responses','fontsize',18);
    else
%         ylabel('SNR','fontsize',14);
%         title('SNRs of Steady-State Responses','fontsize',18);
    end
else
    if isempty(linestyle)
%         cortplotx(xlabs,fcoefs);
        output = fcoefs;
    else
%         cortplotx(xlabs,fcoefs,linestyle);
    end
    
%     ylabel('SSR Amplitude (\muV)','fontsize',14);
%     title('Steady-State Responses','fontsize',18);
end
% xlim(frange);
% xlabel('Frequency (Hz)','fontsize',14);