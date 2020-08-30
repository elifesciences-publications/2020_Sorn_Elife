clc
clear;

T = 1:798:460000; %converting real time to simulation index number
load('para_for_error.mat');
load('experimental_data.mat');

%%
Error = zeros(1,20);
for i = 1:20
    
    k = para_for_error(i,:);
    
    [c1, ~] = ifn_pretreat(k,0); %ifn induction control
    [c2, ~] = ifn_pretreat(k,2);
    [c3, ~] = ifn_pretreat(k,10);
    [c4, ~] = ifn_pretreat(k,24);
    r = [c2/c1 c3/c1 c4/c1]*5000; %weighted priming experiment result
    
    [~,prolonged] = ifn_pretreat(k,-1,T);    
    fitted_data = [prolonged';r'];    
    Error(i) = sum((fitted_data-data_to_fit).^2);

end

scatter(1:20,Error,'ko','filled')
xlabel('time delay')
ylabel('error')
alpha(0.8)
title('all error')
