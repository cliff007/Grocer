function img=FG_make_sure_NaN_to_zero_img(img)
% this function is used to make the input image is a binary image and make
% the NaN values to 0
img(isnan(img))=0;

