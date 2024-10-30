module top_interfaz_periferico_spi #(
    parameter N = 7,
    parameter switches = 16
)(
    input logic         clk,
    input logic         rst,

    // Generador de datos y control de prueba
    input logic         wr_btn,
    input logic         reg_sel_i,
    input logic  [switches-2:0] switches_in,
    // input logic   [N:0] addr_in,  // No se poseen los suficientes switches, se va a hacer un maguiver

    output logic [7:0] t_out_data_7,
    //output logic [15:0] salida_o_leds,
    
    // Puertos SPI
    input logic i_SPI_MISO,
    output logic o_SPI_Clk,
    output logic o_SPI_MOSI,
    output logic C_Select,

    // Para el lab 3
    input logic send_spi,
    input logic lab3
);
    

//    logic clk;

    // Asignaci�n dependiendo los switches que poseamos
    logic [switches-2:0] entrada_i;
    logic [N:0] addr_in;
    logic [7:0] entrada_reg_data;
    
    
    logic [31:0] salida_o;
 
    logic [15:0]salida_o_ceros;
    assign salida_o_ceros = salida_o[31:16];
    
    
    assign entrada_i = switches_in;
    assign addr_in[N:0] = switches_in[N-1+8:8];
    assign entrada_reg_data = switches_in [7:0];

    //Interconexiones 

    // Se�ales del FSM
    logic t_send;
    logic t_trans_ready;
    logic t_RX_DV;
    logic t_inicio;
    logic t_cont_trans;
    logic t_wr2;
    logic t_hold_ctrl;
    logic t_wr2_c;
    logic [N:0] t_addr2;

    // Se�ales del contador
    logic [N:0] t_n_tx_end;
    logic [N+1:0] t_n_rx_end;
    logic t_send_sign;

    // Se�ales del registro de control
    logic [31:0] t_out_ctrl;
    logic t_cs_ctrl;
    logic t_wr1_c;


    // Se�ales del spi master 
    logic t_All_in1;
    logic t_All_in0;

    // Se�ales del registro de datos
    logic [31:0] t_out_data;
    
    assign t_out_data_7 = t_out_data[7:0];
    logic [7:0] t_in2;
    logic t_wr1;    

    logic wr_i;   
    


//    clock_divider #(
//    .CLK_IN_FREQ(100_000_000),
//    .CLK_OUT_FREQ(10_000_000)
//    ) 
//    clock_divider_inst(
//    .clk_in(clk_fpga),       // Reloj de entrada
//    .clk_out(clk)      // Reloj de salida
//    );
    
//    clk_wiz_0 clk_inst(
//     .clk_in1(clk_fpga),
//     .clk_out1(clk)     
//    );
    
    nivel_a_pulso nivel_a_pulso_inst( 
    .clk(clk),
    .in(wr_btn),
    .out(wr_i)
    );
    
    

    // Instancia del FSM de control SPI
    fsm_control_spi fsm_control_spi_inst (
        .clk(clk),
        .rst(rst),
        .send(t_send),  
        .trans_ready(t_trans_ready),  
        .i_RX_DV(t_RX_DV),
        .inicio(t_inicio),  
        .cont_trans(t_cont_trans),
        .wr2(t_wr2),
        .hold_ctrl(t_hold_ctrl),
        .wr2_c(t_wr2_c) // Aqu� deber�as proporcionar la se�al de escritura del registro de control del m�dulo FSM
    );

    // Instancia del contador
    contador #(N) contador_inst (
        .clk(clk),
        .rst(rst),
        .cont_trans(t_cont_trans),
        .n_tx_end(t_n_tx_end),
        .n_rx_end(t_n_rx_end),
        .trans_ready(t_trans_ready),
        .addr2(t_addr2) 
    );



    logic [15:0] i_data_spi;
//    assign i_data_spi[7:0]=t_out_data_7;
    assign i_data_spi = {8'b0, t_out_data_7};
    
    logic [15:0] o_data_spi;
    assign t_in2 = o_data_spi[11:4];
    
    // Instancia del m�dulo SPI_Master
    SPI_Master #(.CLKS_PER_HALF_BIT(2)) spi_master_inst (
        .rst(rst),
        .Clk(clk),
        .i_TX_Byte(i_data_spi),  
        .inicio(t_inicio),
        //.o_TX_Ready(),
        .All_in1(t_All_in1),
        .All_in0(t_All_in0),
        .cs_ctrl(t_cs_ctrl),
        .o_RX_DV(t_RX_DV),  
        .o_RX_Byte(o_data_spi),  
        .o_SPI_Clk(o_SPI_Clk),  
        .i_SPI_MISO(i_SPI_MISO),  
        .o_SPI_MOSI(o_SPI_MOSI),
        .CSelect(C_Select) 
    );

    // Instancia del registro de control
    registro_control_spi #(N) control_register_inst (
        .clk(clk),
        .rst(rst),
        .i_data(entrada_i), // Aqu� deber�as proporcionar la entrada_i como los datos de entrada del registro de control
        .wr2_c(t_wr2_c),
        .wr1_c(t_wr1_c),
        .send(t_send), 
        .send_sign(t_send_sign),
        .cs_ctrl(t_cs_ctrl),  
        .all_1s(t_All_in1),  
        .all_0s(t_All_in0),  
        .n_tx_end(t_n_tx_end),
        .n_rx_end(t_n_rx_end),
        .out_ctrl(t_out_ctrl),
        .hold_ctrl(t_hold_ctrl),
        .send_spi(send_spi)
    );

    // Instancia del registro de datos
    registro_datos_spi #(.N(N))registro_datos_inst ( 
        .clk(clk),
        .rst(rst),
        .hold_ctrl(t_hold_ctrl),
        .addr1(addr_in),  
        .in1(entrada_reg_data),  
        .wr1(t_wr1),  
        .addr2(t_addr2),  
        .wr2(t_wr2),  
        .in2(t_in2), 
        .out_data(t_out_data),
        .lab3(lab3)
    );

    


    // Multiplexor a la salida 
    always_comb begin
        if (reg_sel_i == 1'b1) // Si reg_sel_i est� activo, selecciona los datos de entrada
            salida_o = t_out_data;
               
        else // Si reg_sel_i est� inactivo, selecciona seg�n la se�al de control t_out_ctrl
            salida_o = t_out_ctrl;
    end

    // Demultiplexor a la entrada
    always_comb begin
        if (reg_sel_i == 1'b1) begin // Si reg_sel_i est� activo, selecciona los datos de entrada
            t_wr1 = wr_i;
            t_wr1_c = 0;
        end
        else begin// Si reg_sel_i est� inactivo, selecciona seg�n la se�al de control t_out_ctrl
            t_wr1_c = wr_i;
            t_wr1 = 0;
        end
    end

endmodule

