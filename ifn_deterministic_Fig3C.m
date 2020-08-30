load('best_para.mat', 'new_var')
k = new_var(1,:); %parameter for original model
k(6) = round(k(6));

%%
[c1, ~] = ifn_pretreat(k,0);
[c2, ~] = ifn_pretreat(k,2);
[c3, ~] = ifn_pretreat(k,10);
[c4, ~] = ifn_pretreat(k,24);
r = [c1/c1 c2/c1 c3/c1 c4/c1];

