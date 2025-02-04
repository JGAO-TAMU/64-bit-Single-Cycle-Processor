module SignExtender(BusImm, Imm32, Ctrl);
  output reg [63:0] BusImm;  
  input [31:0] Imm32;        
  input [1:0] Ctrl;          

  always @(*) begin
    case (Ctrl)
      2'b00: begin
        // I-type 12-bit immediate
        BusImm = {{52{Imm32[21]}}, Imm32[21:10]};  
      end
      2'b01: begin
        // D-type 9-bit immediate
        BusImm = {{55{Imm32[20]}}, Imm32[20:12]};  
      end
      2'b10: begin
        // B 26-bit immediate
        BusImm = {{38{Imm32[25]}}, Imm32[25:0]};  
      end
      2'b11: begin
        // CBZ 19-bit immediate
        BusImm = {{45{Imm32[23]}}, Imm32[23:5]};  
      end
      default: begin
        BusImm = 64'b0;
      end
    endcase
  end
endmodule


// module SignExtender(BusImm, Imm32, Ctrl);

//   output reg [63:0] BusImm;  
//   input [31:0] Imm32;        
//   input [2:0] Ctrl; // 3-bit ctrl for movz

//   always @(*) begin
//     case (Ctrl)
//       2'b000: begin
//         // I-type 12-bit immediate
//         BusImm = {{52{Imm32[21]}}, Imm32[21:10]};  
//       end
//       2'b001: begin
//         // D-type 9-bit immediate
//         BusImm = {{55{Imm32[20]}}, Imm32[20:12]};  
//       end
//       2'b010: begin
//         // B 26-bit immediate
//         BusImm = {{38{Imm32[25]}}, Imm32[25:0]};  
//       end
//       2'b011: begin
//         // CBZ 19-bit immediate
//         BusImm = {{45{Imm32[23]}}, Imm32[23:5]};  
//       end
//       2'b100: begin
//         BusImm = {{}} // TODO
//       end
//       default: begin
//         BusImm = 64'b0;
//       end
//     endcase
//   end
// endmodule
