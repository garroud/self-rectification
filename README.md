# Self-rectification
This repo is the matlab implementation code for paper on 3DV 2018. The statistics reported in the paper is implemented by C++ and opencv, which may not be consistent with the one in matlab.
If you are using our algorithm in your work, please consider cite:

## Dependency
* MATLAB 2015B on or above (The code is tested on MATLAB2015b);
* ComputerVisionToolkit writen by [Professor  A. Fusiello](http://www.diegm.uniud.it/fusiello/), download avaliable at [Download](http://www.diegm.uniud.it/fusiello/sw/ComputerVisionToolkit.zip)
* VLFeat 0.9.21 released, download avaliabe at [Download](http://www.vlfeat.org/download/vlfeat-0.9.21-bin.tar.gz)
## Usage
1. Download the ComputerVisionToolkit and VLFeat and unzip the files into `self-rectification/` directory
2. To run the self-rectification, execute `run_rectify.m`. 
## Example results
some image pairs are provided for test purpose.
<figure>
 <img src="https://github.com/garroud/self-rectification/blob/master/test_data/image0_s.png" align=left width="350"> 
 <img src="https://github.com/garroud/self-rectification/blob/master/test_data/image1_s.png" align=center width="350">
 <em>&nbsp;&nbsp;master image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;slave image</em>
<figure>
After self-rectification, The result is
some image pairs are provided for test purpose.
<figure>
 <img src="https://github.com/garroud/self-rectification/blob/master/test_data/image0_s.png" align=left width="350"> 
 <img src="https://github.com/garroud/self-rectification/blob/master/test_data/image1_s.png" align=center width="350">
 <em>&nbsp;&nbsp;master image&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;slave image</em>
<figure>
