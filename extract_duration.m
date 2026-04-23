% Script for extracting contraction durations from sleep trials 

data = load('BIG_DATA_Basak_Este.mat');
trial_info = readtable('Trial_information_narcolepsy.csv');

data_info = data.DATA;

fs = 250; % sampling frequency 

% removing where presentation is zero 
% data_info(data_info.Presentation == 0, :) = [];
contractions = data_info.Contractions;
N = length(contractions); % number of subjects 

% take subject, nap number, and trigger order info for each 
subject = data_info.Sujet;
nap_num = data_info.Bloc;
triggers_order = data_info.Triggers_Order;


% duration array for each contraction 
duration_mat = zeros(N,1);  

for i=1:N
    curr_contr = contractions{i}; 
    
    if (data_info.Presentation(i) == 1)
        if (isempty(curr_contr))
            duration_mat(i) = 0; 
        else
            last_ind = size(curr_contr,2);
            duration_mat(i) = (curr_contr(2,last_ind) - curr_contr(1,1))/fs; 
        end 
    else
        duration_mat(i) = NaN; 
    end 

end 
 
% concatenate to make a durations matrix for given subject, nap, epoch 
duration_data = table(subject, nap_num, triggers_order, duration_mat);
trial_info.Duration = duration_mat; 

writetable(trial_info, '/Users/zeynepozkaya/Desktop/SoundSleep/trial_info_duration.csv');