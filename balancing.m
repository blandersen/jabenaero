clf; close all; clear;clc;

run parameters.m

W.fwdeng = W.ie*2;
W.afteng = W.ie*2;

%% Fuselage Basic Geometry
%Masses in lbs, distances in feet
fuselage.L = 15; %fuselage length
fuselage.R = 1; % radius

%% Position relative to nose tip [x,y]
% position of each weight value

X.CG = [NaN, NaN]; %CG
X.fwdeng = [5,0];
X.afteng = [14,fuselage.R];
X.avi = [2, 0]; %avionics
X.fus = [fuselage.L/2.2, 0];
% Xf
% Xfc
X.fs = [7.5, 0]; %fuel system
% Xfw
% Xie
% Xuav
X.wing = [9, fuselage.R]; 
X.pl = [10, 0];

xfn = fieldnames(X);

%check for a neutral point defined in parameters.m
try NP;
catch NP = 0.6*[fuselage.L, fuselage.R];
end



%% Labels
%for each weight you add, add a corresponding label 'label.component'
label.CG = 'CG';
label.NP = 'NP';
label.fwdeng = 'Fwd. Props';
label.afteng = 'Aft. Props';
label.avi = 'Avionics';
label.fs = 'FS';
label.wing = 'Wing';
label.pl = 'PL';
label.fus = 'Fuse.';
%% CG Calc

Wtotal = 0;
WXtotal = 0;
WYtotal = 0;
for k=1:numel(xfn)
    if( isnumeric(X.(xfn{k})) && ~strcmp((xfn{k}),'CG') )
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

%% Gear placement, tail geometry

Yfus = 2; 


% % % gear positions
% main gear - change Y only
Pmg = [X.CG(1); -2]; %main gear - relative to CG
Pmg(1) = Pmg(1) - tand(15)*Pmg(2);

%front gear, change X only
Pfg = [1; Pmg(2)];

% % %

tailcone = @(x) tand(14)*(x - Pmg(1)) + Pmg(2);


%% plot
fig1 = figure(1);
hold on; axis equal;
title('Relative Weight and CG Placement')
axis([-1 fuselage.L+5 -3 3])
xlabel('Station [m]')
ylabel('Height [m]')
xline(0)
yline(0)
fig1.Position = [250 250 2.5*560 500];

%plot components
for k=1:numel(xfn)
    if( isnumeric(X.(xfn{k})) && ~strcmp((xfn{k}),'CG') )
        %ensure there are Weight/Position/Label for each entry
        try label.(xfn{k});
        catch sprintf('\nLabel needed: Add <label.(xfn{k})>\n'); return;
        end
        try W.(xfn{k});
        catch sprintf('\nWeight needed: Add <W.(xfn{k})>\n'); return;
        end
        try X.(xfn{k});
        catch sprintf('\nPosition needed: Add <X.(xfn{k})>\n'); return;
        end

        x = X.(xfn{k})(1);
        y = X.(xfn{k})(2);
        plot(x,y, '*b', 'linewidth',5)
%         lb = sprintf( '%s\n%3.d kg\n', label.(xfn{k}), W.(xfn{k}) );
        lb = sprintf( '%s\n', label.(xfn{k}) );

        text(x,y,lb,'VerticalAlignment','bottom','HorizontalAlignment','left')
    end
end

%plot CG
cglb = sprintf( '\n%s\n%3.d kg', label.CG, W.CG );
scatter(X.CG(1), X.CG(2),150,'ys','filled','MarkerEdgeColor','k','LineWidth',2)
text(X.CG(1), X.CG(2),cglb,'VerticalAlignment','bottom','HorizontalAlignment','left')

%plot neutral point NP
nplb = sprintf( '\n%s\n', label.NP );
scatter(NP(1), NP(2),150,'ms','filled')
text(NP(1), NP(2), nplb,'VerticalAlignment','bottom','HorizontalAlignment','left')


% plot gear
plot([Pfg(1) Pmg(1)], [Pfg(2) Pmg(2)], 'ko', 'LineWidth', 10)
text([Pfg(1) Pmg(1)], [Pfg(2) Pmg(2)],{'Front Gear','Main Gear'},'VerticalAlignment','top','HorizontalAlignment','left')


% plot tail cone limit
grey = ([0.5,0.5,0.5]);
fplot(tailcone, Pmg(1)*[1 20], '--', 'Color',grey, 'LineWidth', 2)

% plot main cabin
fplot(fuselage.R, '--', 'Color',grey, 'LineWidth', 2)
fplot(-fuselage.R, '--', 'Color',grey, 'LineWidth', 2)



