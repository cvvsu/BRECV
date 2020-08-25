function [idx_BRCV, idx_BRECV, idx_BRECVD] = get_BRECV(im)

% ------------------------------------
% Aug. 14, 2020
% version: 3.0
% Get the indexes of BRCV, BRECV, and BRECVD methods.
%
% Parameters:
%    im (3D matrix)  --  the input hyperspectral image
%    
% Returns:
%    idx_BRCV, idx_BRECV, idx_BRECVD

% basic info
[rows, cols, chs] = size(im);
im_mat = reshape(im, rows*cols, chs);

% mean and std of each band
ch_std = std(im_mat);
ch_mean = mean(im_mat);
% figure; scatter(ch_mean, ch_std);
% xlabel('Mean'); ylabel('Standard Deviation'); title('Distribution of Mean and Standard Deviation')

% cv of each band
cv = ch_std ./ ch_mean;
[~, idx_BRCV] = sort(cv, 'descend');

% the matrix used to get BRECV and BRECVD
cv_mat = ch_std ./ ch_mean';

val(1) = -10; val(chs) = -10;
for i = 2 : chs - 1
    M = cv_mat(i-1:i+1, i-1:i+1);
    M_dif = M(2,2) - [M(1,2);M(2,1);M(3,2);M(2,3)];
    
    
    % mean increases; std decreases; directly drop these bands
    if (M_dif(1)<0&&M_dif(2)<0)||(M_dif(3)<0&&M_dif(4)<0)
        %idx_0 = [idx_0; i];
        val(i) = -10;
        continue;
    end   
    
    % get the values
    val(i) = val(i) + M(2,2)-M(2,1)-(M(1,2)-M(1,1))+M(2,2)-M(2,3)-(M(3,2)-M(3,3));    
    
end

[~, idx_BRECV] = sort(val, 'descend');

% drop adjacent bands
idx_BRECVD = [];
for i = 1 : length(idx_BRECV)
    if ismember(idx_BRECV(i)+1, idx_BRECVD) || ismember(idx_BRECV(i)-1, idx_BRECVD)
        continue
    else
        idx_BRECVD = [idx_BRECVD; idx_BRECV(i)];
    end
    
end
val_ = val(idx_BRECVD);
idx_BRECVD(val_==-10) = [];