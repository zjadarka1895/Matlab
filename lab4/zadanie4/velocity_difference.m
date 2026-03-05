function velocity_delta = velocity_difference(t)
% t - czas od startu rakiety
u=2000;
m0=150000;
q=2700;
g=1.622;
M=700;
 if t <= 0 
        error('Czas musi być w wiekszy od zera');
 end
v = u * log(m0 / (m0 - q * t)) - g * t;
velocity_delta = v-M;

end