# Self-rectification
This repo is the MATLAB implementation code for paper on 3DV 2018. 
## Acknowledgement
* The statistics reported in the paper is implemented by C++ and opencv, which may not be consistent with the one in matlab. 
* Unlike in the paper, we use SIFT feature matcher implemented by  Professor [A. Fusiello](http://www.diegm.uniud.it/fusiello/), Some modification is made to support MATLAB 2015B. We thank Professor Fusiello for his code. 

If you are using our algorithm in your work, please consider cite:

## Dependency
* MATLAB 2015B on or above (The code is tested on MATLAB2015B);

* VLFeat 0.9.21 released, download avaliabe at [Download](http://www.vlfeat.org/download/vlfeat-0.9.21-bin.tar.gz)
## Usage
1. Download the VLFeat toolkit and extract the directory  `vlfeat-0.9.21/` into `self-rectification/` directory;
2. To run the self-rectification, execute `run_rectify.m`.
## Example results
some image pairs are provided for test purpose.
<figure>
 <img src="https://github.com/garroud/self-rectification/blob/master/test_data/image0_s.png" align=left width="350"> 
 <img src="https://github.com/garroud/self-rectification/blob/master/test_data/image1_s.png" align=center width="350">
 <em>master image(left) and right image(right)</em>
</figure>

After self-rectification, The result is
<figure>
 <img src="https://github.com/garroud/self-rectification/blob/master/rec_img0.png" align=left width="350"> 
 <img src="https://github.com/garroud/self-rectification/blob/master/rec_img1.png" align=center width="350">
 <em>Rectified master image(left) and slave image(right), notice that our algorithm makes no transfomration on master image.</em>
</figure>
