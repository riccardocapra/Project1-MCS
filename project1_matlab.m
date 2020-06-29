PATH = './matrix/';

dinfo = dir('./matrix/*.mat');
outFileResult = './results/matlabResults.csv';
title = ["matrix", "length", "nnz", "execTime", "memoryUsage", "error"];
writematrix(title, outFileResult, 'WriteMode', 'overwrite', 'Delimiter', 'comma');

for K = 1 : length(dinfo)
    thisfilename = dinfo(K).name;  %just the name
    fprintf( 'File #%d, "%s" \n', K, thisfilename );   %do something with the data

    name = dinfo(K).name;

    loadMatrix = strcat(PATH, dinfo(K).name);
    fprintf("Computing the %s matrix\n", dinfo(K).name);
    load(loadMatrix);

    matrix = Problem.A;
    clear Problem;

    try   
        profile clear;
        profile('-memory','on');

        length = size(matrix, 1);
        numZeros = nnz(matrix);

        givenSolution = ones(length, 1);
        knownTerms = matrix * givenSolution;

        solution = solveCholesky(matrix, knownTerms);

        info = profile('info');
        functions = {info.FunctionTable.FunctionName};
        myfunct = find(strcmp(functions(:),'project1_matlab>solveCholesky'));
        execTime = info.FunctionTable(myfunct).TotalTime;
        memoryUsage = info.FunctionTable(myfunct).TotalMemAllocated;

        error = norm(givenSolution - solution) / norm(givenSolution);
        
        %clearvars -except keepVariables result;
    catch exception
        disp(exception.message);
        execTime = 0;
        memoryUsage = 0;
        error = 0;
        %clearvars -except keepVariables exception;
    end
    toFile = [string(name) string(length) string(numZeros) string(execTime) string(memoryUsage) string(error)];
    disp(toFile);
    %writeOnFile = cell2mat(toFile);
    writematrix(toFile, outFileResult, 'WriteMode', 'append', 'Delimiter', 'comma');
end
clearvars -except keepVariables exception;

function solution = solveCholesky(A, b)
    R = decomposition(A,'chol','lower');
    solution = R \ b;
end