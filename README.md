# CreateSamples
Create positive images samples for haar cascade training (alternate to opencv_createsamples)

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