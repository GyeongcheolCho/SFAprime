%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program for structured factor analysis                                %
% - A paper entitled "Structured factor analysis: A data matrix-based   %
% alternative to structural equation modeling" is under review in an    %
% academic journal "Structural Equation Modeling A Multidisciplinary    %   
% Journal."                                                             %
% - This program is written by the first author and provided only       %
% for the reviewers to evaluate the performance of the proposed method. %
% - MATLAB R2021b and Windows 64 bit are required to run this program.  %
% - Version Number: 0.1                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data
load('Example_dataset.mat','Zrep','H_true');
%% Specify model(s)
% Measurement Model
% Loading matrix
Model.LAM0=[ 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
             0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
             0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0
             1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0
             0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0
             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1];
% Common factor covariance matrix
Model.PHI0 = [   1, 1, 1, 0, 1, 1 
                 1, 1, 1, 0, 1, 1
                 1, 1, 1, 0, 1, 1
                 0, 0, 0, 1, 0, 0
                 1, 1, 1, 0, 1, 1
                 1, 1, 1, 0, 1, 1];
% Unique factor covariance matrix
Model.THETA0 = [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
                 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
                 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
                 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
                 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1];
% sign-fixing indicator number for each l.v. 
Model.ind_sign=[1, 4, 7, 1, 10, 13];  

% Structural Model
Px=4;
Py=2;
N_models=2;
Model.Bx0 = zeros(Px,Py,N_models);
Model.By0 = zeros(Py,Py,N_models);
Model.opt_LS=zeros(N_models,Py);
Model.Bx0(:,:,1)=[1, 0
                  1, 0
                  1, 0
                  0, 0];
Model.By0(:,:,1)=[0, 1
                  0, 0];
Model.opt_LS(1,:)=[1,2]; % 1 = endogeneity X for DV1, 2 = endogeneity O for DV2. 
Model.Bx0(:,:,2)=[1, 0
                  0, 0
                  1, 0
                  0, 0];
Model.By0(:,:,2)=[0, 1
                  0, 0];
Model.opt_LS(2,:)=[1,2];

% Set options 
Est.N_Boot=0; % Number of bootstrap samples; for testing parameter estimates
Est.N_Sampling=0; % Number of B-S bootstrap samples; for testing IPE
Est.Percentiles_CI=[0.025,0.975]; % percentiles for the two limits of 95% Confidence intervals of model parameter estimates
Est.Min_limit=10^(-13); % tolerance level
Est.Max_iter=10000;     % Maximum number of iteration
Est.N_CFSs=1000; % # of matrices of candidate factor scores to generate
Est.Print=0;          % 0 for printing out nothing. 1 otherwise 

%% Run the program
[Result,Table,Etc]=sfa(Zrep,Model,Est);

%% Results
Result.iter
Result.Converge
Result.Para.LAM
Result.Para.PHI
Result.Para.THETA
Result.Para.Bx
Result.Para.By
Result.Para.PSI
Result.Para.W
Result.Para.cH_std % standard eror of meausurement
Result.Index.IPE       % [IPE, 95% cutoff, 99% cutoff]
Result.Index.LPE
Result.Index.R2
Result.Score.H_set;    % candidate factor score distribution
Result.Score.cH_mean;  % a matrix of expected candidate factor scores
Result.Score.cH_CI    % 95% candidate factor score intervals

%Table.LAM
%Table.THETA
%Table.PHI
%Table.B
%Table.PSI
