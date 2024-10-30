## Bitácora laboratorio 3 

### Ejercicio 1. Interfaz SPI Maestro - Genérica
| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|15/04/24 | Samuel y Elias | Investigación sobre SPI  |

Se ivestiga sobre los protocolos SPI.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|16/04/24 | Samuel y Elias | Se realizan los diseños y diagramas del SPI |

Se hacen los diagramas para el modulo del SPI Master

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|19/04/24 | Samuel y Elias | Se comienza a programar el SPI Master |

Se comienza con el codigo que implementa un SPI Master, se tienen varios errores sobre como hacer la transaccion bit a bit.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|23/04/24 | Samuel y Elias | Se avanza el SPI Master|

Se logran solucionar los errores a la hora de enviar bits en la comunicación SPI, se usaron contadores para hacer estos envios.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|25/04/24 | Samuel y Elias | Concluir la interfaz SPI|

Este día se trabajó hasta terminar toda la interfaz, se logró un correcto funcionamiento del sistema total a nivel de simulación en iverilog, sin embargo hubieron problemas para hacer la implementación en vivado.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|29/04/24 | Samuel y Elias | Realizar la implementación |

En este día se logró hacer el sistema completamente sintetizable y se simulo correctamente en vivado, sin embargo nos dimos cuenta que en ciertas transacciones habían errores en la transmisión de datos, hasta este día no sospechabamos de que trataba el error.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|01/05/24 | Elias | Realizar correcta implementación en la fpga |

Se agregó un modulo de nivel a pulso, con el fin de detectar cuando se pulse el boton de wr_i, esto fue necesario porque algunas veces el boton tenía rebotes entonces la transmisión de datos se daba de manera incorrecta y con eso se resolvieron todos los problemas que se tenían, se da por concluida esta parte del laboratorio.






### Ejercicio 2. Interfaz UART

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|15/04/24 | Keylor y Carlos | Investigación sobre UART  |

Se investigó acerca del funcionamiento del protocolo de comunciación UART. Se continúo con el estudio del diagrama del periférico, ya que no había quedado suficientemente claro. 

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|16/04/24 | Keylor y Carlos | Inicio de la máquina de estados para control del UART |

Este día se inició el diseño de la máquina de estados intetando considerar tanto la transmisión como la recepción simultánea, además de un diagrama de flujo correspondiente. 

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|19/04/24 | Keylor y Carlos | Continuación de la máquina de estados para control del UART |

Se realizaron modificaciones de la máquina de estados con la realimentación brindada por el profesor, de esta manera la fsm se redujo a 2 estados únicamente, en la cual se monitorean las señales rdy del bloque UART.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|23/04/24 | Keylor y Carlos | Implementación bloque IPU y pruebas |

Se realizaron los bloques necesarios para la parte de la interfaz UART, con los registros y la fsm ya funcionando. Se hicieron pruebas con un testbench que simule la recepción y transmisión de datos, estas parecen indicar que esta sección está funcionando correctamente y de acuerdo con lo esperado. Queda pendiente la implementación del generador de pruebas.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|24/04/24 | Keylor y Carlos | Inicio del diseño del generador de pruebas |

Se inició con el diseño del bloque del generador de pruebas, considerando una máquina de estados y algunos sub-bloques pequeños que permitan la visualización del dato recibido en la FPGA, así como la generación correcta del dato que se desea transmitir. Se decide utilizar switches para generar el dato y un push-button para la señal de send.


| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|25/04/24 | Keylor y Carlos | Implementación bloques del generador de pruebas |

Se realizó la implementación de la máquina de estados diseñada anteriormente, además de bloques como un registro para indicar en los leds de la FPGA el dato recibido y un mux que se utiliza para que la máquina de estados pueda escribir en el registro de control según sea necesario. Además, se hizo un módulo que conecte todos los sub-bloques utilizados en el generador de pruebas. Se implementó un top para todo el sistema completo, en simulación se observaron algunos errores, por ejemplo el sistema transmitía varias veces el mismo dato, queda pendiente la corrección de estos.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|26/04/24 | Keylor y Carlos | Pruebas y error sobre toda la interfaz UART |

Se continuaron las pruebas sobre todo el modulo del ejericicio 2, ya incluyendo el periférico UART y el módulo de pruebas. Los resultados no fueron los esperados hasta el momento ya que la captura del dato en los leds del valor recibido por el modulo no era capturado.
ERROR: el valor capturado por el registro previo a los leds siempre contenía el valor del registro de control. 
SOLUCIÓN: para la captura del dato recibido se debe realizar cuando reg_sel_i está en 1, pero también cuando addr_i está en 1, cuando ambas condiciones se satisfacen, podemos actualizar el registro de datos para mostrarlos en los leds, de esta amnera fue solucionado.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|27/04/24 | Keylor y Carlos | Pruebas y error sobre toda la interfaz UART |

ERROR: Al verificar un testbench que contemplara la transmisión y la recepción simultánea y posteriormente una recepción y otra transmición, el valor de new_rx adquirió un comportamiento extraño, completamente indeseado. 
SOLUCIÓN: al volver a rediseñar el diagrama de estados, no estabamos incluyendo la condición en que durante el procesos de transmición (sin recepción de por medio) debiamos volver al estado de inicio, sin realizar mayores cambios, dado que esta transición de estado no existía, la simluación no se podía llevar a cabo. 
Además, para la correcta captura del dato recibido, se incoporó un nuevo estado llamado 'leds', esto nos permitió limíar el bit 'new_rx' por parte del modulo de pruebas y de control' además de captural el dato recibido en los leds. 
Se adjunta el diagrama de datos de la máquina de estados del módulo generador de pruebas. 

![estados](https://github.com/EL3313/laboratorio3-equipo-4/assets/112665832/15ed6914-3568-4321-8b44-7a426b914ba6)

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|29/04/24 | Keylor y Carlos | Implementación de la interfaz UART en FPGA |

Se realizó la implementación de todo el sistema en la tarjeta FPGA y utilizando el programa Realterm, se añadió el reloj de 10 Mhz a partir de un PLL empotrado, al realizar las pruebas se observó que la transmisión se hacía correctamente pero con el problema de que se transmitiía varias veces, se detectó que se debe a que el antirebotes utilizado no era la mejor opción y se decidió cambiar por un detector de pulso. También se presentó un problema en la recepción de datos, no mostraba en los leds de la FPGA algunos datos, específicamente los terminados en 10 y 11, al revisar la máquina de estados se observó que no se estaba cumpliendo una condición de salida en el estado leds, por lo que eso provocaba el error.

| Fecha       | Integrantes | Objetivos     |
|--------------|------|------------|
|30/04/24 | Keylor y Carlos | Corrección de errores y funcionalidad final |

Se corrigieron los errores con las soluciones realizadas el día anterior, ya con esto que sistema realiza la transmisión y recepción de los datos de manera correcta, el detector de pulso evita que se transmitan los datos innecesariamente y la lógica de salida añadida en el estado leds permite que todos los datos recibidos sean mostrados correctamente en la FPGA. El protocolo UART se finalizó correctamente.

### Ejercicio 3. Lectura de un sensor de luminosidad
