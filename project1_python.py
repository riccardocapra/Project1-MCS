import scipy.io as sc
import os, fnmatch
#import numpy as np
#from skparse.chlmod import cholesky
import csv
import time
#from memory_profiler import memory_usage

import numpy

def solveCholesky(A, b):
    R = cholesky(A)
    x = A*b
    solution = R(x)
    return solution

if __name__ == "__main__":
    print(numpy.__version__)

    execution_path = os.getcwd()
    print("percorso: ")
    print(execution_path)
    matrices = fnmatch.filter(os.listdir(execution_path + '\matrix'),'*.mtx')
    print(matrices)

    for matrix in matrices:
        #M = mmread(matrix)
        print(execution_path + '\matrix\\' + matrix)
        #length = M.shape[0]
        #givenSolution = np.ones(length)
        #timeStart = time.time()
        #(mem_usage, result) = memory_usage((solveCholesky,(M.tocsc(),givenSolution)),retval=True)
        #execTime = time.time() - timeStart
        #error = norm(result - givenSolution) / norm(givenSolution)
        #memoryUsage = max(mem_usage)
