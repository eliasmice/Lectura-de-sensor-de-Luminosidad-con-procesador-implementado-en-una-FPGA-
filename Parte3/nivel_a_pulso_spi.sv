module nivel_a_pulso ( 
input logic clk,

input logic in,

output logic out
);

enum logic [1:0] {
ESPERE_INICIO,
PULSO } estado, sig_estado;

bit initialized = 0;
always_ff @(posedge clk) begin
if (!initialized) begin
initialized <= 1;
estado <= ESPERE_INICIO;
end
else estado <= sig_estado;
end


//logica de siguiente estado  
always_comb begin
case(estado)
ESPERE_INICIO:
if(in) sig_estado = PULSO;
else        sig_estado = ESPERE_INICIO;
PULSO:
if(in)   sig_estado = PULSO;
else sig_estado = ESPERE_INICIO;
default:
sig_estado = ESPERE_INICIO;
endcase
end

//logica de salida
always_comb begin
case(estado)
ESPERE_INICIO:
if(in) out = 1;
else out = 0;
PULSO:
if(in) out = 0;
else out = 0;
endcase
end

endmodule