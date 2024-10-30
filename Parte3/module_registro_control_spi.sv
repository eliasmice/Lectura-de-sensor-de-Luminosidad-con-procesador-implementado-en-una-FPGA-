module registro_control_spi #(
    parameter N = 5  //Debe ser menor o igual que 11
)(
    input                             clk,        // Reloj
    input                             rst,        // Reset
    input      [14:0]              i_data,     
    input                           wr2_c,
    input                           send_sign,  //permite limpiar el regitro 'send'
    input                            wr1_c,  //Enable para la escritura del dato de entrada
    input logic hold_ctrl,

    output                            send,       // Puerto de salida "send"
    output                         cs_ctrl,    // Puerto de control de salida CS
    output                          all_1s,     // Puerto de control "all_1s"
    output                          all_0s,     // Puerto de control "all_0s"
    output      [N:0]             n_tx_end,   // Puerto de control "n_tx_end"
    input      [N+1:0]            n_rx_end,    // Puerto de control "n_rx_end"
    output logic          [31:0]  out_ctrl,
    input logic                   send_spi
);

    // Registro de control de 32 bits
    reg [31:0] control_register;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            control_register <= 32'b0;
        end
        else begin
            // Actualizar el registro de control con los bits de i_data
            if (wr1_c) begin
                control_register[0]     <= i_data[0];
                control_register[1]     <= i_data[1];
                control_register[2]     <= i_data[2];
                control_register[3]     <= i_data[3];
                control_register[4+N:4] <= i_data[4+N:4];
            end
            if (send_spi) control_register = 32'b11;

            // Actualizar el registro de control con la se�al de send_sign
            if (wr2_c) begin
                control_register[0] <= ~control_register[0];
            end
                
            // Actualizar el registro de control con la se�al de hold_ctrl
            if (hold_ctrl) begin
                control_register[16+N+1:16] <= n_rx_end;
            end
        end
    end

    // Asignaciones a los puertos de control
    assign send = control_register[0];
    assign cs_ctrl = control_register[1];
    assign all_1s = control_register[2];
    assign all_0s = control_register[3];
    assign n_tx_end = control_register[4+N:4];
    assign out_ctrl = control_register;

endmodule
