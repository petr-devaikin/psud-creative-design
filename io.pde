import hypermedia.net.*;

String nextLine = null;

PrintWriter output;
BufferedReader reader;

UDP udp;  // define the UDP object

void setupIO() {
  if (inputFile == "")
    initListener();
  else
    initReader();
}

void exitIO() {
  if (inputFile == "") {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}

void saveData() {
  if (inputFile == "") {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    output = createWriter("p_"+day()+"-"+month()+"_"+hour()+"-"+minute()+"-"+second()+".txt");
  }
}

void initReader() {
  reader = createReader(inputFile);
}

void initListener() {
  udp = new UDP( this, 9222 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
  output = createWriter("p_"+day()+"-"+month()+"_"+hour()+"-"+minute()+"-"+second()+".txt");
}

// UDP receiver
void receive(byte[] data, String ip, int port ) {
  manipulator.update(data);
  updateSettings();
}

// File reader
String[] readLine() {
  String[] data = null;
  
  try {
    nextLine = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    nextLine = null;
  }
  
  if (nextLine != null) {
    data = split(nextLine, " ");
    manipulator.update(float(data[0]),
                       float(data[1]),
                       float(data[2]),
                       float(data[3]),
                       float(data[4]),
                       float(data[5]));
    updateSettings();
  }
  else {
    println("End of file");
    if (!recordVideo) {
      initReader();
      clearCanvas();
    }
  }
  
  return data;
}