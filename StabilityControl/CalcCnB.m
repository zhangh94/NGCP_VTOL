function [ CnB ] = CalcCnB( ac, SV )
%CALCCNB Function to estimate the directional stability derivative
%   Input
%       SV - vertical tail area [ft2]
% 
%   Output
%       CnB - directional stability derivative

rho =  0.0023769; % density [slug/ft3]
mu = 3.75E-7; % kinematic viscosity at 15C (59F) [lb-s/ft2]
Vstall = sqrt(2*ac.W/(0.5*rho*ac.S_wing*ac.CLmax));
Re = rho * 1.2*Vstall * ac.l_B/mu;

CnB = -57.3 * ac.K_N * ac.K_Rl * ac.S_BS/ac.S_wing *ac.l_B/ac.b_wing + ...
    ac.CLa_v * SV/ac.S_wing*ac.l_vt/ac.b_wing;


end

