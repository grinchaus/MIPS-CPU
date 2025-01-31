`include "util.v"

module mips_cpu(clk, pc, pc_new, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
                register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2);
  // сигнал синхронизации
  input clk;
  // текущее значение регистра PC
  inout [31:0] pc;
  // новое значение регистра PC (адрес следующей команды)
  output [31:0] pc_new;
  // we для памяти данных
  output data_memory_we;
  // адреса памяти и данные для записи памяти данных
  output [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
  // данные, полученные в результате чтения из памяти
  inout [31:0] instruction_memory_rd, data_memory_rd;
  // we3 для регистрового файла
  output register_we3;
  // номера регистров
  output [4:0] register_a1, register_a2, register_a3;
  // данные для записи в регистровый файл
  output [31:0] register_wd3;
  // данные, полученные в результате чтения из регистрового файла
  inout [31:0] register_rd1, register_rd2;

  wire mr, mw, bn, be, alue, rd, rw, jj, jal, jr;
  wire [2:0] aluc;
  control control1(instruction_memory_rd[31:26], instruction_memory_rd[5:0], mr, mw, bn, be, alue, rd, rw, aluc, jj, jal, jr);

  assign register_a1 = instruction_memory_rd[25:21];
  assign register_a2 = instruction_memory_rd[20:16];
  assign register_we3 = rw;
  assign data_memory_we = mw;
  assign instruction_memory_a = pc;

  wire [4:0] trw;
  mux2_5 mux2_51(instruction_memory_rd[20:16], instruction_memory_rd[15:11], rd, trw);
  mux2_5 mux2_52(trw, 5'b11111, jal, register_a3);

  wire [31:0] con;
  wire [31:0] pc0;
  wire [31:0] pc1;
  wire [31:0] conm;
  wire m1, m2;
  sign_extend sign_extend1(instruction_memory_rd[15:0], con);
  shl_2 shl_21(con, conm);
  alu al2(pc, 4, 3'b010, pc0, m1);
  alu al3(pc0, conm, 3'b010, pc1, m2);

  wire [31:0] alures;
  wire [31:0] src2;
  wire null;
  mux2_32 mux2_321(.d0(register_rd2), .d1(con), .a(alue), .out(src2));
  alu al1(register_rd1, src2, aluc, alures, null);

  assign data_memory_a = alures;
  assign data_memory_wd = register_rd2;

  wire [31:0] treg;
  mux2_32 mux2_322(alures, data_memory_rd, mr, treg);
  mux2_32 mux2_323(treg, pc0, jal, register_wd3);

  wire a, b, pcs;
  mux2_1 mux2_11(bn, be, null, b);
  mux2_1 mux2_12(!null, null, be, a);
  and_gate and_gate1(b, a, pcs);

  wire [31:0] tjj;
  wire [31:0] jjext;
  extendj extendj1(instruction_memory_rd[25:0], tjj);
  shl_2 shl_22(tjj, jjext);

  wire [31:0] tpc;
  wire [31:0] tpc2;
  mux2_32 mux2_324(pc0, pc1, pcs, tpc);
  mux2_32 mux2_325(tpc, jjext, jj, tpc2);
  mux2_32 mux2_326(tpc2, register_rd1, jr, pc_new);
endmodule