#  Laboratorio 3 / Parte 2 / Interfaz UART


## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays.
- **UART**: Universal Asynchronous Receiver-Transmitter.

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Criterios de diseño
Para el diseño del sistema UART completo se realizaron dos grandes sub-bloques, la parte relacionada con toda la interfaz del protocolo UART, llamada IPU, la cual se encarga de realizar las transmisiones y recepciones al sistema externo que en este caso es una computadora personal, y una sección llamada generador de pruebas la cual se encarga de crear el dato que el usuario desea transmitir al computador mediante el uso de switches en la FPGA, así como ser capaz de mostrar el dato recibido utilizando los leds de la FPGA. Teniendo estos dos bloques se unirán en un módulo top que se encargará de conectarlos adecuadamente para que el sistema completo funcione correctamente. Estos dos bloques cuentan cada uno con una máquina de estados, las cuales se detallan a continuación.

La máquina de estados del bloque IPU se encarga de monitorear las señales *tx_rdy* y *rx_data_rdy*, las cuales son señales propias de los bloques del UART que indican que la transmisión y la recepción se han realizado correctamente, al mismo tiempo monitorea el registro de control que se encarga de las señales *new_rx* que indica cuando se recibió un dato y *send* que se encarga de enviar un dato a la computadora, al mismo tiempo estas son salidas de la máquina de estados para que sean ajustadas de acuerdo al procedimiento realizado durante el protocolo. También cuenta con señales de habilitación de escritura tanto para el registro de control como para el registro de datos, una señal de dirección *addr2* que indica a cual registro el sistema debe almacenar el dato recibido y la señal *tx_start* que indica que la transmisión a la computadora debe iniciar. El diagrama de esta máquina de estados es el siguiente.

![fsm](https://github.com/EL3313/laboratorio3-equipo-4/assets/112665832/5becc041-35c8-4bca-87a8-1876fc5eb472)

Por su parte, la máquina de estados del generador de pruebas se encarga de monitorear un botón llamado *Boton_send* el cual es el que el usuario utiliza cuando quiere realizar la transmisión de un dato a la computadora, también monitorea las señales *new_rx* y *send* para llevar un control en el cuando se recibió un dato o se está transmitiendo. Las salidas de esta máquina de estados contienen un habilitador de escritura *wr_i* y una señal de selección *reg_sel_i*, estas se utilizarán para indicarle al sistema cuando y donde debe escribir, además de permitir observar el valor del dato recibido que debe ser mostrado en los leds de la FPGA, una señal llamada *addr_i* que le indicará al sistema si se trabajará sobre el registro que tiene el dato recibido o el registro con el dato por transmitir y una señal de dos bits *selec*, esta se utiliza para indicarle a un mux si debe dejar pasar el dato que el usuario desea transmitir o una cierta configuración para el registro de control, dependiendo del estado en el que se encuentre. El diagrama es el siguiente.

![fsm_pruebas](https://github.com/EL3313/laboratorio3-equipo-4/assets/112665832/2035931b-b46f-4d2d-88dd-7b7e928ca687)


## 4. Desarrollo

### 4.1 Módulo "top "
#### 1. Encabezado del módulo
```
module top (
    input logic clk, rst,
    input logic boton_send,

    input logic [7:0] dato,

    input logic rx,
    output logic tx,

    output logic [7:0] leds

);
```

#### 2. Entradas y salidas:
- `clk`: Reloj de la FPGA.
- `rst`: Señal de reset del UART, se asigna a un push button.
- `boton_send`: Señal para que el sistema transmita el dato deseado, se asigna a un push button.
- `dato`: Dato de 8 bits que el usuario desea transmitir, se le asignan 8 switches de la FPGA.
- `rx`: Señal de un bit que recibe el dato de la computadora bit por bit.
- `tx`: Señal de salida que envia bit por bit el dato deseado por el usuario.
- `leds`: Señal de 8 bits que almacena el dato recibido, se le asignan 8 leds de la FPGA para que sea mostrado.

#### 3. Criterios de diseño





