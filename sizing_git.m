clear;close all; clc;

run parameters.m
clear ('PW', 'WS')
% WS = CL_max/2*1/2*rho*Vstall^2;

%variables
WS.lin = linspace(0,500*9.8,500); %N/m2
%% Parameters
% %Speeds %m/s
% V_stall = 41.58;
% V_takeoff = 1.1*V_stall; %lecture 3 slide 47
% V_climb = 64; 
% V_cruise = 108.056;
% V_approach = 1.3*V_stall; %lecture 3 slide 47
% V_landing = 50;
% V_maneuver = [38.0556 + 5.14444, V_cruise, V_cruise]; %10kts above stall 1 engine, landing maneuver
% %Air Densities
% rho_sl= 1.2250; %kg/m^3
% rho_ceil = 1.0556; %kg/m^2, 5000ft

%Dynamic Pressures
q_stall = q(rho_sl, V_stall);
q_maneuver = q(rho_sl, V_maneuver);
q_climb = q(rho_ceil, V_climb);
q_cruise = q(rho_ceil, V_cruise);


%load factor
n=3;

%lift-drag ratio
% LD = 15;
e = 0.8; %oswald
AR = 9.2; %aspect ratio
% G = sind(15); %test
% gamma = 15; %climb angle, degrees


% sweep = 5; %degrees
% TOP = 300; %takeoff parameter - 3000 ft runway %% LETS LOWER THIS
eta = .7; 

%Coefficients
C_D0 = 0.03;

% C_lmax = 1.5;
% C_Lmax = 0.9*C_lmax*cosd(sweep);
% C_Ltakeoff = C_Lmax/1.21;

% Landing
% S_landing = 0.507*mps2knots(V_landing)^2;
% S_a = 450;
%% Equations

PW.Ceiling = 1/LD*(V_cruise/eta);

PW.Maneuver1 = (C_D0*q_maneuver(1)./WS.lin + n^2/(pi*e*AR*q_maneuver(1)).*WS.lin).*(V_maneuver(1)/eta);

PW.Maneuver2 = (C_D0*q_maneuver(2)./WS.lin + n^2/(pi*e*AR*q_maneuver(2)).*WS.lin).*(V_maneuver(2)/eta);

PW.Maneuver3 = (C_D0*q_maneuver(3)./WS.lin + 1^2/(pi*e*AR*q_maneuver(3)).*WS.lin).*(V_maneuver(3)/eta);

PW.Climb = (G + (WS.lin)./(pi*e*AR*q_climb) + C_D0*q_climb./WS.lin).*(V_climb/eta);

WS.Stall = 1/2*C_Lmax*rho_ceil*V_stall^2;

PW.Takeoff = WS.lin/(TOP*C_Ltakeoff);

WS.Landing = (S_landing - S_a)*C_Lmax/80;

%% Figure Plot


figure(1)
hold on

title('Power Loading vs. Wing Loading')
axis([0 2500 0 50])
xlabel('Wing Loading, W/S [N/m^2]')
ylabel('Power to Weight Ratio, P/W, [W/N]')
yline(PW.Ceiling,'b','LineWidth',2)
xline(WS.Stall,'--k','LineWidth',2)
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

optx = 1561.5; %W/S
opty = 34.32; %PW
grid on
plot(optx,opty,'^k','LineWidth',3)

%
legend('Ceiling', 'Stall', 'Low Speed Maneuver', 'Pull Up Maneuver', 'Push Down Maneuver','Climb', 'Takeoff','Landing','Optimal Point')


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