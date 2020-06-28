PATH = './matrix/';
file = "ex15.mat";

dinfo = dir('./matrix/*.mat');

for K = 1 : length(dinfo)
  thisfilename = dinfo(K).name;  %just the name
  fprintf( 'File #%d, "%s" \n', K, thisfilename );   %do something with the data
end

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

    fid = fopen( './results/res.csv', 'wt' );
    fprintf(fid, '%1$s;%2$s;%3$s;%4$s;%5$s',result(1).name,result(1).nonzero,result(1).execTime,result(1).memoryUsage,result(1).error);  
    fclose(fid);
    
    
catch exception
    disp(exception.message);
    clearvars;
end

function solution = solveCholesky(A, b)
    R = decomposition(A,'chol','lower');
    solution = R \ b;
end