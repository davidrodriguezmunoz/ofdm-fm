# Proyecto-FM-OFDM

La funci�n principal es __variacionSNR__.

Los argumentos de entrada son:

* �modo�: Modulaci�n utilizada. Puede ser 'QPSK', '16QAM' o '64QAM'.
* �codificar�: Indica si se realizan o no los c�lculos de codificaci�n. Puede valer 0 o 1.
* �tipo�: Aplicar todos los efectos o uno en particular. Para que se apliquen todos hay que poner 'juntos', para uno solo 'separados'.
* �efecto�: Tipo de efecto a aplicar. Puede ser: 
	* 'NO':  Aplicar s�lo un AWGN.
	* 'PN':  Aplicar un ruido de fase.
	* 'CFO': Aplica un offset a la frecuencia de portadora. Valor por defecto de 7.5 KHz.
	* 'CH': Pasa la se�al por un canal Rayleigh. Al iniciar la simulaci�n se pedir� el valor de la velocidad.
* �dft�: Indica si se usa la DFT adicional (1) o no (0).
* �sinc�: Indica si se realiza sincronismo (1) o no (0).
* �velocidad�: Velocidad en la que se mueve el usuario en caso de efecto CH. No obligatorio si se utiliza otro tipo de efecto. 
* �tipo de equalizacion� : Tipo de ecualizaci�n en caso de efecto CH. No obligatorio si se utiliza otro tipo de efecto. 
	* 'zfe':  Zero forzing equalization.
	* 'mmse': Minimum mean squeare error equalization.
	* 'none': No aplicar equalizaci�n
	

Los par�metros de la simulaci�n se modifican dentro del propio script de __variacionSNR__.

Ejemplo de uso:
���
variacionSNR('16QAM',0,'separados','CH',0,5,'mmse');
���
