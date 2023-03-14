clear;clc;
%DAPCA IV Cost Model

run parameters.m

FTA = 4; %number of flight test aircraft 2-6
We = W0*WeW0;
Q = 500; %number of aircraft to be prodced in 5 years
Tturbineinlet = 1200; %turbine inlet temperature Kelvin
Tmax = 20e3; %engine max thust
Mmax = 0.5; %max engine mach number

% % % % %  

%% Production Cost

Hours.engineering = 5.18*We^(0.777)*V_cruise^(0.894)*Q^(0.163);

Hours.tooling = 7.22*We^(0.777)*V_cruise^(0.696)*Q^(0.163);

Hours.mfg = 10.5*We^(0.82)*V_cruise^(0.484)*Q^(0.641);

Hours.qc = 0.076;

Cost.develop = 67.4*We^(0.630)*V_cruise^(1.3);

Cost.flttest = 1947*We^(0.325)*V_cruise^(0.822)*FTA^(1.21);

Cost.materials = 31.2*We^(0.921)*V_cruise^(0.621)*Q^(0.799);

Cost.engineprod = 3112*(9.66*Tmax + 243.25*Mmax + 1.74*Tturbineinlet - 2228);

Cost.avionics = 10000;

inflation = 1.314;

R.eng = 115;
R.tooling = 118;
R.qc = 108;
R.mfg = 98;


Cost.total = inflation*(Hours.engineering*R.eng + ...
             Hours.tooling*R.tooling + ...
             Hours.mfg*R.mfg + ...
             Hours.qc*R.qc + ...
             Cost.develop +...
             Cost.flttest+...
             Cost.materials+...
             Cost.engineprod*4+...
             Cost.avionics)

%% Direct Operating Cost

Ca = Cost.total - Cost.engineprod
Ce = Cost.engineprod




