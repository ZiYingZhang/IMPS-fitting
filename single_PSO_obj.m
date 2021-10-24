function out = single_PSO_obj(A)
Data = load('0.66V_IMPS_data.txt');

start = 13;
freq = Data(start:end,1);
gain = 1e8;
J_real = Data(start:end,2)*gain;
J_im = Data(start:end,3)*gain;

k1 = A(1);
k2 = A(2);
C_SC = A(3);
C_H = A(4);
C_ss = A(5);
tss = A(6);
R = A(7);
I0 = A(8);

J_w = I0*(k1+1i.*(2*pi*freq).*((C_SC*C_H/(C_SC+C_H))/C_SC))./((k1+k2+1i*(2*pi*freq)).*(1+1i*(2*pi*freq)*(R*(C_SC*C_H/(C_SC+C_H))))+(C_ss/(C_SC+C_H)).*(1i*(2*pi*freq)./(1+1i*(2*pi*freq).*tss)).*(1+R*C_H*(k1+1i*(2*pi*freq))));
out = 1*sum( ((real(J_w)-J_real).^2 )./(abs(J_real)))+1*sum( (imag(J_w)-J_im).^2 ./(abs(J_im)));   
% Chi-squared
% out = sum(((real(J_w)-J_real).^2 + (imag(J_w)-J_im).^2 )./(J_real.^2+J_im.^2));  