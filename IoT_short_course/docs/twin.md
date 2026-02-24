# Digital Twin

## Estimating clock drift 

ESP32 internal oscillators are cost-effective but notoriously sensitive to temperature, leading to a drift that can be several seconds a day.

By building a **Digital Twin**, we aren't just syncing the time; we are creating a mathematical model that lives on your PC, predicts how "wrong" the ESP32 is at any given moment, and feeds back a correction.

### The Architecture

To model the drift, the Twin needs to observe the relationship between the **Physical Clock** (ESP32) and the **Reference Clock** (PC).

![image-2026231832291.png](assets/images/image-2026231832291.png)

We assume the clock drift is linear over short-to-medium durations. The relationship between the ESP32 time ($t_{esp}$) and the PC time ($t_{ref}$) can be modeled as:

$$t_{esp} = (1 + R) \cdot t_{ref} + \phi$$

![image-2026231539281.png](assets/images/image-2026231539281.png)

Where:

- **$R$**: The drift rate (the slope). If $R > 0$, the ESP32 is running fast.
- **$\phi$**: The initial phase offset.

The Digital Twin’s job is to continuously estimate $R$ and $\phi$ using **Linear Regression**.

### Adjustment

Once the Twin calculates the drift rate $R$, it can send a **Correction Factor** back to the ESP32.

Instead of just resetting the time (which causes "time jumps"), the Digital Twin tells the ESP32 how much to "stretch" or "shrink" its perception of a second.

> **The Adjustment Logic:**
> 
> If the Twin calculates that the ESP32 is running **1%** fast, it sends a command: `drift_multiplier = 0.99`. The ESP32 then multiplies its internal delays or timestamps by this factor to stay in sync without jumping.


If you simply did `micros() * multiplier`, the moment your Digital Twin sent a new multiplier (say, from `1.0001` to `0.9999`), your clock would instantly jump backwards by thousands of microseconds.

By using the **Anchor Method** ($base + elapsed \times mult$), we ensure that:

1. **Continuity:** The time at the exact moment of the update remains the same.
2. **Smoothness:** Only the _slope_ of the time progression changes after the update.

###  ESP32 Code (C++)

We add a `SET_PHASE` command to set the initial "Wall Clock" time.

```c++
#include <Arduino.h>

double drift_multiplier = 1.0;
uint64_t last_raw_micros = 0;
double base_wall_time_s = 0; // The Wall Clock time in seconds (Epoch)

double get_wall_clock() {
    uint64_t current_raw = micros();
    uint64_t elapsed_raw = current_raw - last_raw_micros;
    
    // Convert elapsed microseconds to adjusted seconds
    double elapsed_adjusted_s = (elapsed_raw * drift_multiplier) / 1000000.0;
    return base_wall_time_s + elapsed_adjusted_s;
}

void setup() {
    Serial.begin(115200);
}

void loop() {
    // 1. Send heartbeat to Twin
    static uint32_t last_report = 0;
    if (millis() - last_report > 5000) {
        last_report = millis();
        Serial.print("RAW_MICROS:");
        Serial.print(micros());
        Serial.print(",CUR_WALL:");
        Serial.println(get_wall_clock(), 3); // Tell the twin what we THINK the time is
    }

    // 2. Handle Commands
    if (Serial.available() > 0) {
        String data = Serial.readStringUntil('\n');
        
        // Set the "Starting Line" (Phase)
        if (data.startsWith("SET_PHASE:")) {
            base_wall_time_s = data.substring(10).toDouble();
            last_raw_micros = micros();
            Serial.println("ACK: Phase (Wall Clock) Initialized.");
        }
        
        // Adjust the "Speed" (Frequency)
        if (data.startsWith("SET_MULT:")) {
            // Anchor the time before changing the rate
            base_wall_time_s = get_wall_clock();
            last_raw_micros = micros();
            drift_multiplier = data.substring(9).toDouble();
            Serial.println("ACK: Rate Adjusted.");
        }
    }
}
```

---

### Digital Twin (Python)

The Python script now performs two steps:

1. **Sync Phase:** Sends the current PC time immediately upon connection.
2. **Sync Frequency:** Continues to calculate and send the drift multiplier.

Python

```python
import serial
import time
from sklearn.linear_model import LinearRegression

# ... (Previous Class Setup) ...

def main():
    twin = ClockDigitalTwin()
    phase_synced = False
    
    with serial.Serial('COM3', 115200, timeout=1) as ser:
        time.sleep(2) # Wait for ESP32 reboot
        
        while True:
            # 1. INITIAL PHASE SYNC
            if not phase_synced:
                now = time.time()
                ser.write(f"SET_PHASE:{now:.3f}\n".encode())
                phase_synced = True
                print(f"Sent initial Phase: {now}")

            line = ser.readline().decode('utf-8').strip()
            if "RAW_MICROS" in line:
                # Parse: RAW_MICROS:12345,CUR_WALL:17000.123
                parts = line.split(",")
                raw_micros = int(parts[0].split(":")[1])
                esp_thinks_wall = float(parts[1].split(":")[1])
                
                twin.add_sample(raw_micros)
                
                # 2. FREQUENCY ADJUSTMENT
                mult = twin.calculate_multiplier()
                if mult:
                    ser.write(f"SET_MULT:{mult:.8f}\n".encode())
                    error = time.time() - esp_thinks_wall
                    print(f"Correction sent. Current Error: {error*1000:.2f}ms")
```


1. **The Phase Correction (`SET_PHASE`)**: This is like setting a watch. It happens once (or rarely) to align the two clocks to the same "zero" point.
2. **The Frequency Correction (`SET_MULT`)**: This is like adjusting the watch's internal gears. It happens continuously to ensure that as the ESP32 gets hot or cold, the Digital Twin keeps the "Virtual Clock" perfectly aligned with the PC.

!!! warning
    
    Clock drift depends on the temperature 
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
