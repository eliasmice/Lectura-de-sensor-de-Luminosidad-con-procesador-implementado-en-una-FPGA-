module deco7segments (
    input [3:0] selected_switches,
    output logic a, b, c, d, e, f, g
);

wire A, B, C, D;

assign A = selected_switches[3];
assign B = selected_switches[2];
assign C = selected_switches[1];
assign D = selected_switches[0];

always @* begin
    a = ~((~B & ~D) | (~A & C) | (~A & B & D) | (B & C) | (A & ~D) | (A & ~B & ~C));
    b = ~((A & ~C & D) | (~B & ~D) | (~A & ~C & ~D) | (~A & C & D) | (~A & ~B));
    c = ~((~C & D) | (~A & B) | (A & ~B) | (~A & ~C) | (~A & D));
    d = ~((B & ~C & D) | (~B & C & D) | (B & C & ~D) | (A & ~C & ~D) | (~A & ~B & ~D));
    e = ~((~B & ~D) | (C & ~D) | (A & C) | (A & B));
    f = ~((~C & ~D) | (B & ~D) | (~A & B & ~C) | (A & ~B) | (A & C));
    g = ~((~B & C) | (A & ~B) | (A & D) | (C & ~D) | (~A & B & ~C));
end


endmodule
