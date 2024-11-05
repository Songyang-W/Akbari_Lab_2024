function [deltaAIC] = Delta_AIC(X,y, distribution,  linkFunction,variableNames)

fullModel = fitglm(X, y, 'Distribution', distribution, 'Link', linkFunction);
k_full = length(fullModel.Coefficients.Estimate); % Number of parameters (including intercept)
logL_full = fullModel.LogLikelihood; % Log-likelihood of the full model
AIC_full = 2 * k_full - 2 * logL_full;

numVars = size(X, 2);
deltaAIC = zeros(numVars, 1);
% variableNames = fullModel.VariableNames(2:end); % Assuming the first name is '(Intercept)'
pValues = zeros(numVars, 1);
pValues = fullModel.Coefficients.pValue(2:end); % Exclude intercept

for i = 1:numVars
    % Remove the i-th predictor
    X_reduced = X;
    X_reduced(:, i) = []; % Remove column i
    
    % Get the names of the reduced predictors
    reducedVariableNames = variableNames;
    reducedVariableNames{i} = []; % Remove the i-th predictor name
    
    % Fit the reduced GLM
    reducedModel = fitglm(X_reduced, y, 'Distribution', distribution, 'Link', linkFunction);
    
    % Calculate AIC for the reduced model
    k_reduced = length(reducedModel.Coefficients.Estimate);
    logL_reduced = reducedModel.LogLikelihood;
    AIC_reduced = 2 * k_reduced - 2 * logL_reduced;
    
    % Calculate Delta AIC
    deltaAIC(i) = AIC_reduced - AIC_full;
end
% Display the results in a table
resultsTable = table(variableNames', pValues, deltaAIC, ...
                    'VariableNames', {'Variable', 'pValue', 'DeltaAIC'});
disp(resultsTable);

end