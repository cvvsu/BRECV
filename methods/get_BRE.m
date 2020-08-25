function [idx_BRE, idx_BRED] = get_BRE(im)

% ------------------------------------
% Aug. 14, 2020
% version: 3.0
% Get the indexes of BRE and BRED methods.
%
% Parameters:
%    im (3D matrix)  --  the input hyperspectral image
%    
% Returns:
%    idx_BRE, idx_BRED


[rows, cols, chs] = size(im);
sz = rows*cols;
im_mat = reshape(im, sz, chs);

im_min = min(im_mat(:));
if im_min <= 0
    im_mat = im_mat + abs(im_min) + 1;
end

% convert image to float type, as some data sets has very lager value
% ranges (0-65536), which exceeds the limit of MATLAB.
im_mat = im_mat / max(im_mat(:));
ent_left = zeros(chs, 1); ent_right = zeros(chs, 1);
ent = zeros(chs, 1);

% https://stackoverflow.com/questions/23691398/mutual-information-and-joint-entropy-of-two-images-matlab

for i = 1 : chs - 1
    [~, ~, ind1] = unique(im_mat(:,i));
    [~, ~, ind2] = unique(im_mat(:,i+1));
    joint_hist = accumarray([ind1, ind2], 1);
    hist1 = sum(joint_hist,2);
    hist2 = sum(joint_hist,1);
    ent(i) = get_im_entropy(hist1, sz);
    ent(i+1) = get_im_entropy(hist2, sz);
    joint_ent = get_im_entropy(joint_hist, sz);
    ent_left(i+1) = joint_ent - ent(i);
    ent_right(i) = joint_ent - ent(i+1);    
end
ent_dif = ent_left + ent_right;
[~, idx_BRE] = sort(ent_dif, 'descend');


idx_BRED = [];
for i = 1 : length(idx_BRE)
    if ismember(idx_BRE(i)+1, idx_BRED) || ismember(idx_BRE(i)-1, idx_BRED)
        continue
    else
        idx_BRED = [idx_BRED; idx_BRE(i)];
    end
    
end


