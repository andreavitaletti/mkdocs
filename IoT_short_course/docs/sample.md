
# Sample the environment

Usually IoT applications need to observe a physical phenomenon. This is done by sampling.

## Fast Fourier Transform (FFT)

![](assets/images/2024-12-17-04-19-02.png)

[Colab Notebook on FFT](https://colab.research.google.com/drive/1nuZx095lzt2d9h42N7yNu13crGg9eS9A
)

[arduinoFFT library](https://github.com/kosme/arduinoFFT)

In the following [example](https://github.com/kosme/arduinoFFT/blob/master/Examples/FFT_01/FFT_01.ino) the signal is generated internally by the node.

[on wokwi](https://wokwi.com/projects/424775322523875329)

```c
#include <arduinoFFT.h>

/*
These values can be changed in order to evaluate the functions
*/
const uint16_t samples = 64; //This value MUST ALWAYS be a power of 2

const double samplingFrequency = 5000;


const double signalFrequency1 = 500;  // Prima frequenza (Hz)
const double signalFrequency2 = 1200; // Seconda frequenza (Hz)
const uint8_t amplitude1 = 100;       // Ampiezza della prima sinusoide
const uint8_t amplitude2 = 50;        // Ampiezza della seconda sinusoide

/*
These are the input and output vectors
Input vectors receive computed results from FFT
*/
double vReal[samples];
double vImag[samples];

/* Create FFT object */
ArduinoFFT<double> FFT = ArduinoFFT<double>(vReal, vImag, samples, samplingFrequency);

#define SCL_INDEX 0x00
#define SCL_TIME 0x01
#define SCL_FREQUENCY 0x02
#define SCL_PLOT 0x03

void setup()
{
  Serial.begin(115200);
  while(!Serial);
  Serial.println("Ready");
}

void loop()
{
  /* Build raw data */

 double ratio1 = twoPi * signalFrequency1 / samplingFrequency;
 double ratio2 = twoPi * signalFrequency2 / samplingFrequency;


  for (uint16_t i = 0; i < samples; i++)
  {
    vReal[i] = double(amplitude1 * sin(i * ratio1) + amplitude2 * sin(i * ratio2));/* Build data with positive and negative values*/
    vImag[i] = 0.0; //Imaginary part must be zeroed in case of looping to avoid wrong calculations and overflows
  }
  /* Print the results of the simulated sampling according to time */
  Serial.println("Data:");
  PrintVector(vReal, samples, SCL_TIME);
  FFT.windowing(FFTWindow::Hamming, FFTDirection::Forward);	/* Weigh data */
  Serial.println("Weighed data:");
  PrintVector(vReal, samples, SCL_TIME);
  FFT.compute(FFTDirection::Forward); /* Compute FFT */
  Serial.println("Computed Real values:");
  PrintVector(vReal, samples, SCL_INDEX);
  Serial.println("Computed Imaginary values:");
  PrintVector(vImag, samples, SCL_INDEX);
  FFT.complexToMagnitude(); /* Compute magnitudes */
  Serial.println("Computed magnitudes:");
  PrintVector(vReal, (samples >> 1), SCL_FREQUENCY);
  double x = FFT.majorPeak();
  Serial.println(x, 6);
  while(1); /* Run Once */
  // delay(2000); /* Repeat after delay */
}

void PrintVector(double *vData, uint16_t bufferSize, uint8_t scaleType)
{
  for (uint16_t i = 0; i < bufferSize; i++)
  {
    double abscissa;
    /* Print abscissa value */
    switch (scaleType)
    {
      case SCL_INDEX:
        abscissa = (i * 1.0);
	break;
      case SCL_TIME:
        abscissa = ((i * 1.0) / samplingFrequency);
	break;
      case SCL_FREQUENCY:
        abscissa = ((i * 1.0 * samplingFrequency) / samples);
	break;
    }
    Serial.print(abscissa, 6);
    if(scaleType==SCL_FREQUENCY)
      Serial.print("Hz");
    Serial.print(" ");
    Serial.println(vData[i], 4);
  }
  Serial.println();
}

```

Note that FFT.majorPeak() ``Returns an estimation of the dominant frequency according to the interpolation of the biggest peak found on the magnitude array.`` which is  503.166771 while the max frequency of the a peak is arodun 1200 as expected. Indeed the Computed magnitudes are:

```
0.000000Hz 19.3725
78.125000Hz 19.4808
156.250000Hz 19.4963
234.375000Hz 17.5681
312.500000Hz 7.6937
390.625000Hz 285.2706
468.750000Hz 1508.3488
546.875000Hz 1275.2104
625.000000Hz 149.1638
703.125000Hz 8.7482
781.250000Hz 5.8810
859.375000Hz 6.5036
937.500000Hz 6.7344
1015.625000Hz 14.6614
1093.750000Hz 173.3189
1171.875000Hz 760.4988
1250.000000Hz 623.6484
1328.125000Hz 52.2926
1406.250000Hz 7.5248
1484.375000Hz 12.7204
1562.500000Hz 13.0229
1640.625000Hz 12.5002
1718.750000Hz 11.8706
1796.875000Hz 11.2927
1875.000000Hz 10.7984
1953.125000Hz 10.3874
2031.250000Hz 10.0515
2109.375000Hz 9.7820
2187.500000Hz 9.5711
2265.625000Hz 9.4129
2343.750000Hz 9.3029
2421.875000Hz 9.2381
```
![](assets/images/2025-04-04-17-13-56.png)

More realistically the signal is observed by the ADC, as in the following [example](https://github.com/kosme/arduinoFFT/blob/master/Examples/FFT_03/FFT_03.ino)

![](assets/images/2025-03-10-09-14-30.png)

[on wokwi](https://wokwi.com/projects/425024705467787265)

```c

#include "arduinoFFT.h"

/*
These values can be changed in order to evaluate the functions
*/
#define CHANNEL 12
const uint16_t samples = 64; //This value MUST ALWAYS be a power of 2
const double samplingFrequency = 100; //Hz, must be less than 10000 due to ADC
unsigned int sampling_period_us;
unsigned long microseconds;

/*
These are the input and output vectors
Input vectors receive computed results from FFT
*/
double vReal[samples];
double vImag[samples];

/* Create FFT object */
ArduinoFFT<double> FFT = ArduinoFFT<double>(vReal, vImag, samples, samplingFrequency);

void setup()
{
  sampling_period_us = round(1000000*(1.0/samplingFrequency));
  Serial.begin(115200);
  while(!Serial);
  Serial.println("Ready");
}

void loop()
{
  /*SAMPLING*/
  microseconds = micros();
  for(int i=0; i<samples; i++)
  {
      vReal[i] = analogRead(CHANNEL);
      vImag[i] = 0;
      while(micros() - microseconds < sampling_period_us){
        //empty loop
      }
      microseconds += sampling_period_us;
  }
  // ... 
  double x = FFT.majorPeak();
  Serial.println(x, 6); //Print out what frequency is the most dominant.
  while(1); /* Run Once */
  // delay(2000); /* Repeat after delay */
}
```

## A virtual signal

A virtual signal is a practical approach to generate arbitrary signals using one EPS32 as the signal generator, and the other as the sampler. 

The two ESP32 are connected as in the following picture

![](assets/images/2024-12-16-17-23-45.png)

The node on the left works as a **virtual signal**, it generates a signal using the [DAC](https://www.electronicwings.com/esp32/dac-digital-to-analog-converter-esp32) on PIN 25. 
The node on the right sample the generated signal by the [ADC](https://www.electronicwings.com/esp32/adc-of-esp32) and print the [FFT](). 

### The Signal Generator

```c

#include <Arduino.h>

// Define the DAC and ADC pins
const int dacPin = 25;   // DAC1 (GPIO 25) for sinusoid output

// Parameters for the sine wave
const int amplitude = 100;   // Amplitude of the sine wave (max 255 for 8-bit DAC)
const int offset = 128;      // DC offset (middle of the DAC range)
const float signalFrequency = 5.0;  // Frequency of the sine wave in Hz
int samplingFrequencyDAC = 1000; // sampling theorem should be at least 2*frequency

void setup() {
  Serial.begin(115200);

  // Initialize DAC pin (GPIO 25)
  dacWrite(dacPin, 0);  // Initialize DAC with a low value

}

void loop() {
      for (int i = 0; i < samplingFrequencyDAC; i++) {
      int sineValue = (int)(amplitude * sin(2.0 * PI * signalFrequency * i / samplingFrequencyDAC) + offset);
      dacWrite(dacPin, sineValue);  // Write to DAC (8-bit value)
      Serial.print(">");
      Serial.print("dac:");    
      Serial.println(sineValue);
      delay(round(1.0/samplingFrequencyDAC*1000));
      } 
    
}

```

![](assets/images/2024-12-17-03-54-47.png)

### The Sampler

```c

#include <Arduino.h>

const int adcPin = 34;   // ADC1 (GPIO 34) for reading the sinusoid
int samplingFrequencyADC = 500; // sampling theorem should be at least 2*frequency
const uint16_t samples = 512; 

void setup() {
  Serial.begin(115200);
  analogReadResolution(10); 
  analogSetAttenuation(ADC_11db);  // Set ADC attenuation (default 0dB)
}

void loop() {

  for(int i=0; i<samples; i++)
   {
      Serial.print(">");
      Serial.print("adc:");    
      Serial.println(analogRead(adcPin)-512);
      delay(round(1.0/samplingFrequencyADC*1000));
  }
}

```

![](assets/images/2024-12-17-03-53-48.png)

[source code](https://github.com/andreavitaletti/documents/tree/main/PlatformIO/Projects/virtual%20sensor)

## A possible alternative using the PC

![](assets/images/2024-12-17-04-23-56.png)

[ref](https://forum.arduino.cc/t/how-to-read-data-from-audio-jack/458301/3)

``` python3 -m pip install sounddevice ```

```python

# Use the sounddevice module
# http://python-sounddevice.readthedocs.io/en/0.3.10/

import numpy as np
import sounddevice as sd
import time

# Samples per second
sps = 44100

# Frequency / pitch
freq_hz = 2

# Duration
duration_s = 5.0

# Attenuation so the sound is reasonable
atten = 1.0 # 0.3

# NumpPy magic to calculate the waveform
each_sample_number = np.arange(duration_s * sps)
waveform = np.sin(2 * np.pi * each_sample_number * freq_hz / sps)
waveform_quiet = waveform * atten

# Play the waveform out the speakers
sd.play(waveform_quiet, sps)
time.sleep(duration_s)
sd.stop()

```

[Online Tone Generator](https://onlinetonegenerator.com/)

