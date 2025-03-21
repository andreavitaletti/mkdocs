# Power Consumption

* Connect board VIN (red wire) to Arduino 5V if you are running a 5V board Arduino (Mega, etc.). If your board is 3V, connect to that instead.
* Connect board GND (black wire) to Arduino GND
* Connect board SCL (white wire) to Arduino SCL
* Connect board SDA (blue wire) to Arduino SDA
* Connect Vin+ to the positive terminal of the power supply for the circuit under test
* Connect Vin- to the positive terminal or lead of the load


![](assets/images/2024-11-28-11-17-03.png)

[source](https://learn.adafruit.com/adafruit-ina219-current-sensor-breakout/wiring "https://learn.adafruit.com/adafruit-ina219-current-sensor-breakout/wiring")

```c
#include <Wire.h>
#include <Adafruit_INA219.h>

Adafruit_INA219 ina219;

void setup(void) 
{
  Serial.begin(115200);
  while (!Serial) {
      // will pause Zero, Leonardo, etc until serial console opens
      delay(1);
  }

  uint32_t currentFrequency;
  Serial.println("Hello!");
  
  // Initialize the INA219.
  // By default the initialization will use the largest range (32V, 2A).  However
  // you can call a setCalibration function to change this range (see comments).
  if (! ina219.begin()) {
    Serial.println("Failed to find INA219 chip");
    while (1) { delay(10); }
  }
  // To use a slightly lower 32V, 1A range (higher precision on amps):
  //ina219.setCalibration_32V_1A();
  // Or to use a lower 16V, 400mA range (higher precision on volts and amps):
  //ina219.setCalibration_16V_400mA();
  Serial.println("Measuring voltage and current with INA219 ...");
}

void loop(void) 
{
  float shuntvoltage = 0;
  float busvoltage = 0;
  float current_mA = 0;
  float loadvoltage = 0;
  float power_mW = 0;

  shuntvoltage = ina219.getShuntVoltage_mV();
  busvoltage = ina219.getBusVoltage_V();
  current_mA = ina219.getCurrent_mA();
  power_mW = ina219.getPower_mW();
  loadvoltage = busvoltage + (shuntvoltage / 1000);

  Serial.print(busvoltage);
  Serial.print(",");
  Serial.print(shuntvoltage);
  Serial.print(",");
  Serial.print(loadvoltage);
  Serial.print(",");
  Serial.print(current_mA);
  Serial.print(",");
  Serial.print(power_mW);
  Serial.println("");

  delay(50);
}
```

The following picture shows the variation in current consumption when the internal led of a nodMCU Blinks 

![](assets/images/duty.png)

```c
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
}


void loop() {
  digitalWrite(LED_BUILTIN, HIGH);  
  delay(1000);                      
  digitalWrite(LED_BUILTIN, LOW);  
  delay(1000);                      
}

```