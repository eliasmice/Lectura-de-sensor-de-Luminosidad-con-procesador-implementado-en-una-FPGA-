

module SPI_Master
  #(
    parameter CLKS_PER_HALF_BIT = 500)
  (
   
   input        rst,     //Reset
   input        Clk,       //Clock
   
   // TX se�ales para mosi
   input [7:0]  i_TX_Byte,        // Byte a transmitir en MOSI
   input logic inicio,          // Pulso de Datos V�lidos con i_TX_Byte
        
   
   input logic All_in1, All_in0,cs_ctrl,
   
   // RX se�ales para miso
   output logic       o_RX_DV,     // Pulso de Datos V�lidos (1 ciclo de reloj)
   output logic [7:0] o_RX_Byte,   // Byte recibido en MISO

   // SPI 
   output logic o_SPI_Clk,
   input  logic i_SPI_MISO,
   output logic o_SPI_MOSI,
   output logic CSelect          //Se�al Chip Select
   ); 


  logic [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_SPI_Clk_Count;
  logic r_SPI_Clk;
  logic [4:0] r_SPI_Clk_Edges;
  logic r_Leading_Edge;
  logic r_Trailing_Edge;
  logic       r_TX_DV;
  logic [7:0] r_TX_Byte;
  logic   o_TX_Ready;


  logic [2:0] r_RX_Bit_Count;
  logic [2:0] r_TX_Bit_Count;





//Proposito: La siguiente maquina de estados se define para la generaci�n del CHIP SELECT, cs_ctrl controla la logica si activo en bajo o en alto
// Definici?n de par?metros para los estados
// Definici�n de constantes para los estados
localparam ESPERA = 2'b00;
localparam TRANSF = 2'b01;

// Declaraci?n de se?ales de estado y salida
logic [1:0] state, next_state;
logic o_CS;

// L?gica combinacional para la l?gica de transici?n y salida
always @(posedge Clk) begin
        state <= next_state;
        if (~cs_ctrl) CSelect <= o_CS;
        else CSelect <= ~o_CS;
end

// L�gica secuencial para la m�quina de estados
always @(*) begin
    case (state)
        ESPERA: begin
            if (inicio) begin
                next_state = TRANSF;
                o_CS = 1;
            end
            else begin
                next_state = ESPERA;
                o_CS = 0;
            end
        end
        TRANSF: begin
            if (o_RX_DV) begin
                next_state = ESPERA;
                o_CS = 0;
            end
            else begin
                next_state = TRANSF;
                o_CS = 1; 
            end
        end
    endcase
end
// Inicializaci�n de variables
initial begin
    state = ESPERA;
    next_state = ESPERA;
    o_CS = 0;
end

  // Generar SPI clk 
  always @(posedge Clk or posedge rst)
  begin
    if (rst)
    begin
      o_TX_Ready      <= 1'b0;
      r_SPI_Clk_Edges <= 0;
      r_Leading_Edge  <= 1'b0;
      r_Trailing_Edge <= 1'b0;
      r_SPI_Clk       <= 1'b0; 
      r_SPI_Clk_Count <= 0;
    end
    else
    begin

      
      r_Leading_Edge  <= 1'b0; //Flanco ascendente 
      r_Trailing_Edge <= 1'b0; // Flanco descendente
      
      if (inicio)
      begin
        o_TX_Ready      <= 1'b0;
        r_SPI_Clk_Edges <= 16;  
      end
      else if (r_SPI_Clk_Edges > 0)
      begin
        o_TX_Ready <= 1'b0;
        
        if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT*2-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
          r_Trailing_Edge <= 1'b1;
          r_SPI_Clk_Count <= 0;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
          r_Leading_Edge  <= 1'b1;
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else
        begin
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
        end
      end  
      else
      begin
        o_TX_Ready <= 1'b1;
      end
      
      
    end 
  end 


  // Prop�sito: Registrar i_TX_Byte cuando Data Valid se pulsa.
  // Mantiene el almacenamiento local del byte en caso de que el m�dulo de nivel superior cambie los datos
  always @(posedge Clk or posedge rst)
  begin
    if (rst)
    begin
      r_TX_Byte <= 8'h00;
      r_TX_DV   <= 1'b0;
    end
    else
      begin
        r_TX_DV <= inicio; 
        if (inicio)
        begin
          r_TX_Byte <= i_TX_Byte;
        end
      end 
  end 


// Generar la comunicaci�n MOSI para los datos
always @(posedge Clk or posedge rst)
begin
  if (rst)
  begin
    o_SPI_MOSI     <= 1'b0;
    r_TX_Bit_Count <= 3'b111; //Primero env�a el bit MSB
  end
  else
  begin
    
    if (o_TX_Ready)
    begin
      r_TX_Bit_Count <= 3'b111;
    end
    //Condiciones de All in 1 y All in 0 
    else if (All_in1)
    begin
      o_SPI_MOSI <= 1'b1;
    end
    else if (All_in0)
    begin
      o_SPI_MOSI <= 1'b0;
    end
    // Transmisi�n regular de los datos
    else if (r_TX_DV)
    begin
      o_SPI_MOSI     <= r_TX_Byte[3'b111];
      r_TX_Bit_Count <= 3'b110;
    end
    else if (r_Trailing_Edge)
    begin
      r_TX_Bit_Count <= r_TX_Bit_Count - 1'b1;
      o_SPI_MOSI     <= r_TX_Byte[r_TX_Bit_Count];
    end
  end
end



  // Leer los datos que entran al maestro
  always @(posedge Clk or posedge rst)
  begin
    if (rst)
    begin
      o_RX_Byte      <= 8'h00;
      o_RX_DV        <= 1'b0;
      r_RX_Bit_Count <= 3'b111;
    end
    else
    begin

      
      o_RX_DV   <= 1'b0;

      if (o_TX_Ready) 
      begin
        r_RX_Bit_Count <= 3'b111;
      end
      else if (r_Leading_Edge)
      begin
        o_RX_Byte[r_RX_Bit_Count] <= i_SPI_MISO;  
        r_RX_Bit_Count            <= r_RX_Bit_Count - 1'b1;
        if (r_RX_Bit_Count == 3'b000)
        begin
          o_RX_DV   <= 1'b1;  
        end
      end
    end
  end
  
  
  // Sincronizaci�n 
  always @(posedge Clk or posedge rst)
  begin
    if (rst)
    begin
      o_SPI_Clk  <= 1'b0;
    end
    else
      begin
        o_SPI_Clk <= r_SPI_Clk;
      end 
  end 
  

endmodule
