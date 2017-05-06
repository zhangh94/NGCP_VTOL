%{
Author: Frank Zhang
Created: 4/17/17
Updated: 4/24/17

Script to perform stability and control analysis
%}

close all; clear; clc; format compact; fclose('all');
ac = GrabData('./DesignData.txt');

%% Initial Tail Sizing
% S_vt = ac.V_vt * ac.S_wing * ac.b_wing/ac.l_vt
% S_ht = ac.V_ht * ac.S_wing * ac.c_wing/ac.l_ht
S_ht = ac.S_ht;
S_vt = ac.S_vt;

c_vt = sqrt(S_vt/ac.AR_vt)
c_ht = sqrt(S_ht/ac.AR_ht)

b_vt = S_vt/c_vt
b_ht = S_ht/c_ht

V_ht = S_ht*ac.l_ht/(ac.S_wing*ac.c_wing)
V_vt = S_vt*ac.l_vt/(ac.S_wing*ac.b_wing)

S_wing = ac.W/ac.WS
c_wing = sqrt(S_wing/ac.AR_wing)
b_wing = S_wing/c_wing
%% Roskam X-Plot

% h tail
n = 50;
SH = linspace(0,1.5,n);
for i1 = 1:n
   Xac(i1) = CalcXac(ac,SH(i1)); 
   Xcg(i1) = CalcXcg(ac,SH(i1));
end

S_ht = interp1(Xcg-Xac, SH, -0.1)

figure
hold all
plot(SH,Xac);
plot(SH,Xcg);
plot([S_ht S_ht], [0 max(Xac)]);
ylim([min(Xac) max(Xac)])
grid on;
legend('X_a_c','X_c_g')

% v tail
SV = linspace(0,1.0,n);
for i1 = 1:n
    CnB(i1) = CalcCnB(ac, SV(i1));
end

S_vt = interp1(CnB,SV, .001)
figure
hold all
plot(SV,CnB)
plot([S_vt S_vt],[min(CnB) max(CnB)]);
grid on
ylim([min(CnB) max(CnB)]);