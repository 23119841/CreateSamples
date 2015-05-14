PGraphics warpImage(PImage src, float warpAmt, float brAmt, float rad) {

  float[][] warp = new float[4][2];
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 2; j++) {
      warp[i][j] = random(-warpAmt, warpAmt);
    }
  }

  Dimension dim = new Dimension(src.width, src.height);
  ArrayList<PVector> inputPoints = new ArrayList<PVector>();
  inputPoints.add( new PVector(0, 0));
  inputPoints.add( new PVector(src.width, 0));
  inputPoints.add( new PVector(src.width, src.height));
  inputPoints.add( new PVector(0, src.height));
  PImage img = createImage(src.width, src.height, ARGB);
  opencv.loadImage(src);
  opencv.toPImage(warpPerspective(inputPoints, dim, warp), img);
  img = brightenImage(img, random(0, random(-brAmt,brAmt)));
  PGraphics pg = createGraphics(img.width, img.height);
  pg.beginDraw();
  pg.pushMatrix();
  pg.imageMode(CENTER);
  pg.translate(img.width/2, img.height/2);
  pg.rotate(random(random(-rad, rad)));
  pg.image(img, 0, 0);
  pg.popMatrix();
  pg.endDraw();
  return pg;
}

// Warp image
Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, Dimension dim, float[][] t) {

  int w = dim.width;
  int h = dim.height;

  Point a = new Point(0 + t[0][0] * w, 0 + t[0][1] * h);
  Point b = new Point(w + t[1][0] * w, 0 + t[1][1] * h);
  Point c = new Point(w + t[2][0] * w, h + t[2][1] * h);
  Point d = new Point(0 + t[3][0] * w, h + t[3][1] * h);

  Point[] canonicalPoints = new Point[4];
  canonicalPoints[0] = a;
  canonicalPoints[1] = b;
  canonicalPoints[2] = c;
  canonicalPoints[3] = d;

  MatOfPoint2f canonicalMarker = new MatOfPoint2f();
  canonicalMarker.fromArray(canonicalPoints);

  Point[] points = new Point[4];
  for (int i = 0; i < 4; i++) {
    points[i] = new Point(inputPoints.get(i).x, inputPoints.get(i).y);
  }
  MatOfPoint2f marker = new MatOfPoint2f(points);
  return Imgproc.getPerspectiveTransform(marker, canonicalMarker);
}

Mat warpPerspective(ArrayList<PVector> inputPoints, Dimension dim, float[][] warp) {
  Mat transform = getPerspectiveTransformation(inputPoints, dim, warp);
  Mat unWarpedMarker = new Mat(dim.width, dim.height, CvType.CV_8UC1);    
  Imgproc.warpPerspective(opencv.getColor(), unWarpedMarker, transform, new Size(dim.width, dim.height));
  return unWarpedMarker;
}

PImage imageToGrayscale(PImage img) {
  for (int i = 0; i < img.pixels.length; i++) {
    // convert rgb to grayscale
    int argb = img.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
    if ( a == 0) {

      img.pixels[i] = color(255, 0, 0);
    } else {
      int val = (30 * r + 59 * g + 11 * b) / 100;
      img.pixels[i] = color(val);
    }
  }
  img.updatePixels();
  return img;
}


PImage brightenImage(PImage img, float amt) {
  for (int i = 0; i < img.pixels.length; i++) {
    // convert rgb to grayscale
    int argb = img.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
    if ( a == 0) {
      // skip
    } else {
      int val = (30 * r + 59 * g + 11 * b) / 100;
      int amtInt = int( map(amt, 0, 1, 0, 255));
      val += amtInt;
      if ( val > 255) val = 255;
      if ( val < 0) val = 0;
      img.pixels[i] = color(val,a);
    }
  }
  img.updatePixels();
  return img;
}
