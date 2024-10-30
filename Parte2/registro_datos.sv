module registro_datos (
    input logic clk,         
    input logic rst,

    input logic [31:0] in1, //entrada externa
    input logic wr1_d,        //habilitaciÃ³n para in1

    input logic wr2_d,        //habilitacion para in2
    input logic [31:0] in2,

    input logic addr2, //generalemnte va a ser 1
    input logic addr1,  //generalmente va a ser 0

    output logic [31:0] out,  // sale hacia el modulo de control externo
    output logic [31:0] out_d0  //sale para el modulo uart  (solo le importa el valor del registro 0)
);

reg [31:0] registros [1:0];

//salida de datos
assign out=registros[addr1];  //esta salida depende de la direcciÃ³n addr1 
assign out_d0=registros[0];   //decidimos ponerla fija para enviarla al uart

always_ff @(posedge clk) begin : write
    if (rst) begin
        foreach(registros[i])begin 
            registros[i]<=0;       //inicializamos los registros en 0
        end
    end
    if (wr1_d) begin
        registros[addr1] <= in1;  //normalmente va a registro 0
    end
    if(wr2_d) begin
        registros[addr2] ={24'b0,in2[7:0]};   //normalmente va a registro 1
    end
end


endmodule