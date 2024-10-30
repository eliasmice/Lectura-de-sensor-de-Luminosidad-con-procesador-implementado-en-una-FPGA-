`timescale 1ns/1ns

module registro_control_tb;

    // Parámetros y constantes
    parameter N = 5;
    parameter CLK_PERIOD = 10; // Periodo de reloj en unidades de tiempo
    parameter SIM_TIME = 200; // Tiempo total de simulación en unidades de tiempo

    // Señales de control y datos
    logic clk;
    logic rst;
    logic [31:0] i_data;
    logic wr2_c;

    // Puertos de salida
    logic send;
    logic cs_ctrl;
    logic all_1s;
    logic all_0s;
    logic [N:0] n_tx_end;
    logic [N+1:0] n_rx_end;

    // Instancia del módulo registro_control
    registro_control #(
        .N(N)
    ) dut (
        .clk(clk),
        .rst(rst),
        .i_data(i_data),
        .wr2_c(wr2_c),
        .send(send),
        .cs_ctrl(cs_ctrl),
        .all_1s(all_1s),
        .all_0s(all_0s),
        .n_tx_end(n_tx_end),
        .n_rx_end(n_rx_end)
    );

    // Generador de reloj
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Estímulos
    initial begin
        clk = 0;
        rst = 1;
        i_data = 'b0;
        wr2_c = 0;
        #10; // Espera un tiempo antes de quitar el reset
        rst = 0;
        #20; // Espera un poco después de quitar el reset

        // Genera algunos cambios en los datos de entrada
        i_data = 32'b11001100011001100011001100011001; // Cambia los datos de entrada
        wr2_c = 1; // Activa la escritura en el registro de control
        #20; // Espera un tiempo
        wr2_c = 0; // Desactiva la escritura en el registro de control

        // Más cambios en los datos de entrada
        i_data = 32'b10101010101010101010101010101010; // Cambia los datos de entrada nuevamente
        wr2_c = 1; // Activa la escritura en el registro de control
        #20; // Espera un tiempo
        wr2_c = 0; // Desactiva la escritura en el registro de control

        $finish; // Finaliza la simulación
    end

endmodule

module registro_control #(
    parameter N = 5  //Debe ser menor o igual que 11
)(
    input                             clk,        // Reloj
    input                             rst,        // Reset
    input      [31:0]              i_data,     // Dirección del último dato a enviar
    input                           wr2_c,
   
    inout                           send,       // Puerto de salida "send"
    inout                         cs_ctrl,    // Puerto de control de salida CS
    inout                          all_1s,     // Puerto de control "all_1s"
    inout                          all_0s,     // Puerto de control "all_0s"
    inout      [N:0]             n_tx_end,   // Puerto de control "n_tx_end"
    inout      [N+1:0]           n_rx_end    // Puerto de control "n_rx_end"
);

    // Registro de control de 32 bits
    reg [31:0] control_register;

    always_comb begin 
        if (wr2_c) 
            control_register[0] = send;
    end

    // Asignaciones a los puertos de control
    assign send = control_register[0];
    assign cs_ctrl = control_register[1];
    assign all_1s = control_register[2];
    assign all_0s = control_register[3];
    assign n_tx_end = control_register[4+N:4];
    assign n_rx_end = control_register[16+N+1:16];

    // Proceso para actualizar el registro de control con los bits de i_data
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_register <= 32'b0;  // Reset del registro de control en caso de reset
        end else begin
            // Actualizar el registro de control con los bits de i_data
            control_register[0]     <= i_data[0];
            control_register[1]     <= i_data[1
