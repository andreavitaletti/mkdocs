# Wireless Connectivity

For the sake of convenience, we use WiFi connectivity, a WiFi Access Point is available everywhere and we can even use our mobile phone in tethering, however:

!!! warning
    WiFi is not appropriate for IoT connectivity since it is power demanding

The selection of the most appropriate wireless connectivity technology depends mostly on the application requirements and it is usually a tradeoff among energy, data throughput, coverage and cost.

The following table compares different wireless technologies. WiFi has the highest figures in terms of energy consumptions. 

![https://www.emnify.com/blog/iot-connectivity](assets/images/2025-01-17-06-18-23.png)



In our experiments, we us LoRaWAN. In particular, we have a Gateway connected to [The Thing Network (TTN)](https://www.thethingsnetwork.org/).

Heltec, produces a nice device, the [WiFi LoRa 32(V3)](https://heltec.org/project/wifi-lora-32-v3/), that we use in our experiments. 

A simple code to establish a first connection si available [here](https://github.com/andreavitaletti/PlatformIO/tree/main/Projects/TTN_connection). 

It is basically the ttn-otaa example available in the [rgot-org/TTN_esp32](https://registry.platformio.org/libraries/rgot-org/TTN_esp32/examples) library.

![](assets/images/2025-01-18-08-11-47.png)