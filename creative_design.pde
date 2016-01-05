import hypermedia.net.*;

Pointer pointer = new Pointer();
Manipulator manipulator = new Manipulator();

String input_file = "ex2.txt";
String next_line = null;

PrintWriter output;
BufferedReader reader;

float lastMillis = 0;

float FREQUENCY = 60;

UDP udp;  // define the UDP object

void setup() {
  size(600, 600);
  
  if (input_file == "") {
    udp = new UDP( this, 9222 );
    //udp.log( true );     // <-- printout the connection activity
    udp.listen( true );
    output = createWriter("p_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+".txt");
  }
  else {
    init_reader();
  }
}

void init_reader() {
  reader = createReader(input_file);
}

//process events
void draw() {
  background(0, 0, 0);
  pushMatrix();
  translate(300, 300);
  pointer.draw();
  popMatrix();
  
  if (input_file != "") {
    int time = millis();
    for (float i = lastMillis; i < time - lastMillis; i += 1000 / FREQUENCY) {
      readLine();
      lastMillis = i;
    }
  }
}


void keyPressed() {
  if (input_file == "") {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
  exit(); // Stops the program
}


// UDP receiver
void receive(byte[] data, String ip, int port ) {
  manipulator.update(data);
  pointer.change(manipulator);
  redraw();
}

// File reader
String[] readLine() {
  String[] data = null;
  
  try {
    next_line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    next_line = null;
  }
  
  if (next_line != null) {
    data = split(next_line, " ");
    manipulator.update(float(data[0]),
                       float(data[1]),
                       float(data[2]),
                       float(data[3]),
                       float(data[4]),
                       float(data[5]));
    pointer.change(manipulator);
  }
  else {
    println("End of file");
    init_reader();
  }
  
  return data;
}