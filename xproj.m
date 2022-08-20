% Radek Duchon (xducho07)
% Projekt ISS
% FIT VUT 2018/2019

pkg load signal

%1. uloha
[y, Fs] = audioread("xducho07.wav");
N = length(y); %Pocet vzorku

printf("Vzorkovaci frekvence signalu: %d\n", Fs)
printf("Pocet vzorku signalu: %d\n", N)
printf("Delka signalu v sekundach %d\n", N/Fs)
printf("Pocet reprezentovanych binarnich symbolu: %d\n", N/16)

%2.uloha
x = y(8:16:end);
for i = 1:length(x)
  if x(i) > 0
    x(i) = 1;
  else
    x(i) = 0;
  endif
endfor

figure(1)
plot(linspace(0, 0.02, Fs/50), y(1:Fs/50))
hold on
stem(((1:20)*16-8)/Fs, x(1:20))
xlabel("t")
ylabel("s[n], symbols")
title("Exercise 2")
axis('tight')
grid on
hold off


%3.uloha
B = [0.0192, -0.0185, -0.0185, 0.0192];
A = [1.0000, -2.8870, 2.7997, -0.9113];
figure(2)
zplane(B, A); %stabilni
axis('tight')
title("Exercise 3")

%4.uloha
figure(3)
H = abs(freqz(B, A, Fs/2));
plot(H);%Dolni H
xlabel("f (Hz)")
ylabel("|H(f)|")
axis('tight')
title("Exercise 4")
grid on

[val, ind] = min(H(1:length(H)/2));
for i = (1:length(H))
  if H(i)*sqrt(2) <= H(1)
    printf("Mezni frekvence: %dHz\n", i);
    break;
  endif
endfor


%5.uloha
ssn = filter(B, A, y);
figure(4)
plot(linspace(0, 0.02, Fs/50), ssn(1:Fs/50))
hold on
plot(linspace(0, 0.02, Fs/50), y(1:Fs/50))
xlabel("t")
axis('tight')
title("Exercise 5")
grid on
hold off


%6.uloha
xshifted = ssn(8+17:16:end);
for i = 1:length(xshifted)
  if xshifted(i) > 0
    xshifted(i) = 1;
  else
    xshifted(i) = 0;
  endif
endfor

figure(5)
plot(linspace(0, 0.02, Fs/50), y(1:Fs/50))
hold on
plot(linspace(0, 0.02, Fs/50), ssn(1:Fs/50))
plot(linspace(0, 0.02, Fs/50), ssn(1+17:Fs/50+17))
stem(((1:20)*16-8)/Fs, xshifted(1:20))
xlabel("t")
ylabel("s[n], ss[n], ssshifted[n], symbols")
axis('tight')
title("Exercise 6")
grid on
hold off


%7.uloha
z = 0;

for i = 1:length(xshifted)
  if xshifted(i) != x(i)
    z = z + 1;
  endif
endfor
printf("Pocet chyb: %d\nChybovost: %f%%\n", z, z/length(xshifted)*100)

%8.uloha
figure(6)
plot(abs(fft(y))(1:Fs/2))
hold on
plot(abs(fft(ssn))(1:Fs/2))
xlabel("Hz")
title("Exercise 8")
grid on;
hold off;


%9.uloha
figure(7)
p = hist(y,50)/N;
plot(linspace(-50, 50, length(p)), p)
xlabel("x")
title("Exercise 9\nOdhad funkce hustoty rozdeleni pravdepodobnosti p(x, 50)")
axis('tight')
grid on
printf("Integral: %f\n", sum(p));


%10.uloha
R = xcorr(y, 50, "biased");
figure(8)
plot(-50:50, R)
xlabel("k");
ylabel("R[k]");
title("Exercise 10");
axis('tight');


%11.uloha
printf("R(0): %f\nR(1): %f\nR(16): %f\n", R(51+0), R(51+1), R(51+16));


%12.uloha
figure(9)
kolik = 50;
ksi = zeros(kolik, kolik);
ymin = min(y);
ymax = max(y);
roz = ymax-ymin;
x = linspace(ymin, ymax, kolik);
for i = 1:N-1
  ksi(round((y(i)-ymin)/roz*(kolik-1))+1,round((y(i+1)-ymin)/roz*(kolik-1))+1) += 1;
endfor
p = ksi/(N-1);
imagesc(x, x, p/(x(1)-x(2))*(x(1)-x(2)));
colorbar;
xlabel("x2")
ylabel("x1")
title("Exercise 12")
axis xy;


%13.uloha
printf("Integral(overeni): %f\n", sum(sum(p)));


%14.uloha
suma = 0;
for i = 1:kolik
  for ii = 1:kolik
    suma += p(i, ii) * x(i) * x(ii);
  endfor
endfor

printf("R[1]: %f\n", suma);


