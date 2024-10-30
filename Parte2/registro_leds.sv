module registro_leds(
    input wire clk,     // SeÃ±al de reloj
    input wire reset,   // SeÃ±al de reset
    input wire reg_sel_i,
    input wire addr_i,  // SeÃ±al de control para capturar el nuevo dato
    input wire [31:0] salida_o,  // SeÃ±al de entrada de 32 bits
    
    output reg [7:0] salida_reg  // Salida de los 8 bits mÃ¡s significativos del registro
);

reg [31:0] registro;  // Registro de 32 bits para almacenar el dato de entrada

always @(posedge clk) begin
    if (reset) begin
        registro <= 0;  // Si hay un reset, el registro se inicializa en 0
    end else begin
        if (reg_sel_i & addr_i) begin
            registro <= salida_o;  // Si addr_i es 1, captura el nuevo dato
        end
    end
end

// AsignaciÃ³n de los 8 bits mÃ¡s significativos del registro a la salida
assign salida_reg = registro[7:0];

endmodule