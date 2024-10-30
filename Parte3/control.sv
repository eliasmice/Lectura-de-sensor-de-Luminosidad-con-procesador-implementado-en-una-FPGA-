module control (
    input logic clk, // Reloj de entrada
    input logic rst,
    output logic [1:0] mux_control, // Señal de control para el multiplexor
    output logic [7:0] AN // Señal AN en formato hot bit
);

// Declaración de señales internas
logic [1:0] contador; // Contador interno



// Proceso para el contador y asignación de mux_control y AN
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        contador = 2'b00; // Inicialización del contador
    end else begin
        if (contador == 2'b11) begin // Si el contador está en 3, reiniciar a 0
            contador <= 2'b00;
        end else begin
            contador <= contador + 1; // Incrementar el contador en 1
        end

        // Asignación de mux_control y AN basado en el valor del contador
        case (contador)
            2'b00: begin
                mux_control = 2'b00; // 1 en binario normal
                AN = 8'b11111110; // Hot bit en la primera posición
            end
            2'b01: begin
                mux_control = 2'b01; // 2 en binario normal
                AN = 8'b11111101; // Hot bit en la segunda posición
            end
            2'b10: begin
                mux_control = 2'b10; // 4 en binario normal
                AN = 8'b11111011; // Hot bit en la tercera posición
            end
            default: begin
                mux_control = 2'b11; // 8 en binario normal
                AN = 8'b11110111; // Hot bit en la cuarta posición
            end
        endcase
    end
end

endmodule
