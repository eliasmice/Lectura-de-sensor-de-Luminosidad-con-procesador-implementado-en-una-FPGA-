module fsm (
    input logic clk,
    input logic rst,
    input logic [31:0] out_c,//salida del registro de control
    input logic rx_data_rdy, //seÃ±al que indica que la recepciÃ³n finalizÃ³
    input logic tx_rdy,      //seÃ±al que indica que la transmisiÃ³n finalizÃ³

    output logic [1:0] new_rx_send, //seÃ±ales de control_ registro de control
    output logic we_c, we_d,   //seÃ±ales de habilitaciÃ³n de escritura en control y datos respectiv.
    output logic addr2,       //direcciÃ³n de escritura registro de datos
    output logic tx_start     //seÃ±al para comenzar la transmisiÃ³n
);
logic new_rx;
logic send;
assign new_rx_send = {new_rx,send};

logic new_rx_in;
assign new_rx_in = out_c[1]; 
logic send_in;
assign send_in = out_c[0];

    //Definimos la cantidad de bits de estado y su codificacion
    enum logic [1:0] {
        sin_comunicacion,
        enviando
    } estado, sig_estado;

    //MEMORIA SECUENCIAL (siemore es igual)
    always_ff @(posedge clk) begin
    if(rst) estado <= sin_comunicacion;
    else estado <= sig_estado;
    end
    
    //LOGICA DE SIGUIENTE ESTADO COMBINACIONAL
    always_comb begin
    case(estado)
        sin_comunicacion: begin
            if(rst) begin
                sig_estado = sin_comunicacion;
            end
            if (!send_in & !rx_data_rdy & !tx_rdy) begin
                sig_estado = sin_comunicacion;
            end
            if(!send_in & rx_data_rdy & !tx_rdy) begin
                sig_estado=sin_comunicacion; 
            end
            if(send_in & !rx_data_rdy & !tx_rdy) begin
                sig_estado=enviando;
            end
            if(send_in & rx_data_rdy & !tx_rdy) begin
                sig_estado=enviando;
            end
        end
        
        enviando: begin
            if(send_in & rx_data_rdy & !tx_rdy) begin
                sig_estado=enviando;
            end
            if(send_in & !rx_data_rdy & !tx_rdy) begin
                sig_estado=enviando;
            end
            if(send_in & tx_rdy) begin
                sig_estado=sin_comunicacion; //esta transiciÃ³n toma en cuenta las dos formas de retornar a sin comuniaciÃ³n' desde enviando
            end
        end
    endcase
    end
    
    //LOGICA DE SALIDA COMBINACIONAL
    always_comb begin
    case(estado)

    sin_comunicacion: begin

        if(rst | (!send_in & !rx_data_rdy & !tx_rdy)) begin
            new_rx=0;
            send=0;
            we_c=0;
            we_d=0;
            addr2=1; //decision
            tx_start=0;
        end

        if(!send_in & rx_data_rdy & !tx_rdy) begin
            new_rx=1;
            send=0;
            we_c=1;
            we_d=1;
            addr2=1; 
            tx_start=0;
        end

        if(send_in & !rx_data_rdy & !tx_rdy) begin
            new_rx=0;
            send=0;
            we_c=0;
            we_d=0;
            addr2=1; //decision
            tx_start=1;
        end

        if(send_in & rx_data_rdy & !tx_rdy) begin
            new_rx=1;
            send=1;
            we_c=1;
            we_d=1;
            addr2=1;
            tx_start=1;
        end
    end
    enviando: begin
        if(send_in & rx_data_rdy & !tx_rdy) begin
            new_rx=1;
            send=1;
            we_c=1;
            we_d=1;
            addr2=1; 
            tx_start=send_in;
        end
        if(send_in & !rx_data_rdy & !tx_rdy)  begin
            new_rx=0; //no deberÃ­a importar
            send=1;
            we_c=0;
            we_d=0;
            addr2=1; //decision
            tx_start=send_in;
        end
        if(send_in & !rx_data_rdy &tx_rdy) begin
            new_rx=0; 
            send=0;
            we_c=1;
            we_d=0;
            addr2=1; //decision
            tx_start=0;
        end
        if(send_in & rx_data_rdy & tx_rdy) begin
            new_rx=1; 
            send=0;
            we_c=1;
            we_d=1;
            addr2=1; //decision
            tx_start=0;

        end
    end

    endcase
    end
endmodule