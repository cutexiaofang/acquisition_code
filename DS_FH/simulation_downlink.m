clc;
clear all;
close all;
%%%% System Parameters  (put the parameters of the system here)
N  = 2500;     %%% chip period (# of chips to repeat itself)
Nh = 55;      %%% Frequnence of hopping code to repeat itself
Fc = 10e6;      %%% chip rate
Fb = 4000;       %%% Bit rate
Fh = 20000;     %%% hopping rate (#of hops per second)
Fdmax = 70e3;   %%% doppler range [-70kHz~70kHz]
Fs  = 110e6;     %%% signal sampling rate
Fo = 70e6;      %%% freqence of IF signal
NumFhFreq = 128;%%% FhFreq number
FhFreq_inteval = 40e3;%%% FhFreq range [0~5.08MHZ]
SysParameter.N = N;
SysParameter.Nh = Nh;
SysParameter.Fb = Fb;
SysParameter.Fc = Fc;
SysParameter.Fh = Fh;
SysParameter.Fs = Fs;
SysParameter.Fo = Fo;
SysParameter.Tc = 1/Fc;
SysParameter.Tb = 1/Fb;
SysParameter.Fdmax = Fdmax;
SysParameter.NumFhFreq = NumFhFreq;
SysParameter.FhFreq_inteval = FhFreq_inteval;

%%%test
FsTc = SysParameter.Fs*SysParameter.Tc;   %%% #of samples per chip
FsTb = SysParameter.Fs*SysParameter.Tb;   %%% #of samples per bit
Fd = rand(1)*SysParameter.Fdmax*2 - SysParameter.Fdmax;  
Tau = floor(1000*rand(1)*FsTc);  
SigLen = 100*FsTb;
Sig = DSFH_downlink(SysParameter,Fd,Tau,SigLen);
