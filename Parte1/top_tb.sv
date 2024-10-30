`timescale 1ns / 1ps

module tb_top_interfaz_periferico_spi;

    // Parámetros de simulación
    parameter N = 6;
    parameter CLK_PERIOD = 10; // Periodo del reloj en unidades de tiempo de simulación

    // Señales de entrada
    logic clk_fpga;

    logic rst;
    logic wr_i;
    logic reg_sel_i;
    logic [14:0] switches_in;
    //logic [N:0] addr_in;
    //logic i_SPI_MISO;

    // Señales de salida
    logic [15:0] salida_o;
    logic o_SPI_Clk;
    logic o_SPI_MOSI;
    logic C_Select;

    // Instancia del módulo bajo prueba
    top_interfaz_periferico_spi #(.N(7)) dut (
        .clk_fpga(clk_fpga),
        .rst(rst),
        .wr_btn(wr_i),
        .reg_sel_i(reg_sel_i),
        .switches_in(switches_in),
//        .addr_in(addr_in),
        .salida_o_leds(salida_o),
        //.i_SPI_MISO(~o_SPI_MOSI),
        .o_SPI_Clk(o_SPI_Clk),
        .o_SPI_MOSI(o_SPI_MOSI),
        .C_Select(C_Select)
    );

    // Señal de salida del clock_divider
    logic clk_out;

    // Instancia jer?rquica del subm?dulo clock_div_inst
    clock_divider #(
        .CLK_IN_FREQ(100_000_000),
        .CLK_OUT_FREQ(200000)
    ) clock_div_inst (
        .clk_in(clk_fpga),
        .clk_out(clk_out)
    );

    // Generación del reloj clk_fpga
    always #(CLK_PERIOD/2) clk_fpga = ~clk_fpga;

    initial begin 
        $dumpfile("waveformtop.vcd");
        $dumpvars(0, tb_top_interfaz_periferico_spi);
    end

    // Secuencia de prueba
    initial begin
        clk_fpga = 0;
        rst = 1;
        begin
            repeat (2) begin
            @(posedge clk_out);
            end
        end
        rst = 0;

        // Probamos con reg_sel_i activo 
        reg_sel_i = 1;  
        switches_in = 16'b1;
        wr_i = 1; 
         @(posedge clk_out);
         wr_i=0;

        begin
            repeat (2) begin
            @(posedge clk_out);
            end
        end

        reg_sel_i = 1;  
        switches_in = 16'b1_00000010;
        @(posedge clk_out);
        wr_i = 1; 

        begin
            repeat (1) begin
            @(posedge clk_out);
            end
        end
        wr_i = 0; 
        begin
            repeat (1) begin
            @(posedge clk_out);
            end
        end

    
        
        reg_sel_i = 0;   //Envia entrada registro de datos
        switches_in = 16'b11_0_0_1_1;
        wr_i = 1; // Por ejemplo, escribir en el registro cuando reg_sel_i está activo
        begin
            repeat (2) begin
            @(posedge clk_out);
            end
        end
        wr_i = 0;
        begin
            repeat (80) begin
            @(posedge clk_out);
            end
        end

        reg_sel_i = 0;   //Envia entrada registro de datos
        switches_in = 16'b11_0_0_1_1;
        wr_i = 1; // Por ejemplo, escribir en el registro cuando reg_sel_i está activo
         begin
            repeat (2) begin
            @(posedge clk_out);
            end
        end
        wr_i = 0;
        begin
            repeat (80) begin
            @(posedge clk_out);
            end
        end

        reg_sel_i = 1;  
        switches_in = 16'b0_00000010;
        begin
            repeat (10) begin
            @(posedge clk_out);
            end
        end
        switches_in = 16'b1_00000010;
        begin
            repeat (10) begin
            @(posedge clk_out);
            end
        end

        switches_in = 16'b10_00000010;
        begin
            repeat (10) begin
            @(posedge clk_out);
            end
        end

        switches_in = 16'b11_00000010;
        begin
            repeat (10) begin
            @(posedge clk_out);
            end
        end

        $finish;
    end

endmodule

