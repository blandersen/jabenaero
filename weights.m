%%WEIGHTS GIVEN IN LBS%%

kg2lb = @(x) x*2.20462;


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
Wwing = 0.036*(Sw^0.758)*(Wfw^0.0035)*(AR/cosd(A)^2)^.6 * q_cruise^0.006 *lambda^0.04*(100*tc/cosd(A))^(-0.3)*(Nz*Wdg)^0.49

 
Sf = 46*pi*(6.32^2)/4 + 2*pi*(6.32^2)/4;                    %Estimate, 14 m length, modelled as cylinder
Lt = 2;                                                      %hella estimate
L = 46;

D = (1.9257 - 1.83)*3.281;                                  %fuselage depth (assuming it's thickness?)

Wf = 0.052*(Sf^1.086)*(Nz*Wdg)^.177*Lt^(-0.051)*(L/D)^(-.072)*q_cruise^.241























function dp = q(rho,V)
dp = 1/2 *rho.*V^2;
end 