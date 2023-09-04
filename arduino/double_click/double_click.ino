#include "BluetoothSerial.h"
#include "Dictionary.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;
int buttonPins[] = {34, 35};
int numOfButtons;
Dictionary *buttonValuesDict; // stores states and times of when pressed

void setup() {
  numOfButtons = sizeof(buttonPins) / sizeof(buttonPins[0]);
  
  buttonValuesDict = new Dictionary(numOfButtons);

  for (int i = 0; i < numOfButtons; i++) {
    int buttonPin = buttonPins[i];
    // set pinModes of all the buttons
    pinMode(buttonPin, INPUT);

    // initialize states and end pressed times of all the buttons
    resetValues(buttonPin);
  }

  Serial.begin(115200);
  SerialBT.begin("ESP32test");
  Serial.println("The device started, now you can pair it with bluetooth!");
}

void loop() {
  for (int i = 0; i < numOfButtons; i++) {
    int buttonPin = buttonPins[i];
    int buttonState = digitalRead(buttonPin);
    
    if (buttonState == HIGH){
      delay(200);
      Serial.println("Button Pressed ");
      Serial.println(buttonPin);
      
      if (buttonValuesDict->search(buttonPin + "clicks").toInt() == 0) {
        // add long to string buffer to save as a string
        char millisStr[40];
        sprintf(millisStr, "%u", millis());
        buttonValuesDict->insert(buttonPin + "timePress", millisStr);

        // add long to string buffer ito save as a string
        char timePressLimitStr[40];
        sprintf(timePressLimitStr, "%u", millis() + 250);
        buttonValuesDict->insert(buttonPin + "timePressLimit", timePressLimitStr);
        
        buttonValuesDict->insert(buttonPin + "clicks", "1");
      }
      // double click
      else if (buttonValuesDict->search(buttonPin + "clicks").toInt() == 1 
        && millis() < buttonValuesDict->search(buttonPin + "timePressLimit").toInt()) {
        Serial.println("Button Pressed twice");
      
        sendMessage(String(buttonPin) + "_1");
        
        resetValues(buttonPin);   
      }    
    }

    // single click
    if (buttonValuesDict->search(buttonPin + "clicks").toInt() == 1 
      && buttonValuesDict->search(buttonPin + "timePressLimit").toInt() != 0 
      && millis() > buttonValuesDict->search(buttonPin + "timePressLimit").toInt()) {
      Serial.println("Button Pressed Once");
      
      resetValues(buttonPin);   

      sendMessage(String(buttonPin) + "_0");
    }
  }
}

void resetValues(int buttonPin) {
  buttonValuesDict->insert(buttonPin + "timePress", "0");
  buttonValuesDict->insert(buttonPin + "timePressLimit", "0");
  buttonValuesDict->insert(buttonPin + "clicks", "0");
}

void sendMessage(String message) {
  // string buffer
  uint8_t buf[message.length()];
  memcpy(buf, message.c_str(), message.length());

  SerialBT.write(buf, message.length());
  //SerialBT.println(); 

  delay(25);
}
