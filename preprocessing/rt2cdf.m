function [Fx,t] = rt2cdf(x,p,lim)
%rt2cdf Convert reaction times to a cumulative distribution function.
%   FX = RT2CDF(X,P,LIM) returns the cumulative distribution function (CDF)
%   of the RT distribution X for the intervals P between the RT limits LIM.
%   P is a vector of decimal values between 0 and 1 inclusive and LIM is a
%   a 2-element vector containing the lower and upper RT limits in
%   milliseconds. CDFs can be averaged over subjects as long as the same
%   intervals were used to compute them (Vincent, 1912; Ratcliff, 1979).
%   This function treats NaNs as missing values, and ignores them.
%
%   [...,T] = RT2CDF(...) returns the time intervals used to compute the
%   CDF.
%
%   See also RT2PDF, RT2CFP, CFP2PER, GETAUC.
%
%   RaceModel https://github.com/mickcrosse/RaceModel

%   References:
%       [1] Vincent SB (1912) The function of the vibrissae in the
%           behavior of the white rat. Anim Behav Monogr 1(5):84.
%       [2] Ratcliff R (1979) Group reaction time distributions and an
%           analysis of distribution statistics. Psychol Bull
%           86(3):446-461.

%   Author: Mick Crosse
%   Email: mickcrosse@gmail.com
%   Cognitive Neurophysiology Laboratory,
%   Albert Einstein College of Medicine, NY
%   Apr 2017; Last Revision: 3-May-2019

% Set default values
if nargin < 3 || isempty(lim)
    lim = [min(x),max(x)];
elseif lim(1) > lim(2)
    error('Value of LIM(1) must be < LIM(2).')
end
if nargin < 2 || isempty(p)
    p = 0.05:0.1:0.95;
end

% Get number of observations and intervals
nx = sum(~isnan(x));
np = length(p);

% Compute time intervals
t = lim(1)+p*(lim(2)-lim(1));

% Compute CDF
Fx = zeros(np,1);
for i = 1:np
    Fx(i) = nansum(x<=t(i))/nx;
end