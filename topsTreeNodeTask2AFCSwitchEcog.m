classdef topsTreeNodeTask2AFCSwitchEcog < topsTreeNodeTask
   % @class topsTreeNodeTask2AFCSwitchEcog
   %
   % Simple 2AFC task with change-points.
   %
   % DEPENDENCIES: uses dotsPlayableTonePTB, which uses several 
   %  Psychtoolbox files: 
   %     PsychPortAudio.m
   %     PsychPortAudio.mexmaci64
   %     PsychPortAudioTimingTest.m
   %     Screen.m
   %     Screen.mexmaci64
   %
   % For standard configurations, call:
   %  topsTreeNodeTask2AFCSwitchEcog.getStandardConfiguration
   %
   % Otherwise:
   %
   %  1. Create an instance directly:
   %        task = topsTreeNodeTask2AFCSwitchEcog();
   %
   %  2. Set properties.
   %
   %  3. Add this as a child to another topsTreeNode
   %
   % 12/10/19 created by jig from topsTreeNodeTaskSimpleBandit
   
   properties % (SetObservable) % uncomment if adding listeners
      
      % Trial properties, put in a struct for convenience
      settings = struct( ...
         'predictOrReport',            'Report', ... % duh
         'useDrawables',               true, ... % Use visual stimuli
         'usePlayables',               true, ... % Use auditory stimuli
         'checkFixation',              false, ... % Whether to use eye tracker to check
         'minimumRT',                  0.0, ...
         'fractionCongruent',          0.0, ... % fraction of targets congurent with source
         'Subject',                    '', ... %Patient Number
         'Hazard',                     '', ... Hazard condition
         'stimlist',                    '');    
      
      % Task timing parameters, all in sec
      timing = struct( ...
         'waitFix',                    5.0, ...
         'waitNoFix',                  0.5, ...
         'waitBeforeStim',             1.0, ...
         'stimDuration',               1.0, ...
         'waitAfterStim',              1.0, ...
         'waitBeforeChoice',           0.1, ...
         'choiceTimeout',              5.0, ...
         'waitAfterChoice',            0.1, ...
         'minimumRT',                  0,   ...
         'interTrialInterval',         0.5);
      
      % Fields below are optional but if found with the given names
      %  will be used to automatically configure the task
      
      % independentVariables used by topsTreeNodeTask.makeTrials. Can
      % modify using setIndependentVariableByName and
      % setIndependentVariablesByName.
      %
      % Creates the array of trialData structures, using:
      %  name     ... list of independent variables
      %  values   ... array of values associated with each independent
      %                    variable
      %  priors   ... empty, or relative frequencies of each value for each
      %                    independent variable (automatically normalizes
      %                    to sum to 1).
      %
      %  Also uses:
      %     trialIterations property to determine the number
      %              of copies of each trial type to use
      %     trialIterationMethod property to determine the
      %              ordering of the trials (in trialIndices)
      independentVariables = struct( ...
            'TrialCount',   struct('values', zeros(3,1))); 
      
      % dataFieldNames is a cell array of string names used as trialData fields
      % state and stim are 1/2
      trialDataFields = {'fixationOn', 'playOn', ...
         'choice', 'choiceTime', 'RT', 'fixationOff', ...
         'stim', 'state', 'totalChoices','Subject'};
      
      % Drawables settings
      drawable = struct( ...
         ...
         ...   % Stimulus ensemble and settings
         'stimulusEnsemble',           struct( ...
         ...
         ...   % Fixation settings
         'fixation',                   struct( ...
         'fevalable',                  @dotsDrawableTargets, ...
         'settings',                   struct( ...
         'nSides',                     4,                ...
         'width',                      1.0.*[2.0 0.2],   ...
         'height',                     1.0.*[0.2 2.0],   ...
         'colors',                     [1 0 0])),        ...
         ...
         ...
         'BottomArc',                     struct( ...
         'fevalable',                  @dotsDrawableText, ...
         'settings',                   struct( ...
         'x',                           0,                ...
         'y',                          -4,     ...
         'string',                       'R')), ...
         ...
         ...
         'TopArc',                     struct( ...
         'fevalable',                  @dotsDrawableText, ...
         'settings',                   struct( ...
         'x',                           0,                ...
         'y',                           4,     ...
         'string',                       'L')), ...
         ...
         ...
         'ErrorMessage',               struct( ...
         'fevalable',                  @dotsDrawableText, ...
         'settings',                   struct( ...
         'x',                           0,                ...
         'y',                           0,               ...
         'string',                 'Please Respond'))))
      
      % Playable settings
      playable = struct( ...
         ...
         ...   % Playable A settings
         'stimulusA',                  struct(     ...
         'fevalable',                  @dotsPlayableTonePTB, ...
         'settings',                   struct(     ...
         'frequency',                  200,        ...
         'duration',                   1.0)),      ...
         ...
         ...   % Playable B settings
         'stimulusB',                  struct(     ...
         'fevalable',                  @dotsPlayableTonePTB, ...
         'settings',                   struct(     ...
         'frequency',                  1000,        ...
         'duration',                   1.0)));
      
      % Readable settings
      readable = struct( ...
         ...
         ...   % The readable object
         'reader',                     struct( ...
         ...
         'copySpecs',                  struct( ...
         ...
         ...    % Button box (this is actually a HIDKeyboard, so you should
         ...    %    list this before the keyboard to make sure the correct
         ...    %    class is mapped
         'dotsReadableHIDButtons',     struct( ...
         'start',                      {{@defineEventsFromStruct, struct( ...
         'name',                       {'choseA', 'choseB'}, ...
         'component',                  {'Button1', 'Button2'})}}), ...
         ...
         ...   % Keyboard events
         'dotsReadableHIDKeyboard',    struct( ...
         'start',                      {{@defineEventsFromStruct, struct( ...
         'name',                       {'choseA', 'choseB'}, ...
         'component',                  {'KeyboardF', 'KeyboardJ'})}}), ...
         ...
         ...   % Gamepad
         'dotsReadableHIDGamepad',   	struct( ...
         'start',                      {{@defineEventsFromStruct, struct( ...
         'name',                       {'choseA', 'choseB'}, ...
         'component',                  {'Trigger1', 'Trigger2'})}}), ...
         ...
         ...   % Dummy to run in demo mode
         'dotsReadableDummy',          struct( ...
         'start',                      {{@defineEventsFromStruct, struct( ...
         'name',                       {'choseA', 'choseB'}, ...
         'component',                  {'Dummy1', 'Dummy2'})}}))), ...
         ...
         ...   % The eye tracker object, if being used
         'eye',                        struct( ...
         ...
         'copySpecs',                  struct( ...
         ...
         ...   % The gaze windows
         'dotsReadableEye',            struct( ...
         'bindingNames',               'stimulusEnsemble', ...
         'prepare',                    {{@updateGazeWindows}}, ...
         'start',                      {{@defineEventsFromStruct, struct( ...
         'name',                       {'holdFixation', 'brokeFixation'}, ...
         'ensemble',                   {'fixationEnsemble', 'fixationEnsemble'}, ... % ensemble object to bind to
         'ensembleIndices',            {[1 1], [1 1]}, ...
         'isInverted',                 {0, 1})}}))));
      
      % Feedback messages
      message = struct( ...
         ...
         'message',                    struct( ...
         ...
         ...   Instructions
         'Instructions',               struct( ...
         'text',                       'Instructions', ...
         'speakText',                  true, ...
         'duration',                   1.0, ...
         'pauseDuration',              0.5, ...
         'bgEnd',                      [0 0 0]), ...
         ...
         ...   Cue to predict
         'Predict',                    struct(  ...
         'text',                       ''), ...
         ...
         ...   Cue to report
         'Report',                     struct(  ...
         'text',                       '')));
   end

          
   
   methods
      
      %% Constuct with name optional.
      % @param name optional name for this object
      % @details
      % If @a name is provided, assigns @a name to this object.
      function self = topsTreeNodeTask2AFCSwitchEcog(varargin)
         
         % ---- Make it from the superclass
         %
         self = self@topsTreeNodeTask(mfilename, varargin{:});
      end
      
      %% Start task method
      function startTask(self)
         
         switch lower(self.settings.Subject{2,1})
             case 'high'
                 self.settings.stimlist = load('HighHazard.mat');

             case 'low'
                 self.settings.stimlist = load('LowHazard.mat');                 
         end
         
         
         % ---- Initialize the state machine
         %
         self.initializeStateMachine();
         
         % ---- Set up block switches
         %
         self.trialIterationMethod            = 'sequential';
         self.incrementTrialMethod            = 'auto';
         
         % ---- Set up readables
         %
         % Check for eye helper
         if ~isfield(self.helpers, 'eye') || isempty(self.helpers.eye.theObject)
            self.settings.checkFixation = false;
         end
         
         % ---- Show task-specific instructions
         %         
         if strcmpi(self.settings.predictOrReport, 'predict')
            self.settings.predictOrReport = 'Predict';
            self.helpers.message.setText('Instructions', ...
               {'Predict the identity of the next stimulus'});
         else
            self.settings.predictOrReport = 'Report';
            self.helpers.message.setText('Instructions', ...
               {'Report the identity of the previous stimulus'});
         end
         self.helpers.message.show('Instructions');
      end
      
      %% Overloaded finish task method
      function finishTask(self)
      end
      
      %% Overloaded start trial method
      %
      % Put stuff here that you want to do at the beginning of each
      %  trial
      function startTrial(self)
         % ---- Get the trial
         %
         trial = self.getTrial();
         %stimlist = load('ecoglist.mat');
         %---- Set up trial struct
         %               
            % We iterate through each "trial" several times, so at the
            % beginning we need to reset these counters           
            trial.totalChoices = 0;
            trial.state = self.settings.stimlist.hazard(trial.trialIndex,1);            
            trial.stim = self.settings.stimlist.hazard(trial.trialIndex,2);
            trial.Subject = self.settings.Subject;

         
         
         % Re-save the trial
         self.setTrial(trial);
         
         % ---- Prepare the playables
         %
         if self.settings.usePlayables
            self.helpers.stimulusA.theObject.prepareToPlay();
            self.helpers.stimulusB.theObject.prepareToPlay();
         end
         
         % ---- Set up readable isActive flags
         %
         if self.settings.checkFixation
            self.helpers.eye.theObject.setEventsActiveFlag({'holdFixation', 'brokeFixation'}, 'all');
         end
         self.helpers.reader.theObject.setEventsActiveFlag({'choseA', 'choseB'}, 'all');
         
         % ---- Use the task ITI
         %
         self.interTrialInterval = self.timing.interTrialInterval;
         
         % ---- Show information about the trial
         %
         % Task information

         
         % Show the information
      end
      
      %% Finish Trial
      %
      % Could add stuff here
      function finishTrial(self)
      end
      
      %% Show stimulus
      %
      function showStimulus(self)
         
         % ---- Get the trial
         %
         trial = self.getTrial();
         
         % ---- Play the auditory stimulus         
         %
         if self.settings.usePlayables            
            self.helpers.(['stimulus' 64+trial.stim]).startPlaying( ...
               self, 'playOn');
         end
      end       

      %% Check for choice
      %
      % Save choice/RT information and set up feedback for the dots task
      function nextState = checkForChoice(self, events, eventTag, nextStateAfterChoice)
         
         % ---- Check for event
         %
         eventName = self.helpers.reader.readEvent(events, self, eventTag);
         
         % Nothing... keep checking
         if isempty(eventName)
            nextState = [];
            return
         end
         
         % ---- Good choice!
         %
         % Override completedTrial flag
         self.completedTrial = true;
         
         % Jump to next state when done
         
         % ---- Save trial info
         % 
         % Get current task/trial and set/save RT, choice
         trial        = self.getTrial();
         trial.RT     = trial.choiceTime - trial.TargetsOn;
         trial.choice = 1+double(strcmp(eventName, 'choseB'));
         
         % Mark as correct/error (with respect to largest reward side)
         trial.totalChoices = trial.totalChoices + 1;
        
         nextState = strcat(nextStateAfterChoice,eventName);

         
         % Re-save the trial
         self.setTrial(trial);
      end
   end
   
   methods (Access = protected)
      
      %% configureStateMachine method
      %
      function initializeStateMachine(self)
         
         % ---- Fevalables for state list
         %
         % Draw
         blanks = {@dotsTheScreen.blankScreen};
         showfp = {@draw, self.helpers.stimulusEnsemble,{{'isVisible', true, 1}, {'isVisible', false, [2 3 4]}}, self, 'fixationOn'};
         hidefp = {@draw, self.helpers.stimulusEnsemble,{{'isVisible', true, []}, {'isVisible', false, 1}}, self, 'fixationOff'};
         showtg = {@draw, self.helpers.stimulusEnsemble,{{'isVisible', true, [2 3]}, {'isVisible', false, 4}}, self, 'TargetsOn'};
         showerror = {@draw, self.helpers.stimulusEnsemble,{{'isVisible', true, 4}, {'isVisible', false, [2 3]}}, self, 'ErrorMessage'};
         hidetga = {@draw, self.helpers.stimulusEnsemble,{{'isVisible', true, []}, {'isVisible', false, 3}}, self, 'TargetAOff'};
         hidetgb = {@draw, self.helpers.stimulusEnsemble,{{'isVisible', true, []}, {'isVisible', false, 2}}, self, 'TargetBOff'};




         showst = {@showStimulus, self};
         
         % Read
         chkchc = {@checkForChoice, self, {'choseA' 'choseB'}, 'choiceTime', 'waitAfterChoice'};
         
         % ---- Conditional check for fixation
         %
         if self.settings.checkFixation
            chkeyef = {@getNextEvent, self.helpers.reader.theObject, false, {'holdFixation'}};
            chkeyeb = {@getNextEvent, self.helpers.reader.theObject, false, {'brokeFixation'}};
            nextFix = 'checkFixation';
         else
            chkeyef = {};
            chkeyeb = {};
            nextFix = 'noCheckFixation';
         end
                  
         % ---- Timing variables, read directly from the timing property struct
         %
         t = self.timing;

         % ---- The Stimulus state machine
         %
         stimStates = {...
            'name'               'entry'  'input'  'timeout'            'exit'   'next'         ; ...
            'showFP'             showfp   {}       0                    {}       nextFix        ; ...            
            'checkFixation'      {}       chkeyef  t.waitFix            {}       'retry'        ; ...
            'retry'              blanks   {}       t.interTrialInterval {}       'checkFixation'; ...            
            'noCheckFixation'    {}       {}       t.waitNoFix          {}       'holdFixation' ; ...
            'holdFixation'       {}       chkeyeb  [1 0.5 2]            {}       'showStim'     ; ...
            'showStim'           showst   chkeyeb  t.stimDuration       {}       'waitAfterStim'; ...
            'waitAfterStim'      {}       chkeyeb  [1 0.5 2]            hidefp       'blank'        ; ...
            'blank'              blanks   {}       0                    {}       ''             ; ...
            };
         
         % ---- The Response state machine
         %
         responseStates = {...
            'name'               'entry'  'input'  'timeout'            'exit'   'next'         ; ...
            'getChoice'          showtg    chkchc     5                  blanks    'beforeChoice'   ; ...   
            'beforeChoice'        showerror        {}     1                  {}      'getChoice'    ; ...
            'waitAfterChoicechoseA'   hidetgb    {}       [0.5 0.5 1]      blanks         ''          ; ...
            'waitAfterChoicechoseB'   hidetga    {}       [0.5 0.5 1]      blanks         ''          ;
            };

         % ---- Add state machines in appropriate order
         %
         if strcmp(self.settings.predictOrReport, 'predict')
            
            % Prediction task: first response, then stimulus
            self.addStateMachine(stimStates);
            self.addStateMachine(responseStates);
         else
            
            % Report task: first stimulus, then response
            self.addStateMachine(stimStates);
            self.addStateMachine(responseStates); 
         end
      end
   end
   
   methods (Static)
      
      %% ---- Utility for defining standard configurations
      %
      function task = getStandardConfiguration(varargin)
         
         % ---- Get the task object, with optional property/value pairs
         task = topsTreeNodeTask2AFCSwitchEcog(varargin{:});
      end
   end
end
