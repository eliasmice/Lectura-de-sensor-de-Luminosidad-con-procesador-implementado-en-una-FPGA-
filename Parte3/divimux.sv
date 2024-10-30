module divimux (
    input logic clk, // Reloj de entrada de 10 MHz
    input logic rst,
    output logic enable // Señal de enable a 400 Hz
);

// Parámetros
parameter CLK_FREQUENCY = 10_000_000; // Frecuencia del reloj de entrada en Hz
parameter TARGET_FREQUENCY = 240; // Frecuencia objetivo en Hz
localparam CYCLES_PER_PERIOD = CLK_FREQUENCY / (2*TARGET_FREQUENCY);

// Contador para seguir el número de ciclos
logic [$clog2(CYCLES_PER_PERIOD)-1:0] cycle_counter;


// Módulo de generación de señal de enable
always_ff @(posedge clk) begin
    if (rst) begin
        cycle_counter <= 0;
        enable <= 1'b0;
    end else begin
        if (cycle_counter == CYCLES_PER_PERIOD - 1) begin
            cycle_counter <= 0;
            enable <= ~enable; // Cambiar el estado de la señal de enable cada período
        end else begin
            cycle_counter <= cycle_counter + 1;
        end
    end
end

endmodule
