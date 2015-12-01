import hypermedia.net.*;


UDP udp;  // define the UDP object

void setup() {

  // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 6000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

//process events
void draw() {;}



void receive( byte[] data, String ip, int port ) {
  byte[] header = subset(data, 0, 4);
  
  float a_x = get4bytesFloat(data, 4);
  float a_y = get4bytesFloat(data, 8);
  float a_z = get4bytesFloat(data, 12);
  
  float g_x = get4bytesFloat(data, 16);
  float g_y = get4bytesFloat(data, 20);
  float g_z = get4bytesFloat(data, 24);
  
  // print the result
  println( "acceleration: "+a_x+", "+a_y+", "+a_z+" gyroscope: "+g_x+", "+g_y+", "+g_z+" from "+ip+" on port "+port );
}

float get4bytesFloat(byte[] data, int offset) { 
  String hexint=hex(data[offset+3])+hex(data[offset+2])+hex(data[offset+1])+hex(data[offset]); 
  return Float.intBitsToFloat(unhex(hexint)); 
} 