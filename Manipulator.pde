class Manipulator {
  float[] acc = new float[3];
  float[] gyro = new float[3];
  
  void update(byte[] row_data) {
    //byte[] header = subset(row_data, 0, 4);
    
    acc[0] = get4bytesFloat(row_data, 4);
    acc[1] = get4bytesFloat(row_data, 8);
    acc[2] = get4bytesFloat(row_data, 12);
    
    gyro[0] = get4bytesFloat(row_data, 16);
    gyro[1] = get4bytesFloat(row_data, 20);
    gyro[2] = get4bytesFloat(row_data, 24);
    
    output.println(acc[0] + " " + acc[1] + " " + acc[2] + " " + gyro[0] + " " + gyro[1] + " " + gyro[2]);
  }
  
  void update(float acc1, float acc2, float acc3, float gyro1, float gyro2, float gyro3) {
    acc[0] = acc1;
    acc[1] = acc2;
    acc[2] = acc3;
    
    gyro[0] = gyro1;
    gyro[1] = gyro2;
    gyro[2] = gyro3;
  }
  
  // 0 - normal leg position
  // 1 - leg 'to sky'
  float getLegPosition() { 
    return -(acc[1] - 1) / 2;
  }
  
  // movement: raize leg
  float getLegRaize() {
    //float r1 = abs(1 - abs(acc[0])) * gyro[0];
    float r2 = abs(1 - abs(acc[2])) * gyro[2];
    return r2;
  }
  
  float getLegBringing() {
    float r1 = abs(acc[0]) * gyro[0];
    float r2 = abs(acc[2]) * gyro[2];
    return -r1;
  }
  
  float getLegSpin() {
    return gyro[1];
  }
  
  float get4bytesFloat(byte[] data, int offset) { 
    String hexint=hex(data[offset+3])+hex(data[offset+2])+hex(data[offset+1])+hex(data[offset]); 
    return Float.intBitsToFloat(unhex(hexint)); 
  } 
}