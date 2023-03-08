clear;close all; clc;

run parameters.m

SAVEFIGURE = true;


% WS = CL_max/2*1/2*rho*Vstall^2;

%variables

WSopt = WS; %W/S
PWopt = PW; %PW

clear ('PW', 'WS')

WS.lin = linspace(0,500*9.8,500); %N/m2
%% Parameters

%Dynamic Pressures
q_stall = q(rho_sl, V_stall);
q_maneuver = q(rho_ceil, V_maneuver);
q_climb = q(rho_ceil, V_climb);
q_cruise = q(rho_ceil, V_cruise);


%overall efficiency for prop system
eta = .2; 


%% Equations

PW.Ceiling = 1/LD*(V_cruise/eta);

PW.Maneuver1 = (C_D0*q_maneuver(1)./WS.lin + n(1)^2/(pi*e*AR*q_maneuver(1)).*WS.lin).*(V_maneuver(1)/eta);

PW.Maneuver2 = (C_D0*q_maneuver(2)./WS.lin + n(1)^2/(pi*e*AR*q_maneuver(2)).*WS.lin).*(V_maneuver(2)/eta);

PW.Maneuver3 = (C_D0*q_maneuver(3)./WS.lin + n(2)^2/(pi*e*AR*q_maneuver(3)).*WS.lin).*(V_maneuver(3)/eta);

PW.Climb = (G + (WS.lin)./(pi*e*AR*q_climb) + C_D0*q_climb./WS.lin).*(V_climb/eta);

WS.Stall = 1/2*C_Lmax*rho_ceil*V_stall^2;

PW.Takeoff = WS.lin/(TOP*C_Ltakeoff);

WS.Landing = (S_landing - S_a)*C_Lmax/80;

%% Figure Plot


fig = figure(1);
hold on

title('Power Loading vs. Wing Loading')
axis([0 2500 0 250])
xlabel('Wing Loading, W/S [N/m^2]')
ylabel('Power to Weight Ratio, P/W, [W/N]')
yline(PW.Ceiling,'b','LineWidth',2)
% xline(WS.Stall,'--k','LineWidth',2)
plot(WS.lin,PW.Maneuver1,'r','LineWidth',2)
plot(WS.lin,PW.Maneuver2,'--r','LineWidth',2)
plot(WS.lin,PW.Maneuver3,':r','LineWidth',2)
plot(WS.lin,PW.Climb, 'm','LineWidth',2)
plot(WS.lin, PW.Takeoff, 'g','LineWidth',2)
xline(WS.Landing, 'y','LineWidth',2)

%optimal point
% opter = PW.Climb;
% opty = min(opter);
% optx = WS.lin((opter) == opty);


grid on
plot(WSopt,PWopt,'^k','LineWidth',3)

%
legend('Ceiling', 'Low Speed Maneuver', 'Pull Up Maneuver', 'Push Down Maneuver','Climb', 'Takeoff','Landing','Optimal Point')

if SAVEFIGURE
    cd figures
    exportgraphics(fig, 'sizing.png', 'ContentType', 'vector');
    cd ..
end

%% Functions
function dynamicpressure = q(rho,V) 
dynamicpressure = 1/2 * rho .* V .^2;
end

function mps = mph2mps(mph)
mps = mph/2.237;
end

function knots = mps2knots(mps)
knots = mps*1.94384;
end