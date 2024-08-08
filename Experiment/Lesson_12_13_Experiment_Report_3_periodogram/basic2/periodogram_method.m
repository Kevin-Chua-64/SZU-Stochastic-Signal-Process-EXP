function [Sx] = periodogram_method(x, len)
    Xk = abs(fft(x));
    Sx = Xk.^2 / len;
end