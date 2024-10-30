
module antirebotes (
    input wire clk,
    input wire pulse,
    output reg detected_pulse
);

// Definici?n de par?metros para los estados
parameter Espere_uno = 1'b0;
parameter Espere_cero = 1'b1;

// Declaraci?n de se?ales de estado y salida
reg [1:0] state, next_state;
reg output_pulse;


// L?gica combinacional para la l?gica de transici?n y salida
always @(posedge clk) begin
        state <= next_state;
        detected_pulse <= output_pulse;
end

// Lógica secuencial para la máquina de estados
always @(*) begin
    case (state)
        Espere_uno: begin
            if (pulse) begin
                next_state = Espere_cero;
            end
            else begin
                next_state = Espere_uno;
            end
        end
        Espere_cero: begin
            if (pulse) begin
                next_state = Espere_cero;
            end
            else begin
                next_state = Espere_uno;
            end
        end
    endcase
end

//Lógica de salida
always @(*) begin
    case (state)
        Espere_uno: begin
            if (pulse) begin
                output_pulse = 1;
            end
            else begin
                output_pulse = 0;
            end
        end
        Espere_cero: begin
            if (pulse) begin
                output_pulse = 0;
            end
            else begin
                output_pulse = 0;
            end
        end
    endcase
end

// Inicialización de variables
initial begin
    state = Espere_uno;
    next_state = Espere_uno;
    output_pulse = 0;
end


endmodule