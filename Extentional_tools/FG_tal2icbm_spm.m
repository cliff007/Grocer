function outpoints = FG_tal2icbm_spm(inpoints)
%
% This function converts coordinates from Talairach space to MNI
% space (normalized using the SPM software package) using the 
% tal2icbm transform developed and validated by Jack Lancaster 
% at the Research Imaging Center in San Antonio, Texas.
%
% http://www3.interscience.wiley.com/cgi-bin/abstract/114104479/ABSTRACT
% 
% FORMAT outpoints = icbm_spm2tal(inpoints)
% Where inpoints is N by 3 or 3 by N matrix of coordinates
% (N being the number of points)
%
% ric.uthscsa.edu 3/14/07
if nargin==0
    dlg_prompt={'Enter a Tailarch Coord.: x{mm} ,y{mm} ,z{mm},or you can just close this window to select a Coord. txt file'};
    dlg_name='SPM (MNI) coordinate';
    inpoints=inputdlg(dlg_prompt,dlg_name);

    %% otherwise inquery many coordinates one time in a .txt file
     if isempty(inpoints) || strcmp(inpoints{1},'')
        % select the .txt file that contain all the sphere coordinate (as below)
                % coordinate.txt  (if your file is .mat format, please load and save as .txt first, sorry!)
                    % the coordinates it contain is as below( a group of x/y/z(mm) each line)
                    %      1     2     3
                    %      4     5     6
                    %     -1    -2    -3
          if strcmp(spm('ver',[],1),'SPM5')|strcmp(spm('ver',[],1),'SPM8')
               coord_txt = spm_select(1,'.txt','Select the txt file where the voxel-space coordinates are in:', [],pwd,'.*txt');
               eval(['inpoints=load(''' coord_txt ''');']);
          end
     else
         inpoints=str2num(inpoints{1});    
     end
end

% inpoints=inpoints;

dimdim = find(size(inpoints) == 3);
if isempty(dimdim)
  error('input must be a N by 3 or 3 by N matrix')
end
if dimdim == 2
  inpoints = inpoints';
end

% Transformation matrices, different for each software package
icbm_spm = [0.9254 0.0024 -0.0118 -1.0207
	   	   -0.0048 0.9316 -0.0871 -1.7667
            0.0152 0.0883  0.8924  4.0926
            0.0000 0.0000  0.0000  1.0000];

% invert the transformation matrix
icbm_spm = inv(icbm_spm);

% apply the transformation matrix
inpoints = [inpoints; ones(1, size(inpoints, 2))];
inpoints = icbm_spm * inpoints;

% format the outpoints, transpose if necessary

outpoints = inpoints(1:3, :);
if dimdim == 2
  outpoints = outpoints';
end
fprintf('\n\n-------see the output below(row by row):\n')