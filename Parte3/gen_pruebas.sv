module gen_pruebas (
    input logic clk, rst,

    input logic [31:0] salida_o,
    input logic boton_send,
    input logic [7:0] dato,

    output logic wr_i,
    output logic reg_sel_i,
    output logic addr_i,
    output logic [31:0] entrada_i,
    output logic [7:0] leds

);
logic [1:0] selec_i;
fsm_pruebas unidadfsm_pruebas (
    .clk(clk),
    .rst(rst),
    .boton_send(boton_send),
    .salida_o(salida_o),
    .wr_i(wr_i),
    .reg_sel_i(reg_sel_i),
    .addr_i(addr_i),
    .selec(selec_i)
);

mux_pruebas unidad_mux_pruebas (
    .dato(dato),
    .selec(selec_i),
    .entrada_i(entrada_i)
);

registro_leds unidad_registro_leds (
    .clk(clk),
    .reset(rst),
    .addr_i(addr_i),
    .reg_sel_i(reg_sel_i),
    .salida_o(salida_o),
    .salida_reg(leds)
);
endmodule