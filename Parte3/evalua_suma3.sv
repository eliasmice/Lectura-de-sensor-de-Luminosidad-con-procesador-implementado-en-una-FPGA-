module evalua_suma3 (
	input logic D0,
	input logic D1,
	input logic D2,
	input logic D3,
	output logic Q0,
	output logic Q1,
	output logic Q2,
	output logic Q3
);
	logic [3:0] entrada_concatenada;
	logic [3:0] resultado;

	assign entrada_concatenada = {D3, D2, D1, D0};

	always @(*) begin
            if (entrada_concatenada < 5) begin
			resultado = entrada_concatenada;
		end else begin
			resultado = entrada_concatenada + 3;
		end
	end

	assign {Q3, Q2, Q1, Q0} = resultado;
endmodule