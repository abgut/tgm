% A function that loads datafile and rewrites its entries into a structure.

function data=load_datafile(datafile)

load(datafile)
data.omegam=omegam;
data.S21mc=S21mc; 
data.anglem=anglem;