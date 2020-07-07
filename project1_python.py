import scipy.io as sio
import scipy.linalg as lin
import os, fnmatch
import sksparse.cholmod as skc
import csv
import time
from memory_profiler import memory_usage
from glob import glob
import numpy as np


def solveCholesky(A, b):
    R = skc.analyze(A)
    R.cholesky_inplace(A, b)
    #R.solve_A(b)
    #x = A*b
    print(R)
    solution = R(b)
    return solution

if __name__ == "__main__":
    execution_path = os.getcwd()
    print("percorso: ")
    print(execution_path)
    matrices = sorted(glob(execution_path + '\matrix\*.mat'), key=os.path.getsize)
    print(matrices)

    for matrix in matrices:
        #M = mmread(matrix)
        file = sio.loadmat(matrix)
        print(execution_path + '\matrix\\' + matrix)
        M = file['Problem']['A'][0][0]
        print(type(M))
        length = M.shape[0]
        
        givenSolution = np.ones(length)
        
        knownTerms = M*givenSolution
        result=solveCholesky(M,knownTerms)
        #timeStart = time.time()
        #(mem_usage, result) = memory_usage((solveCholesky,(M,knownTerms)),retval=True)
        #execTime = time.time() - timeStart
        error = lin.norm(result - givenSolution) / lin.norm(givenSolution)
        #memoryUsage = max(mem_usage)
