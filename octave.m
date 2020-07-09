PATH = './matrix/';

dinfo = dir('./matrix/*.mat');
outFileResult = './results/octaveResults.csv';
title = ["matrix,length,nnz,execTime,error,\n"];

fid = fopen (outFileResult, "a");
%writematrix(title, outFileResult, 'WriteMode', 'overwrite', 'Delimiter', 'comma');
fputs (fid, title);


function solution = solveCholesky(A, b)
    R = chol(A, "lower");
    solution = R \ b;
end

for K = 1 : 1
    thisfilename = dinfo(K).name;  %just the name
    fprintf( 'File #%d, "%s" \n', K, thisfilename );   %do something with the data

    name = dinfo(K).name;

    loadMatrix = strcat(PATH, dinfo(K).name);
    fprintf("Computing the %s matrix\n", dinfo(K).name);
    load(loadMatrix);

    matrix = Problem.A;
    clear Problem;

    try 
		profile off
		profile clear
        profile on
        
        %profile('-memory','on');

        length = size(matrix, 1);
        numZeros = nnz(matrix);

        givenSolution = ones(length, 1);
        knownTerms = matrix * givenSolution;
		
		solution = solveCholesky(matrix,knownTerms);
		
		profile off
        
		info = profile('info');
        functions = {info.FunctionTable.FunctionName};
        myfunct = find(strcmp(functions(:),'solveCholesky'));
        execTime = info.FunctionTable(myfunct).TotalTime;
        %memoryUsage = info.FunctionTable(myfunct).TotalMemAllocated;

        error = norm(givenSolution - solution) / norm(givenSolution);
        
        %clearvars -except keepVariables result;
    catch exception
        disp(exception.message);
        execTime = 0;
        memoryUsage = 0;
        error = 0;
        %clearvars -except keepVariables exception;
    end
    toFile = [name,",",num2str(length),",",num2str(numZeros),",",num2str(execTime),",",num2str(error),",\n" ];
    disp(toFile);
    %writeOnFile = cell2mat(toFile);
    %writematrix(toFile, outFileResult, 'WriteMode', 'append', 'Delimiter', 'comma');
	%csvwrite(outFileResult, toFile,"-append")
	fputs (fid, toFile);
	
end
fclose (fid);
clearvars -except keepVariables exception;

