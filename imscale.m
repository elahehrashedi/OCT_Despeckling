function [Aout] = imscale(Ain)
% Simple function to scale down GPR image
% [Aout] = imscale(Ain)
% Scales data in Ain from any range to 0-1 range.
% Scaled data is stored in Aout.
%
% June 2012
Amin = min(min(Ain));
Amax = max(max(Ain));
if(Amin < 0)
Ain = Ain - Amin;
end
Amax = max(max(Ain));
Aout = Ain/Amax;