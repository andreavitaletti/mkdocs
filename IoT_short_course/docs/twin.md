# Digital Twin

## Estimating clock drift 

ESP32 internal oscillators are cost-effective but notoriously sensitive to temperature, leading to a drift that can be several seconds a day.

By building a **Digital Twin**, we aren't just syncing the time; we are creating a mathematical model that lives on your PC, predicts how "wrong" the ESP32 is at any given moment, and feeds back a correction.

### The Architecture

To model the drift, the Twin needs to observe the relationship between the **Physical Clock** (ESP32) and the **Reference Clock** (PC).

![image-2026231832291.png](IoT_short_course/docs/assets/images/image-2026231832291.png)

---

### 1. The Mathematical Model

We assume the clock drift is linear over short-to-medium durations. The relationship between the ESP32 time ($t_{esp}$) and the PC time ($t_{ref}$) can be modeled as:

$$t_{esp} = (1 + R) \cdot t_{ref} + \phi$$

![image-2026231539281.png](IoT_short_course/docs/assets/images/image-2026231539281.png)

Where:

- **$R$**: The drift rate (the slope). If $R > 0$, the ESP32 is running fast.
    
- **$\phi$**: The initial phase offset.
    

The Digital Twin’s job is to continuously estimate $R$ and $\phi$ using **Linear Regression**.

---

### 2. Implementation Strategy

#### A. The Physical Asset (ESP32)

The ESP32 sends its internal `micros()` value to the PC via Serial or MQTT at regular intervals.


```
// ESP32 Snippet
void loop() {
  // Send local timestamp to the Digital Twin every 10 seconds
  unsigned long local_now = micros();
  Serial.println(local_now); 
  delay(10000);
}
```

#### B. The Digital Twin (Python on PC)

The Twin maintains a state of the ESP32's clock behavior. It uses the incoming data to update its internal model.

Python

```
import time
import numpy as np
from sklearn.linear_model import LinearRegression

class ESP32DigitalTwin:
    def __init__(self):
        self.esp_times = []
        self.ref_times = []
        self.model = LinearRegression()
        self.is_trained = False

    def update_model(self, esp_micros):
        # Record the reference time the moment the packet arrives
        ref_now = time.time() 
        
        self.esp_times.append([esp_micros])
        self.ref_times.append(ref_now)

        if len(self.esp_times) > 5:
            self.model.fit(self.esp_times, self.ref_times)
            self.is_trained = True
            
    def predict_real_time(self, current_esp_micros):
        if not self.is_trained:
            return "Insufficient data"
        # Predict what the PC time 'should' be based on ESP32 micros
        return self.model.predict([[current_esp_micros]])[0]

# Usage
twin = ESP32DigitalTwin()
# ... data collection loop ...
twin.update_model(1000050) # Example incoming microsecond value
```

---

### 3. Closing the Loop: Adjustment

Once the Twin calculates the drift rate $R$, it can send a **Correction Factor** back to the ESP32.

Instead of just resetting the time (which causes "time jumps"), the Digital Twin tells the ESP32 how much to "stretch" or "shrink" its perception of a second.

> **The Adjustment Logic:**
> 
> If the Twin calculates that the ESP32 is running **1%** fast, it sends a command: `SET_TICK_MULTIPLIER = 0.99`. The ESP32 then multiplies its internal delays or timestamps by this factor to stay in sync without jumping.

### Why this is a "Digital Twin" and not just NTP:

1. **Predictive:** If the ESP32 loses connection, the Twin can still predict its current time based on the historical drift model.
    
2. **Environmental Awareness:** Advanced twins can incorporate temperature data (since $R$ varies with heat) to create a multi-variable drift model.

## Maintenance

* Periodic
* Preventive
* Predictive
* Reactive

![](assets/images/2025-02-22-08-39-20.png "https://www.sim-tek.com.tr/predictive-maintenance/" )

## [The difference between Static and Dynamic Unbalance](https://www.youtube.com/watch?v=JB8i7LtY3mU)

<iframe width="560" height="315" src="https://www.youtube.com/embed/JB8i7LtY3mU?si=5j4mh8RmYGS-83ng" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## A simple experiment

![](assets/images/schematics.png)
![](assets/images/device.png)
![](assets/images/rest.png)
![](assets/images/balanced.png)
![](assets/images/unbalanced.png)

[code](https://github.com/andreavitaletti/PlatformIO/tree/main/Projects/Digital_twin)

## A simple model 

Centrifugal force of a mass $m_e$ at distance $r$ from the center of rotation, with angular velocity $\omega$: $F​=m_e ​r \omega$

Using a lumped mass model, and assuming the damping coefficient and the stiffness of the support are negligible, if the mass or the rotor is $m$, we can write :


$m \ddot{x} = m_e ​r \omega^2 cos(\omega t)$

$m \ddot{y} = m_e ​r \omega^2 sin(\omega t)$

This allows us to estimate the accelerations under the simplistic assumptions we made. 
