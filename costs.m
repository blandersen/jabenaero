clf;close all;clear;clc;
%DAPCA IV Cost Model

run parameters.m

FTA = 4; %number of flight test aircraft 2-6
We = W0*WeW0;
Q = 200; %number of aircraft to be prodced in 5 years
Tturbineinlet = 1200; %turbine inlet temperature Kelvin
Tmax = 20e3; %engine max thust, can get this from bild script
Mmax = 0.5; %max engine mach number
Neng = 4*Q;
inflation = 1.314;
Ce = 285000; %single engine cost

%wrap rates Raymer 18
R.eng = inflation*115;
R.tooling = inflation*118;
R.qc = inflation*108;
R.mfg = inflation*98;


% % % % %  


%% Production Cost

Hours.engineering = 5.18*We^(0.777)*V_cruise^(0.894)*Q^(0.163);

Hours.tooling = 7.22*We^(0.777)*V_cruise^(0.696)*Q^(0.163);

Hours.mfg = 10.5*We^(0.82)*V_cruise^(0.484)*Q^(0.641);

Hours.qc = 0.076*Hours.mfg;

Cost.develop = inflation*67.4*We^(0.630)*V_cruise^(1.3);

Cost.flttest = inflation*1947*We^(0.325)*V_cruise^(0.822)*FTA^(1.21);

Cost.materials = inflation*31.2*We^(0.921)*V_cruise^(0.621)*Q^(0.799);

% Cost.engineprod = inflation*3112*(9.66*Tmax + 243.25*Mmax + 1.74*Tturbineinlet - 2228);

Cost.engineprod = Ce*Neng;

Cost.avionics =12000*Q*W.avi;% inflation*20000;

Cost.battery = 150*1046*Q;% needs review: $150 kWhr*1046kg/hr*1hr*quantity aircraft



dapcaoverprediction = 0.9;

Cost.total = dapcaoverprediction*(Hours.engineering*R.eng + ...
             Hours.tooling*R.tooling + ...
             Hours.mfg*R.mfg + ...
             Hours.qc*R.qc + ...
             Cost.develop +...
             Cost.flttest+...
             Cost.materials+...
             Cost.engineprod+...
             Cost.avionics+...
             Cost.battery)

Y = inflation.*[Hours.engineering*R.eng, ...
             Hours.tooling*R.tooling , ...
             Hours.mfg*R.mfg, ...
             Hours.qc*R.qc,...
             Cost.develop,...
             Cost.flttest,...
             Cost.materials,...
             Cost.engineprod]./1e6;
b = barh(Y);
yticklabels({'Engineering Labor','Tooling Labor','Manufacturing Labor','Quality Control Labor','Development','Flight Test','Materials','Engines'}) 
xtips = b.YEndPoints + .001;
ytips = b.XEndPoints;
labels = cell(size(b.YData));
for i = 1:length(b.YData)
    labels{i} = sprintf('%.1f',b.YData(i));   
end
text(xtips, ytips, labels, 'VerticalAlignment', 'middle');
xlim([0,550])
xlabel('Cost [millions]')
title('RDT&E and Flyaway Costs')

fprintf('%.2f million dollars\n',Cost.total/1e6)

%% Direct Operating Cost

Ca = 8e6; %aircraft price sin engine
Nepa = 4; %engines per aircraft
flhr = 2080; %flight hours per year

matfh = inflation*(3.3*(Ca/1e6) + 14.2 + (58*(Ce/1e6)-26)*Nepa) %mat cost per flight hour

pilotcost = flhr*R.eng %raymer 18.5.2

fueldpkg = 0.8; %80 cents per kg
% fuelcost = this needs fuel burned per flight -- what the heck are we to
% do ---- use max fuel weight fraction to get ~800 km , assume full tank
% burns, fuelweight/flight time * fueldpk * annual flight time ?

nump = 5:1:200;
costperplane = Cost.total./nump;
figure(2); 
hold on;
plot(5:200,Cost.total./(5:200),'-b','LineWidth',2)
plot(200:2000,Cost.total./(200:2000),'--b','LineWidth',2)
title('Vehicle Cost vs. Production Quantity')
ylabel('USD 2023')
xlabel('Production Quantity')
set(gca, 'YScale', 'log')
grid on
set(gca,'Fontsize',14,'box','off')
legend('First 5 Years','Continued Production')
%% Profitability for a max distance flight
cost_paxkm = 0.62;
fuelcpkg = 0.82; %82cents per kg
fuelcost = fuelcpkg * W0 *WfW0







