module fsm_sensor (
    input logic clk,
    input logic rst,
    input logic conto1,  //Señal que indica que se contó 1 segundo

    output logic send_spi,    //Señal que habilita el protocolo SPI   
    output logic send_uart,   //Señal que habilita el protocolo UART
    output logic cuente1,     //Señal que le indica al contador que cuente
    output logic lab3
);

    //Definimos la cantidad de bits de estado y su codificacion
    enum logic [1:0] {
        inicio,
        recepcion,
        muestra_dato
    } estado, sig_estado;

    //MEMORIA SECUENCIAL (siempre es igual)
    always_ff @(posedge clk) begin
    if(rst) estado <= inicio;
    else estado <= sig_estado;
    end
    
    //LOGICA DE SIGUIENTE ESTADO COMBINACIONAL
    always_comb begin
    case(estado)

        inicio: begin
            if(rst) begin
                sig_estado = inicio;
            end
            if(!conto1) begin
                sig_estado=recepcion;
            end
        end
        
        recepcion: begin
            if(!conto1) begin
                sig_estado=recepcion;
            end
            if(conto1) begin
                sig_estado=muestra_dato;
            end
        end

        muestra_dato: begin
            sig_estado=recepcion;
        end

        default sig_estado=inicio;
    endcase
    end
    
    
    //LOGICA DE SALIDA COMBINACIONAL
    always_comb begin
    case(estado)

    inicio: begin

        if(rst) begin
            send_spi = 0;
            send_uart = 0;
            cuente1 = 0;
            lab3 = 1; 
        end else begin
            if(!conto1) begin 
                send_spi = 1;
                send_uart = 0;
                cuente1 = 1;
                lab3 = 1;
            end
        end
    end

    recepcion: begin
        if(!conto1) begin
            send_spi = 0;
            send_uart = 0;
            cuente1 = 1;
            //lab3 = 0;
        end
        if(conto1) begin
            send_spi = 0;
            send_uart = 1;
            cuente1 = 1;
            //lab3 = 0;
        end
    end

    muestra_dato: begin
     if(!rst) begin
        send_spi = 1;
        send_uart = 0;
        cuente1 = 1;
        //lab3 = 0;
     end
    end

    endcase
    end
endmodule