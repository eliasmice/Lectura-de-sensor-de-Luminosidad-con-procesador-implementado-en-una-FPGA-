module IPU (
    input logic clk,
    input logic rst,
    
    input logic wr_i,
    input logic reg_sel_i,
    input logic [31:0] entrada_i,
    input logic addr_i,
    input logic rx,

    output logic [31:0]salida_o,

    output logic tx

);
//seÃ±ales asociadas al registro de control
logic out_c_i;
//logic [31:0] entrada_i_in;
logic wr1_c_in;
logic wr2_c_in;
logic [1:0] in2_c_in;
logic [31:0] out_c_in;

//logic reg_sel_i_in;
logic wr_i_in;

logic wr1_d_in;

logic wr2_d_in;
logic [31:0] in2_d_in;
logic addr2_d_in;

logic [31:0] out_d_in;
logic [31:0] out_d0_in;

logic [7:0] salida_tx;
assign salida_tx = out_d0_in [7:0];

logic tx_start_in;
logic tx_rdy_in;
logic rx_data_rdy_in;

registro_control unidad_registrocontrol_DUT(
    .clk(clk),
    .rst(rst),
    .in1(entrada_i),
    .wr1_c(wr1_c_in),
    .wr2_c(wr2_c_in),
    .in2(in2_c_in),

    .out_c(out_c_in)
);

demux unidad_demux_DUT (
    .reg_sel_i(reg_sel_i),
    .wr_i(wr_i),
    .wr1_c(wr1_c_in),
    .wr1_d(wr1_d_in)
);

registro_datos unidad_registro_datos_DUT (
    .clk(clk),
    .rst(rst),
    .in1(entrada_i),
    .wr1_d(wr1_d_in),
    .wr2_d(wr2_d_in),
    .in2(in2_d_in),
    .addr1(addr_i),
    .addr2(addr2_d_in),
    .out(out_d_in),
    .out_d0(out_d0_in)
);

mux unidad_mux_DUT (
    .reg_sel_i(reg_sel_i),
    .out_c(out_c_in),
    .out_d(out_d_in),
    .salida_o(salida_o)
);

fsm unidad_fsm_DUT(
    .clk(clk),
    .rst(rst),
    .out_c(out_c_in),
    .rx_data_rdy(rx_data_rdy_in), //conectar con receptor
    .tx_rdy(tx_rdy_in),      //conectar con tranmisor
    .new_rx_send(in2_c_in),
    .we_c(wr2_c_in),
    .we_d(wr2_d_in),
    .addr2(addr2_d_in),
    .tx_start(tx_start_in)  //conectar con el transmisor
);

UART unidad_uart_dut(
    .clk(clk),
    .reset(rst),
    .tx_start(tx_start_in),
    .tx_rdy(tx_rdy_in),
    .rx_data_rdy(rx_data_rdy_in),
    .data_in(salida_tx),
    .data_out(in2_d_in),
    .tx(tx),
    .rx(rx)
);
endmodule


