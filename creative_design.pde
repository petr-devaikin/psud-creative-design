import hypermedia.net.*;

Pointer pointer = new Pointer();
Manipulator manipulator = new Manipulator();

PrintWriter output;

float FREQUENCY = 60;

UDP udp;  // define the UDP object

void setup() {
  size(600, 600);
  udp = new UDP( this, 9222 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
  output = createWriter("p_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+".txt");
}

//process events
void draw() {
  background(0, 0, 0);
  pushMatrix();
  translate(300, 300);
  pointer.draw();
  popMatrix();
}


void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}



void receive(byte[] data, String ip, int port ) {
  manipulator.update(data);
  pointer.change(manipulator);
  redraw();
}