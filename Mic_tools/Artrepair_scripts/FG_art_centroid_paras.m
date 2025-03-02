function  Output = FG_art_centroid_paras(Y)
% FORMAT  Output = art_centroid(Y)
%     Calculates VERY APPROXIMATE movement parameters, in case
%  no realignment file is available. If no argument, a GUI asks
%  user for an image. All dimensions are in voxels.
%
% INPUT:  A 3D matrix of an image got from spm_read_vols
% FUNCTION:  For a scan volume, compute the mean intensity and 
%      centroid positions in each coordinate direction. No mask is
%      applied. 
% OUTPUT:  Output is 1x4 vector.
%  Output(1)   = mean intensity of the 3D image
%  Output(2:4) = mean position of data, in X,Y, and Z directions.
%       
% Paul Mazaika - July 2004   [ no code updates for v.2 ]
% v3.  added multi SPM versions. Mar09

% revised by cliff: 
% Be careful:  "Centroid" is the physical center of an image that is
% related to its image intensity~~

spmv = spm('Ver'); spm_ver = 'spm2';
if (strcmp(spmv,'SPM5') || strcmp(spmv,'SPM8b') || strcmp(spmv,'SPM8') )
    spm_ver = 'spm5'; end

if ( nargin == 0 )
    if strcmp(spm_ver,'spm5')
         F = spm_select(1, 'image', 'Select one image'); 
    else  % spm2 version
         F = spm_get(1, '.img', 'Select one image');
    end
    %F  = spm_get(Inf,'.img','select one image');
    % if it's an array, might want to select one image.
    f = deblank(F(1,:));  % was F(1,:)   % cliff: original one is : deblank(F(54,:))
    V = spm_vol(f);
    Y = spm_read_vols(V);   % Y is double, size 2MB; 
end

[ NX, NY, NZ ] = size(Y);

%  Find the global properties
Ymean = mean(mean(mean(Y)));   % Average intensity
planex = zeros(NX,1);
planey = zeros(NY,1);
planez = zeros(NZ,1);
%  Moment arrays in x,y, and z directions.
momx = 0; sumx = 0;
for i = 1:NX
    planex(i) = mean(mean(Y(i,:,:)));
    momx = momx + i*planex(i);
    sumx = sumx + planex(i);
end
momy = 0; sumy = 0;
for i = 1:NY
    planey(i) = mean(mean(Y(:,i,:)));
    momy = momy + i*planey(i);
    sumy = sumy + planey(i);
end
momz = 0; sumz = 0;
for i = 1:NZ
    planez(i) = mean(mean(Y(:,:,i)));
    momz = momz + i*planez(i);
    sumz = sumz + planez(i);
end

% Set return values
Output(1) = Ymean;
Output(2) = momx/sumx;  % cliff,  x-coordinate of the centroid of the 3D image
Output(3) = momy/sumy;  % cliff,  x-coordinate of the centroid of the 3D image
Output(4) = momz/sumz;  % cliff,  x-coordinate of the centroid of the 3D image

% cliff
% by getting the centroid of a series of images, we can measure
% the  motion these series of images very approximately
