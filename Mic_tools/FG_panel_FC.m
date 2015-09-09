
function FC_Paras=FG_panel_FC
clc  
warning off all
% only allow one instance of this toolbox
hdl=findobj('Tag','FG_GUI');
if ~isempty(hdl)
%     uiresume; %% quite the "uiwait"
    close (hdl)
    clear hdl
end


%     % Make Display correct in linux
%     if ~ispc
% ZoomFactor=0.8;  %ZoomFactor=0.85;
% ObjectNames = fieldnames(handles);
% for i=1:length(ObjectNames);
%     eval(['IsFontSizeProp=isprop(handles.',ObjectNames{i},',''FontSize'');']);
%     if IsFontSizeProp
% eval(['PCFontSize=get(handles.',ObjectNames{i},',''FontSize'');']);
% FontSize=PCFontSize*ZoomFactor;
% eval(['set(handles.',ObjectNames{i},',''FontSize'',',num2str(FontSize),');']);
%     end
% end

%%%%%%%%% Start: initial figure window %%%%%%%%%

        %-Open startup window, set window defaults
        %-Get size and scalings and create Menu window
        FGtitle='Functional Connectivity...';
        S = get(0,'ScreenSize');
        if all(S==1), error('Can''t open any graphics windows...'), end

        [WS FS PF Rect bno bgapr bh gh by bx bw]=Exec_getwinDef;

        %-Draw fmri_grocer window
        Fig_handle = figure( ...
            'IntegerHandle','off',...
            'Name',['Panel for ' FGtitle],...
            'NumberTitle','off',...
            'Tag','FG_GUI',...
            'Position',Rect.*WS,...
            'Resize','off',...
            'MenuBar','none',...
            'DefaultTextFontName',PF.helvetica,...
            'DefaultTextFontSize',FS(6),...
            'DefaultUicontrolFontName',PF.times,...
            'DefaultUicontrolFontSize',FS(11),...
            'DefaultUicontrolInterruptible','on',...
            'Renderer','painters',...
            'Visible','off' ...
            );


        %     UpdateDisplay(handles);
        %     movegui(handles.figCSMain, 'center');
        % 	set(handles.figCSMain,'Name','Regress Out Covariables');



        %- Setting up checkboxes, text-edit boxes and buttons
        %=======================================================================
         uicontrol(Fig_handle,'Style','Frame','Back',[1,0,1], ...
             'BackgroundColor',[1,1 1],...
             'Units','pixels', ...
             'Position',[bx-5 by(2)-15 bw+18 bh*2.2].*WS); 
         
         uicontrol(Fig_handle,'Style','Frame','Back',[1,0,1], ...
             'BackgroundColor',[1,1 1],...
             'Units','pixels', ...
             'Position',[bx-5 by(8)-5 bw+18 bh*5.2].*WS); 
         
         uicontrol(Fig_handle,'Style','Frame','Back',[1,0,1], ...
             'BackgroundColor','w',...
             'Units','pixels', ...
             'Position',[bx-5 by(9)-5 bw+18 bh*0.9].*WS);          
                
%          uipanel(Fig_handle,'Title','hello','FontSize',12,...
%              'FontSize',10, ...
%              'BackgroundColor','w',...
%              'Units','pixels', ...
%              'Position',[bx-5 by(3)-2 bw+6 bh*3.2].*WS);


        h_detrend=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx by(1) bw*0.15 bh*0.45].*WS,...
              'String','Detrend', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@detrend);  

        h_bandpass=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx by(2) bw*0.2 bh*0.45].*WS,...
              'String','BandPASS', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@bandpass); 

        h_bandpass_low=uicontrol(Fig_handle,'Style','edit', ...
              'Position',[bx+bw*0.2+10 by(2) bw*0.15 bh*0.8].*WS,...
              'String','0.01', ...
              'ToolTipString','Enter the low-limit of the Freq. band',...
              'ForeGroundColor','b',...
              'FontWeight','BOLD',...
              'FontSize',FS(14),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@bandpass_low);


        uicontrol(Fig_handle,'Style','edit',...
              'Position',[bx+bw*0.4+10 by(2) bw*0.35 bh*0.8].*WS,...
              'String',' < Low Freq. -|- High Freq. >', ...
              'HorizontalAlignment','center', ...
              'ToolTipString','----',...
              'ForeGroundColor','black',...
              'FontSize',FS(11),...
              'FontWeight','BOLD',...
              'backgroundcolor','g' , ...
              'Tag','run_b',...      
              'Interruptible','off'); 

        h_bandpass_up=uicontrol(Fig_handle,'Style','edit', ...
              'Position',[bx+bw*0.8+10 by(2) bw*0.15 bh*0.8].*WS,...
              'String','0.08', ...
              'ToolTipString','Enter the up-limit of the Freq. band',...
              'ForeGroundColor','b',...
              'FontWeight','BOLD',...
              'FontSize',FS(14),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@bandpass_up);


        uicontrol(Fig_handle,'Style','text',...
              'Position',[bx by(3) bw bh*0.5].*WS,...
              'String','--- Specify ROI and Covariates for FC As below ---', ...
              'HorizontalAlignment','Center', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontWeight','BOLD',...
              'FontSize',FS(12),...
              'Tag','run_b',...      
              'Interruptible','off');  

        h_rois=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx by(4) bw bh*0.45].*WS,...
              'String','Choose ROIs for functional connectivity...', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_rois);   

        h_globalmean=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx by(5) bw*0.5 bh*0.45].*WS,...
              'String','Remove global mean', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_globalmean); 

        h_headmotion=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx+bw*0.5+10 by(5) bw*0.5 bh*0.45].*WS,...
              'String','Remove 6 head-motion parameters', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_headmotion); 

        h_white=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx by(6) bw*0.5 bh*0.45].*WS,...
              'String','Remove white matter signal', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_white); 

        h_csf=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx+bw*0.5+10 by(6) bw*0.5 bh*0.45].*WS,...
              'String','Remove CSF signal', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_csf); 

        h_covs=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx by(7) bw*0.5 bh*0.45].*WS,...
              'String','Choose more covariate files (txt)', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','black',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_covs);   

        listItems = {'1. ROI-AllVoxels','2. ROIs-ROIs','3. Voxel-AllVoxels', '4. The first Two (1. & 2.)'};
        h_types=uicontrol(Fig_handle,'Style','listbox',...
          'Position',[bx+bw*0.5+10 by(8) bw*0.5 bh*1.8].*WS,...
          'ListboxTop',1, ...
          'String',listItems, ...
          'ToolTipString','Select a FC type you want to perform',...
          'ForeGroundColor','black',...
          'FontSize',FS(10),...
          'Tag','run_b',...      
          'Interruptible','off',...
          'CallBack',@FC_types); 

        h_alff=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx by(9) bw*0.5 bh*0.45].*WS,...
              'String','   (f)ALFF/m(f)ALFF-1', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','g',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_alff); 

        h_reho=uicontrol(Fig_handle,'Style','checkbox', ...
              'Position',[bx+bw*0.5+10 by(9) bw*0.5 bh*0.45].*WS,...
              'String','   (sm)ReHo/(s)mReHo-1 [27-Voxel] ', ...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','g',...
              'FontSize',FS(10),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@FC_reho); 



        h_save=uicontrol(Fig_handle,'String','Save settings',...
              'Position',[bx+bw*0.1 by(10)*0.68 bw*0.25 bh].*WS,...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','b',...
              'FontWeight','BOLD',...
              'FontSize',FS(15),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@savesetting); 

        h_load=uicontrol(Fig_handle,'String','Load settings',...
              'Position',[bx+bw*0.4 by(10)*0.68 bw*0.25 bh].*WS,...
              'ToolTipString','Do you want to do this?',...
              'ForeGroundColor','r',...
              'FontWeight','BOLD',...
              'FontSize',FS(15),...
              'Tag','run_b',...      
              'Interruptible','off',...
              'CallBack',@loadsetting); 

        h_ok=uicontrol(Fig_handle,'String','OK',...
              'Position',[bx+bw*0.7 by(10)*0.68 bw*0.25 bh*1.2].*WS,...
              'ToolTipString','exit the fmri_grocer',...
              'ForeGroundColor','black',...
              'FontSize',FS(30),...
              'FontWeight','BOLD',...
              'Interruptible','off',...
              'CallBack',@OK);

         handles.detrend=h_detrend;
         handles.bandpass=h_bandpass;
         handles.bandpass_low=h_bandpass_low;
         handles.bandpass_up=h_bandpass_up;
         handles.rois=h_rois;
         handles.globalmean=h_globalmean;
         handles.headmotion=h_headmotion;
         handles.white=h_white;
         handles.csf=h_csf;
         handles.covs=h_covs;
         handles.types=h_types;
           handles.alff=h_alff;
           handles.reho=h_reho;
         handles.save=h_save;
         handles.load=h_load;
         handles.ok=h_ok;

         set(Fig_handle,'userdata',handles);
        %=======================================================================
        % after drawing the figure, set it into visible and on top
        set(Fig_handle,'Visible','on')
        % FC_Paras=guidata(Fig_handle);
        FC_Paras.handles=handles;
       %% get the original values of all uicontrols
        collect_and_set_fig_paras(Fig_handle,handles)   ;
       
        guidata(Fig_handle,FC_Paras); % save the Fig_handle into Guidata
        set(Fig_handle,'userdata',handles); % set the 'userdata' of Fig_handle as handles
        % FC_s=guidata(Fig_handle);
        
        % FG_setAlwaysOnTop(Fig_handle,1); % make this figure always ontop,and this makes trouble for sub-GUIs such as file selecting
%         uiwait(Fig_handle) % 
        FC_Paras=FG_load_FC_panel_parameters('FC_Paras.mat'); % after close the GUI, read out the saved .mat file to get the output variable.
        
        fprintf('\n...')
%%%%%%%%% END: initial figure window %%%%%%%%%

%% parameter collecting
function FC_Paras=collect_and_set_fig_paras(Fig_handle,handles)
       %% get the original values of all uicontrols
        handle_names=fieldnames(handles);
        for i=1:size(handle_names,1)-3
            if strcmp(handle_names{i},'bandpass_low') || strcmp(handle_names{i},'bandpass_up')
                eval(['FC_Paras.val_' ,deblank(handle_names{i}) '=get(handles.',deblank(handle_names{i}),',''string'');']);
            elseif strcmp(handle_names{i},'rois') || strcmp(handle_names{i},'covs')
                eval(['FC_Paras.userdata_' ,deblank(handle_names{i}) '=get(handles.',deblank(handle_names{i}),',''userdata'');']);   
                eval(['FC_Paras.val_' ,deblank(handle_names{i}) '=get(handles.',deblank(handle_names{i}),',''value'');']);  
            else                
                eval(['FC_Paras.val_' ,deblank(handle_names{i}) '=get(handles.',deblank(handle_names{i}),',''value'');']); 
            end
        end       
       
        guidata(Fig_handle,FC_Paras); % save the Fig_handle into Guidata
        set(Fig_handle,'userdata',handles); % set the 'userdata' of Fig_handle as handles

%=======    initial position function    ==========

function  [WS FS PF Rect bno bgapr bh gh by bx bw]=Exec_getwinDef   
        WS   = spm('WinScale');				%-Window scaling factors, Returns ratios of current display dimensions to that of a 1152 x 900
        FS   = spm('FontSizes');			%-Scaled font sizes
        PF   = spm_platform('fonts');			%-Font names (for this platform)
        screenxy=get(0,'ScreenSize');  % four element:screenxy ==>[left, bottom, width, height]
        Rect = [1/4*screenxy(3) 290 600 500];
       % Rect = [1/4*screenxy(3) 1/5*screenxy(4) 1/4*screenxy(3) 1/2.3*screenxy(4)];   %-Raw size menu window; rect = [left, bottom, width, height]
        bno = 11; bgno = bno+1; % bno= button num, bgno=button_gap num
        bgapr = 0.10; %  button gap ratio
        bh = Rect(4) / (bno + bgno*bgapr);      % Button height
        gh = bh * bgapr;% Button gap height
        by = fliplr(cumsum([0 ones(1, bno-1)*(bh+gh)])+gh);
        bx = Rect(3)*0.02;
        bw = Rect(3)*0.96;


%=======    callback functions    ==========
%%% checkboxes   
function detrend(h_detrend,eventdata)
%% h_detrend can be directly get while you are clicking "Detrend" checkbox
% handles=get(gcf,'userdata'); %% use gcf to get the current figure's handle
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_detrend=get(h_detrend,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata

% if (get(h_detrend,'Value') == get(h_detrend,'Max'))
%    set(h_detrend,'Value',0);
% elseif (get(h_detrend,'Value') == get(h_detrend,'min'))
%     set(h_detrend,'Value',1);
% end
fprintf('')   

function bandpass(h_bandpass,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_bandpass=get(h_bandpass,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
% handles=get(gcf,'userdata');
% bandpass_low=get(handles.bandpass_low,'string');
% set(handles.bandpass_up,'string',0.2);
fprintf('')  

function bandpass_low(h_bandpass_low,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_bandpass_low=get(h_bandpass_low,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')  

function bandpass_up(h_bandpass_up,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_bandpass_up=get(h_bandpass_up,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')  
      
function FC_rois(h_rois,eventdata)
rois = spm_select(inf,'any','Select all ROI images...', [],pwd,'.*nii$|.*img$');
if ~isempty(rois)
    set(h_rois,'userdata',rois)
else
    set(h_rois,'value',0)
end
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.userdata_rois=get(h_rois,'userdata');
FC_Paras.val_rois=get(h_rois,'value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata

fprintf('')   

function FC_globalmean(h_globalmean,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_globalmean=get(h_globalmean,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')   

function FC_headmotion(h_headmotion,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_headmotion=get(h_headmotion,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')   
 

function FC_white(h_white,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_white=get(h_white,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')    

function FC_csf(h_csf,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_csf=get(h_csf,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('') 

function FC_covs(h_covs,eventdata)
covfiles = spm_select(inf,'any','Select covaritate files...', [],pwd,'.*txt$');
covs=[];
if ~isempty(covfiles)
    for i=1:size(covfiles,1)
        try
            tem=load(covfiles(i,:));  
            covs=[covs tem];
        catch me           
            continue
        end        
    end
else
    set(h_covs,'value',0)
end
set(h_covs,'userdata',covs)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.userdata_covs=get(h_covs,'userdata');
FC_Paras.val_covs=get(h_covs,'value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')   


function FC_types(h_types,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_types=get(h_types,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')   



function FC_alff(h_alff,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_alff=get(h_alff,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')    

function FC_reho(h_reho,eventdata)
FC_Paras=guidata(gcf); % read out the origial gui data
FC_Paras.val_reho=get(h_reho,'Value');
guidata(gcf,FC_Paras); % re-save the new parameters into Guidata
fprintf('')   

%%% buttons
function  savesetting(h_save,eventdata)   % while "eventdata" is just an unused variable for the function handle purpose
FC_Paras=collect_and_set_fig_paras(gcf,get(gcf,'userdata'));
% FC_Paras=guidata(gcf); % read out the origial gui data
try
    FC_Paras=rmfield(FC_Paras,'handles');
catch
    ;
end
save('FC_Paras.mat','FC_Paras')
fprintf('--Parameters saved--\n')

function  loadsetting(h_load,eventdata)   % while "eventdata" is just an unused variable for the function handle purpose
handles=get(gcf,'userdata'); % read out the origial gui data
try
    FC_Paras=FG_load_FC_panel_parameters;
catch
    fprintf('')
end
fprintf('--Parameters load--\n')
       %% load and set the saved values of all uicontrols
        handle_names=fieldnames(FC_Paras);
        
        % reset to the initial
        for i=1:size(handle_names,1)
            if strcmp(handle_names{i}(5:end),'bandpass_low') 
                eval(['set(handles.',deblank(handle_names{i}(5:end)),',''string'',0.01)'])
            elseif strcmp(handle_names{i}(5:end),'bandpass_up')                
                eval(['set(handles.',deblank(handle_names{i}(5:end)),',''string'',0.08)'])
            elseif strcmp(handle_names{i}(5:end),'rois') || strcmp(handle_names{i}(5:end),'covs')
                eval(['set(handles.',deblank(handle_names{i}(5:end)),',''value'',0)']);      
            elseif strcmp(handle_names{i}(10:end),'rois') || strcmp(handle_names{i}(10:end),'covs')
                eval(['set(handles.',deblank(handle_names{i}(10:end)),',''userdata'',[])']);   
            else                
                eval(['set(handles.',deblank(handle_names{i}(5:end)),',''value'',0)']) 
            end
        end           
        % load the saved paras
        for i=1:size(handle_names,1)
            if strcmp(handle_names{i}(5:end),'bandpass_low') || strcmp(handle_names{i}(5:end),'bandpass_up')
                eval(['set(handles.',deblank(handle_names{i}(5:end)),',''string'',','FC_Paras.' ,deblank(handle_names{i}),')'])
            elseif strcmp(handle_names{i}(5:end),'rois') || strcmp(handle_names{i}(5:end),'covs')
                eval(['set(handles.',deblank(handle_names{i}(5:end)),',''value'',','FC_Paras.' ,deblank(handle_names{i}),')']);      
            elseif strcmp(handle_names{i}(10:end),'rois') || strcmp(handle_names{i}(10:end),'covs')
                eval(['set(handles.',deblank(handle_names{i}(10:end)),',''userdata'',','FC_Paras.' ,deblank(handle_names{i}),')']);   
            else                
                eval(['set(handles.',deblank(handle_names{i}(5:end)),',''value'',','FC_Paras.' ,deblank(handle_names{i}),')']) 
            end
        end       
fprintf('--Parameters reset--\n')


function FC_Paras=OK(h_OK,eventdata)
FC_Paras=collect_and_set_fig_paras(gcf,get(gcf,'userdata'));
% FC_Paras=guidata(gcf); % read out the origial gui data
try
    FC_Paras=rmfield(FC_Paras,'handles');
catch
    ;
end
auto_save_name=FG_check_and_rename_existed_file('FC_Paras.mat');
save(auto_save_name,'FC_Paras')
close; 
fprintf('--Parameters saved!--\n')

