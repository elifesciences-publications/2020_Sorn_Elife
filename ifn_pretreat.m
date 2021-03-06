function [output, output2] = ifn_pretreat(k, pretreatTime, R)
% function to simulate each experiment
    % output is empty for sustained input, 
    % output2 in empty for 0 2 10 24
    switch pretreatTime
        case 0
            len = 20; % this is the control
        case 2
            len = 30; 
        case 10
            len = 38;            
        case 24
            len = 52;  
        case -1
            len = 46; % this is the sustained input
    end

    dt = 0.0001; 
    total_step = round(len/dt);
    thresh = k(6)/dt;
    
    %% initialize array and asign initial conditions
    irf = zeros(1,total_step+1);
    irf(1) = 45;
    usp = zeros(1,total_step+1);
    t =  zeros(1,total_step+1);
    
    pf = @(X) k(1)*X/(k(2)+X); nf = @(X) (k(3)/(k(3)+X));
    
    %% stimulation 
    ifn = zeros(1,total_step+1)-1;
    switch pretreatTime 
        case 0
            % for control
            ifn = zeros(1,total_step+1)-1;
            sti_length = 10/dt;
            ifn(1:sti_length+1) = 0:sti_length;
        case -1
            % for sustained input
            ifn = 0:total_step;
        otherwise
            % for other pretreatment
            sti_length1 = pretreatTime/dt; 
            sti_length2 = 10/dt;

            ifn(1:sti_length1+1) = 0:sti_length1;
            starting_pos = sti_length1+8/dt+2; 
            ifn(starting_pos:starting_pos+sti_length2) = 0:sti_length2;
    end
    sti_u = (ifn>=thresh); sti_i = (ifn>=0);   
    
    %% simulate steps
    for i = 1:total_step
        p = pf(irf(i));    n = nf(usp(i));

        di = sti_i(i)*(k(4)+p)*n;
        du = sti_u(i)*(k(5)+p)*n;

        irf(i+1) = irf(i) + dt*di;
        usp(i+1) = usp(i) + dt*du;
        t(i+1) = t(i) + dt;
    end
    
    %% output
    switch pretreatTime
        case 0 % for control
            output = irf(end) - irf(1);
            output2 = [];
        case -1 % for sustained input
            output = [];
            output2 = irf(R); 
        otherwise % for other pretreatment
            st = find(t>=(len-20),1);
            output = irf(end)-irf(st);
            output2 = [];
    end
end



