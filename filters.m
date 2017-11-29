h = [1/2, 1, 1/2];
n = -1:1;
stem(n,h, 'filled') % Impulse response

H = fftshift(fft(h))
H_mag = abs(H)
stem(n,H_mag, 'filled')

fy = linspace(-1,1,21);
H = 1 + cos(2*pi*fy)
stem(fy,(abs(H)), 'filled')

omega = linspace(-pi,pi,21);
H = 1 + cos(omega);
stem(fy,(abs(H)), 'filled')

ft = linspace(-1,1,21);
[X,Y] = mesh(fy,ft)
