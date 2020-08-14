function [acc_svm, acc_knn] = get_classification_acc(im, gt, loop_times, dist_KNN)

% ----------------------------------------------
% July 26, 2020
% version: 3.0
% Get the classification accuracies using SVM and KNN classifiers
%
% Parameters:
%    im (double, 3D matrix)  --  the input image
%    gt (double, 2D matrix)  --  the ground labels
%    loop_times (int, 10)    --  run several times to reduce randomness. 
%    dist_KNN   (int, 3)     --  the distance used for KNN classifier
%
% Returns:
%    acc_svm  (struct)       --  OA, AA, Kappa, J 
%    acc_knn  (struct)       --  OA, AA, Kappa, J

if nargin < 3
    loop_times = 10;
end

if nargin < 4 
    dist_KNN = 3;
end


% size of input image and reshape the data
[rows, cols, channels] = size(im);
data = reshape(im, rows*cols, channels);

% number of classes
num_classes = max(gt(:));

% ratio for training set
p = 0.1;

% pre-store the intermediate results
OA_s = zeros(loop_times,1); AA_s = zeros(loop_times,1); 
Kappa_s = zeros(loop_times, 1); J_s = zeros(num_classes, loop_times);

OA_k = zeros(loop_times,1); AA_k = zeros(loop_times,1); 
Kappa_k = zeros(loop_times, 1); J_k = zeros(num_classes, loop_times);

parfor loop_time = 1 : loop_times
    
    % pre-store the train set and the test set
    tr_x = [];   tr_y = [];
    te_x = [];   te_y = [];
    for num_class = 1 : num_classes
        curr_idx = find(gt(:)==num_class);
        num_idx = length(curr_idx);
        random_idx = curr_idx(randperm(num_idx));
        
        % get training data for current class
        num_tr = floor(num_idx * p);
        tr_idx = random_idx(1:num_tr);        
        tr_x = [tr_x; data(tr_idx, :)];
        tr_y = [tr_y; gt(tr_idx)];
        
        % get test data for current class
        te_idx = random_idx(num_tr+1:end);
        te_x = [te_x; data(te_idx, :)];
        te_y = [te_y; gt(te_idx)];       
    end  
     
     % SVM classfier
     t_svm = templateSVM('Standardize',1,'KernelFunction','rbf','BoxConstraint',10,'KernelScale','auto');
     mdl_svm = fitcecoc(tr_x, tr_y, 'Learners', t_svm, 'Coding', 'onevsall');
     pred_svm = predict(mdl_svm, te_x);
     [OA_s(loop_time),AA_s(loop_time), Kappa_s(loop_time), J_s(:, loop_time)] = interpret_confusionmat(te_y, pred_svm);
     
     % KNN classifier
     mdl_knn = fitcknn(tr_x, tr_y, 'NumNeighbors', dist_KNN);
     pred_knn = predict(mdl_knn, te_x);
     [OA_k(loop_time),AA_k(loop_time), Kappa_k(loop_time), J_k(:, loop_time)] = interpret_confusionmat(te_y, pred_knn);
    
end

acc_svm.OA = mean(OA_s); acc_svm.AA = mean(AA_s); acc_svm.Kappa = mean(Kappa_s); acc_svm.J = mean(J_s, 2);
acc_knn.OA = mean(OA_k); acc_knn.AA = mean(AA_k); acc_knn.Kappa = mean(Kappa_k); acc_knn.J = mean(J_k, 2);


