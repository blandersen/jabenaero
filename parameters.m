%all units MKS

%Load Factors
n = [3 -1];
Nz = 1.5*n;

%Speeds %m/s
V_stall = 41.58;
V_takeoff = 1.1*V_stall; %lecture 3 slide 47
V_climb = 64; 
V_cruise = 108.056;
V_approach = 1.3*V_stall; %lecture 3 slide 47
V_landing = 50;
V_maneuver = [38.0556 + 5.14444, V_cruise, V_cruise]; %10kts above stall 1 engine, landing maneuver
%Air Densities
rho_sl= 1.2250; %kg/m^3
rho_ceil = 1.0556; %kg/m^2, 5000ft

% Wings
S = 44;
Wfw %fuel weight stored in wing
AR %aspect ratio
qcs %quarter chord sweep
taper %taper ratio
tc %thickness to chord

% Aerodynamics
sweep = 10; %degrees
C_D0 = 0.008;
C_lmax = 1.5;
C_Lmax = 0.9*C_lmax*cosd(sweep); %lecture
C_Ltakeoff = C_Lmax/1.21; %lecture


% Weights (kg)
Wfw




