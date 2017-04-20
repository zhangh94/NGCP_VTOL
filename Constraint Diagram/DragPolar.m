function [ CDtot ] = DragPolar( CL )
%DRAGPOLAR Returns CDtot for a given CL based on VLM from VSPAERO
%   Iter 0

% TODO: Decide to use VSPAERO CD0 or drag build up CD0
% alpha = linspace(-5,15,20);
CLdat = [-0.1832	-0.11515	-0.04617	0.02342	0.09984	0.17485	0.25259	0.33488	0.41886	0.50541	0.5943	0.68525	0.77882	0.87443	0.97259	1.07332	1.17598	1.28064	1.38746	1.49621];
CDdat = [0.01488	0.01337	0.01243	0.01216	0.01274	0.01419	0.01675	0.02062	0.02583	0.03254	0.04089	0.05094	0.06295	0.07691	0.09313	0.11168	0.13268	0.15626	0.18255	0.2117];
% CDtot = interp1(CLdat,CDdat,CL);
f = griddedInterpolant(CLdat,CDdat,'spline','none');
% f.ExtrapolationMethod = 'NONE';
CDtot = f(CL);
end

