#include <Canbus.h>
#include <defaults.h>
#include <global.h>
#include <mcp2515.h>
#include <mcp2515_defs.h>

#define TRIGGER_PIN_1  A1  
#define ECHO_PIN_1     A2
#define TRIGGER_PIN_2  10  
#define ECHO_PIN_2     9
#define TRIGGER_PIN_3  5  
#define ECHO_PIN_3     4 
#define TRIGGER_PIN_GT  3  
#define ECHO_PIN_GT     8
#define TRIGGER_PIN_GP  A0
#define ECHO_PIN_GP     12
#define TRIGGER_PIN_T  A4  
#define ECHO_PIN_T     A5
#define TRIGGER_PIN_P  6  
#define ECHO_PIN_P     7

const int buttonPin_T = 11; 
const int buttonPin_P = 2; 
unsigned long startTime_T = 0, startTime_P = 0, dorong_T = 0, dorong_P = 0, vss = 0;
unsigned long thoigian_T = 0, dem_T = 0, thoigian_P = 0, dem_P = 0, ts_T = 0, ts_P = 0;
bool counting_T = false;
bool counting_P = false;
bool lastButtonState_T = HIGH;
bool lastButtonState_P = HIGH;
bool currentButtonState_T;
bool currentButtonState_P;
unsigned long lastDebounceTime_T = 0; 
unsigned long lastDebounceTime_P = 0; 
unsigned long debounceDelay = 50; 
unsigned long preMillis = 0;
const unsigned long inter = 1000; 
unsigned long giay = 0;
uint64_t duration_1, duration_2, duration_3;
uint64_t duration_GT, duration_GP, duration_T, duration_P;
uint32_t distance_1, distance_2, distance_3, distance_GT, distance_GP, distance_T, distance_P, zero = 0;
uint16_t combinedValue, i, pre_angle, phi = 0, x=994, directions = 1;
uint32_t temp = 0, L = 2648, A = 1544, B = 1044, Rof, R;

void setup() {
  Serial.begin(115200);

  if(Canbus.init(CANSPEED_500)) {
    Serial.println("oke");
  } else {
    Serial.println("can't init");
  }

  pinMode(TRIGGER_PIN_1,OUTPUT);
  pinMode(ECHO_PIN_1,INPUT);
  pinMode(TRIGGER_PIN_2,OUTPUT);
  pinMode(ECHO_PIN_2,INPUT);
  pinMode(TRIGGER_PIN_3,OUTPUT);
  pinMode(ECHO_PIN_3,INPUT);
  pinMode(TRIGGER_PIN_GT,OUTPUT);
  pinMode(ECHO_PIN_GT,INPUT);
  pinMode(TRIGGER_PIN_GP,OUTPUT);
  pinMode(ECHO_PIN_GP,INPUT);
  pinMode(TRIGGER_PIN_T,OUTPUT);
  pinMode(ECHO_PIN_T,INPUT);
  pinMode(TRIGGER_PIN_P,OUTPUT);
  pinMode(ECHO_PIN_P,INPUT);
  pinMode(buttonPin_T, INPUT_PULLUP);
  pinMode(buttonPin_P, INPUT_PULLUP);
}

void sensor() {
  digitalWrite(TRIGGER_PIN_1, LOW);  
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN_1, HIGH);       
  delayMicroseconds(20);              
  digitalWrite(TRIGGER_PIN_1, LOW);        
  duration_1 = pulseIn(ECHO_PIN_1,HIGH);  
  distance_1 = (duration_1 * 35) / (2*1000);
  if ((distance_1 > 20) && (distance_1 < 600)) {
    Serial.print(distance_1);
    Serial.print(",");
  } else {
    Serial.print(zero);
    Serial.print(",");
  }

  digitalWrite(TRIGGER_PIN_2, LOW);  
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN_2, HIGH);       
  delayMicroseconds(20);              
  digitalWrite(TRIGGER_PIN_2, LOW);        
  duration_2 = pulseIn(ECHO_PIN_2,HIGH);  
  distance_2 = (duration_2 * 35) / (2*1000);
  if ((distance_2 > 20) && (distance_2 < 600)) {
    Serial.print(distance_2);
    Serial.print(",");
  } else {
    Serial.print(zero);
    Serial.print(",");
  }

  digitalWrite(TRIGGER_PIN_3, LOW);  
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN_3, HIGH);       
  delayMicroseconds(20);              
  digitalWrite(TRIGGER_PIN_3, LOW);        
  duration_3 = pulseIn(ECHO_PIN_3,HIGH);
  distance_3 = (duration_3 * 35) / (2*1000);
  if ((distance_3 > 20) && (distance_3 < 600)) {
    Serial.print(distance_3);
    Serial.print(",");
  } else {
    Serial.print(zero);
    Serial.print(",");
  }

  digitalWrite(TRIGGER_PIN_GT, LOW);  
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN_GT, HIGH);       
  delayMicroseconds(20);              
  digitalWrite(TRIGGER_PIN_GT, LOW);        
  duration_GT = pulseIn(ECHO_PIN_GT,HIGH); 
  distance_GT = (duration_GT * 35) / (2*1000);
  if ((distance_GT > 20) && (distance_GT < 600)) {
    Serial.print(distance_GT);
    Serial.print(",");
  } else {
    Serial.print(zero);
    Serial.print(",");
  }

  digitalWrite(TRIGGER_PIN_GP, LOW);  
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN_GP, HIGH);       
  delayMicroseconds(20);              
  digitalWrite(TRIGGER_PIN_GP, LOW);        
  duration_GP = pulseIn(ECHO_PIN_GP,HIGH);  
  distance_GP = (duration_GP * 35) / (2*1000);
  if ((distance_GP > 20) && (distance_GP < 600)) {
    Serial.print(distance_GP);
    Serial.print(",");
  } else {
    Serial.print(zero);
    Serial.print(",");
  }

  digitalWrite(TRIGGER_PIN_T, LOW);  
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN_T, HIGH);       
  delayMicroseconds(20);              
  digitalWrite(TRIGGER_PIN_T, LOW);        
  duration_T = pulseIn(ECHO_PIN_T,HIGH); 
  distance_T = (duration_T * 35) / (2*1000);
  if ((distance_T > 20) && (distance_T < 600)) {
    Serial.print(distance_T);
    Serial.print(",");
  } else {
    Serial.print(zero);
    Serial.print(",");
  }

  digitalWrite(TRIGGER_PIN_P, LOW);  
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN_P, HIGH);       
  delayMicroseconds(20);              
  digitalWrite(TRIGGER_PIN_P, LOW);        
  duration_P = pulseIn(ECHO_PIN_P,HIGH);  
  distance_P = (duration_P * 35) / (2*1000);
  if ((distance_P > 20) && (distance_P < 600)) {
    Serial.print(distance_P);
    Serial.print(",");
  } else {
    Serial.print(zero);
    Serial.print(",");
  }
}

void button_T() {
  currentButtonState_T = digitalRead(buttonPin_T);
  if (currentButtonState_T == LOW && lastButtonState_T == HIGH && (millis() - lastDebounceTime_T) > debounceDelay) {
    dem_T++;
    if(dem_T > 3) {
      dem_T = 0;
    }
    lastDebounceTime_T = millis();
  }
  lastButtonState_T = currentButtonState_T;
}

void button_P() {
  currentButtonState_P = digitalRead(buttonPin_P);
  if (currentButtonState_P == LOW && lastButtonState_P == HIGH && (millis() - lastDebounceTime_P) > debounceDelay) {
    dem_P++;
    if(dem_P > 3) {
      dem_P = 0;
    }
    lastDebounceTime_P = millis();
  }
  lastButtonState_P = currentButtonState_P;
}

void obd2Req_SASM() {
  tCAN message;
  message.id = 0x797;
  message.header.rtr = 0;
  message.header.length = 8;
  message.data[0] = 0x03;
  message.data[1] = 0x22;
  message.data[2] = 0x20;
  message.data[3] = 0x3A;
  message.data[4] = 0x00;
  message.data[5] = 0x00;
  message.data[6] = 0x00;
  message.data[7] = 0x00;
  mcp2515_bit_modify(CANCTRL, (1<<REQOP2) | (1<<REQOP1) | (1<<REQOP0), 0);
  mcp2515_send_message(&message);
}

void obd2Res_SASM() {
  tCAN message;
  uint8_t dataBuffer[256];
  uint16_t totalLength = 0;
  uint8_t bufferIndex = 0;
  uint8_t can_int_status = mcp2515_read_register(CANINTF);
  if (bit_is_set(can_int_status, RX0IF) || bit_is_set(can_int_status, RX1IF)) {
    if (mcp2515_get_message(&message)) {
      if (message.id == 0x79F) {
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
        if (message.header.length >= 6) {
            combinedValue = (message.data[5] << 8) | message.data[6];
            phi = 1.5*combinedValue/480;
        }  
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
        if ((message.data[0] >> 4) == 0x1) {
          totalLength = ((message.data[0] & 0x0F) << 8) | message.data[1];
          bufferIndex = 0;
          for (int i = 2; i < message.header.length; i++) {
            dataBuffer[bufferIndex++] = message.data[i];
          }

          while (bufferIndex < totalLength) {
            uint8_t nextFrameReceived = 0;
            while (!nextFrameReceived) {
              can_int_status = mcp2515_read_register(CANINTF);
              if (bit_is_set(can_int_status, RX0IF) || bit_is_set(can_int_status, RX1IF)) {
                if (mcp2515_get_message(&message)) {
                  for (int i = 1; i < message.header.length; i++) {
                    if (bufferIndex < totalLength) {
                      dataBuffer[bufferIndex++] = message.data[i];
                    }
                  }
                  nextFrameReceived = 1; 
                }
              }
            }
          }
            directions = dataBuffer[11];
        }
      }
    }
  }
}

void obd2Req_VSS() {
  tCAN message;
  message.id = 0x7DF;
  message.header.rtr = 0;
  message.header.length = 8;
  message.data[0] = 0x02;
  message.data[1] = 0x01;
  message.data[2] = 0x0D;
  message.data[3] = 0x00;
  message.data[4] = 0x00;
  message.data[5] = 0x00;
  message.data[6] = 0x00;
  message.data[7] = 0x00;
  mcp2515_bit_modify(CANCTRL, (1<<REQOP2) | (1<<REQOP1) | (1<<REQOP0), 0);
  mcp2515_send_message(&message);
}

void obd2Res_VSS() {
  tCAN message;
  uint8_t can_int_status = mcp2515_read_register(CANINTF);
  if (bit_is_set(can_int_status, RX0IF) || bit_is_set(can_int_status, RX1IF))
  {
    if (mcp2515_get_message(&message))
    {
      if (message.id == 0x7E8)
      {
        vss = message.data[3];
      }
    }
  }
}

void loop() {
  if(x == 1000) {
    pre_angle = phi;
    sensor();
    button_T();
    button_P();
//xxxxxxxxxxxxxxxxxx Position xxxxxxxxxxxxxxxxxxxxxxxx//
  if((dem_P % 2 != 0) || (dem_T % 2 != 0)) {
    obd2Req_VSS();
    delay(1);
    obd2Res_VSS();
    delay(1);
 
    if (dem_T % 2 != 0) {
        if ((distance_T < 21) || (distance_T > 250)) {
            if (!counting_T) {
                startTime_T = millis();
                counting_T = true;
            }
        thoigian_T = millis() - startTime_T;
        } else {
            counting_T = false;
            thoigian_T = 0;
            dorong_T = 0;
        }
    } else {
        counting_T = false;
        thoigian_T = 0;
        dorong_T = 0;
    }
    ts_T = thoigian_T;
    dorong_T = vss * ts_T / 3.6; 
    lastButtonState_T = currentButtonState_T;

    if (dem_P % 2 != 0) {
        if ((distance_P < 21) || (distance_P > 250)) {
            if (!counting_P) {
                startTime_P = millis();
                counting_P = true;
            }
        thoigian_P = millis() - startTime_P;
        } else {
            counting_P = false;
            thoigian_P = 0;
            dorong_P = 0;
        }
    } else {
        counting_P = false;
        thoigian_P = 0;
        dorong_P = 0;
    }
    ts_P = thoigian_P;
    dorong_P = vss * ts_P / 3.6; 
    lastButtonState_P = currentButtonState_P;
    
  } else {
    dorong_P = 0;
    dorong_T = 0;
    counting_T = false;
    thoigian_T = 0;
    dorong_T = 0;
    counting_P = false;
    thoigian_P = 0;
    dorong_P = 0;
  }
//xxxxxxxxxxxxxxxxxxxxx Turning Wheel xxxxxxxxxxxxxxxxxxxxxxxxx//
    obd2Req_SASM();
    delay(18);
    obd2Res_SASM();
    delay(18);

    if (pre_angle != phi) {
      Serial.print(phi);
      Serial.print(",");
    } 
    else {
      Serial.print(pre_angle);
      Serial.print(",");
    }
    
    Rof = L/sin(phi*PI/180) +  0.5*(A-B);
    R = sqrt((Rof - 0.5*(A-B)) * (Rof - 0.5*(A-B)) - L*L) - 0.5*B;

    Serial.print(Rof);
    Serial.print(",");
    Serial.print(R);
    Serial.print(",");
    Serial.print(dem_T);
    Serial.print(",");
    Serial.print(dorong_T);
    Serial.print(",");
    Serial.print(dem_P);
    Serial.print(",");
    Serial.print(dorong_P);
    Serial.print(",");
    Serial.print(vss);
    Serial.print(",");
    Serial.print(directions);
    Serial.print(",");
    Serial.print(x);
    Serial.print(",");
    Serial.println("");
  } 
  else {
    x++;
  }
}
