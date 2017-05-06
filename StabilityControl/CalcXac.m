function [ Xac] = CalcXac( ac, SH )
%CALCXAC Function to estimate the aero center longitudinal location 
%   Input
%       ac - aircraft design data struct constructed using GrabData
%       SH - Horizontal tail area [ft2]
% 
%   Output
%       Xac - aerodynamic center location non-dimensionalized by main wing chord
% 
%   Assumptions
%       Unswept, untapered wing
%       Lift from fuselage ignored

% TODO: Show warning if wing is tapered or swept
if (~(ac.Lam_w) == 0 || ~(ac.lam_w == 1))
    warning('Wing taper/sweept ignored for XPlot calculation');
end
Xac_wb = ac.Xac_w + ac.dXac_b;
Xac_h = (ac.l_ht +0.25*sqrt(SH/ac.AR_ht))/ac.c_wing;

% see what happens if downwash gradient is 0
KA = 1/ac.AR_wing - 1/(1 + ac.AR_wing^1.7);
Klam = (10 - 3 * ac.lam_w)/7;
KH = (1 - ac.h_ht/ac.b_wing)/(2 * ac.l_ht/ac.b_wing)^(1/3);
deda = 4.44*(KA*Klam*KH*cosd(ac.Lam_w))^(1.19);
% deda = .1;

CLa_wb = ac.CLa_w;

Xac = (Xac_wb + ac.CLa_h/CLa_wb*ac.e_ht*SH/ac.S_wing*Xac_h*(1-deda))/...
    (1 + ac.CLa_h/CLa_wb*ac.e_ht*SH/ac.S_wing*(1-deda));

end

