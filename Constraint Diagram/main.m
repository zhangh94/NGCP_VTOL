%{
Author: Frank Zhang
Created: 4/17/17
Updated: 4/17/17

Script to generate a constraint diagram based on the requirements derived for
the NGCP VTOL aircraft
%}

close all; clear; clc; format compact; fclose('all');

%% Parameters

n = 50; % number of data points
WS = linspace(.25,1.5,n); % wingloading [lb/ft2]

% TODO: Evaluate if TW = 1.67 target is reasonable
% TW target is already set at 1.67 to achieve T=W at 60% power setting (Only in RC)
PW = linspace(3, 15, n); % power to weight [hp/lb]

rho =  0.0023769; % density [slug/ft3]
g = 32.2; % gravity constant [ft/s2]

% grab design data
ac = GrabData('./DesignData.txt');
figure
hold all;
grid on
xlabel('Wing-Loading [lb/ft^2]')
ylabel('Power to Weight [ft-lb/s/lb]');

%% Endurance Constraint
%{
Reference: Traub, Lance W. "Range and Endurance Estimates for Battery-Powered
Aircraft". Journal of Aircraft (March-April 2011)
%}
% TODO: Generate a "motor deck"
% TODO: Evaluate if these huge endurance values are reasonable
Ue = sqrt(2/rho .*WS * sqrt(ac.k/(3 * ac.CD0))); % best endurance speed [ft/s]
S = ac.W./WS;

% endurance calculation with 20% battery consumption used by TO/LD
E = (ac.Rt).^(1-ac.n).*((ac.e_tot.*ac.V.*ac.C)./...
    (0.5.*rho.*Ue.^3.*S.*ac.CD0 + (2*ac.W.*WS.*ac.k./(rho.*Ue)))).^ac.n...
    - ac.C*0.20;
contour(WS,PW,repmat(E,n,1),[16/60 16/60]);

%% Dash Constraint (Max Speed)
% TODO: Figure out if this accounts for prop efficiency
CL = linspace(0.05,ac.CLmax,n);

% Vinterp = griddedInterpolant(Pr,V,'spline','none');
for i1 = 1:n
    V = sqrt(2.*WS(i1)./(rho.*CL));
    CD = DragPolar(CL);
    
    % Reference: Anderson. Aircraft Performance and Design. Eqn 5.56. 1999
    Pr = sqrt((2.*WS(i1).*ac.W^2.*CD.^2)./(rho.*CL.^3))/ac.e_prop; % power required
    Pa = PW * ac.W; % power available
    Vmax(:,i1) = interp1(Pr,V,Pa);
    
end

contour(WS,PW,Vmax,[66 66]);
%% Stall Speed Constraint
Vstall = 1./sqrt(0.5*rho.*ac.CLmax./WS); % [ft/s]
contour(WS,PW,repmat(Vstall,n,1),[26.4 26.4]);
%% TOFL
N = 1;

% TODO: Does this seem right? Power required feels very very low
% TODO: Remove nested for loop
% Reference: Anderson. Aircraft Performance and Design. Chapter 6.7.1. 1999
for i1 = 1:n
    for j1 = 1:n
        Vlo = 1.2*Vstall(i1);
        Vinf = 0.7*Vlo;
        P = PW(j1)*ac.W;
        T = ac.e_prop * P/Vinf;
        KT = T/ac.W - ac.muR;
        
        G = (16 * ac.h_w/ac.b_wing)^2/(1 + (16 * ac.h_w/ac.b_wing)^2);
        KA = -rho/(2*WS(i1))*(ac.CD0 + G*ac.k*ac.CLto^2 - ac.muR*ac.CLto);
        
        % Ground roll and rotation distance
        TOFL(j1,i1) = 1./(2*g*KA).*log(1 + (KA./KT)*(Vlo^2)) + N.*Vlo; % [ft]
    end
end

contour(WS,PW,TOFL,[100 100]);
legend({'Endurance','Dash','Vstall','TOFL'});