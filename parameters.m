%all units MKS

g = 9.81; %gravity

%% Speeds %m/s
V_stall = 41.58;
V_takeoff = 1.1*V_stall; %lecture 3 slide 47
V_climb = 64; 
V_cruise = 108.056;
V_approach = 1.3*V_stall; %lecture 3 slide 47
V_landing = 50;
V_maneuver = [38.0556 + 5.14444, V_cruise, V_cruise]; %10kts above stall 1 engine, pull up maneuver, push down


%% Factors
n = [3 -1];
Nz = 1.5*n;
TOP = 300; %Takeoff parameter
G = sind(15); %climb gradient
S_landing = 0.507*mps2knots(V_landing)^2;
S_a = 450;

%% Air Densities
rho_sl= 1.2250; %kg/m^3
rho_ceil = 1.0556; %kg/m^2, 5000ft

%% Propulsion
PW = 26.2426; %W/N
% eta %propulsive efficiency

%% Wings
S = 44; %area
% b = %span
AR = 9.2;%aspect ratio
qcs = 10;% degrees quarter chord sweep
taper = 0.4;%taper ratio
tc = 0.15; %thickness to chord
xc = 0.25; %max thickness at quarter chord
WS = 1227.4549; %wing loading, N/m2

%% Aerodynamics
sweep = 10; %degrees
C_D0 = 0.008; %parasitic drag
C_lmax = 1.5; %airfoil 
C_Lmax = 0.9*C_lmax*cosd(sweep); %lecture
C_Ltakeoff = C_Lmax/1.21; %lecture


LD = 16; %lift to drag ratio
%% Structures

%% Weights and Fractions (kg)
%components
% Wpmax = 2268; %payload weight for cessna
WeW0 = .55; %empty weight fraction
Wc = 104.326; %weight of 1 person
pax = 16; %15 passengers + 1 pilot
Wp = pax*Wc; %payload weight is equivalent to 16 people with 30lbs of cargo each

% fuel weight ratio
WfW0 = .25; %max for cessna

% Wfw = ;%fuel weight in wings
Wpress = 0; %weight penalty for cabin pressurization

W0 = (Wp)./(1 - WeW0 - WfW0);
% W0 = (Wp + pax*Wc)./(1 - WeW0 - WfW0); %assumes paylaod + passengers
