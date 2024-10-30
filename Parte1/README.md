#  Laboratorio 3 / Parte 1 / Interfaz SPI Maestro - Genérica


## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays.
- **Switch**: dsipositivo que enlaza o abre el circuito entre dos posiciones.
- **SPI**: Serial Peripheral Interface.
- **MOSI**: Master output, slave input.
- **MISO**: Master input, slave out.

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo


### 3.1 Módulo "top_interfaz_periferico_spi "
#### 1. Encabezado del módulo
```
module top_interfaz_periferico_spi #(
    parameter N = 7,
    parameter switches = 16
)(
    input logic         clk_fpga,
    input logic         rst,

    // Generador de datos y control de prueba
    input logic         wr_btn,
    input logic         reg_sel_i,
    input logic  [switches-2:0] switches_in,

    output logic [15:0] salida_o_leds,

    // Puertos SPI
    //input logic i_SPI_MISO,
    output logic o_SPI_Clk,
    output logic o_SPI_MOSI,
    output logic C_Select
); 
```
Son las entradas y salidas que se asignarán en la FPGA para la generación de pruebas 



#### 2. Entradas y salidas:
- `clk_fpga`: Reloj de la FPGA.
- `rst`: Señal de reset del SPI, se asigna a un push button.
- `wr_btn`: Señal de enable para los registros, se asigna a un push button.
- `reg_sel_i`: Señal para seleccionar el registro sobre el que se quiere escribir los datos, se asgina a un switch.
- `[switches-2:0] switches_in`: Señal se switches, son los datos que se van a escribir en los registros.
- `[15:0] salida_o_leds`: Señal de los leds para mostrar la salida de forma binaria, se muestra lo almacenado en el registro de datos.
- `i_SPI_MISO`: Señal de MISO para el SPI.
- `o_SPI_Clk`: Señal de SPI clk para el SPI slave.
- `o_SPI_MOSI`: Señal de MOSI para el SPI.
- `C_Select`: Señal del Chip Selcet.

#### 3. Criterios de diseño
El modulo es el encargado de hacer el llamado de todos los demás y enlazarlos 



### 3.2 Módulo "SPI_Master"
#### 1. Encabezado del módulo
```
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

```



#### 2. Entradas y salidas:
- `Clk`: Reloj del sistema.
- `rst`: Señal de reset del SPI.
- `i_TX_Byte`: Byte de 8 bits que se desea transmitir a través de la línea MOSI.
- `inicio`: Señal de entrada que indica el inicio de una nueva transmisión.
- `All_in1`: Señal de entrada que habilita enviar todos los datos en 1.
- `All_in0`: Señal de entrada que habilita enviar todos los datos en 0.
- `cs_ctrl`: Señal de control que determina la lógica de la señal de Chip Select
- `o_RX_DV`: Señal de salida que indica que un nuevo byte de datos ha sido recibido a través de la línea MISO. 
- `o_RX_Byte`: Byte de 8 bits que contiene los datos recibidos a través de la línea MISO.
- `o_SPI_Clk`: Señal de reloj SPI generada por el módulo, utilizada para sincronizar la comunicación con el dispositivo esclavo.
- `i_SPI_MOSI`: Señal de entrada que recibe los datos del dispositivo esclavo a través de la línea MISO.
- `o_SPI_MOSI`: Señal de salida que transmite los datos al dispositivo esclavo a través de la línea MOSI
- `C_Select`: Señal del Chip Select.

#### 3. Criterios de diseño
EL modulo implemente un controlador maestro para una comunicación SPI, se presenta un resumen de sus funciones:

1. **Generación de señal de reloj SPI**: El módulo genera una señal de reloj SPI (`o_SPI_Clk`) con una frecuencia determinada por el parámetro `CLKS_PER_HALF_BIT`. La generación de la señal de reloj se realiza contando los ciclos de reloj del sistema y alternando la señal de reloj SPI en los flancos ascendente y descendente.

2. **Transmisión de datos (MOSI)**: El módulo permite transmitir un byte de datos (`i_TX_Byte`) a través de la línea MOSI (Master Output, Slave Input).

3. **Recepción de datos (MISO)**: El módulo puede recibir un byte de datos (`o_RX_Byte`) a través de la línea MISO (Master Input, Slave Output). 
4. **Generación de señal de Chip Select**: El módulo genera una señal de Chip Select (`CSelect`) para seleccionar el dispositivo esclavo con el que se desea comunicar. Esta señal se activa cuando se inicia una transmisión y se desactiva cuando se completa la recepción de los datos, la logica, ya sea activa en bajo o activa en alto es controlado por la entrada (`cs_ctrl`).

5. **Entradas y salidas adicionales**: El módulo tiene entradas adicionales como `All_in1` y `All_in0` que permiten controlar el comportamiento de la línea MOSI, ya sea que todos los datos a transmitir sean 1 o 0.






### 3.3 Módulo "registro_datos"
#### 1. Encabezado del módulo
```
module registro_datos #(parameter N = 5)
(
    input logic clk,         
    input logic rst,
    input logic hold_ctrl,

    input logic [N:0]addr1,
    input logic [7:0] in1, //entrada externa
    input logic wr1,        //habilitaciÃ³n para in1
    
    input logic [N:0] addr2, 
    input logic wr2,        //habilitacion para in2
    input logic [7:0] in2,

    output logic [31:0] out_data  // sale hacia el modulo de control externo
    
);

```



#### 2. Entradas y salidas:
- `clk`:  Señal de reloj del sistema.
- `rst`: Señal de reset para inicializar todos los registros en 0.
- `hold_ctrl`: Señal de control que determina si se utiliza addr1 o addr2 como dirección de los registros.
- `addr1`: Direccion de los registros.
- `in1`: Entrada de 8 bits para escribir datos en los registros.
- `wr1`: Señal de habilitación para escribir in1 en los registros.
- `addr2`: Direccion de los registros.
- `wr2`: Señal de habilitación para escribir in2 en los registros.
- `in2`: Entrada de 8 bits para escribir datos en los registros.
- `out_data`: Salida de 32 bits que contiene el valor almacenado en el registro direccionado.

#### 3. Criterios de diseño
El módulo contiene un banco de registros de 32 bits, donde cada registro tiene una dirección única de N+1 bits. Tiene la capacidad de escritura y lectura de datos a través de direcciones específicas, permite la escritura de datos de 8 bits o 32 bits en los registros, dependiendo de las señales de habilitación wr1 y wr2.






![Texto alternativo](/Parte1/fig/diagramadeestados.png)




En la siguiente imagen se muestra la simulación final en icarus verilog donde se observa un correcto funcionamiento, ya que se recorren todos los registros indicados por n_tx_end, se hacen 2 envios idénticos con datos llenados en el registro de datos al inicio de la simulación.

![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124948957/6b9c6c40-be5f-4e0e-b56c-bf7e697acec4)
