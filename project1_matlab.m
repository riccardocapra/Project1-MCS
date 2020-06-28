PATH = './matrix/';
file = "Flan_1565.mat";
result(1).name = file;

loadMatrix = strcat(PATH, file);
fprintf("Computing the %s matrix\n", regexprep(file, '\.[^\.]*$', ''));
load(loadMatrix);

matrix = Problem.A;
clear Problem;

try   
    profile clear;
    profile('-memory','on');

    result(1).nonzero = nnz(matrix);

    givenSolution = ones(length(matrix), 1);
    knownTerms = matrix * givenSolution;
    
    solution = solveCholesky(matrix, knownTerms);
    
    profileInfo = profile('info');
    functionNames = {profileInfo.FunctionTable.FunctionName};
    functionRow = find(strcmp(functionNames(:),'project1_matlab>solveCholesky'));
    result(1).execTime = profileInfo.FunctionTable(functionRow).TotalTime;
    result(1).memoryUsage = profileInfo.FunctionTable(functionRow).TotalMemAllocated;

    result(1).error = norm(givenSolution - solution) / norm(givenSolution);
    clearvars -except keepVariables result;
catch exception
    disp(exception.message);
    clearvars;
end

function solution = solveCholesky(A, b)
    R = decomposition(A,'chol','lower');
    solution = R \ b;
end