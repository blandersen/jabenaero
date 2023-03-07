clf; close all; clear;clc;

run parameters.m

W.fwdeng = W.ie*2;
W.afteng = W.ie*2;
W.fwdgear = 400/3; %~5% of gross mass
W.aftgear = 400/3; %~5% of gross mass
%% Fuselage Basic Geometry
%Masses in lbs, distances in feet


%% Mean Aerodynamic Chord
%mac is defined in parameters.m
mac_sweep_distance = ((cr+2*ct)) / (3*(cr+ct)); % offset from forwardmost point
wing_cg_offset = 0.40*cr; % 40% of root chord wing CG is placed
tip_leading_edge_offset = (b/2)*sind(sweep); % with respect to forward most leading 

%% Position relative to nose tip [x,y]
% position of each weight value
%change the fraction 0.XXX percent of the fuselage

X.CG = [NaN, NaN]; %CG
X.avi = [0.1* fuselage.cabin, 0]; %avionics
X.fus = [0.55 * fuselage.cabin, 0];
X.elec = [0.4 * fuselage.cabin, -0.80 * fuselage.R];
X.fs = [0.7 * fuselage.cabin, 0]; %fuel system
% Xie
X.wing = [0.5 * fuselage.cabin + wing_cg_offset, fuselage.R]; %number is forward most point of leading edge
X.pl = [0.6 * fuselage.cabin, 0];
X.fwdeng = X.wing + [tip_leading_edge_offset,0];
X.afteng = [0.9 * fuselage.cabin,fuselage.R];
X.fwdgear = [0.1 * fuselage.cabin, -fuselage.R];
X.pilot = [0.15 * fuselage.cabin, 0];
%front gear placement
Pfg = [0.1 * fuselage.cabin, -fuselage.R*1.5];

xfn = fieldnames(X);

%check for a neutral point defined in parameters.m
try NP;
catch NP = 0.62*[fuselage.cabin, fuselage.R];
end



%% Labels
%for each weight you add, add a corresponding label 'label.component'
label.CG = 'CG';
label.NP = 'NP';
label.fwdeng = 'Fwd. Props';
label.afteng = 'Aft. Props';
label.avi = 'Avi.';
label.fs = 'FS';
label.wing = 'Wing';
label.pl = 'PL';
label.fus = 'Fuse.';
label.elec = 'Elec.';
label.fwdgear = 'Fwd Gear';
label.pilot = 'Pilot';
% label.fcontrol = 'Controls';
%% CG Calc

Wtotal = 0;
WXtotal = 0;
WYtotal = 0;
for k=1:numel(xfn)
    if( isnumeric(X.(xfn{k})) && ~strcmp((xfn{k}),'CG') )
        try label.(xfn{k});
        catch, fprintf('\nLabel needed: Add <label.%s>\n',(xfn{k})); return;
        end
        try W.(xfn{k});
        catch, fprintf('\nWeight needed: Add <W.%s>\n',(xfn{k})); return;
        end
        try X.(xfn{k});
        catch, fprintf('\nPosition needed: Add <X.%s>\n',(xfn{k})); return;
        end
        x = X.(xfn{k})(1);
        y = X.(xfn{k})(2);
        Wtotal = Wtotal + W.(xfn{k});
        WX = W.(xfn{k})*x;
        WY = W.(xfn{k})*y;
        WXtotal = WXtotal+WX;
        WYtotal = WYtotal+WY;
    end
end
W.CG = Wtotal;
X.CG(1) = WXtotal/Wtotal;
X.CG(2) = WYtotal/Wtotal;

%% Static Margin

staticmargin = (NP(1) - X.CG(1))/mac;

%% Gear placement, tail geometry

Yfus = 2; 
clearance = 20; %degrees above horizontal at main gear to clear land/takeoff

% % % gear positions
% main gear - change Y only
Pmg = [X.CG(1); Pfg(2)]; %main gear - relative to CG
Pmg(1) = Pmg(1) - tand(clearance)*Pmg(2);

%front gear, change X only


% % %

tailcone = @(x) tand(14)*(x - Pmg(1)) + Pmg(2);


%% plot
fig1 = figure(1);
subplot(2,1,1)
hold on; axis equal;
title('Relative Weight and CG Placement')
axis([-1 fuselage.cabin+5 -3 3])
xlabel('Station [m]')
ylabel('Height [m]')
xline(0)
xline(fuselage.nose)
yline(0)
fig1.Position = [250 250 1028 640];
xline(fuselage.nose+fuselage.cabin)
%plot components
for k=1:numel(xfn)
    if( isnumeric(X.(xfn{k})) && ~strcmp((xfn{k}),'CG') )
        %ensure there are Weight/Position/Label for each entry


        x = X.(xfn{k})(1);
        y = X.(xfn{k})(2);
        plot(x,y, '*b', 'linewidth',5)
%         lb = sprintf( '%s\n%3.d kg\n', label.(xfn{k}), W.(xfn{k}) );
        lb = sprintf( '  %s', label.(xfn{k}) );

        ptext = text(x,y,lb,'VerticalAlignment','middle','HorizontalAlignment','left');
        set(ptext,'Rotation',45);
    end
end

%plot CG
cglb = sprintf( '%s %8.0f kg', label.CG, W.CG );
pcg = scatter(X.CG(1), X.CG(2),150,'ys','filled','MarkerEdgeColor','k','LineWidth',2);
% text(X.CG(1), X.CG(2),cglb,'VerticalAlignment','bottom','HorizontalAlignment','left')

%plot neutral point NP
% nplb = sprintf( '\n%s\n', label.NP );
pnp = scatter(NP(1), NP(2),150,'ms','filled');
% text(NP(1), NP(2), nplb,'VerticalAlignment','bottom','HorizontalAlignment','left')


% plot gear
plot([Pfg(1) Pmg(1)], [Pfg(2) Pmg(2)], 'ko', 'LineWidth', 10);
text([Pfg(1) Pmg(1)], [Pfg(2) Pmg(2)],{'Front Gear','Main Gear'},'VerticalAlignment','top','HorizontalAlignment','left');


% plot tail cone limit
grey = ([0.5,0.5,0.5]);
fplot(tailcone, Pmg(1)*[1 20], '--', 'Color',grey, 'LineWidth', 2)

% plot main cabin
fplot(fuselage.R, '--', 'Color',grey, 'LineWidth', 2)
fplot(-fuselage.R, '--', 'Color',grey, 'LineWidth', 2);

legend([pcg pnp], {cglb,'Neutral Point'},'Location','southeast' )

%% Plot Stability
subplot(2,1,2)
hold on
title('Static Margin')
p1 = plot(([0 mac] + X.wing(1)), [0 0], 'Color', grey,'Linewidth',6);
p2 = scatter(X.CG(1), 0,150,'ys','filled','MarkerEdgeColor','k','LineWidth',2);
p3 = scatter(NP(1), 0,150,'ms','filled');


%display static margin
text(X.wing(1),-1, sprintf('Static Margin: %5.2f %%',staticmargin*100),'VerticalAlignment','bottom','HorizontalAlignment','left');
yline(0);
pltax = gca;
pltax.XLim = pltax.XLim + [-2 2];
pltax.YLim = [-2 2];
xlabel('Station [m]');
legend([p1 p2 p3], {'MAC', 'Center of Gravity', 'Neutral Point'});



