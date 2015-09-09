
function [FFF_name,FFF_num]=FG_F_names_contrasts()
clear FFF_name
clear FFF_num

% After you setting up this file, [save OR save as..] it,
% and then select the file you saved in the next step.



%%% set up the F-contrast names in a column as below
FFF_name={
'1 passive_risk'
'2 active_risk'
'3 noreward_risk'
'4 passive-noreward_risk'
'5 active-passive_risk'
'6 active-noreward_risk'
'7 win_passive'
'8 loss_passive'
'9 win_active'
'10 loss_active'
'11 active-passive_win'
'12 active-passive_loss';
}';

%%% set up the F-contrast numbers in a column as below
FFF_num={
'0 0 1'
'zeros(1,10) 1'
'zeros(1,18) 1'
'0 0 1 zeros(1,15) -1'
'0 0 -1 zeros(1,7) 1'
'zeros(1,10) 1 zeros(1,7) -1'
'zeros(1,4) 1'
'zeros(1,6) 1'
'zeros(1,12) 1'
'zeros(1,14) 1'
'zeros(1,4) -1 zeros(1,7) 1'
'zeros(1,6) -1 zeros(1,7) 1'
}';

fprintf('\n-----------F-contrasts are all set!\n\n')
