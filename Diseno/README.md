# Planteamiento de la solución 

## Parte 1 - Interfaz SPI Maestro - Genérica

### Módulo spi_master:
Este es el módulo de alto nivel que implementa la funcionalidad de la interfaz SPI maestro. Contiene los registros de control y los registros de datos que permiten configurar y operar la comunicación SPI.
Por cada trasferencia de información que se quiera hacer, se activa un registro de control, y N registros de datos de N bits.
Los registros de datos contienen un conjunto de 2^N registros de 32 bits, donde N es un parámetro que define el ancho de la dirección. Cada registro posee un campo DATO de lectura y escritura, que se utiliza para almacenar los datos a enviar y recibir a través de la interfaz SPI.

### Módulo spi_port:
Este módulo se encarga de implementar la lógica de bajo nivel del protocolo SPI.
Maneja la generación de la señal de reloj SCK y la transmisión y recepción de datos a través de MOSI y MISO.
Se encarga de sincronizar la transmisión y recepción de datos de acuerdo con el protocolo SPI.
La interacción entre estos dos módulos permite implementar la funcionalidad completa de la interfaz SPI maestro. El módulo spi_master proporciona una interfaz de alto nivel, mientras que el módulo spi_port se encarga de los detalles de bajo nivel del protocolo SPI.


### Flujo de operación de la interfaz SPI maestro:
- Cuando se activa la señal "send", el módulo SPI Maestro inicia la transferencia SPI.
- El módulo lleva un registro del número de transacciones que ha enviado y recibido.
- Mientras el número de transacciones enviadas es menor que "n_tx_end", el módulo continúa enviando datos desde los registros "reg_sel_i" y "addr_in".
- Después de cada transacción, el dato recibido desde el esclavo se almacena en el registro de datos correspondiente "addr_in".
- Cuando se completan todas las transacciones, el módulo SPI Maestro se pone en estado inactivo.
  Ese comportamiento se refleja en el siguiente diagrama de bloques:
  ![Diagrama en blanco (4)](https://github.com/EL3313/laboratorio3-equipo-4/assets/124948957/ad9d4083-616f-4bf9-a47c-679b7e1a83e2)






#### Transacción SPI entre el maestro y el esclavo
- Comienza con la configuración de los registros de control tanto en el maestro como en el puerto SPI para establecer la comunicación.
- Luego, se genera la señal de reloj (SCK) para sincronizar la comunicación.
- Durante cada ciclo de reloj, el maestro envía un bit (MOSI) al puerto SPI, mientras que el puerto SPI envía un bit de vuelta (MISO) al maestro simultáneamente.
- Esto se repite para cada bit en la transacción, comenzando por el bit más significativo (MSB) y terminando con el menos significativo (LSB).
- Finalmente, la transacción concluye y se completa el flujo de la comunicación SPI.

  
![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/836663ef-e970-4dde-b12e-0f8529d7fe81)

![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/fef18f0b-162a-4969-8521-c74c1c1df38d)



Para la transacción de N cantidad de datos que se hará a través de los ciclos de reloj, se plantea hacer uso de contadores: los contadores pueden utilizarse para controlar el envío y recepción de bits durante la transacción. 
- Se utilizará un contador para rastrear cuántos bits se han enviado o recibido durante la transacción.
- Se utilizarán banderas que indiquen si se está enviando o recibiendo un bit en un momento dado.
- Un proceso always que controlará el envío y recepción de bits en función de los valores del contador y las banderas.
- Una vez que se han enviado y recibido todos los bits, se da por finalizado, la señal send vuelve a 0.



## Parte 2 - Interfaz UART
Para la implementación de la interfaz UART, se desarrolló primero el siguiente diagrama inicial que permite tener claro como es el funcionamiento de este protocolo.

![Diagrama inicial](https://github.com/EL3313/laboratorio3-equipo-4/assets/112665832/6589c7c7-82ff-49f5-9332-b5afa27b596d)

Teniendo este diagrama, se expande la lógica a un diagrama de estados, en el cual se consideran las señales de salida de los bloques de UART, los cuales se trabajarán como entradas de la máquina de estados de control del sistema. Las entradas y salidas de la máquina de estados se encuentran nombradas arriba a la derecha del diagrama de estados. Es importante tener en cuenta como se ajustó el nombre de algunas de las señales en el diagrama de estados, siendo específicos, la señal we_c es la habilitación de escritura en el registro de control, mientras que we_d es la habilitación de escritura en el registro 1, el cual recibe el dato de la computadora. También, la señal de entrada out(registro control) corresponde al valor almacenado en el registro de control que se utilizará para que la máquina de estados conozca los valores actuales almacenados de send y new_rx.

![Estados](https://github.com/EL3313/laboratorio3-equipo-4/assets/112665832/59c26778-8784-4338-a96f-fa9e6663f508)

Por último, para la parte del generador de pruebas, se decidió utilizar los switches de la FPGA para escribir el dato que será enviado a la computadora, se utilizán también un par de push-button de la FPGA, uno para activar la señal de send para realizar la transmisión y otro para habilitar la escritura en el registro 0.

![pruebas](https://github.com/EL3313/laboratorio3-equipo-4/assets/112665832/9c5ecaa0-4494-4eda-ace5-8bba432f5ddf)


## Parte 3 - Lectura de un sensor de luminosidad 
Completadas las partes 1 y 2, se hacen las conexiones y enlaces necesarios de acuerdo con los protocolos a utilizar (SPI y UART), se muestran los diagramas correspondientes:


![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/12aa0c02-0726-46fa-9509-220247427f43)


![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/484dc445-9a07-4b7e-95be-0812f92f630f)





