%all units MKS

g = 9.81; %gravity

%% Air Densities
rho_sl= 1.2250; %kg/m^3
rho_ceil = 1.0556; %kg/m^2, 5000ft



%% Wings
S = 44; %area
AR = 9.2;%aspect ratio
b = sqrt(AR*S);
qcs = 10;% degrees quarter chord sweep
taper = 0.4;%taper ratio
tc = 0.15; %thickness to chord
xc = 0.25; %max thickness at quarter chord
WS = 1340; %wing loading, N/m2
cr = 2.6; %root chord
ct = 1.04; %tip chord
mac = (2/3)*((1 + taper + taper^2)/(1+taper))*cr;
Ymac = (b/6)*(1+2*taper)/(1+taper);

%% Aerodynamics
sweep = 10; %degrees
C_D0 = 0.02; %parasitic drag
C_lmax = 1.5; %airfoil 
C_Lmax = 0.9*C_lmax*cosd(sweep); %lecture
C_Ltakeoff = C_Lmax/1.21; %lecture
dCLda = 1/0.174532925; %1/rads
AOAmax = 13; %deg
LD = 16; %lift to drag ratio
e = 0.8;

% NP = [x, y]

%% Structures
fuselage.cabin = 15;
fuselage.R = 3/2;
fuselage.nose = 0;
body.length = 18;

%% Weights and Fractions (kg)
%components
% Wpmax = 2268; %payload weight for cessna
WeW0 = .55; %empty weight fraction
Wc = 104.326; %weight of 1 person
pax = 16; %15 passengers + 1 pilot
Wp = pax*Wc; %payload weight is equivalent to 16 people with 30lbs of cargo each

% fuel weight ratio
WfW0 = 0.125; %max for cessna

% battery weight ratio
WbW0 = 0.125;

% Wfw = ;%fuel weight in wings
Wpress = 0; %weight penalty for cabin pressurization

W0 = (Wp)./(1 - WeW0 - WfW0 - WbW0);
% W0 = (Wp + pax*Wc)./(1 - WeW0 - WfW0); %assumes paylaod + passengers

% Weights in kg

% W.fus= 4.5999e+03; don't know where this comes from
W.fus = 1.0433e+03;  %fuselage 12.5% of takeoff weight
W.wing= 756.4274; %wing
% W.fus= 147.1241; %fuselage
W.ie= 743.1507; %installed engines
W.fc= 229.6821; %
W.avi= 660.5895; %avionics
W.fs= 334.2519; %fuel system
W.elec= 286.8911; %electrical components
W.pl= 757.0068; %payload
W.fuel= 2.0862e+03; %fuel weight
W.pilot = 110; %pilot
W.tail = W.wing/3;

%% Propulsion
PW = 30; %W/N
TotalPower = PW*9.8*W0
% eta %propulsive efficiency

%% Speeds %m/s
V_stall = sqrt(WS*2/(C_Lmax*rho_ceil));
% V_stall = 47;

V_takeoff = 1.1*V_stall; %lecture 3 slide 47
V_climb = 1.4*V_stall; 
V_cruise = 108.056;
V_approach = 1.3*V_stall; %lecture 3 slide 47
V_landing = 1.15*V_stall;
V_maneuver = [38.0556 + 5.14444, V_cruise, V_cruise]; %10kts above stall 1 engine, pull up maneuver, push down

Velocities = {'V_stall ', V_stall;
              'V_takeoff', V_takeoff;
              'V_climb', V_climb;
              'V_cruise', V_cruise;
              'V_approach', V_approach;
              'V_landing', V_landing;
              'V_maneuver', V_maneuver}

%% Factors
n = [3 -1];
Nz = 1.5*n;
TOP = 200; %Takeoff parameter
G = tand(12); %climb gradient
S_landing = 0.507*mps2knots(V_landing)^2;
S_a = 450;

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