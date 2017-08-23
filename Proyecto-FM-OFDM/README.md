# Proyecto-FM-OFDM

La función principal es __variacionSNR__.

Los argumentos de entrada son:

* ´modo´: Modulación utilizada. Puede ser 'QPSK', '16QAM' o '64QAM'.
* ´codificar´: Indica si se realizan o no los cálculos de codificación. Puede valer 0 o 1.
* ´tipo´: Aplicar todos los efectos o uno en particular. Para que se apliquen todos hay que poner 'juntos', para uno solo 'separados'.
* ´efecto´: Tipo de efecto a aplicar. Puede ser: 
	* 'NO':  Aplicar sólo un AWGN.
	* 'PN':  Aplicar un ruido de fase.
	* 'CFO': Aplica un offset a la frecuencia de portadora. Valor por defecto de 7.5 KHz.
	* 'CH': Pasa la señal por un canal Rayleigh. Al iniciar la simulación se pedirá el valor de la velocidad.
* ´dft´: Indica si se usa la DFT adicional (1) o no (0).
* ´sinc´: Indica si se realiza sincronismo (1) o no (0).
* ´velocidad´: Velocidad en la que se mueve el usuario en caso de efecto CH. No obligatorio si se utiliza otro tipo de efecto. 
* ´tipo de equalizacion´ : Tipo de ecualización en caso de efecto CH. No obligatorio si se utiliza otro tipo de efecto. 
	* 'zfe':  Zero forzing equalization.
	* 'mmse': Minimum mean squeare error equalization.
	* 'none': No aplicar equalización
	

Los parámetros de la simulación se modifican dentro del propio script de __variacionSNR__.

Ejemplo de uso:
´´´
variacionSNR('16QAM',0,'separados','CH',0,5,'mmse');
´´´
