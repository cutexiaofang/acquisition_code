%%% This function is to 
function [rate_shift_sample] = code_rate_shift_sample(SysParameter,fd,code)
code_exp = [code,code];
FsTc = SysParameter.Fs*SysParameter.Tc;                                    %#of samples per chip
N = length(code)*FsTc;                                                     %number of sample
Ts = 1/SysParameter.Fs;                                                    %sample interval
rate_shift = SysParameter.Fc + fd/(SysParameter.Fo/SysParameter.Fc);                   %rate after chip rate shift
T_rate_shift = 1/rate_shift;                                               %time width of chip after chip rate shift
for n = 0:N-1
    chip_shift_index = floor(Ts*n/T_rate_shift);
    rate_shift_sample(n+1) = code_exp(chip_shift_index+1);
end

