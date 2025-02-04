module Decode24 ( out , in ) ; 
  input [ 1 : 0 ] in ; //2 wide input 
  output [ 3 : 0 ] out ; //4 wide output

  assign out = (in == 2'b00) ? 4'b0001 :  //if in == 00, out = 0001
               (in == 2'b01) ? 4'b0010 :  // in == 01, out = 0010
               (in == 2'b10) ? 4'b0100 :  // in == 10, out = 0100
               (in == 2'b11) ? 4'b1000 :  // in = 11, out = 1000
               4'b0000; //else out == 0000
    
endmodule