#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;
int buttonPins[] = {34, 35, 36, 39};
int numOfButtons;

void setup() {
  numOfButtons = sizeof(buttonPins) / sizeof(buttonPins[0]);

  for (int i = 0; i < numOfButtons; i++) {
    int buttonPin = buttonPins[i];
    // set pinModes of all the buttons
    pinMode(buttonPin, INPUT);
  }

  Serial.begin(115200);
  SerialBT.begin("ESP32test1");
  Serial.println("The device started, now you can pair it with bluetooth!");
}

void loop() {
  for (int i = 0; i < numOfButtons; i++) {
    int buttonPin = buttonPins[i];
    int buttonState = digitalRead(buttonPin);
    
    if (buttonState == HIGH) { 
      delay(200);
      Serial.println("Button Pressed ");
      Serial.println(buttonPin);

      sendMessage(String(buttonPin));

      // makes button only send message once when pressed and held
      while (buttonState == HIGH) {
        buttonState = digitalRead(buttonPin);
        delay(50);
      }
    }
  }
}

void sendMessage(String message) {
  // string buffer
  uint8_t buf[message.length()];
  memcpy(buf, message.c_str(), message.length());

  SerialBT.write(buf, message.length());

  delay(25);
}
