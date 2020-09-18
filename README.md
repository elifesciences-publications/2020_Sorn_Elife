This code is associated with the paper from Mudla et al., "Cell-cycle-gated feedback control mediates desensitization to interferon stimulation". eLife, 2020. http://dx.doi.org/10.7554/eLife.58825

**Instructions for using code**
1. ifn_stochastic(pretreatTime, numb_of_cells)
	- To use this function, input pretreatment	time of IFN-alpha and the desired number of cells you want. The output of this function is IRF9 induction and USP18 level at the onset of the second stimulation.
	- Fig6 contains 3 separate experiments, namely 2hr, 10hr and 24hr pretreatment experiments. 

2. ifn_pretreat(k, pretreatTime, R)
	- This function outputs the induction of IRF9 when different pretreatment time of IFN-alpha is given to the cells. It could also output the behavior of the system under prolonged IFN-alpha stimulation when needed. The input needed for using this function is pretreatment time, parameter for the model, and a indexing number that identifies the correct mapping between real time and simulation time. 
3. error_cal_Fig3B
    - This script makes use of ifn_pretreat and computes the sum sqaured error between simulation and expeirmental data. 
    - This script creates a plot of delay time v sum of squared error which identifies an 8hr optimal delay time.
4. ifn_deterministic_Fig3C
    - This script recreates the simulated data of Fig3C.
