close all;
clear;
clc;

SAVEFIGURE = false;

fig = figure

W0 = 8.3461e+03;                %kg
W0 = kg2lb(W0);
%%WEIGHTS GIVEN IN LBS%%

rho_ceil = 1.0556;               %kg/m^3, 5000 ft
V_cruise = 108.056;
q_cruise = q(rho_ceil, V_cruise)/6895;
tc = 0.15;

%Wing
W.w = kg2lb(2.0865e3);
AR = 9.2;
A = 10;
lambda = 0.4;
Wdg = kg2lb(8.34601e3);
Nz = 4.5;
Sw = 44*(3.281^2);
W.wing = 0.036*(Sw^0.758)*(W.w^0.0035)*(AR/cosd(A)^2)^.6 * q_cruise^0.006 *lambda^0.04*(100*tc/cosd(A))^(-0.3)*(Nz*Wdg)^0.49;

 
Sf = 46*pi*(6.32^2)/4 + 2*pi*(6.32^2)/4;                    %Estimate, 14 m length, modelled as cylinder
Lt = 2;                                                      %hella estimate
L = 46;

D = (1.9257 - 1.83)*3.281;                                  %fuselage depth (assuming it's thickness?)

W.fus = 0.052*(Sf^1.086)*(Nz*Wdg)^.177*Lt^(-0.051)*(L/D)^(-.072)*q_cruise^.241;





%Engine
W_engine = 235;
W_en = kg2lb(W_engine);
Ne = 2;
W.ie = 2.575*W_en^0.922*Ne; % WHAT'S THIS



%flight controls 
b = 73.25;
W.fc = .053*(L^1.536)*(b^.371)*(Nz*(Wdg*(10^-4)))^.8;

%Avionics weight
Wuav = 1100;                                     %range 800-1400 lb from book
W.avi = 2.117*Wuav^.933;

%fuel system (hella estioimate too)
Vt = 720;                                        %gal, for SkyCourier
ViVt = 1;
Nt = 3;                                          %1 per wing and in fuselage ?

W.fs = 2.49*Vt^.726*(.5^.363)*Nt^.242*Ne^.157;


%electrical
W.elec = 12.57*(W.fus + W.avi)^.51;

%seating
W.seat = 30*16;                                  % in kg, using 30kg per seat

%weights in kg
W.wing = lb2kg(W.wing);
W.fus = lb2kg(W.fus);
W.ie = lb2kg(W.ie);
W.fc = lb2kg(W.fc);
W.avi = lb2kg(W.avi);
W.fs = lb2kg(W.fs);
W.elec = lb2kg(W.elec);
W.pl = lb2kg(1.6692e+03);
W.fuel = 0.25*lb2kg(W0);


y = [W.wing, W.fus, W.ie, W.fc, W.avi, W.fus, W.elec, W.pl, W.fuel, W.seat];
Y = y/lb2kg(W0);
Y(end+1) = 1-sum(Y);
b = barh(Y);
yticklabels({'Wings', 'Fuselage', 'Installed Engines', 'Flight Controls', 'Avionics', 'Fuel Systems', 'Electrical','Payload','Fuel', 'Seating', 'Unassigned'}) 
xtips = b.YEndPoints + .001;
ytips = b.XEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, 'VerticalAlignment', 'middle')
xlabel('Weight Fraction')
title('Weight Budget')


if SAVEFIGURE
    cd figures
    exportgraphics(fig, 'weights.pdf', 'ContentType', 'vector');
    cd ..
end

function dp = q(rho,V)
dp = 1/2 *rho.*V^2;
end 


function w = kg2lb(x)
w = x*2.20462;
end 

function w = lb2kg(x)
w = x/2.205;
end 
