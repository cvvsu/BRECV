function [im, imc, gt] = read_images(fn)

% --------------------------------------
% July 26, 2020
% version: 3.0
% Read images 
%
% Parameters:
%    fn (str)  -- the filename without '.mat', such as 'Indian_pines'
% 
% Returns:
%    im  (double, 3D matrix)  --  the hyperspectral image
%    imc (double, 3D matrix)  --  the corrected hyperspectral image
%    gt  (couble, 2D matrix)  --  ground labels for each class

% add the subpaths 
addpath(genpath(pwd));

% get related file names
fn_im = [fn '.mat'];
fn_gt = [fn '_gt.mat'];
fn_imc = [fn '_corrected.mat'];

% read related files
im = importdata(fn_im);
gt = importdata(fn_gt);

% check whether the corrected image exists
% load the corrected image if true
if exist(fn_imc, 'file')
    imc = importdata(fn_imc);
else
    imc = [];
end


