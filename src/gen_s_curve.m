clc; clearvars; close all;

global options go_backwards;

% RUN INITIALIZATION SCRIPTS
% INITIALIZE CANTERA
% run('/Users/gpavanb/Ihme_Research/BR_Control/auto_cantera/lib/cantera/matlab/toolbox/ctpath.m');
% INITIALIZE MATCONT
run('/Users/gpavanb/Ihme_Research/BR_Control/S_Curve/matcont/init.m');

% ADD PATHS
addpath('../include/');

% SET S-CURVE DIRECTION
go_backwards = 0;

% SET START MASS FLOW - MASS FRACTIONS ARE SET TO ADIABATIC FLAME
% COMPOSITION
start_mdot = 5e-3;

%% CODE STARTS HERE 

% INITIALIZE PSR SYSTEM
options = Options('../data/ch4.yml');
[args,seed] = initialize_reactor;
n_sp = length(seed);

% LOAD DUMP IF REQUIRED
dump = [];
if (exist('dump.mat','File'))
    load('dump.mat');
    seed = dump(1:end-1,end);
    start_mdot = dump(end,end);
end

% RUN MATCONT
p=[start_mdot,args];ap1=[1];
[x0,v0]=init_EP_EP(@rhs,seed,p,ap1);
opt=contset;
opt=contset(opt,'VarTolerance',1e-3);
opt=contset(opt,'FunTolerance',1e-3);
opt=contset(opt,'InitStepSize',10);
opt=contset(opt,'MinStepSize',1e-1);
opt=contset(opt,'MaxStepSize',100);
opt=contset(opt,'MaxNumPoints',100);
opt=contset(opt,'Singularities',1);
opt=contset(opt,'Backward',go_backwards);
opt=contset(opt,'TSearchOrder',0);
[x,v,s,h,f]=cont(@equilibrium,x0,[],opt);

% DUMP LAST SOLUTION
dump = [dump,x];
save('dump.mat','dump');

%% PLOT S-CURVE
semilogx(dump(n_sp+1,:),dump(n_sp,:),'-o','LineWidth',2);
hold on;
set(gcf,'Position',[100 100 1000 850],'Color',[1 1 1]);
set(gca,'FontSize',40,'FontName','Times New Roman');
title('S-Curve');
xlabel('$\dot{m}$ $(Kg/s)$','Interpreter','Latex');
ylabel('T (K)');