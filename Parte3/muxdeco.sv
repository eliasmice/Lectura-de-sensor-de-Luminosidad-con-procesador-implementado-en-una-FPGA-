module muxdeco (
    input [15:0] switches,
    input [1:0] mux,
    output logic [3:0] selected_switches
);

logic [1:0] select;



always @* begin
    if (mux == 2'b10)begin
        select = 2'b10; // Selecciona el segundo grupo de switches
    end
    else if (mux == 2'b01)begin
        select = 2'b01; // Selecciona el tercer grupo de switches
    end

    else if (mux == 2'b11)begin  
        select = 2'b11; // Selecciona el cuarto grupo de switches
    end
    else begin
        select = 2'b00; // Selección predeterminada: primer grupo de switches
    end
end

always @* begin
    case (select)
        2'b00: selected_switches = switches[3:0];   // Muestra el primer grupo de switches
        2'b01: selected_switches = switches[7:4];   // Muestra el segundo grupo de switches
        2'b10: selected_switches = switches[11:8];  // Muestra el tercer grupo de switches
        default: selected_switches = switches[15:12];// Muestra el cuarto grupo de switches
    endcase
end

endmodule