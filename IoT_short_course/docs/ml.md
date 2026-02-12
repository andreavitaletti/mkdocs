# ML Playground

[https://playground.scienxlab.org/](https://playground.scienxlab.org/)
[https://mlplaygrounds.com/machine/learning/linearRegression.html](https://mlplaygrounds.com/machine/learning/linearRegression.html)

# Tensorflow Lite Micro on ESP32 

Reference examples are available [here](https://github.com/espressif/tflite-micro-esp-examples). You have to download from github [esp-nn](https://github.com/espressif/esp-nn) and [esp32-camera](https://github.com/espressif/esp32-camera) and place them into the relative folders under components.

Then go to examples/hello_worlds and as usual idf.py build, idf.py flash and finally idf.py monitor.

A nice explanation on how the model is generated can be found on the book [TinyML by Pete Warden, Daniel Situnayake](https://www.oreilly.com/library/view/tinyml/9781492052036/ch04.html). The corresponding jupyter notebook is available [here](https://colab.research.google.com/github/goodboychan/goodboychan.github.io/blob/main/_notebooks/2020-09-24-01-Training-Hello-world-Model-for-Microcontroller.ipynb)

Some other useful resources are listed below:

* [First steps with ESP32 and TensorFlow Lite for Microcontrollers](https://medium.com/@dmytro.korablyov/first-steps-with-esp32-and-tensorflow-lite-for-microcontrollers-c2d8e238accf)
* [Get started with microcontrollers](https://www.tensorflow.org/lite/microcontrollers/get_started_low_level)

## Anomaly detection

Build a **real-time anomaly detector** that identifies unusual patterns in sensor data (e.g., temperature, vibration, or audio) directly on the ESP32 using TinyML.

---

## Step 1: Choose a dataset / sensor

Some options suitable for ESP32 sensors:

|Sensor type|Example dataset / task|Notes|
|---|---|---|
|Accelerometer|Detect unusual movement of a device (falling, shaking)|Use onboard MPU6050|
|Temperature|Detect abnormal temperature spikes|Simple, easy for TinyML|
|Microphone|Detect unusual sounds (e.g., clapping, alarm)|Use I2S mic, feasible with Edge Impulse|
|Vibration|Predict machine anomalies|Requires IMU or piezo sensor|
## Step 2: Define the anomaly detection approach

There are several approaches suitable for TinyML:

1. **Statistical thresholding**
    - Keep a running mean & standard deviation of sensor readings.
    - Flag readings that are >2–3σ from the mean.
    - Pros: very light, easy on ESP32 RAM.
    - Cons: sensitive to noise.
2. **One-class ML model**
    - Train a model only on “normal” data, flag anything deviating.
    - TinyML-compatible options:
        - **TensorFlow Lite for Microcontrollers (TFLM)** with a small fully connected NN
        - **Isolation Forest** (can be converted to tiny NN)
        - **Autoencoder**: small network compressing and reconstructing input, high reconstruction error → anomaly
3. **TinyML library examples**
    - **Edge Impulse Anomaly Detection**: supports accelerometer, microphone, temp sensors. Generates ready-to-deploy TFLite micro models for ESP32.

## Step 3: Preprocessing & feature extraction

Depending on the sensor:

|Sensor|Features|
|---|---|
|Accelerometer|RMS, mean, variance, FFT energy|
|Temperature|Rolling mean, slope, variance|
|Microphone|MFCCs, energy, zero-crossing rate|
|Vibration|RMS, spectral centroid, peak-to-peak|

> Keep the features small (<10–20 floats) to fit TinyML models on ESP32.

## Step 4: Train the model

1. Collect “normal” data with ESP32 or simulate in Python.
2. Train a tiny autoencoder or fully connected NN (e.g., 2–3 hidden layers, 16–32 neurons each).
3. Convert to **TensorFlow Lite for Microcontrollers**.
4. Load onto ESP32 using Arduino, PlatformIO, or ESP-IDF.

---

## Step 5: Run inference on ESP32

- Sample the sensor every X ms (e.g., 100 ms).
- Feed the features to the TinyML model.
- Compute anomaly score:
    - Autoencoder: `score = ||input - reconstructed||`
    - Threshold: if score > threshold → anomaly
- Optional: trigger an LED, buzzer, or send a message via Wi-Fi/LoRa.
    

---

## Exercise 

1. Collect **1 minute of normal temperature data** from ESP32 sensor.
2. Train a **TinyML autoencoder** on this data.
3. Introduce a **synthetic anomaly** (e.g., sudden spike).
4. Deploy model on ESP32.
5. Detect anomaly **in real time** and light up LED.
6. Optional challenge: add **wireless logging** of anomalies to a server.

## Python / TensorFlow – Training the Autoencoder

```python

# tinyml_anomaly_train.py
import numpy as np
import tensorflow as tf

# Simulated "normal" temperature data
normal_data = np.random.normal(loc=25.0, scale=0.5, size=(1000, 1))  # 1000 samples

# Autoencoder model
model = tf.keras.Sequential([
    tf.keras.layers.Input(shape=(1,)),
    tf.keras.layers.Dense(8, activation='relu'),
    tf.keras.layers.Dense(4, activation='relu'),
    tf.keras.layers.Dense(8, activation='relu'),
    tf.keras.layers.Dense(1)
])

model.compile(optimizer='adam', loss='mse')
model.fit(normal_data, normal_data, epochs=50, batch_size=16)

# Save as TFLite model
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with open("autoencoder.tflite", "wb") as f:
    f.write(tflite_model)

print("Model saved as autoencoder.tflite")


```
✅ This trains a tiny autoencoder on normal temperature values.

## Arduino / ESP32 – Load & Run TFLite Model

```c
#include <Arduino.h>
#include "TensorFlowLite.h"
#include "model_data.h"  // autoencoder.tflite converted to a C array
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/version.h"

// ----------------- Settings -----------------
#define SENSOR_PIN 34
#define LED_PIN 2
#define TFLITE_MODEL autoencoder_model_data
#define TFLITE_MODEL_SIZE autoencoder_model_data_len
#define ANOMALY_THRESHOLD 0.5  // Adjust based on training

// ----------------- Globals -----------------
const int kTensorArenaSize = 2 * 1024;
uint8_t tensor_arena[kTensorArenaSize];

tflite::MicroInterpreter* interpreter;
TfLiteTensor* input;
TfLiteTensor* output;

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);

  // Load model
  const tflite::Model* model = tflite::GetModel(TFLITE_MODEL);
  if (model->version() != TFLITE_SCHEMA_VERSION) {
    Serial.println("Model schema mismatch!");
    while(1);
  }

  // Ops resolver
  static tflite::AllOpsResolver resolver;

  // Interpreter
  static tflite::MicroInterpreter static_interpreter(model, resolver, tensor_arena, kTensorArenaSize);
  interpreter = &static_interpreter;
  interpreter->AllocateTensors();

  input = interpreter->input(0);
  output = interpreter->output(0);
}

void loop() {
  // --- Read sensor ---
  float temp = analogRead(SENSOR_PIN) * (3.3 / 4095.0) * 10 + 20;  // example scaling
  input->data.f[0] = temp;

  // --- Run inference ---
  TfLiteStatus status = interpreter->Invoke();
  if (status != kTfLiteOk) {
    Serial.println("Invoke failed");
    return;
  }

  float recon = output->data.f[0];
  float anomaly_score = abs(temp - recon);

  Serial.print("Temp: "); Serial.print(temp);
  Serial.print(" | Recon: "); Serial.print(recon);
  Serial.print(" | Score: "); Serial.println(anomaly_score);

  // --- Check anomaly ---
  if (anomaly_score > ANOMALY_THRESHOLD) {
    digitalWrite(LED_PIN, HIGH);  // anomaly detected
  } else {
    digitalWrite(LED_PIN, LOW);
  }

  delay(200);  // sample every 200ms
}
```

1. `model_data.h` can be generated from `autoencoder.tflite` using:
`xxd -i autoencoder.tflite > model_data.h`
2. `ANOMALY_THRESHOLD` should be tuned based on reconstruction error on validation data.
3. Sensor reading is simulated here — replace with your **real sensor** (temperature, accelerometer, etc.).
4. Very lightweight: **fits ESP32 with ~2 KB tensor arena**.

## Why Autoencoder?

We want to **detect anomalies** in sensor data, e.g., temperature spikes, unusual vibration, or abnormal movement patterns.

Key points:

- **Normal data is abundant**
- **Anomalies are rare** or hard to label in advance

This is a classic **unsupervised anomaly detection problem**.

An **autoencoder** is a neural network trained to **reconstruct its input**:

`Input x  →  Encoder → Latent Space → Decoder → Output x̂ (reconstruction)`

- It **learns the patterns of “normal” data**.
- If you feed it a **normal sample**, it reconstructs it accurately → low reconstruction error.
- If you feed it an **anomalous sample**, it cannot reconstruct it well → high reconstruction error.

So the **reconstruction error** can be used as an **anomaly score**:

Anomaly Score == ∣∣x−x^∣∣

|Advantage|Why it matters for ESP32|
|---|---|
|**Lightweight**|A small autoencoder (few layers, few neurons) can run on a microcontroller.|
|**No labeled anomalies needed**|Only needs normal data to train. Useful because anomalies are rare.|
|**Generalizable**|Can detect anomalies that were not seen during training.|
|**Simple inference**|Forward pass only → low latency → real-time detection.|
## Alternative approaches vs autoencoder

|Method|Pros|Cons for ESP32|
|---|---|---|
|Statistical threshold (mean ± 3σ)|Very light|Doesn’t capture complex patterns; sensitive to noise|
|One-class SVM|Can capture nonlinear boundaries|Memory-heavy; slower inference|
|Isolation Forest|Good for multidimensional data|Not trivial to run on microcontrollers|
|Autoencoder|Captures complex patterns, light|Needs tiny neural network tuning|

✅ Autoencoder is a **perfect balance** between capability and feasibility for TinyML on microcontrollers.

## Intuition

Think of it like this:

- Autoencoder learns a **“normal sensor behavior fingerprint.”**
- Anything that deviates from that fingerprint → flagged as anomaly.    
- Works for **time series**, **multivariate data**, or even **audio features (MFCCs)**.

```pgsql

         Normal Data                 Anomalous Data
       ----------------          ----------------
       Temp = 25 ± 0.5             Temp spike = 30
           |                            |
           v                            v
      +-------------+             +-------------+
      |   Encoder   |             |   Encoder   |
      +-------------+             +-------------+
           |                            |
           v                            v
     Latent representation         Latent representation
           |                            |
           v                            v
      +-------------+             +-------------+
      |   Decoder   |             |   Decoder   |
      +-------------+             +-------------+
           |                            |
           v                            v
      Reconstructed Temp = 25 ± 0.5   Reconstructed Temp ≈ 25.1
           |                            |
           v                            v
   Reconstruction error ≈ 0        Reconstruction error ≈ 4.9
           |                            |
           v                            v
   ✅ Normal                       ⚠️ Anomaly detected

```

- **Normal Data**
    - Autoencoder is trained on “normal” temperature readings (~25°C).
    - Encoder compresses input → decoder reconstructs it almost perfectly.
    - **Reconstruction error ≈ 0 → Not an anomaly.**
- **Anomalous Data**
    - Temperature suddenly spikes to 30°C.
    - Autoencoder has **never seen this pattern**, so reconstruction fails.
    - **Reconstruction error is high → anomaly detected.**

- Works **without labeled anomalies**    
- **Lightweight computation**: forward pass only
- Can extend to **multivariate input** (temperature + humidity + vibration)
- Threshold on reconstruction error decides **anomaly vs normal**

![reconstruction_error.png](IoT_short_course/docs/assets/images/reconstruction_error.png)

![signal_vs_reconstruction-2026212474173.png](IoT_short_course/docs/assets/images/signal_vs_reconstruction-2026212474173.png)

