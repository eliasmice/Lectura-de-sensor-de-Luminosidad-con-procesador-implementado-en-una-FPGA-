`timescale 1ns/1ns

module contador_tb;

    // Parámetros
    localparam N = 5;

    // Definición de señales
    reg clk;
    reg rst;
    reg cont_trans;
    reg [N:0] n_tx_end;
    
    wire [N+1:0] n_rx_end;
    wire trans_ready;
    wire [N:0] addr2;

    // Instancia del contador
    contador #(N) dut (
        .clk(clk),
        .rst(rst),
        .cont_trans(cont_trans),
        .n_tx_end(n_tx_end),
        .n_rx_end(n_rx_end),
        .trans_ready(trans_ready),
        .addr2(addr2)
    );

    // Generación de clock
    always #5 clk = ~clk;

    // Inicialización de señales
    initial begin
        clk = 0;
        rst =1;
        cont_trans = 0;
        n_tx_end = 6'd5; // Por ejemplo, un valor de 10 para n_tx_end
        repeat (2) begin
        @(posedge clk);
        end 
        rst = 0;
        cont_trans = 1; // Iniciar la señal de conteo después de 50 unidades de tiempo
        repeat (6) begin
        @(posedge clk);
        end
        //cont_trans = 0; // Detener la señal de conteo después de 100 unidades de tiempo
        repeat (6) begin
        @(posedge clk);
        end
        cont_trans = 1;
        repeat (6) begin
        @(posedge clk);
        end
        $finish; // Finalizar la simulación después de 10 unidades de tiempo adicionales
    end

//    // Monitoreo de las señales de salida
//    always @(n_rx_end, trans_ready, addr2) begin
//        $display("n_rx_end = %b, trans_ready = %b, addr2 = %b", n_rx_end, trans_ready, addr2);
//    end

endmodule
