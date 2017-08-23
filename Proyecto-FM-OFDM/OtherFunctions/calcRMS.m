function rms = calcRMS(x)
% RMS calculator of a signal x (should be a vector)

rms = sqrt(mean(abs(x).^2));

end

