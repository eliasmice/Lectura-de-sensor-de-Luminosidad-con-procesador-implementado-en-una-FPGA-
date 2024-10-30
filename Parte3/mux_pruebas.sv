module mux_pruebas (
    input logic [7:0] dato,
    input logic [1:0] selec,
    output logic [31:0] entrada_i
);

    always @* begin
    case (selec)
        2'b00: entrada_i = {24'b0, dato};
        2'b01: entrada_i = {30'b0, 2'b00};
        2'b10: entrada_i = {30'b0, 2'b01};
        2'b11: entrada_i = {30'b0, 2'b11};
        default: entrada_i = 32'b0; 
    endcase
    end

endmodule