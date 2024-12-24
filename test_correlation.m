clear all, close all, clc;

N_test = 10;
corr_test = zeros(N_test,1);

for test_ind = 1:N_test
    
    test_ind
    clearvars -except test_ind corr_test

    one_trial_activity;
    corr_test(test_ind) = corr_amplifi(1,2);

end

mean_corr = mean(corr_test)
std_corr = std(corr_test)

clearvars -except corr_test mean_corr std_corr

save('corr_result')