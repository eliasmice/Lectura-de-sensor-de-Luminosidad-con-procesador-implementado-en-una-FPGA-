module top_module_display (
    input logic [15:0] switches,
    input  logic clk_10MHz,   
    input  logic i_Rst,
    output logic a, b, c, d, e, f, g,
    output logic [7:0] AN // Puertos para controlar los nodos comunes
);

//logic [15:0] q;
//logic [15:0] din;
logic [3:0] selected_switches;
logic [1:0] mux;
logic clk_mux;


// clk_wiz_0 instance_name(
//     // Clock out ports
//     .clk_out1(clk_10MHz),     // output clk_out1
//     .clk_in1(i_Clk)  // input clk_in1
//     );      

// Instancia del módulo muxdeco
muxdeco muxinst (
    .switches(switches),
    .mux(mux),
    .selected_switches(selected_switches)
);

// Instancia del módulo deco7segments
deco7segments deco (
    .selected_switches(selected_switches),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g)
);

control control (
    .clk(clk_mux),
    .rst(i_Rst),
    .mux_control(mux),
    .AN(AN)
);

divimux divimux(
    .clk(clk_10MHz), // Reloj de entrada de 10 MHz
    .rst(i_Rst),
    .enable(clk_mux) //Habilitador del mux para el display a encender
);


endmodule