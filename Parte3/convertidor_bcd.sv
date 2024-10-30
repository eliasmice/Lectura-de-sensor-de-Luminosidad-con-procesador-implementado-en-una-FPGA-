module convertidor_bcd (
	input logic [7:0] dato,
	output logic [11:0] decimal);

logic [3:0] unidades;
logic [3:0] decenas;
logic [3:0] centenas;
logic [4:0][3:0] cable;
assign unidades[0] = dato[0];
assign centenas[1] = cable[4][3];

evalua_suma3 ev0(dato[5],dato[6],dato[7],0,cable[0][0],cable[0][1],cable[0][2],cable[0][3]);
evalua_suma3 ev1(dato[4],cable[0][0],cable[0][1],cable[0][2],cable[1][0],cable[1][1],cable[1][2],cable[1][3]);
evalua_suma3 ev2(dato[3],cable[1][0],cable[1][1],cable[1][2],cable[2][0],cable[2][1],cable[2][2],cable[2][3]);
evalua_suma3 ev3(dato[2],cable[2][0],cable[2][1],cable[2][2],cable[3][0],cable[3][1],cable[3][2],cable[3][3]);
evalua_suma3 ev4(cable[2][3],cable[1][3],cable[0][3],0,cable[4][0],cable[4][1],cable[4][2],cable[4][3]);
evalua_suma3 ev5(dato[1],cable[3][0],cable[3][1],cable[3][2],unidades[1],unidades[2],unidades[3],decenas[0]);
evalua_suma3 ev6(cable[3][3],cable[4][0],cable[4][1],cable[4][2],decenas[1],decenas[2],decenas[3],centenas[0]);

assign centenas[2] = 0;
assign centenas[3] = 0;

assign decimal = {centenas, decenas, unidades};

endmodule