clear;clc;
%calc tip speed
%% input
rpm = 2400;
radius = 1.3;
Ta = 293; %K

%% calcs
Rg = 287; %J/kgK
gamma = 1.4;

angvel = rpm * 2*pi / 60;
tipspeed = angvel*radius;
speedofsound = sqrt(Rg*gamma*Ta);
tipmach = tipspeed/speedofsound;
%% string output
outstr = ['RPM: %.2f\n'...
    'Radial Velocity: %.2f rad/s\n',...
    'Prop Radius: %.2f m'...
    '\nTip Speed: %.2f m/s\n'...
    'Tip Mach: %.2f\n'...
    ];


fprintf(outstr, rpm, angvel, radius, tipspeed, tipmach)
