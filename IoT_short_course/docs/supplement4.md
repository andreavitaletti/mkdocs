# From [Wokwi](https://wokwi.com/) to a real device

1. Compile the code and on the code editor press F1 to download the firmware. It is a .bin file, let's name it sketch.bin file 
2. ```
   esptool.py --chip esp32 --port "/dev/ttyUSB0" --baud 921600  --before default_reset --after hard_reset write_flash  -z --flash_mode keep --flash_freq keep --flash_size keep 0x1000 "bootloader.bin" 0x8000 "partitions.bin" 0xe000 "boot_app0.bin" 0x10000 "sketch.bin"
   ```
Once partitions and bootloader are uploaded, you can simply upload the sketch. To upload for the first time the partitions and the bootloader you can simply used arduino IDE 

3. ```
   esptool.py --chip esp32 --port "/dev/ttyUSB0" --baud 921600  --before default_reset --after hard_reset write_flash  -z --flash_mode keep --flash_freq keep --flash_size keep 0x10000 ./sketch.bin 
   ```

In principle you can even use a [Web tool](https://learn.adafruit.com/adafruit-metro-esp32-s2/web-serial-esptool)

## [Partition Table](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-guides/partition-tables.html)

| # Name   |    Type    |  SubType  |  Offset     |   Size    |  Flags |
|----------|------------|-----------|-------------|-----------|--------|
| nvs      |       data |  nvs      |      0x9000 |   0x5000  |        |
| otadata  |   data     |  ota      |      0xe000 |   0x2000  |        |
| app0     |      app   |   ota_0   |    **0x10000**  |  0x140000 |        |
| app1     |      app   |   ota_1   |    0x150000 | 0x140000  |        |
| spiffs   |    data    |  spiffs   |   0x290000  | 0x160000  |        |
| coredump |  data      |  coredump | 0x3F0000    | 0x10000   |        |