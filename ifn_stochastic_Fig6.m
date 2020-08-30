clc
clear all

%% parameters
load('best_para.mat', 'new_var')
k = new_var(1,:);
cell_cycle_len = 21.82;
n1 = 300; %noise irf
n2 = 1400; %noise usp
numb_of_cells = 400; % number of cells

%% initialize
i2 = zeros(1,numb_of_cells);
u2 = zeros(1,numb_of_cells);
i10 = zeros(1,numb_of_cells);
u10 = zeros(1,numb_of_cells);
i24 = zeros(1,numb_of_cells);
u24 = zeros(1,numb_of_cells);

%% simulate all cells
for i = 1:numb_of_cells
    
    delay = cycle(cell_cycle_len); %generating cell cycle dependent delay, function cycle provided below
    k(6) = delay;
    k(6) = max(0,k(6));

    [i2(i),u2(i)] = ifn_s(k,n1,n2,2); % ifn_s is the function for simulating one trajectory, function provide below
    [i10(i),u10(i)] = ifn_s(k,n1,n2,10);
    [i24(i),u24(i)] = ifn_s(k,n1,n2,24);
end


%% plotting
figure(1)
scatter(u2,i2,'go','filled')
hold on
scatter(u10,i10,'bo','filled')
scatter(u24,i24,'ro','filled')

legend('2hr','10hr','24hr')
alpha(0.5)
hold off


%%
function delay = cycle(tl)
    % generating cell cycle dependent delay
    dt = .001;
    active = 7.3; % length of active phase during one cell cycle
    T1 = 0:dt:tl;
    c = (T1<active); % one complete cell cycle profile

    c = [c c]; %2 cell cycle profiles
    T = linspace(0,2*tl,length(c)); %associated time coordinate
    start_index = randi([1 length(T1)]); %start at a random time in the cell cycle
    cropped_cycle = c(start_index:end);
    delay_index = find(cropped_cycle==1,1); %find the first time instance within the cropped cell cycle where transcription is allowed
    T_new = T(start_index:end)-T(start_index); % shift time coordinate
    delay = max(0,T_new(delay_index)); % find the delay time
end

function [irf_in,usp_level] = ifn_s(k,n1,n2, pretreatTime)

    switch pretreatTime
        case 2
            len = 45; 
        case 10
            len = 53;            
        case 24
            len = 67;
    end
    dt = 0.001;
    total_step = round(len/dt);
    
    %% initialize array and asign initial conditions

    thresh = k(6)/dt;
    irf = zeros(1,total_step+1);
    irf(1) = 45;
    usp = zeros(1,total_step+1);
    t =  zeros(1,total_step+1);

    pf = @(X) k(1)*X/(k(2)+X); nf = @(X) (k(3)/(k(3)+X));
    %% stimulation 
    ifn = zeros(1,total_step+1)-1;
    sti_length1 = pretreatTime/dt;
    sti_length2 = 35/dt;

    ifn(1:sti_length1+1) = 0:sti_length1;
    starting_pos = sti_length1+8/dt+2;
    ifn(starting_pos:starting_pos+sti_length2) = 0:sti_length2;
    sti_u = (ifn>=thresh); sti_i = (ifn>=0);
    
    %% simulation steps
    for i = 1:total_step
        p = pf(irf(i));    n = nf(usp(i));

        di = sti_i(i)*(k(4)+p)*n;
        du = sti_u(i)*(k(5)+p)*n;

        irf(i+1) = max(irf(i) + dt*di + dt*n1*randn,0);
        usp(i+1) = max(usp(i) + dt*du + dt*n2*randn,0);
        t(i+1) = t(i) + dt;
    end
    
    %% output
    irf(end) = max(irf(end),0);
    usp(end) = max(usp(end),0);  

    st = find(t>=(len-34),1);
    irf_in = irf(end)-irf(st);
    usp_level = usp(st);
end