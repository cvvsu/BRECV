clear; close all; clc;
dbstop if error;
warning off;

% add paths
addpath(genpath(pwd));

%% read images
fn = 'Indian_pines';
[im, imc, gt] = read_images(fn);
if ~isempty(imc)
    im = imc;
end

%% select bands
[idx_BRCV, idx_BRECV,idx_BRECVD] = get_BRECV(im);
[idx_BRE, idx_BRED] = get_BRE(im);    % entropy costs more time than CV based methods

%% evaluation
num_select = 30;
loop_times = 1;  % please kindly change this parameter, we use 100

% the base line
[base_svm, base_knn] = get_classification_acc(im, gt, loop_times);

BRCV_svm = []; BRCV_knn = [];
BRECV_svm = []; BRECV_knn = [];
BRECVD_svm = []; BRECVD_knn = [];
BRE_svm = []; BRE_knn = [];
BRED_svm = []; BRED_knn = [];

for i = 1 : num_select
    [BRCV_svm_, BRCV_knn_] = get_classification_acc(im(:,:,idx_BRCV(1:i)), gt, loop_times);
    [BRECV_svm_, BRECV_knn_] = get_classification_acc(im(:,:,idx_BRECV(1:i)), gt, loop_times);
    [BRECVD_svm_, BRECVD_knn_] = get_classification_acc(im(:,:,idx_BRECVD(1:i)), gt, loop_times);
    [BRE_svm_, BRE_knn_] = get_classification_acc(im(:,:,idx_BRE(1:i)), gt, loop_times);
    [BRED_svm_, BRED_knn_] = get_classification_acc(im(:,:,idx_BRED(1:i)), gt, loop_times);
    BRCV_svm = [BRCV_svm, BRCV_svm_]; BRCV_knn = [BRCV_knn, BRCV_knn_];
    BRECV_svm = [BRECV_svm, BRECV_svm_]; BRECV_knn = [BRECV_knn, BRECV_knn_];
    BRECVD_svm = [BRECVD_svm, BRECVD_svm_]; BRECVD_knn = [BRECVD_knn, BRECVD_knn_];
    BRE_svm = [BRE_svm, BRE_svm_]; BRE_knn = [BRE_knn, BRE_knn_];
    BRED_svm = [BRED_svm, BRED_svm_]; BRED_knn = [BRED_knn, BRED_knn_];
    clear *svm_ *knn_
end

% save results
save res.mat *_svm *_knn
