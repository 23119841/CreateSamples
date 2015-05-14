import java.io.File;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.awt.Dimension;
// OpenCV for Processing
// https://github.com/atduskgreg/opencv-processing
import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;
import org.opencv.core.Mat;
import org.opencv.core.CvType;

/*
 * CreateSamples for HaarCascade training with OpenCV (alternative method to ./opencv_createsamples)
 * designed for adding random background images to transparent positive sample. png files
 *
 * You'll still need to run ./opencv_createsamples to generate the .vec file, but you can omit the -num parameter
 * Instructions: edit the 'posDir', 'negDir', and 'outDir' 
 * You can adjust the rotation amount, brightness amount, and warp amount in 'warpImage' function
 *  
 * This is a visually verbose and customizable way to generate a large quantity of positive samples.
 * Uses OpenCV2 for Processing by @atduskgreg
 * 
 * For info on how to train a cascade see:
 * http://coding-robin.de/2013/07/22/train-your-own-opencv-haar-classifier.html
 * http://www.trevorsherrard.com/Haar_training.html
 * https://github.com/JoakimSoderberg/catcierge-samples
 * https://github.com/JoakimSoderberg/imageclipper
 *
 * Adam Harvey / ahprojects.com
 * May 13, 2015
 */

// ------------------------------------------------------------------------
// Editable sample settings 
float sampleWarpAmt = .03; // +/- skew image
float sampleBrtAmt = .015; // +/- adjust brightness of all image pixels (except transparent)
float sampleRadAmt = PI/32; // +/- rotate image at center
String posDir = "";
String negDir = "";
String outDir = "";
int maxIterations = 15;
// ------------------------------------------------------------------------

// OpenCV
OpenCV opencv;
PImage srcImg, warpImg;
Contour contour;

// File IO
List<File> posFiles, negFiles;

// Logic
int fileCounter = 0, iteration = 0; // adjust to make enough positive samples

void setup() {
  String[] paths = loadStrings("paths.txt");
  for (int i = 0; i < paths.length; i++) {
    String[] pieces = split(paths[i], "=");
    String k = pieces[0];
    String v = pieces[1];
    if (k.equals("pos")) {
      posDir = v;
    } else if (k.equals("neg")) {
      negDir = v;
    } else if (k.equals("out")) {
      outDir = v;
    }
  }
  posFiles = getFileList(posDir);
  negFiles = getFileList(negDir);

  println(posFiles.size() + " pos files" );
  println(negFiles.size() + " neg files");

  File f = posFiles.get(0);
  PImage img = loadImage(f.getAbsolutePath());
  size(img.width *2, img.height);

  opencv = new OpenCV(this, img);
  for (int i = 0; i < maxIterations; i++) {
    print("#");
  }
  println("");
}

void draw() {

  if ( fileCounter < posFiles.size()) {

    File posFile = posFiles.get(fileCounter);

    // get random negative img
    int ridx = int(random(0, negFiles.size() - 1));
    File negFile = negFiles.get(ridx);

    // Composite positive with negative
    srcImg = loadImage(posFile.getAbsolutePath());

    warpImg = processFile(posFile, negFile, iteration); // * magic happens here *

    // Draw
    background(50);
    image(srcImg, 0, 0);
    pushMatrix();
    translate(srcImg.width, 0);
    image(warpImg, 0, 0);
    popMatrix();

    // Save file to output directory
    String path = outDir + posFile.getName();
    path = path.substring(0, path.length()-4);
    String ext = getFileExtension(posFile);
    path += "-" + (iteration+1) + ".jpg";
    warpImg.save(path);

    print("-");
    if ( ++iteration >= maxIterations) {
      println("");
      for (int i = 0; i < maxIterations; i++) {
        print("#");
      }
      println(" " + (fileCounter+1) + " / " + posFiles.size());

      // Save normal file
      PImage normImg = processFileNoWarp(posFile, negFile); // * magic happens here *
      // Save file to output directory
      path = outDir + posFile.getName();
      path = path.substring(0, path.length()-4);
      path += "-0" + ".jpg";
      normImg.save(path);

      iteration = 0; // reset
      fileCounter++; // increment to next file
    }
  } else {
    println("Bye");
    exit();
  }
}

PGraphics processFile(File posFile, File negFile, int iteration) {

  PImage posImg = loadImage(posFile.getAbsolutePath());
  PGraphics warpImg = warpImage(posImg, 0.04, 0.4, PI/32);
  PImage negImg = loadImage(negFile.getAbsolutePath());
  negImg = imageToGrayscale(negImg);
  PGraphics posGr = createGraphics(posImg.width, posImg.height);
  posGr.beginDraw();
  posGr.image(negImg, 0, 0, posImg.width, posImg.height);
  posGr.image(warpImg, 0, 0);
  posGr.endDraw();

  return posGr;
}

PGraphics processFileNoWarp(File posFile, File negFile) {

  PImage posImg = loadImage(posFile.getAbsolutePath());
  PImage negImg = loadImage(negFile.getAbsolutePath());
  negImg = imageToGrayscale(negImg);
  PGraphics posGr = createGraphics(posImg.width, posImg.height);
  posGr.beginDraw();
  posGr.image(negImg, 0, 0, posImg.width, posImg.height);
  posGr.image(posImg, 0, 0);
  posGr.endDraw();

  return posGr;
}
