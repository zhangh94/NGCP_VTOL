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
WS = linspace(.25,3,n); % wingloading [lb/ft2]

% TODO: Evaluate if TW = 1.67 target is reasonable
% TW target is already set at 1.67 to achieve T=W at 60% power setting (Only in RC)
TW = linspace(0.1, 2, n); % thrust-to-weight

rho =  0.0023769; % density [slug/ft3]
g = 32.2; % gravity constant [ft/s2]

% grab design data
ac = GrabData('./DesignData.txt');
figure
hold all;
grid on
% xlim([0 3]);
% ylim([0 2]);
%% Endurance Constraint
%{
Reference: Traub, Lance W. "Range and Endurance Estimates for Battery-Powered
Aircraft". Journal of Aircraft (March-April 2011)
%}
% TODO: Generate a "motor deck"
% TODO: Evaluate if these huge endurance values are reasonable
% TODO: Probably factor a TO/LD correction factor
Ue = sqrt(2/rho .*WS * sqrt(ac.k/(3 * ac.CD0))); % best endurance speed [ft/s]
S = ac.W./WS;

% endurance calculation with 25% battery consumption used by TO/LD
E = (ac.Rt).^(1-ac.n).*((ac.e_tot.*ac.V.*ac.C)./...
    (0.5.*rho.*Ue.^3.*S.*ac.CD0 + (2*ac.W.*WS.*ac.k./(rho.*Ue)))).^ac.n...
    - ac.C*0.25;
contour(WS,TW,repmat(E,n,1),[20/60 20/60]);
%     - ac.Rt/(ac.i_max^ac.n)*(ac.C/ac.Rt)^ac.n * 0.20; % Endurance [hours]
%% Dash Constraint (Max Speed)
%{
% TODO: Figure out max speed using Pr = Pa
Max speed occurs at Velocity where Pr (equals D) is equal to Pa (equals max power)
Vmax = sqrt((2*WS*CD^2)/(rho*CL^3))/TW

%}

% might be invalid for motor-propeller aircraft
for i1 = 1:n
    % NOTE: TW is low at (1) and high at (end)
    % NOTE: TW here is T_available/W
    Vmax(:,i1) = sqrt((TW.*(WS(i1)+WS(i1).*sqrt(TW.^2-4*ac.CD0*ac.k)))/...
        (rho * ac.CD0)); % [ft/s]
end
contour(WS,TW,Vmax,[66 66]);
%% Stall Speed Constraint
% TODO: Evaluate if CLmax = 1.2 is reasonable
Vstall = 1./sqrt(0.5*rho.*ac.CLmax./WS); % [ft/s]
contour(WS,TW,repmat(Vstall,n,1),[26.4 26.4]);
%% TOFL
T = TW*ac.W;

for i1 = 1:n
    Vlo = 1.2.*Vstall(i1); % Lift off velocity [ft/s]
    CLto = WS(i1)/(0.5*rho*(0.7*Vlo).^2);
    % TODO: Add drag polar
    % TODO: Add motor deck
    % TODO: Add bonus drag for landing gear
    
    % assume flight condition to be at 0.7*Vlo
    L = 0.5*rho*(0.7*Vlo).^2.*S.*CLto;
    D = 0.5*rho*(0.7*Vlo).^2.*S*0.05; % TODO: REPLACE THIS CD WITH DRAG POLAR
    TOFL(:,i1) = (1.44*(ac.W^2))./(g*rho*S(i1).*ac.CLmax.*(T-(D+ac.muR*(ac.W-L))));
end
contour(WS,TW,TOFL,[175 175]);
legend({'Endurance','Dash','Vstall','TOFL'});