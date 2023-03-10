% neutral point
clc
run("parameters.m")
wingAirfoil = table2array(readtable("wing_airfoil"));
tailAirfoil = wingAirfoil;

n = 1000;
xmax = 18;
ymax = 3;

COG = [10 2];
HIGHT = 4;
LENGTH =  18;

x_wing = 0.5*LENGTH;
y_wing = 0;

x_tail = LENGTH;
y_tail = 1*HIGHT;

x = linspace(0,xmax,n)';
y = linspace(0,ymax,n)';
p = [x,y];

p_wing = [x_wing y_wing];
p_tail = [x_tail y_tail];

S_wing = 60;
S_tail = 10;

rho = rho_sl;
U = V_takeoff;
q = 1/2*rho*U^2;

alpha = 5;
trim = -5;

CL_wing = wingAirfoil(:,2);
CD_wing = wingAirfoil(:,3) ;%+ wingAirfoil(:,4);
CM_wing = wingAirfoil(:,5);

CL_tail = tailAirfoil(:,2);
CD_tail = tailAirfoil(:,3) ;%+ wingAirfoil(:,4);
CM_tail = tailAirfoil(:,5);

i = cast(((alpha - wingAirfoil(1))/ 0.25 + 1),"uint8");
j = cast(((alpha - tailAirfoil(1) + trim)/ 0.25 + 1),"uint8");


L_wing = q*CL_wing(i)*S_wing;
D_wing = q*CD_wing(i)*S_wing;
M_wing = q*CM_wing(i)*S_wing;

L_tail = q*CL_tail(j)*S_tail;
D_tail = q*CD_tail(j)*S_tail;
M_tail = q*CM_tail(j)*S_tail;

F_wing = [L_wing D_wing];
F_tail = [L_tail D_tail];

Mx = M_tail + M_wing + (x-x_wing).*F_wing(1) + (x-x_tail).*F_tail(1);
My = M_tail + M_wing + (y-y_wing).*F_wing(2) + (y-y_tail).*F_tail(2);

figure(1)
hold on
yline(0)
plot(x,Mx)

[m, k] = min(abs(M))

NP = [x(k(1)) y(k(2))]





% M_pitch = COG*[W0; 0]