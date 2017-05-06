function [ Xcg ] = CalcXcg( ac, SH )
%CALCXCG Summary of this function goes here
%   Detailed explanation goes here

% Estimate weight
vol_ht = ac.Vol_ht/ac.S_ht *SH;
W_ht = ac.rho_ht * vol_ht;

% estimate ht CG location at 33% HT chord
CG_ht = ac.l_wLE + ac.l_ht + 0.33*ac.c_ht;

% output Xcg
CG = (ac.CG_ht*ac.W_ht + CG_ht*W_ht)/(ac.W_ht + W_ht);
Xcg = (CG - ac.l_wLE)/ac.c_wing;
end

