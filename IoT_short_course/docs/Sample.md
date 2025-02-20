
# Sample the environment

Usually IoT applications need to observe a physical phenomenon. This is done by sampling.

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

## Fast Fourier Transform (FFT)

![](assets/images/2024-12-17-04-19-02.png)

[Colab Notebook on FFT](https://colab.research.google.com/drive/1nuZx095lzt2d9h42N7yNu13crGg9eS9A
)

[arduinoFFT library](https://github.com/kosme/arduinoFFT)

```c

#include <Arduino.h>
#include "arduinoFFT.h"


// Define the DAC and ADC pins
const int adcPin = 36;   // ADC1 (GPIO 34) for reading the sinusoid
int samplingFrequencyADC = 27; // sampling theorem should be at least 2*frequency
const uint16_t samples = 64; 

double vReal[samples];
double vImag[samples];


/* Create FFT object */
ArduinoFFT<double> FFTADC = ArduinoFFT<double>(vReal, vImag, samples, samplingFrequencyADC);

void setup() {
  Serial.begin(115200);
  analogReadResolution(10); 
  analogSetAttenuation(ADC_11db);  // Set ADC attenuation (default 0dB)
}

void loop() {

  for(int i=0; i<samples; i++)
   {
      vReal[i] = analogRead(adcPin)-512;
      vImag[i] = 0;
      /*
      Serial.print(">");
      Serial.print("adc:");    
      Serial.println(analogRead(adcPin)-512);
      */
      delay(round(1.0/samplingFrequencyADC*1000));
  }

  FFTADC.windowing(FFTWindow::Hamming, FFTDirection::Forward);	
  FFTADC.compute(FFTDirection::Forward); 
  FFTADC.complexToMagnitude();
  double x = FFTADC.majorPeak();
  Serial.print("ADC FFT: ");
  Serial.println(x, 6);

  }


```

[source code](https://github.com/andreavitaletti/documents/tree/main/PlatformIO/Projects/virtual%20sensor)