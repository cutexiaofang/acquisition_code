%%%% simulate the DS/FH acq. performance 
%%%% System Parameters  (put the parameters of the system here)
% N  = 2500;      %%% chip period (# of chips to repeat itself)
% Nh = 55;        %%% chip period of hopping code to repeat itself
% Fc = 10e6;      %%% chip rate
% Fb = 4000;      %%% Bit rate
% Fh = 20000;     %%% hopping rate (#of hops per second)
% Fdmax = 70e3;   %%% doppler range [-70kHz~70kHz]
% Fs  = 110e6;    %%% signal sampling rate
% Fo = 70e6;      %%% freqence of IF signal
% NumFhFreq = 128;%%% FhFreq number
% FhFreq_inteval = 40e3;%%% FhFreq range [0~5.08MHZ]
% SysParameter.N = N;
% SysParameter.Fb = Fb;
% SysParameter.Fc = Fc;
% SysParameter.Fh = Fh;
% SysParameter.Fs = Fs;
% SysParameter.Fo = Fo;
% SysParameter.Tc = 1/Fc;
% SysParameter.Tb = 1/Fb;
% SysParameter.Nh = Nh;
% SysParameter.Fdmax = Fdmax;
% SysParameter.NumFhFreq = NumFhFreq;
% SysParameter.FhFreq_inteval = FhFreq_inteval;

%%%% function to generate the DS FH signal
%%% SysParameter: system parameters
%%% Fd: doppler freq.
%%% Tau: time delay
%%% SigLen: leng of the signal to be generated

function Sig = DSFH(SysParameter,Fd,Tau,SigLen)

FsTc = SysParameter.Fs*SysParameter.Tc;
FsTb = SysParameter.Fs*SysParameter.Tb;   %%% #of samples per bit
PG  = FsTb/FsTc;   %%% #of chips per bit

%%% 0. generate rand info bits
NumBits = ceil(SigLen/FsTb)+1;   %%% generate 1 more bit of signal for delay
Bit = sign(rand(1,NumBits)-0.5);   %%%uipolar to bipolar

%%% 1. generate the code sequence
DsCode = repmat(sign(rand(1,SysParameter.N)-0.5),1,NumBits);


%%% 2. generate the FH freq. need to acount for Fd for each freq hop freq.
FhFreq_index = floor(SysParameter.NumFhFreq*rand(1,SysParameter.Nh));
FhFreq_min = SysParameter.Fo-SysParameter.FhFreq_inteval/2*(SysParameter.NumFhFreq-1);
%%% number of info Bit during each time period of hopping code
Thop_Tb_ratio = SysParameter.Nh/(SysParameter.N/(SysParameter.Fc/SysParameter.Fh)); 
FhFreq_exp = repmat(FhFreq_min + FhFreq_index*SysParameter.FhFreq_inteval,1,...
       ceil(NumBits/Thop_Tb_ratio));
FhFreq = FhFreq_exp(1:NumBits*(SysParameter.N/(SysParameter.Fc/SysParameter.Fh)));


%%% 3. Spread the bits by DsCode
DSSS = DsCode.*rectpulse(Bit,PG);                              


%%% 4. Get the Sampled the DSSS code which code rate is affected by Dopppler
DSSS_sample = code_rate_shift_sample(SysParameter,Fd,DSSS); 


%%% 5. Freq hop the signal
t = 0:1/SysParameter.Fs:(length(DSSS_sample)-1)*(1/SysParameter.Fs);
FhFreq_sample =  rectpulse(FhFreq,SysParameter.Fs/SysParameter.Fh);
Sig = DSSS_sample.*cos(2*pi*(FhFreq_sample+Fd).*t);

%% 6 Delay the signal by Tau
Sig_delay = Sig(Tau+1:end);

end