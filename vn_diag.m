close all;
clear;
clc;


np = 3;                          %Positive load factor
nn = -1;                       %Negative load factor 


%Density 
rho_sl = 1.2250;                 %kg/m^3
rho_ceil = 1.0556;               %kg/m^3, 5000 ft
rho = sqrt(rho_ceil/rho_sl);


%Speeds
V_stall = 43.6994;
V_takeff = 1.1*V_stall;
V_climb = 64;
V_maneuver = 38.0556 + 5.14444;
V_cruise = 108.056;
V_dive = 1.5*V_cruise;           %from lecture
% V_g = V_cruise - 10;               %reference only
V_g = V_cruise*0.75;               %reference only

%Equivalent Speeds
V_ecruise = rho*V_cruise;
V_edive = rho*V_dive;
V_eg = rho*V_g;



sweep = 10;                      %degrees
c = 1;                           % m, reference only, BA changed to 1


%Dynamic Pressures 
q_stall = q(rho_sl, V_stall);
q_cruise = q(rho_ceil, V_cruise);

%Coefficients
C_D0 = 0.008;
C_lmax = 1.5;
C_lmax = 0.9*C_lmax*cosd(sweep);


%Plot 1
n1 = @(v) (v/V_stall).^2;
vmax1 = sqrt(np)*V_stall;
x1 = linspace(0, vmax1);
plot(x1, n1(x1), 'b','LineWidth',2)
hold on 
xline(0, 'LineWidth', 2)
yline(0, 'LineWidth', 2)
set(gca,'Fontsize',14,'box','off')

%Plot 2
n2 = @(v) - (v/V_stall).^2;
vmax2 = sqrt(-nn)*V_stall;
x2 = linspace(0, vmax2);
plot(x2, n2(x2), 'b','LineWidth',2)

%Plot 3
x3 = linspace(vmax1, V_edive);
n3 = np + zeros(length(x3), 1);
plot(x3, n3, 'b','LineWidth',2)

%Plot 4
x4 = linspace(vmax2, V_ecruise);
n4 = nn + zeros(length(x4), 1);
plot(x4, n4, 'b','LineWidth',2)

%Plot 5
plot([V_ecruise V_edive], [nn 0], 'b','LineWidth',2)

%Plot 6
plot([V_edive V_edive], [np 0], 'b','LineWidth',2)



%% Gust %%

WS = 1561;                                  %N/m^2
cl = 1.5;


% Ude = 9.144;                                 %30 ft/s, from lec

dCLda = 1/0.174532925;
Ude = [7.5 9.144];
g = 9.81;
mu = @(rho, c) 2*WS/(rho*g*c*dCLda);
K = @(mu) 0.88*mu/(5.3 + mu);
U = @(k) k*Ude;



dn = @(q, U, V, W) q*dCLda*U/(V*W);


plot([0 V_edive], [1 1], '--')

mu_g = mu(rho_ceil, c);
K_g = K(mu_g);
U_g = Ude(2) * K_g * .5;
dn_g = dn(q_cruise, U_g, V_eg, WS);

mu_cruise = mu(rho_ceil, c);
K_cruise = K(mu_cruise);
U_cruise = Ude(2) * K_cruise;
dn_cruise = dn(q_cruise, U_cruise, V_ecruise, WS);

mu_dive= mu(rho_ceil, c);
K_dive = K(mu_dive);
U_dive = Ude(1) * K_dive;
dn_dive = dn(q_cruise, U_dive,V_edive, WS);

plot([V_eg V_eg], [(1-dn_g) (1+dn_g)],'r','LineWidth',2)
plot([V_ecruise V_ecruise], [(1-dn_cruise) (1+dn_cruise)],'r','LineWidth',2)
plot([V_edive V_edive], [(1-dn_dive) (1+dn_dive)],'r','LineWidth',2)


gustlabels = {'V_{g}','V_{e,cruise}','V_{e,dive}'};
xgust = [V_eg, V_ecruise, V_edive];
ygust = [dn_g, dn_cruise, dn_dive];
plot(xgust,[1 1 1],'o')
text(xgust,[1 1 1],gustlabels,'VerticalAlignment','bottom','HorizontalAlignment','left')

plot([0 xgust],[1 ,(1 + ygust)],'-r','LineWidth',2)
plot([0 xgust],[1 ,(1 - ygust)],'-r','LineWidth',2)


np = 3; nn = -1;
vnlabels = {'PHAA', 'NHAA', 'PLAA', 'NLAA'};
xvn = [sqrt(np)*V_stall, sqrt(-nn)*V_stall, V_edive, V_ecruise]; 
yvn = [np nn np nn];
plot(xvn,yvn,'o')
text(xvn,yvn,vnlabels,'VerticalAlignment','bottom','HorizontalAlignment','right')


title('V-n Diagram and Gust Envelope')


axis([0, V_dive+10, -1.5 4])

ylabel('Load Factor [-]')
xlabel('Airspeed [m/s]')

function dp = q(rho,V)
dp = 1/2 *rho.*V^2;
end 