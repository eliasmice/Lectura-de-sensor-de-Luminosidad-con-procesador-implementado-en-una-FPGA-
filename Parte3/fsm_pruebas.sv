module fsm_pruebas (
    input logic clk,
    input logic rst,
    input logic boton_send,         //Botón que permite escribir el dato en registro para luego enviar
    input logic [31:0] salida_o,   //Puede ser el registro de control o el dato a mostrar

    output logic wr_i,        //Habilitación de escritura
    output logic reg_sel_i,   //Selector de registros
    output logic addr_i,      //Dirección de escritura
    output logic [1:0] selec  //Selector para el valor de entrada_i
);

    logic send;
    assign send = salida_o [0];
    logic new_rx;
    assign new_rx = salida_o [1];


    //Definimos la cantidad de bits de estado y su codificacion
    enum logic [2:0] {
        inicial,
        leds,
        escritura,
        lectura,
        limpiar_new_rx
    } estado, sig_estado;

    //MEMORIA SECUENCIAL (siempre es igual)
    always_ff @(posedge clk) begin
    if(rst) estado <= inicial;
    else estado <= sig_estado;
    end
    
    //LOGICA DE SIGUIENTE ESTADO COMBINACIONAL
    always_comb begin
    case(estado)
        inicial: begin
            if(rst) begin
                sig_estado = inicial;
            end
            if(!boton_send & !new_rx & send) begin
                sig_estado=inicial;
            end
            ///
            if (!boton_send & new_rx & !send) begin
                sig_estado = leds;
            end
            if (!boton_send & new_rx & send) begin
                sig_estado = leds;
            end
            if (!boton_send & !new_rx & !send) begin
                sig_estado = inicial;
            end
            if(boton_send) begin
                sig_estado=escritura; 
            end
        end
        
        leds: begin
            if(!new_rx) begin
                sig_estado=inicial;
            end
        end

        escritura: begin
                sig_estado=lectura;
        end

        lectura: begin
            if(!new_rx) begin
                sig_estado=inicial;
            end
            if(new_rx) begin
                sig_estado=limpiar_new_rx;
            end
        end
        limpiar_new_rx: begin
            sig_estado=inicial;
        end
        default sig_estado=inicial;
    endcase
    end
    
    
    //LOGICA DE SALIDA COMBINACIONAL
    always_comb begin
    case(estado)

    inicial: begin

        if(rst) begin
            wr_i = 0;
            reg_sel_i = 0;
            addr_i = 0;
            selec = 2'b00; //En realidad no importa
            
        end else begin
            if(!boton_send & new_rx & !send) begin  //vamos a leds
                wr_i = 1;
                reg_sel_i = 0;
                addr_i = 1;
                selec = 2'b01;
            end
            
            if(!boton_send & new_rx & send) begin  //vamos a leds
                wr_i = 1;
                reg_sel_i = 0;
                addr_i = 1;
                selec = 2'b10;
            end
            
            if(!boton_send & !new_rx & send) begin   //vovemos a inicio
                wr_i = 0;   
                reg_sel_i = 0;
                addr_i = 1;
                selec = 2'b10;
            end
    
            if(boton_send) begin   // vamos a escritura
                wr_i = 1;
                reg_sel_i = 1;
                addr_i = 0;
                selec = 2'b00;
            end
        end
    end

    leds: begin
        if(!new_rx) begin
            wr_i = 0;
            reg_sel_i = 1;
            addr_i = 1;
            selec = 2'b10;
        end else begin
            wr_i = 0;
            reg_sel_i = 1;
            addr_i = 1;
            selec = 2'b10;
        end
    end

    escritura: begin
     if(!rst) begin
        wr_i = 0;
        reg_sel_i = 0;
        addr_i = 0;
        selec = 2'b00;

     end
    end

    lectura: begin
        if(!new_rx) begin   //ACA PONEMOS BIT SEND EN 1
            wr_i = 1;
            reg_sel_i = 0;
            addr_i = 0;
            selec = 2'b10; 
        end
        if(new_rx) begin    //ACA ES DONDE LEEMOS EL DATO
            wr_i = 0;
            reg_sel_i = 1;
            addr_i = 1;
            selec = 2'b00;
        end
    end

    limpiar_new_rx: begin   //ACA LIMPIAMOS EL BIT NEW_RX
        if(!rst) begin
            wr_i = 1;
            reg_sel_i = 0;
            addr_i = 0;
            selec = 2'b10;
        end
    end
    endcase
    end
endmodule