module mux (
    input logic [31:0] out_c,
    input logic [31:0] out_d,
    input logic reg_sel_i,
    output logic [31:0] salida_o
);

    assign salida_o = (reg_sel_i) ? out_d : out_c;

endmodule
