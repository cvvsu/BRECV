function im_ent = get_im_entropy(im_hist, nums)

% https://stackoverflow.com/questions/23691398/mutual-information-and-joint-entropy-of-two-images-matlab



im_hist_no_zero = nonzeros(im_hist);
im_prob = im_hist_no_zero / nums;
im_ent = -sum(im_prob.*log2(im_prob));