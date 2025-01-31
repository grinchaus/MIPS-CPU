// модуль, который реализует расширенение
// 16-битной знаковой константы до 32-битной
module sign_extend(in, out);
  input [15:0] in;
  output [31:0] out;

  assign out = {{16{in[15]}}, in};
endmodule

// модуль, который реализует побитовый сдвиг числа
// влево на 2 бита
module shl_2(in, out);
  input [31:0] in;
  output [31:0] out;

  assign out = {in[29:0], 2'b00};
endmodule

// 32 битный сумматор
module adder(a, b, out);
  input [31:0] a, b;
  output [31:0] out;

  assign out = a + b;
endmodule

// 32-битный мультиплексор
module mux2_32(d0, d1, a, out);
  input [31:0] d0, d1;
  input a;
  output [31:0] out;
  assign out = a ? d1 : d0;
endmodule

// 5 - битный мультиплексор
module mux2_5(d0, d1, a, out);
  input [4:0] d0, d1;
  input a;
  output [4:0] out;
  assign out = a ? d1 : d0;
endmodule
// 1 - битный мультиплексор
module mux2_1(d0, d1, a, out);
  input d0, d1;
  input a;
  output out;
  assign out = a ? d1 : d0;
endmodule
//26-битной знаковой константы до 32-битной
module extendj(in, out);
  input [25:0] in;
  output [31:0] out;
  assign out = {6'b000000, in};
endmodule

module and_gate(a, b, out);
  input a, b;
  output reg out;

  always @(a && b) begin
    out = a && b;
  end
endmodule

module alu(a, b, control, res, null);
  input signed [31:0] a, b;
  input [2:0] control;
  output reg [31:0] res;
  output reg null;

  reg [31:0] tempb;

  always @(control or a or b) begin
    if (control[2] == 0) 
    begin 
      tempb = b;
    end else begin
      tempb = ~b;
    end

    case (control[1:0])
      0:
         res = a & tempb;
      1:
         res = a | tempb;
      2:
         res = a + tempb + control[2];
      3:
        if (control[2] == 1) begin
          if (a < b) begin
             res = 1;
          end else begin
             res = 0;
          end
        end 
      endcase

      if (res == 0) begin
        null = 1;
      end else begin
        null = 0;
      end
  end
endmodule

module control(op, func, mr, mw, bn, be,alue, rd, rw, aluc, jj, jal, jr);
  input wire [5:0] op;
  input wire [5:0] func;
  output wire mr, mw, bn, be, alue, rd, rw, jj, jal, jr;
  output reg [2:0] aluc;

  reg tmr, tmw, tbn, tbe, talue, trd, trw, tjj, tjal, tjr;

  reg [1:0] aluop;

  always @* begin

    tjr = 0; tjal = 0; tmr = 0;  talue = 0; tjj = 0; tmw = 0; tbe = 0; tbn = 0; trd = 0; trw = 0;

    case (op)
      0: begin
        trw = 1; trd = 1; aluop = 2'b10;
      end
      2: begin
        tjj = 1; aluop = 2'b10;
      end
      3: begin
        trw = 1; tjal = 1; tjj = 1; aluop = 2'b10;
      end
      4: begin
        tbe = 1; aluop = 2'b01;
      end
      5: begin
        tbn = 1; aluop = 2'b01;
      end
      8: begin
        trw = 1; talue = 1; aluop = 2'b00;
      end
      12: begin
        trw = 1; talue = 1; aluop = 2'b11;
      end
      35: begin
        trw = 1; talue = 1; tmr = 1; aluop = 2'b00;
      end
      43: begin
        talue = 1; tmw = 1; aluop = 2'b00;
      end
    endcase

    if (aluop == 2'b00)
    begin
      aluc = 3'b010;
    end 
    else if (aluop == 2'b11) 
    begin
      aluc = 3'b000;
    end 
    else if (aluop == 2'b01)
    begin
      aluc = 3'b110;
    end else begin
      case (func)
      6'b100100: aluc = 3'b000;
      6'b100101: aluc = 3'b001;
      6'b100000: aluc = 3'b010;
      6'b100010: aluc = 3'b110;
      6'b101010: aluc = 3'b111;
      6'b001000: tjr = 1;
      endcase
    end
  end

  assign mr = tmr;
  assign rd = trd;
  assign alue = talue;
  assign rw = trw;
  assign be = tbe;
  assign mw = tmw;
  assign bn = tbn;
  assign jj = tjj;
  assign jal = tjal;
  assign jr = tjr; 
endmodule