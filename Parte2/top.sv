module top (
    input logic clk, rst,
    input logic boton_send,

    input logic [7:0] dato,

    input logic rx,
    output logic tx,

    output logic [7:0] leds

);
logic boton_send_i;
logic rst_i;
logic [31:0] salida_o_in;
logic wr_i_in;
logic reg_sel_i_in;
logic addr_i_in;
logic [31:0] entrada_i_in;
logic clk_10MHz;

clk_wiz_0 clk_inst(
     .clk_in1(clk),
     .clk_out1(clk_10MHz)     
);

antirebotes antirebotes_send(
    .clk(clk_10MHz),
    .pulse(boton_send),
    .detected_pulse(boton_send_i)
);

antirebotes antirebotes_rst(
    .clk(clk_10MHz),
    .pulse(rst),
    .detected_pulse(rst_i)
);

gen_pruebas unidad_pruebas (
    .clk(clk_10MHz),
    .rst(rst_i),
    .salida_o(salida_o_in), //
    .boton_send(boton_send_i),
    .dato(dato),

    .wr_i(wr_i_in),//
    .reg_sel_i(reg_sel_i_in), //
    .addr_i(addr_i_in), //
    .entrada_i(entrada_i_in),//
    .leds(leds)
);

IPU unidad_IPU (

    .clk(clk_10MHz),
    .rst(rst_i),
    
    .wr_i(wr_i_in),//
    .reg_sel_i(reg_sel_i_in),//
    .entrada_i(entrada_i_in), //
    .addr_i(addr_i_in),//

    .salida_o(salida_o_in),//
    
    .rx(rx),
    .tx(tx)
);
endmodule