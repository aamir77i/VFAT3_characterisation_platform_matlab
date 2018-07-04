%% generate tab controls
f = figure;
tgroup = uitabgroup('Parent', f);
tab1 = uitab('Parent', tgroup, 'Title', 'Register settings');
tab2 = uitab('Parent', tgroup, 'Title', 'calibration');
tab3 = uitab('Parent', tgroup, 'Title', 'scurves');
tab4 = uitab('Parent', tgroup, 'Title', 'trimming');
% default selected tab
tgroup.SelectedTab = tab1;

%% tab1 
Button_connect = uicontrol('Parent', tab1, 'Style', 'button', 'String', 'connect', ...
  'HorizontalAlignment', 'left', 'Position', [80 320 170 25]) ;
edtLoanAmount = uicontrol('Parent', tab1, 'Style', 'edit', ...
 'Position', [224 320 200 30]) ;