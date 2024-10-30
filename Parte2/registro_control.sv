module registro_control (
    input logic clk,         
    input logic rst,

    input logic [31:0] in1, //entrada externa
    input logic wr1_c,        //habilitaciÃ³n para in1

    input logic wr2_c,        //habilitacion para in2
    input logic [1:0] in2,

    output reg [31:0] out_c
);

reg [31:0] registro;

always_comb begin: read
    out_c = registro;
end

always_ff @(posedge clk) begin : write
    if (rst) begin
        registro <= 32'b0;
    end
    if (wr1_c & !wr2_c) begin
        registro <= in1;
    end
    if(wr2_c & !wr1_c) begin
        registro[1:0] <=in2;
    end
    if(wr2_c & wr1_c) begin
        registro[31:2] <= in1;
        registro[1:0]  <= in1[1:0] | in2; 
    end
end

endmodule