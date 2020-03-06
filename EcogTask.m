function EcogTask()
% function EcogTask(taskName, noGraphics)
%
% Test task with the given name
%
% Arguments:
%  taskName   ... string name, without topsTreeNodeTask suffix
%  noGraphics ... if true, do not use screen

%% ---- Create topsTreeNodeTopNode to control the experiment
%
% Make the topsTreeNodeTopNode
topNode = topsTreeNodeTopNode('test');

% Add the screen ensemble as a "helper" object. See
% topsTaskHelperScreenEnsemble for details
if nargin < 2 || isempty(noGraphics) || ~noGraphics
   topNode.addHelpers('screenEnsemble',  ...
      'displayIndex',      0, ...
      'remoteDrawing',     false, ...
      'topNode',           topNode);
end



% Add 'keyboard' readable that reads from the keyboard
topNode.addReadable('dotsReadableHIDKeyboard');
%topNode.addHelpers('TTL', 'fevalable', @dotsWritableDOut1208FS)

%dtopNode.addHelpers('TTL', 'fevalable', @dotsWritableDOutLabJack);

PredictTask = topsTreeNodeTask2AFCSwitchEcog();

         %PredictTask.settings.predictOrReport = 'Predict';
         prompt = {'Please enter Subject number ' , 'Hazard Condition (high or low)' , 'Report Condition (predict or report)'};
         PatientID = inputdlg(prompt);
         PredictTask.settings.Subject = PatientID;
         PredictTask.settings.predictOrReport = PatientID{3,1};
         
% Add the task
topNode.addChild(PredictTask);       


% Run it
topNode.run();
