clear;clc;

run weights.m

W.fwdeng = W.ie*2;
W.afteng = W.ie*2;


%Masses in lbs, distances in feet
Lfus = 15; %fuselage length

%% Position relative to nose tip [x,y]
X.CG = [NaN, NaN]; %CG
X.fwdeng = [5,0];
X.afteng = [14,0];
X.avi = [2, 0]; %avionics
% Xe
% Xf
% Xfc
X.fs = [10, 0]; %fuel system
% Xfw
% Xie
% Xuav
X.wing = [8, 0]; 

xfn = fieldnames(X);

%% Labels
label.CG = 'CG';
label.fwdeng = 'Fwd. Engine';
label.afteng = 'Aft Engine';
label.avi = 'Avionics';
label.fs = 'Fuel System';
label.wing = 'Wing';

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

%% plot
figure
hold on; axis equal;
title('Relative Weight and CG Placement')
axis([-1 Lfus+2 -3 3])
%plot components
for k=1:numel(xfn)
    if( isnumeric(X.(xfn{k})) && ~strcmp((xfn{k}),'CG') )
        x = X.(xfn{k})(1);
        y = X.(xfn{k})(2);
        plot(x,y, '*b', 'linewidth',2)
        lb = sprintf( '%s\n%3.d kg\n', label.(xfn{k}), W.(xfn{k}) );
        text(x,y,lb,'VerticalAlignment','bottom','HorizontalAlignment','right')
    end
end

%plot CG
cglb = sprintf( '%s\n%3.d kg\n', label.CG, W.CG );
plot(X.CG(1), X.CG(2),'ko', 'linewidth',2)
text(x,y,cglb,'VerticalAlignment','top','HorizontalAlignment','left')

% text(x,y,labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
