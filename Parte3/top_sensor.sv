module top_sensor (
    input logic i_clk,
    input logic rst,
    //del spi:
    


    output logic [7:0] salida_o_leds,
    
    // Puertos SPI
    input logic i_SPI_MISO,
    output logic o_SPI_Clk,
    output logic o_SPI_MOSI,
    output logic C_Select,
    
    //del uart :
    input logic rx,
    output logic tx,
    output logic [7:0] leds_uart,

    // Del Display

    output logic a, b, c, d, e, f, g,
    output logic [7:0] AN // Puertos para controlar los nodos comunes

);

logic send_uart; // SEÑAL SEND_UART DE LA MAQUINA DE ESTADOS


logic conto1;   //                  <<-- viene del detector de puslo
logic send_spi;
logic cuente1;
logic lab3;
logic clk_out;  //                  <<-- viene del clk_divider_1s -- pasarlo por el detector de pulso
logic clk;

clk_wiz_0 clk_inst(
     .clk_in1(i_clk),
     .clk_out1(clk)     
);

top unidad_top_uart_DUT (
    .rst(rst),
    .clk(clk),
    .boton_send(send_uart),
    .dato(salida_o_leds),
    .rx(rx),
    .tx(tx),
    .leds(leds_uart)
);

//INSTANCIAR UNIDAD DEL SPI
top_interfaz_periferico_spi #(.N(7),.switches(16)
) top_spi_inst(
    .clk(clk),
    .rst(rst),

    // Generador de datos y control de prueba
//    .wr_btn(wr_btn),
//    .reg_sel_i(reg_sel_i),
//    .switches_in(switches_in),
    .t_out_data_7(salida_o_leds),
    
    // Puertos SPI
    .i_SPI_MISO(i_SPI_MISO),
    .o_SPI_Clk(o_SPI_Clk),
    .o_SPI_MOSI(o_SPI_MOSI),
    .C_Select(C_Select),

    // Para el lab 3
    .send_spi(send_spi),
    .lab3(lab3)
);


fsm_sensor unidad_fsm_sensor_DUT( 
    .clk(clk),
    .rst(rst),
    .conto1(conto1),  //             <<-- viene del detector de pulso
    .send_spi(send_spi),
    .send_uart(send_uart),
    //.cuente1(cuente1),            <<-- no hace falta, siempre está contando
    .lab3(lab3)
);

clock_divider #(
    .CLK_IN_FREQ(10_000_000),
    .CLK_OUT_FREQ(1)
    )  unidad_contador1segundo_DUT ( 
    .clk_in(clk),
    .clk_out(clk_out)
);

antirebotes unidad_detector_pulso( 
    .clk(clk),
    .pulse(clk_out),
    .detected_pulse(conto1)
);

logic [15:0] deco_data;
assign deco_data = {7'b0,salida_o_leds};

logic [11:0] dato_decimal;
logic [15:0] deco_data_decimal;
assign deco_data_decimal = {4'b0,dato_decimal};

//INSTANCIAR DECO:
top_module_display deco7segments_inst (
    .switches(deco_data_decimal),
    .clk_10MHz(clk),   
    .i_Rst(rst),
    .a(a), 
    .b(b), 
    .c(c),
    .d(d), 
    .e(e), 
    .f(f),
    .g(g),
    .AN(AN) // Puertos para controlar los nodos comunes
);

logic [7:0] entrada_bcd;
assign entrada_bcd = salida_o_leds;

convertidor_bcd convertidor_bcd (
    .dato(entrada_bcd),
    .decimal(dato_decimal)
);

endmodule

