

// Instancia para el fsm con el registro de control 
module top_fsm_regcontrol #(
    parameter N = 5
)(
    input logic         clk,
    input logic         rst,
    
    input logic         wr_i,
    input logic         reg_sel_i,
    input logic  [31:0] entrada_i,
    input logic   [N:0] addr_in,
    input logic t_trans_ready,
    output logic [31:0] salida_o
);

    //Interconexiones 

    // Señales del FSM
    logic t_send;
//    logic t_trans_ready;
    logic t_RX_DV;
    logic t_inicio;
    logic t_cont_trans;
    logic t_wr2;
    logic t_hold_ctrl;
    // Señales del contador
    logic [N:0] t_n_tx_end;
    logic [N+1:0] t_n_rx_end;
//    logic trans_ready;
    logic send;
    logic wr2_c;

    // Instancia del FSM de control SPI
    fsm_control_spi #(N) fsm_control_spi_inst (
        .clk(clk),
        .rst(rst),
        .send(send),  
        .trans_ready(t_trans_ready),  
        .i_RX_DV(t_RX_DV),
        .inicio(t_inicio),  
        .cont_trans(t_cont_trans),
        .wr2(t_wr2),
        .hold_ctrl(t_hold_ctrl),
        .send_sign(t_send),
        .wr2_c(wr2_c) // Aquí deberías proporcionar la señal de escritura del registro de control del módulo FSM
    );
    
    
    // Instancia del registro de control
    registro_control #(N) control_register_inst (
        .clk(clk),
        .rst(rst),
        .i_data(entrada_i), // Aquí deberías proporcionar la entrada_i como los datos de entrada del registro de control
        .wr2_c(wr2_c), 
        .send_sign(t_send),
        .wr1_c(wr_i), 
        .send(send),
        .cs_ctrl(),  
        .all_1s(),  
        .all_0s(),  
        .n_tx_end(t_n_tx_end),
        .n_rx_end(t_n_rx_end)
    );
    
    
    // Instancia del contador
//    contador #(N) contador_inst (
//        .clk(clk),
//        .rst(rst),
//        .cont_trans(t_cont_trans),
//        .n_tx_end(t_n_tx_end),
//        .n_rx_end(t_n_rx_end),
//        .trans_ready(trans_ready),
//        .addr2(addr_in) // Aquí deberías proporcionar la dirección addr_in como la salida del contador
//    );

    // Instancia del módulo SPI_Master
//    SPI_Master spi_master_inst (
//        .rst(rst),
//        .Clk(clk),
//        .i_TX_Byte(8'h00),  
//        .inicio(t_inicio),
//        .o_TX_Ready(trans_ready),
//        .All_in1(1'b1),
//        .All_in0(1'b0),
//        .o_RX_DV(t_RX_DV),  
//        .o_RX_Byte(),  
//        .o_SPI_Clk(),  
//        .i_SPI_MISO(),  
//        .o_SPI_MOSI()  
//    );



//    // Instancia del registro de datos
//    registro_datos #(N) registro_datos_inst (
//        .clk(clk),
//        .rst(rst),
//        .addr1(),  
//        .in1(),  
//        .wr1(),  
//        .addr2(addr_in),  
//        .wr2(t_wr2),  
//        .in2(reg_sel_i ? entrada_i : 0), // Aquí proporcionas la entrada_i como entrada del registro de datos si reg_sel_i está activo
//        .out(salida_o)  
//    );

endmodule


