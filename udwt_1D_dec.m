%
% UDWR undecimated wavelet decomposition
%
% [H, V, D, L] = udwt(X,NLIV,FILTER_TYPE,LINEARPHASE_TYPE)
%
% X = input image
% NLIV = level of decomposition
% FILTER_TYPE = wavelet filter type
% LINEARPHASE_TYPE = linear phase flag
%
% H, V, D, [L]= horizontal, diagonal, diagonal [lowpass] wavelets
% coefficients [and approximation]
%
function [H L] = udwt_1D_dec(x,nliv,FILTER_TYPE,LINEARPHASE_FLAG)

DISPLAY_FLAG = 1;

%
% Inizializzazioni
%
[M N] = size(x);			% Dimensioni immagini
%
[Lo_D,Hi_D] = wfilters(FILTER_TYPE,'d');
Lo_D = Lo_D/sqrt(2);
Hi_D = Hi_D/sqrt(2);
[Lo_R,Hi_R] = wfilters(FILTER_TYPE,'r');   % FILTRI di RICOSTRUZIONE
Lo_R = Lo_R/sqrt(2);
Hi_R = Hi_R/sqrt(2);

% calcolo filtro equivalente

for liv = 1:nliv
    lp_eq = 1;
    lp_eq_r = 1;
    for k = 0:liv-2
       lp_eq = conv(Lo_D, upsamp2(lp_eq, 2));
       lp_eq_r = conv(Lo_R, upsamp2(lp_eq_r,2)); %%% NUOVO %%%
    end
    lp_filt = conv(lp_eq, upsamp2(Lo_D, 2^(liv-1)));
    hp_filt = conv(lp_eq, upsamp2(Hi_D, 2^(liv-1)));
    lp_filt_r = conv(lp_eq_r, upsamp2(Lo_R,2^(liv-1)));
    hp_filt_r = conv(lp_eq_r, upsamp2(Hi_R,2^(liv-1)));
    Nlp = size(lp_filt,2);
    Nhp = size(hp_filt,2);
    Nlpr = size(lp_filt_r,2);
    Nhpr = size(hp_filt_r,2);

    [maxlp,delay_lowpass] = max(abs(lp_filt));
    [maxlp,delay_highpass] = max(abs(hp_filt));
    delay_lowpass = delay_lowpass - 1;
    delay_highpass = delay_highpass - 1;
    delay_lowpass = Nlpr/2 - 1
    delay_highpass = Nhpr/2 - 1
    
end
if DISPLAY_FLAG == 1
    figure(1)
    stem(lp_filt)
    pause
    stem(hp_filt)
    pause
    [Hl W] = freqz(lp_filt,1,512);
    plot(W,abs(Hl))
    pause
    [Hh W] = freqz(hp_filt,1,512);
    plot(W,abs(Hh))
    pause
end

% decomposizione wavelet

H = filtro1dsprt(x, hp_filt, delay_highpass, LINEARPHASE_FLAG, 0);
if nargout == 2
    L = filtro1dsprt(x, lp_filt, delay_lowpass, LINEARPHASE_FLAG, 0);
end


return