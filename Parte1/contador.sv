module contador #(parameter N = 5)(
    input clk,
    input rst,
    input cont_trans,
    input [N:0] n_tx_end,
    //input wr2_c,
    output logic [N+1:0] n_rx_end,
    output logic [N:0] addr2,
    output logic trans_ready
);

logic [N+1:0] cuenta_trans;

assign n_rx_end = cuenta_trans;
assign addr2 = cuenta_trans;

always_ff @(posedge clk) begin
    if (rst) begin
        cuenta_trans <= 0;
        trans_ready <= 0;
    end 
    else if (cont_trans) begin
        if (cuenta_trans == n_tx_end) begin
            trans_ready <= 1; 
            cuenta_trans <= 0;// Se dispara trans_ready justo antes de reiniciar cuenta_trans
        end else if (cuenta_trans < n_tx_end) begin
            cuenta_trans <= cuenta_trans + 1;
        end
    end
    else begin
        trans_ready <=0;
    end 
end

endmodule