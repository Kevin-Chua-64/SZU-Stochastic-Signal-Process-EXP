function [Sx] = correlogram_method(x, len)
    % Autocorrelation (x-axis from -(len/2-1) to (len/2-1), (len-1) in total)
    Rx = zeros(2*(len/2)-1, 1);
    % Calculate autocorrelation
    for m=1:len/2
        x1 = x(m:len);
        x2 = x(1:len+1-m);
        Rx(len/2 + m-1) = x1*x2' / len;
        Rx(len/2 - m+1) = Rx(len/2 + m-1);     % Rx(-m) = Rx(m)
    end
    
    Sx = abs(fft(Rx));
end