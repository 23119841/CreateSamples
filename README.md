# CreateSamples
Create positive image samples is a for haarcascade training (alternative to opencv_createsamples). 

##### Advantages over opencv_createsamples
More control over generating collection of positive training samples from a samll set of images. Use this app to combine folder of .png files (cutous of the object you want to classify) with transparency channel onto random background images to generate more varied positive samples. 

##### Disadvantages
Slower than opencv_createsamples. And still requires opencv_createsamples to generate .vec files. If you use this with Natashi Seo's [tutorial](http://note.sonots.com/SciSoftware/haartraining.html) you'll need to edit the perl script to generate only 1 file. Example:

`/path/to/opecv_createsamples -bgcolor 0 -bgthresh 0 -maxxangle 1.1 -maxyangle 1.1 maxzangle 0.5 -maxidev 40 -w 20 -h 20 -num 1 -img ./positive_images/yourimg.jpg -vec ./samples/yourimg.jpg.vec`


##### Requires
* [OpenCV2 for Processing](https://github.com/atduskgreg/opencv-processing)
* folder of postive images, folder of negative images

##### Instructions
* Set the positive, negative, and output image directory
* Adjust parameters to create new version of your positive samples
* `sampleWarpAmt` how much to warp the images
* `sampleBrtAmt` how much to vary the brightness
* `sampleRadAmt` how much to vary the rotation

![Screenshot](https://github.com/adamhrv/CreateSamples/blob/master/screenshot.png)