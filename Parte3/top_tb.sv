`timescale 1ns / 1ps
        
module tb_top_sensor;

    // Par�metros de simulaci�n
    parameter CLK_PERIOD = 10; // Periodo del reloj en unidades de tiempo de simulaci�n

    // Se�ales de entrada
    logic clk;
    logic rst;

    // Se�ales de salida
    logic [7:0] salida_o_leds;
    logic i_SPI_MISO;
    logic o_SPI_Clk;
    logic o_SPI_MOSI;
    logic C_Select;
    logic tx;
    logic rx;
    logic [7:0] leds_uart;
    logic a, b, c, d, e, f, g;
    logic [7:0] AN;
    
    

    // Instancia del m�dulo bajo prueba
    top_sensor dut (
        .i_clk(clk),
        .rst(rst),
//        .wr_btn(wr_btn),
//        .reg_sel_i(reg_sel_i),
//        .switches_in(switches_in),
        //.addr_in(addr_in),  // No se poseen los suficientes switches, se va a hacer un maguiver
        .salida_o_leds(salida_o_leds),
        .i_SPI_MISO(i_SPI_MISO),
        .o_SPI_Clk(o_SPI_Clk),
        .o_SPI_MOSI(o_SPI_MOSI),
        .C_Select(C_Select),
        .rx(rx),
        .tx(tx),
        .leds_uart(leds_uart),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .AN(AN)
    );
    
    assign i_SPI_MISO = ~o_SPI_MOSI;

    // Generaci�n del reloj clk
    always #(CLK_PERIOD/2) clk = ~clk;

//    initial begin 
//        $dumpfile("waveformtop_sensor.vcd");
//        $dumpvars(0, tb_top_sensor);
//    end

    // Secuencia de prueba
    initial begin
        clk = 0;
        rst = 0;
        // Esperar ciclos de reloj
        repeat (2000) @(posedge clk);
        rst = 1;
        repeat (2000) @(posedge clk);

        // Desactivar el reset
        rst = 0;
        
        repeat (200000000) @(posedge clk);

        $finish;
    end

endmodule
