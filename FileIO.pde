ArrayList<File> getFileList(String dir) {
  ArrayList<File> files = new ArrayList<File>();
  Queue<File> dirs = new LinkedList<File>();
  dirs.add(new File(dir));
  while (!dirs.isEmpty ()) {
    for (File f : dirs.poll ().listFiles()) {
      if (f.isDirectory()) {
        dirs.add(f);
      } else if (f.isFile()) {
        String ext = getFileExtension(f);
        if ( ext.equals("png") || ext.equals("jpg")) {
          files.add(f);
        }
      }
    }
  }
  return files;
}
String getFileExtension(File file) {
  String name = file.getName();
  int lastIndexOf = name.lastIndexOf(".");
  if (lastIndexOf == -1) {
    return ""; // empty extension
  }
  return name.substring(lastIndexOf + 1);
}
