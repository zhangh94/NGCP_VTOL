function [ CDtot ] = DragPolar( CL )
%DRAGPOLAR Returns CDtot for a given CL based on VLM from VSPAERO
%   Iter 6

% TODO: Decide to use VSPAERO CD0 or drag build up CD0
% alpha = linspace(-5,15,20);
CLdat = [-0.04138	0.02924	0.09855	0.16724	0.23734	0.30827	0.37934	0.45087	0.52327	0.59734	0.67079	0.7384	0.83632	0.90557	0.98885	1.07254	1.15808	1.24495	1.3329	1.4231	1.51295];
CDdat = [0.01397	0.01367	0.01415	0.01542	0.01755	0.02058	0.02449	0.02933	0.03517	0.0421	0.04994	0.05828	0.07154	0.08156	0.09541	0.11063	0.12759	0.1463	0.16679	0.18944	0.21368];
% CDtot = interp1(CLdat,CDdat,CL);
f = griddedInterpolant(CLdat,CDdat,'spline','none');
% f.ExtrapolationMethod = 'NONE';
CDtot = f(CL);

plotBool = 0;

if (plotBool)
   figure
   plot(CDdat,CLdat);
   grid on;
end

end

