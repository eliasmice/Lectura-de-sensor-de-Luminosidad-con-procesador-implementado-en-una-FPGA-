module clock_divider #(
    parameter CLK_IN_FREQ = 100000000, // Frecuencia de reloj de entrada en Hz
    parameter CLK_OUT_FREQ = 200000   // Frecuencia de reloj de salida deseada en Hz
)(
    input clk_in,       // Reloj de entrada
    output clk_out      // Reloj de salida
);

localparam DIVISOR = CLK_IN_FREQ / (2*CLK_OUT_FREQ); // Calcular el factor de división

reg [$clog2(DIVISOR)-1:0] counter = 0; // Contador con el tamaño adecuado
reg clk_out_reg = 0;                   // Registro para almacenar la señal de reloj de salida

// Divisor de reloj
always @(posedge clk_in) begin
    if (counter == DIVISOR - 1) begin
        counter <= 0;
        clk_out_reg <= ~clk_out_reg; // Cambiar el estado del reloj de salida
    end else begin
        counter <= counter + 1;
    end
end

assign clk_out = clk_out_reg; // Asignar el registro al puerto de salida

endmodule