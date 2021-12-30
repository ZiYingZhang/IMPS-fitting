# IMPS fitting
A matlab package is used to fit and plot intensity modulated photocurrent spectroscopy (IMPS) data.
  
The datasets contain the photocurrent response as a function of the frequency of a light perturbation. These data can be fitted using a dynamics model firstly proposed by [Peter, L. M](https://researchportal.bath.ac.uk/en/persons/laurie-peter) et al. [Journal of Electroanalytical Chemistry, 396(1-2), 219-226](https://www.sciencedirect.com/science/article/pii/0022072895041155).
  
Herein, the users can put the fitting codes (the main.m and the obj.m files) and the experiment data.txt (The first column of data is the frequency, the second and third columns of data are the real and imaginary parts of the complex function of the photocurrent response, respectively) in one folder and modify the path, initial values, and boundary conditions, the dynamic parameters will be output if it can converge successfully.
  
  <img src="https://github.com/ZiYingZhang/IMPS-fitting/blob/main/example/0.66%20V.jpg" width="50%" align="center" />
