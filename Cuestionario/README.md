# Cuestionario previo

## 1.  Investigue sobre la especificacióon de la interfaz SPI. Preste atención a los aspectos necesarios para poder diseñar un controlador maestro de SPI, además de los diferentes modos de SPI.
La Interfaz Periférica Serial (SPI) es una interfaz de comunicación síncrona, full-duplex, basada en maestro-esclavo, ampliamente utilizada entre microcontroladores y periféricos como sensores, ADCs, DACs, registros de desplazamiento, SRAM, entre otros. SPI permite que tanto el maestro como el esclavo transmitan datos simultáneamente, y puede ser una interfaz de 3 o 4 cables. La interfaz SPI es flexible, permitiendo seleccionar el borde ascendente o descendente del reloj para muestrear y/o desplazar los datos.

### Diseño de un Controlador Maestro de SPI
Para diseñar un controlador maestro de SPI, es crucial entender los aspectos clave de la comunicación SPI:
- **Inicio de la Comunicación**: Para iniciar la comunicación SPI, el maestro debe enviar la señal de reloj y seleccionar el esclavo habilitando la señal SS. Usualmente, la selección de chip es una señal activa baja, por lo que el maestro debe enviar un lógico 0 en esta señal para seleccionar el esclavo.
- **Transmisión de Datos**: SPI es una interfaz full-duplex, lo que significa que tanto el maestro como el esclavo pueden enviar datos al mismo tiempo a través de las líneas MOSI y MISO. Durante la comunicación SPI, los datos se transmiten (desplazados serialmente en el bus MOSI/SDO) y se reciben (los datos en el bus (MISO/SDI) se muestran o leen) simultáneamente. El borde del reloj sincroniza el desplazamiento y el muestreo de los datos.
- **Modos de Operación**: SPI opera en varios modos, definidos por la polaridad y fase del reloj. Estos modos determinan cómo se muestrea y desplaza la información. Por ejemplo, en el Modo 1, la polaridad del reloj es 0, lo que indica que el estado inactivo de la señal de reloj es bajo. La fase del reloj en este modo es 1, lo que indica que los datos se muestran en el borde descendente y se desplazan en el borde ascendente de la señal de reloj.

### Diferentes Modos de SPI
Los modos de operación de SPI se definen por la polaridad y fase del reloj, lo que afecta cómo se muestran y desplazan los datos. Por ejemplo:
- **Modo 0 (CPOL=0, CPHA=0)**: Polaridad de reloj baja, los datos se muestrean en el flanco ascendente y se desplazan hacia afuera en el flanco descendente
 ![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/745c99a5-a0ec-47f8-825e-bb0b091f969b)

- **Modo 1 (CPOL=0, CPHA=1)**: Polaridad del reloj baja, los datos se muestran en el borde descendente y se desplazan en el borde ascendente.
 ![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/e80f9f03-241c-4c96-8d41-5f4806299297)

- **Modo 2 (CPOL=1, CPHA=0)**: Polaridad del reloj alta, los datos se muestran en el borde ascendente y se desplazan en el borde descendente.
 ![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/d2d60320-8332-4ed9-a4e7-73464c74fb5b)

- **Modo 3 (CPOL=1, CPHA=1)**: Polaridad del reloj alta, los datos se muestran en el borde ascendente y se desplazan en el borde descendente.
 ![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/89d4de89-3ab8-49c1-914d-27ed62936535)

### Conexiones Master-Slave
 ![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/8dcaaa29-43c9-4939-b906-c45a4bec4409)
![image](https://github.com/EL3313/laboratorio3-equipo-4/assets/124960144/85369654-37da-4ddd-970a-78b7418d1c40)


### Aplicaciones Prácticas

SPI es especialmente útil en aplicaciones donde se requiere una comunicación eficiente y rápida entre dispositivos. Por ejemplo, los interruptores y multiplexores habilitados para SPI de Analog Devices pueden reducir significativamente el número de GPIOs requeridos en el diseño de un sistema, simplificando el diseño a nivel de sistema y ahorrando espacio en la placa.

### Conclusión

La SPI es una interfaz de comunicación versátil y eficiente que permite una comunicación rápida y sincronizada entre dispositivos. Al diseñar un controlador maestro de SPI, es crucial comprender los modos de operación y cómo se manejan los datos durante la transmisión. La flexibilidad de SPI en términos de polaridad y fase del reloj, junto con su capacidad para operar en modo full-duplex, lo hacen ideal para una amplia gama de aplicaciones, desde la comunicación entre microcontroladores y periféricos hasta la configuración de interruptores y multiplexores en sistemas complejos.



[1] M. Grusin, "Serial Peripheral Interface (SPI)," SparkFun, [En línea]. Disponible: https://learn.sparkfun.com/tutorials/serial-peripheral-interface-spi/all 


[2] P. Dhaker, "Introduction to SPI Interface," Analog Dialogue, [En línea]. Disponible: https://www.analog.com/en/resources/analog-dialogue/articles/introduction-to-spi-interface.html 


## 2.  Investigue sobre la comunicación serie UART. Preste atención a las diferentes características de configuración necesarias para la comunicación serie mediante UART (por ejemplo, baud rate, paridad, etc). Además, investigue cómo puede utilizar puertos serie en su computadora, considerando el sistema operativo que utilice.

La comunicación serie UART significa receptor/transmisor asíncrono universal y define un protocolo para intercambiar datos en serie entre dos dispositivos. El UART es muy simple y solo utiliza dos cables entre el transmisor y receptor para transmitir y recibir en ambas direcciones. Ambos terminales también tienen una conexión a tierra. La comunicación en UART se puede dar en una sola dirección, esto se conoce como simplex, también puede ser bidireccional por turnos, refiriéndose a que primero se transfiere un dato de un lado y cuando acabe, el otro lado transmitirá un dato, este se conoce como semidúplex, por último, está el dúplex completo el cual es capaz de transmitir datos de manera bidireccional al mismo tiempo, sin esperar que se transfiera de un lado para poder transferir del otro.

![bloque uart](https://github.com/EL3313/laboratorio3-equipo-4/assets/112665832/de20b32f-c7a0-4318-b0af-6829f116af78)

Existen varias características de configuración necesarias para la comunicación serie mediante UART. 

### Baud rate
Uno de los aspectos a tener en cuenta es el baud rate (tasa de baudios), esto es una medida de la velocidad de transmisión de datos en un canal de comunicación. Es una de las características más importantes a la hora de transmitir información de manera rápida y eficiente. Por ejemplo, si se utiliza una baud rate de 9600, quiere decir que el sistema es capaz de transmitir 9600 bits por segundo. Como el protocolo UART es asíncrono, el transmisor y receptor no dependen de ningún reloj, pero es necesario que ambos tengan una misma velocidad para la transmisión de los datos. Además de tener la misma velocidad en baudios, ambos lados de una conexión UART deben utilizar los mismos parámetros y estructura de datos.

### Bits de inicio y de parada
El bit de inicio es un bit que utiliza el transmisor para indicar que está recibiendo datos. Por su parte, el bit de parada es el que indica cuando han terminado de pasarse todos los datos del usuario. Estos bits se comportan con una transición de alto a bajo, y viceversa, según la configuración que se les haya dado.

### Bits de datos
Estos son los bits de datos del usuario, la cantidad de estos bits suelen variar, pero en promedio es muy común que sean 7 u 8 bits. Estos bits de datos se transmiten de uno en uno partiendo del bit menos significativo.

### Bit de paridad
Este bit se puede utilizar para la detección de errores, este bit se coloca al final de los bits de datos y del bit de parada. El bit de paridad se debe configurar dependiendo del tipo de paridad que se desea ejecutar. Si se desea trabajar una paridad par, este bit se ajusta para que la cantidad de 1 en los datos sea par, si lo que se busca paridad impar, se configura el bit para que la cantidad de 1 sea impar.

### Uso de un puerto serie en Windows
También, es importante entender cómo utilizar un puerto serie, y teniendo en cuenta que la gran mayoría de las computadoras actuales ya no los traen incorporados, se debe buscar alguna alternativa para poder utilizarlos. Por ejemplo, para el caso de Windows, se puede utilizar un convertidor serie USB e instalar los controladores necesarios para poder utilizarlo, estos suelen instalarse automáticamente cuando el convertidor se conecta a una computadora con acceso a internet, pero en todo caso se pueden instalar con el disco que el convertidor incluye. La propia Microsoft tiene un controlador serie llamado Usbser.sys, compatible con Windows 10 y 11, este también se puede cargar automáticamente.

[1] R&S Essentials, "Entendiendo el UART", Rohde-Schwarz, [En línea], Disponible: https://www.rohde-schwarz.com/lat/productos/prueba-y-medicion/essentials-test-equipment/digital-oscilloscopes/entendiendo-el-uart_254524.html#:~:text=UART%20significa%20receptor%2Ftransmisor%20as%C3%ADncrono,y%20recibir%20en%20ambas%20direcciones

[2] Polaridad.es, "Baud rate: la clave para una transmisión de datos rápida y eficiente", [En línea], Disponible: https://polaridad.es/baud-rate-la-clave-para-una-transmision-de-datos-rapida-y-eficiente/?expand_article=1#google_vignette

[3] Windows, "Controlador serie USB (Usbser.sys)", Microsoft Learn, [En línea], Disponible: https://learn.microsoft.com/es-es/windows-hardware/drivers/usbcon/usb-driver-installation-based-on-compatible-ids

