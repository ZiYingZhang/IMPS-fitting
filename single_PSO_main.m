%%%%%%%%%%%%%
% This file was created by Zhang ZiYing. 
% If you have any questions, please send an email to alexander.zzy@foxmail.com.
% Any suggestions are welcome.
%%%%%%%%%%%%%
clear;clc;close all
fold_path = '\';% Your data storage path
data_files = dir(fullfile(fold_path,'0.66V_IMPS_data.txt'));
file_name = data_files.name;

tic

A0 = [33.758,437.42,5.03152014318634e-07,4.03924701218289e-06,2.73672744231602e-06,0.00172632348798512,166.834769555937,-8.27342249198379e1;
    31.4860000002957,471.278100000000,5.32031520701958e-07,4.17621969352889e-06,3.44185203191925e-06,0.00189266718599826,166.997048969864,-9.14935098941795e1];
LB = [31.486 408.1066 1.12e-8 1.01e-8 1.01e-8 0.01e-9 162 -200]; % lower boundary
UB = [36.372 471.2781 1.01e-4 1.01e-4 1.05e-4 7.50e-0 167 -3]; % upper boundary
gain = 1e8;


myopt = optimoptions('particleswarm','PlotFcn','pswplotbestf','InitialSwarm',A0,'SwarmSize',150,'StallIterLimit',60);
a = particleswarm(@single_PSO_obj,8,LB,UB,myopt);

%% plotting
Data = load(fullfile(fold_path,file_name));

start = 1;
f_fitting = Data(start:end,1); 
J_real_ex = Data(start:end,2);
J_im_ex = Data(start:end,3);

k1 = a(1);    
k2 = a(2);         
C_SC = a(3);     
C_H = a(4);      
C_ss = a(5);
tss = a(6);
R = a(7);
I0 = a(8);
C = (C_SC*C_H/(C_SC+C_H));
f_fit_max = (R*C)^(-1)/2/pi;
f_fit_min = (k1+k2)/2/pi;
yita = k1/(k1+k2);
yita_iv = 1/yita;
I_cross = I0/gain*C_H/(C_SC+C_H);
I_fit_min = I0/gain*yita;
MS_CSC = 1/C_SC^2;
MS_C = 1/C^2;
data_Jre = Data(:,2);
min(data_Jre); 

asolution = a;
asolution(8) = asolution(8)/gain;
a_data = asolution;
a_data(9:17) = [C f_fit_max f_fit_min yita yita_iv I_cross I_fit_min MS_CSC MS_C];

J_fit =  I0/gain*(k1+1i.*(2*pi*f_fitting).*((C_SC*C_H/(C_SC+C_H))/C_SC))./((k1+k2+1i*(2*pi*f_fitting)).*(1+1i*(2*pi*f_fitting)*(R*(C_SC*C_H/(C_SC+C_H))))+(C_ss/(C_SC+C_H)).*(1i*(2*pi*f_fitting)./(1+1i*(2*pi*f_fitting).*tss)).*(1+R*C_H*(k1+1i*(2*pi*f_fitting))));
J_real_fit = real(J_fit);
J_im_fit = imag(J_fit);

%%%%%%%%%%%%%%%%%%%
figure(2)
subplot(2,2,[1,3]);
plot(J_real_fit,J_im_fit,'-o','linewidth',4);
hold on
plot(J_real_ex,J_im_ex,'o','linewidth',0.1);
grid on
% legend('Fitting Data','Experiment Data','FontSize',8) 

set(gca,'YDir','reverse');
set(gca,'FontSize',12,'Fontname','Times New Roman');
xlabel('H''','FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
ylabel('H''''','FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')

subplot(2,2,2);
semilogx(f_fitting,J_real_ex,'ro','linewidth',2)
hold on
semilogx(f_fitting,J_real_fit,'r-','linewidth',2)
set(gca,'FontSize',12,'Fontname','Times New Roman');
xlabel('Frequency/Hz','FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
ylabel('H''', 'FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
grid on
% legend('Experiment Data:H''','Fitting Data:H''','FontSize',6,'Location','southwest') 


subplot(2,2,4);
semilogx(f_fitting,J_im_ex,'bo','linewidth',2)
hold on
semilogx(f_fitting,J_im_fit,'b-','linewidth',2)
set(gca,'FontSize',12,'Fontname','Times New Roman');
xlabel('Frequency/Hz','FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
ylabel('H''''', 'FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
grid on
% legend('Experiment Data:H''''','Fitting Data:H''''','FontSize',6,'Location','southwest') 
saveas(gcf,strcat(file_name,'_1.tiff'))

%%%%%%%%%%%%%%%%%%%
figure(3)
% fitting 
f = logspace(5,-3,129);
J_fullfit =  I0/gain*(k1+1i.*(2*pi*f).*((C_SC*C_H/(C_SC+C_H))/C_SC))./((k1+k2+1i*(2*pi*f)).*(1+1i*(2*pi*f)*(R*(C_SC*C_H/(C_SC+C_H))))+(C_ss/(C_SC+C_H)).*(1i*(2*pi*f)./(1+1i*(2*pi*f).*tss)).*(1+R*C_H*(k1+1i*(2*pi*f))));
J_real_fullfit = real(J_fullfit);
J_im_fullfit = imag(J_fullfit);

f_full_ex = Data(:,1); 
J_real_fullex = Data(:,2);
J_im_fullex = Data(:,3);
subplot(1,2,1);
plot(J_real_fullfit,J_im_fullfit,'-','linewidth',4);
hold on
plot(J_real_fullex,J_im_fullex,'o','linewidth',0.1);
grid on
% legend('Fitting Data','Experiment Data','FontSize',8) 
xlabel('Re(j(w)/I_0)')
ylabel('Im(j(w)/I_0)')

set(gca,'YDir','reverse');
set(gca,'FontSize',12,'Fontname','Times New Roman');
xlabel('H''','FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
ylabel('H''''','FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')

subplot(1,2,2);
semilogx(f_full_ex,J_real_fullex,'ro','linewidth',2)
hold on
semilogx(f_full_ex,J_im_fullex,'bo','linewidth',2)
semilogx(f,J_real_fullfit,'r-','linewidth',2)
semilogx(f,J_im_fullfit,'b-','linewidth',2)
grid on
legend('Experiment Data:H''','Experiment Data:H''''','Fitting Data:H''','Fitting Data:H''''','FontSize',6,'Location','southwest') 

set(gca,'FontSize',12,'Fontname','Times New Roman');
xlabel('Frequency/Hz','FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
ylabel('Transfer Function', 'FontSize',12,'FontWeight','bold','Color','k','FontName','Times New Roman ')
saveas(gcf,strcat(file_name,'_2.tiff'))
toc