module demux (
    input logic reg_sel_i,
    input logic wr_i,
    output logic wr1_c, //control
    output logic wr1_d  //datos
);

    assign wr1_c = (reg_sel_i) ? 1'b0 : wr_i;
    assign wr1_d = (reg_sel_i) ? wr_i : 1'b0;

endmodule
