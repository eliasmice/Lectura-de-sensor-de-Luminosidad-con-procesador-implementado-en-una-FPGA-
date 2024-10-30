

module fsm_control_spi (
    // ENTRADAS
    input logic clk, rst,
    input logic send,
    input logic trans_ready, // Cuando se envian los = n tx end en diagrama
    input logic i_RX_DV,
    // SALIDAS
    output logic inicio,
    output logic cont_trans,
    output logic wr2,
    output logic hold_ctrl,
    output logic wr2_c
);
    // Definimos la cantidad de bits de estado y su codificacion
    enum logic [1:0] {
        manda_hold,
        manda_inicio,
        inicia_trans
    } estado, sig_estado;
    
    // LOGICA DE SIGUIENTE ESTADO COMBINACIONAL
    always_comb begin
        case (estado)
            manda_hold: 
                if (send) sig_estado = manda_inicio;
                else if (!send)  sig_estado = manda_hold;
                else if (trans_ready)  sig_estado = manda_hold;
            manda_inicio: 
                if (send) 
                    sig_estado = inicia_trans;
                else 
                    sig_estado = manda_inicio;
            inicia_trans:
                if (!trans_ready && i_RX_DV) sig_estado = manda_hold;
                else if (!trans_ready && !i_RX_DV) sig_estado = inicia_trans;
            default:
                sig_estado = manda_hold;
        endcase
    end

    // MEMORIA SECUENCIAL (siempre es igual)
    always_ff @(posedge clk) begin
        if (rst) 
            estado <= manda_hold;
        else 
            estado <= sig_estado;
    end

    // LOGICA DE SALIDA COMBINACIONAL
    always_comb begin
        case (estado)
            manda_hold: 
                if (trans_ready) 
                    {inicio, cont_trans, wr2, hold_ctrl, wr2_c} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
                else if (send) {inicio, cont_trans, wr2, hold_ctrl, wr2_c} = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
                else if (!send) {inicio, cont_trans, wr2, hold_ctrl, wr2_c} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
            manda_inicio:
                if (send) 
                    {inicio, cont_trans, wr2, hold_ctrl, wr2_c} = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0};
                else if (!send) 
                    {inicio, cont_trans, wr2, hold_ctrl, wr2_c} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
            inicia_trans:
                if (!trans_ready && i_RX_DV) 
                    {inicio, cont_trans, wr2, hold_ctrl, wr2_c} = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0};
                else if (!trans_ready && !i_RX_DV) 
                    {inicio, cont_trans, wr2, hold_ctrl, wr2_c} = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
                
        endcase
    end    
endmodule

