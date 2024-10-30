module registro_datos_spi #(parameter N = 5)
(
    input logic clk,         
    input logic rst,
    input logic hold_ctrl,

    input logic [N:0]addr1,
    input logic [7:0] in1, //entrada externa
    input logic wr1,        //habilitaciÃ³n para in1
    
    input logic [N:0] addr2, 
    input logic wr2,        //habilitacion para in2
    input logic [7:0] in2,
    input logic lab3,
    

    output logic [31:0] out_data  // sale hacia el modulo de control externo
    
);
logic [N:0] address;
reg [31:0] registros [N:0];

assign out_data=registros[address];

//Dirección de consulta y acción en los registros dependiente del spi control
always_comb begin
    if (!hold_ctrl)
        address = addr1;  
    else address = addr2;
    if (lab3) address = 0;
end

always_ff @(posedge clk) begin : write
    if (rst) begin
        foreach(registros[i])begin 
            registros[i]=0;       //inicializamos los registros en 0
        end
    end
    if (wr1) begin
        registros[address] = in1;  
    end
    if(wr2) begin
        registros[address] = {23'b0,in2[7:0]};   
    end
end


endmodule