close all;
clear;
clc;
W0 = 8.3461e+03;                %kg
W0 = kg2lb(W0);
%%WEIGHTS GIVEN IN LBS%%

rho_ceil = 1.0556;               %kg/m^3, 5000 ft
V_cruise = 108.056;
q_cruise = q(rho_ceil, V_cruise)/6895;
tc = 0.15;

%Wing
Wfw = kg2lb(2.0865e3);
AR = 9.2;
A = 10;
lambda = 0.4;
Wdg = kg2lb(8.34601e3);
Nz = 4.5;
Sw = 44*(3.281^2);
Wwing = 0.036*(Sw^0.758)*(Wfw^0.0035)*(AR/cosd(A)^2)^.6 * q_cruise^0.006 *lambda^0.04*(100*tc/cosd(A))^(-0.3)*(Nz*Wdg)^0.49;

 
Sf = 46*pi*(6.32^2)/4 + 2*pi*(6.32^2)/4;                    %Estimate, 14 m length, modelled as cylinder
Lt = 2;                                                      %hella estimate
L = 46;

D = (1.9257 - 1.83)*3.281;                                  %fuselage depth (assuming it's thickness?)

Wf = 0.052*(Sf^1.086)*(Nz*Wdg)^.177*Lt^(-0.051)*(L/D)^(-.072)*q_cruise^.241;





%Engine
W_engine = 235;
W_en = kg2lb(W_engine);
Ne = 2;
Wie = 2.575*W_en^0.922*Ne;



%flight controls 
b = 73.25;
Wfc = .053*(L^1.536)*(b^.371)*(Nz*(Wdg*(10^-4)))^.8;

%Avionics weight
Wuav = 1100;                                     %range 800-1400 lb from book
Wavi = 2.117*Wuav^.933;

%fuel system (hella estioimate too)
Vt = 720;                                        %gal, for SkyCourier
ViVt = 1;
Nt = 3;                                          %1 per wing and in fuselage ?

Wfs = 2.49*Vt^.726*(.5^.363)*Nt^.242*Ne^.157;


%electrical
We = 12.57*(Wfs + Wavi)^.51;



%weights in kg
Wwing = lb2kg(Wwing)
Wf = lb2kg(Wf)
Wie = lb2kg(Wie)
Wfc = lb2kg(Wfc)
Wavi = lb2kg(Wavi)
Wfs = lb2kg(Wfs)
We = lb2kg(We)

y = [Wwing, Wf, Wie, Wfc, Wavi, Wfs, We];
Y = y/lb2kg(W0);
b = barh(Y);
yticklabels({'Wings', 'Fuselage', 'Installed Engines', 'Flight Controls', 'Avionics', 'Fuel Systems', 'Electrical'}) 
xtips = b.YEndPoints + .001;
ytips = b.XEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, 'VerticalAlignment', 'middle')
xlabel('W/W_0')
title('Weight Budget')




function dp = q(rho,V)
dp = 1/2 *rho.*V^2;
end 


function w = kg2lb(x)
w = x*2.20462;
end 

function w = lb2kg(x)
w = x/2.205;
end 
