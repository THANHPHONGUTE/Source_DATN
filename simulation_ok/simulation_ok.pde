 import processing.serial.*; 
 import java.awt.event.KeyEvent;
 import java.io.IOException;  
 Serial myPort;
 String[] data;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
String distance_1="", distance_2="", distance_3="", distance_4="", distance_5="", distance_6="", distance_7="", angl="", Rof="", R="", dem_P="", dorong_P="", dem_T="", dorong_T="", vss="", directions="";
int iDistance_1, iDistance_2, iDistance_3, iDistance_4, iDistance_5, iDistance_6, iDistance_7, iangl, iRof, iR, idem_P, idorong_P, idem_T, idorong_T,ivss,idirections;
float angle1 = 0, angle2 = 0, angle3 = 0, angle4 = 0, angle5 = 0, angle6 = 0, angle7 = 0;
int L = 2648, A = 1544, B = 1044;
float P_1, P_2, P_3, T_1, T_2, T_3, Rate_iRof, Rate_iR;
int temp_T = 0, temp_P = 0, dr_T = 0, dr_P = 0;
int interval = 200, okShown_T; 
int previousMillis1 = 0, previousMillis2 = 0, previousMillis3 = 0, previousMillis4 = 0;
boolean circleVisible1 = false;  
boolean circleVisible2 = false;  
boolean circleVisible3 = false;  
boolean circleVisible4 = false;  
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
 void setup() {
    size(1900,970);  
    smooth();
    myPort = new Serial(this,"COM29", 115200);
    data = new String[16];
 }
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx// 
void draw() {
    background(0); 
    noStroke();
    Car ();
//xxxxxxxxx 5 sensor xxxxxxxxx//
    noStroke();
    fill(200,100,100); 
    rect(342,435, 12, 12,5,5,5,5);  // TS
    fill(200,100,100); 
    rect(342,525, 12, 12,5,5,5,5);  // DS
    fill(200,100,100); 
    rect(352,480, 12, 12,5,5,5,5);  // GS
    if(idem_P % 2 != 0) {
        fill(200,100,100); 
        rect(323,430, 10, 10,5,5,5,5);  // P
    }
    if(idem_T % 2 != 0) {
        fill(200,100,100); 
        rect(323,530, 10, 10,5,5,5,5);  // T
    }
//xxxxxxxxx Mirror xxxxxxxxx//
    float lineLength = 25;
    float angleDegrees_1 = -57;
    float angleDegrees_2 = 57;
    float startX_1 = 200, startX_2 = 200;
    float startY_1 = 435, startY_2 = 535;
    float angleRadians_1 = radians(angleDegrees_1);
    float angleRadians_2 = radians(angleDegrees_2);
    float endX_1 = startX_1 + cos(angleRadians_1) * lineLength;
    float endY_1 = startY_1 + sin(angleRadians_1) * lineLength;
    float endX_2 = startX_2 + cos(angleRadians_2) * lineLength;
    float endY_2 = startY_2 + sin(angleRadians_2) * lineLength;
    float midX_1 = (startX_1 + endX_1)/2;  
    float midY_1 = (startY_1 + endY_1)/2;
    float midX_2 = (startX_2 + endX_2)/2;  
    float midY_2 = (startY_2 + endY_2)/2;

    stroke(0, 0, 255);  // Blue
    strokeWeight(3);
    line(startX_1, startY_1, endX_1, endY_1);
    line(startX_2, startY_2, endX_2, endY_2);
    noFill();
    arc(midX_2, midY_2, 18, 25, 19*PI/60, 79*PI/60);
    arc(midX_1, midY_1, 18, 25, 123*PI/180, 303*PI/180);
  
// 2 Sensor 
    fill(200,100,100); // Red
    rect(205,410, 12, 12,5,5,5,5);  // TT
    fill(200,100,100); 
    rect(205,550, 12, 12,5,5,5,5);  // DT
//xxxxxxxxxxxxxxxxxxxxxxxxxx - Receive Data - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
  if (myPort.available() > 0) {
    String inData = myPort.readStringUntil('\n'); 
    if (inData != null) {
        data = split(inData, ',');
        boolean found1000 = false;
    for (int i = 0; i < data.length; i++) {
        if (int(data[i]) == 1000) {
            found1000 = true;
            break;
        }
    }
// Extract values from the array
    if (found1000 && data.length >= 10) {
        int distance_1 = int(data[0]);
        int distance_2 = int(data[1]);
        int distance_3 = int(data[2]);
        int distance_4 = int(data[3]); // GT
        int distance_5 = int(data[4]); // GP
        int distance_6 = int(data[5]); // T
        int distance_7 = int(data[6]); // P
        int angl = int(data[7]);
        int Rof = int(data[8]);
        int R = int(data[9]);
        int dem_T = int(data[10]);
        int dorong_T = int(data[11]);
        int dem_P = int(data[12]);
        int dorong_P = int(data[13]);
        int vss = int(data[14]);
        int directions = int(data[15]);
// Convert strings to integers
        iDistance_1 = int(distance_1);
        iDistance_2 = int(distance_2);
        iDistance_3 = int(distance_3);
        iDistance_4 = int(distance_4);
        iDistance_5 = int(distance_5);
        iDistance_6 = int(distance_6);
        iDistance_7 = int(distance_7);
        iangl = int(angl);
        iRof = int(Rof);
        iR = int(R);
        idem_T = int(dem_T);
        idorong_T = int(dorong_T);
        idem_P = int(dem_P);
        idorong_P = int(dorong_P);
        ivss = int(vss);
        idirections = int(directions);
      }
    }
  }
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
  R_quayvong();
  drawText ();
  drawSimul();
}
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
void Car() {
  // Car
  fill(0,102,204);   // Blue
  rect(160, 435, 180, 100); 
  arc(160, 485, 70, 100, PI/2, 3*PI/2); 
  arc(340, 485, 35, 100, 3*PI/2, 5*PI/2); 
  noFill();
  stroke(255);
  strokeWeight(2);
  arc(225, 485, 70, 150, 5*PI/6, 7*PI/6);
  
  float Length = 30;
  float ang_1 = -160;
  float ang_2 = -20;
  float X_1 = 195, Y_1 = 447;
  float X_2 = 195, Y_2 = 523;
  float angRadians_1 = radians(ang_1);
  float angRadians_2 = radians(ang_2);
  float endX1 = X_1 - cos(angRadians_1) * Length;
  float endY1 = Y_1 - sin(angRadians_1) * Length;
  float endX2 = X_2 + cos(angRadians_2) * Length;
  float endY2 = Y_2 + sin(angRadians_2) * Length;

  line(X_1, Y_1, endX1, endY1);
  line(X_2, Y_2, endX2, endY2);
  arc(242, 485, 40, 105, 5*PI/6, 7*PI/6);
  arc(242, 485, 45, 110, 5*PI/6, 7*PI/6);
//==============================================//  
  float Length_a = 70;
  float ang_a1 = -177;
  float ang_a2 = -3;
  float X_a1 = endX1, Y_a1 = endY1;
  float X_a2 = endX2, Y_a2 = endY2;
  float angRadians_a1 = radians(ang_a1);
  float angRadians_a2 = radians(ang_a2);
  float endXa1 = X_a1 - cos(angRadians_a1) * Length_a;
  float endYa1 = Y_a1 - sin(angRadians_a1) * Length_a;
  float endXa2 = X_a2 + cos(angRadians_a2) * Length_a;
  float endYa2 = Y_a2 + sin(angRadians_a2) * Length_a;

  line(X_a1, Y_a1, endXa1, endYa1);
  line(X_a2, Y_a2, endXa2, endYa2);
  arc(307, 485, 30, 95, 5*PI/6, 7*PI/6);
//==============================================//  
  float Length_b = 37;
  float ang_b1 = 155;
  float ang_b2 = 25;
  float X_b1 = endXa1, Y_b1 = endYa1;
  float X_b2 = endXa2, Y_b2 = endYa2;
  float angRadians_b1 = radians(ang_b1);
  float angRadians_b2 = radians(ang_b2);
  float endXb1 = X_b1 - cos(angRadians_b1) * Length_b;
  float endYb1 = Y_b1 - sin(angRadians_b1) * Length_b;
  float endXb2 = X_b2 + cos(angRadians_b2) * Length_b;
  float endYb2 = Y_b2 + sin(angRadians_b2) * Length_b;

  line(X_b1, Y_b1, endXb1, endYb1);
  line(X_b2, Y_b2, endXb2, endYb2);
  arc(310, 485, 40, 160, -PI/6, PI/6);
  
  arc(260, 458, 180, 30, -3*PI/4, -PI/4);
  arc(260, 512, 180, 30, -7*PI/4, -5*PI/4);
//==============================================//  
  float Length_aa = 17;
  float ang_aa1 = -65;
  float ang_aa2 = -115;
  float angRadians_aa1 = radians(ang_aa1);
  float angRadians_aa2 = radians(ang_aa2);
  float midX_a1 = (X_a1 + endXa1)/2;  
  float midY_a1 = (Y_a1 + endYa1)/2;
  float midX_a2 = (X_a2 + endXa2)/2;  
  float midY_a2 = (Y_a2 + endYa2)/2;
  float endmidXa1 = midX_a1 + cos(angRadians_aa1) * Length_aa;
  float endmidYa1 = midY_a1 + sin(angRadians_aa1) * Length_aa;
  float endmidXa2 = midX_a2 - cos(angRadians_aa2) * Length_aa;
  float endmidYa2 = midY_a2 - sin(angRadians_aa2) * Length_aa;

  line(midX_a1, midY_a1, endmidXa1, endmidYa1);
  line(midX_a1+5, midY_a1, endmidXa1+5, endmidYa1);
  line(midX_a2, midY_a2, endmidXa2, endmidYa2);
  line(midX_a2+5, midY_a2, endmidXa2+5, endmidYa2);
  
  line(248, 448, 255, 448);
  line(248, 450, 255, 450);
  
  line(296, 448, 303, 448);
  line(296, 450, 303, 450);
  
  line(248, 518, 255, 518);
  line(248, 520, 255, 520);
  
  line(296, 518, 303, 518);
  line(296, 520, 303, 520);
}

//xxxxxxxxxxxxxxxxxxx Net Dut - Tam O - R xxxxxxxxxxxxxxxxxxxxxx//
void R_quayvong() {
  stroke(255, 255, 255);
  drawDottedLine(400, 438, 1500, 438, 25);
  drawDottedLine(400, 535, 1500, 535, 25);
  stroke(255, 255, 255);
  drawDottedLine(327, 150, 327, 395, 25);
  drawDottedLine(327, 565, 327, 850, 25);
  noFill();
  stroke(255, 255, 255); 
  strokeWeight(2); 
  
  float Rx = 327;
  float Ry = 485;
  Rate_iRof = iRof/15;
  Rate_iR = iR/15;
  if(idirections == 0) {
// xxxx Left xxxx
    arc(Rx, Ry + Rate_iR , Rate_iRof * 2, Rate_iRof * 2, -3*PI/4, -PI/10);
  } else {
// xxxx Right xxxx
    arc(Rx, Ry - Rate_iR , Rate_iRof * 2, Rate_iRof * 2, PI/10, 3*PI/4);
  }
}

void drawDottedLine(float x1, float y1, float x2, float y2, float dotSpacing) {
  float lineLength = dist(x1, y1, x2, y2);
  int segments = int(lineLength / dotSpacing);
  float deltaX = (x2 - x1) / segments;
  float deltaY = (y2 - y1) / segments;
  for (int i = 0; i < segments; i += 2) {
    float xStart = x1 + i * deltaX;
    float yStart = y1 + i * deltaY;
    float xEnd = x1 + (i + 1) * deltaX;
    float yEnd = y1 + (i + 1) * deltaY;
    line(xStart, yStart, xEnd, yEnd);
  }
}
 // xxxxxxxxxxxxxxxxxxx - Sensor Value - xxxxxxxxxxxxxxxxxxxx
 void drawText() {
  fill(98,245,60);
 //xxxxxx P - 1 XXXXXXXXXXX//
   float x1 = 1700;
   float y1 = 100;
    if(iDistance_1 > 600 || iDistance_1 == 0) {
       text("No Signal", x1-75, y1 );
    } 
    else {
      text(iDistance_1 +" cm", x1, y1);
    }
  
 //xxxxxx G - 2 XXXXXXXXXXX//
   int x2 = 1700;
   int y2 = 500;
    if(iDistance_2 > 600 || iDistance_2 == 0) {
       text("No Signal", x2-75, y2);
    } 
    else {
      text(iDistance_2 +" cm", x2, y2);
    }
   
 //xxxxxx T - 3 XXXXXXXXXXX//
   int x3 = 1700;
   int y3 = 850;
   
    if(iDistance_3 > 600 || iDistance_3 == 0) {
       text("No Signal", x3-75, y3);
    }
    else {
    text(iDistance_3 +" cm", x3, y3);
    }
  
 //xxxxxx Mirror - 4 XXXXXXXXXXX//
   float x5 = 205;
   float y5 = 100;
  
    if(iDistance_5 > 600 || iDistance_5 == 0) {
       text("No Signal", x5, y5);
    }
    else {
      text(iDistance_5 +" cm", x5, y5);
    }
   
 //xxxxxx Mirror - 5 XXXXXXXXXXX//
   int x4 = 205;
   int y4 = 910;
   
    if(iDistance_4 > 600 || iDistance_4 == 0) {
       text("No Signal", x4, y4);
    }
    else {
    text(iDistance_4 +" cm", x4, y4);
    }
  
 //xxxxxx T XXXXXXXXXXX//
  float xT = 700;
  float yT = 910;
  float xP = 700;
  float yP = 100;
   
  if(idem_T % 2 != 0) {
    if(idorong_T < 6807) {
         text("Dorong = "+ idorong_T + "mm", xT, yT);
      }
    else {
      text("Dorong = "+ idorong_T + "mm", xT, yT);
      temp_T = 1;
    }
    if(temp_T == 1) {
      stroke(0, 255, 0); 
      strokeWeight(10);
      line(650, 860, 670, 900);
      line(670, 900, 690, 800); 
    }
  } else {
    temp_T = 0;
  }
    
 //xxxxxx P XXXXXXXXXXX//
    if(idem_P % 2 != 0) {
        if(idorong_P < 6807) {
            text("Dorong = "+ idorong_P + "mm", xP, yP);
        }
        else {
            text("Dorong = "+ idorong_P + "mm", xP, yP);
            temp_P = 1;
        }
        if(temp_P == 1) {
            stroke(0, 255, 0); 
            strokeWeight(10);
            line(650, 70, 670, 110);
            line(670, 110, 690, 10); 
        }
    } else {
    temp_P = 0;
   }
   
 //xxxxxx Angle XXXXXXXXXXX//
    int x8 = 1300;
    int y8 = 100;
    text(iangl +" do", x8, y8);
    textSize(40);

 //xxxxxx VSS - 14 XXXXXXXXXXX//
  if((idem_T%2!=0) || (idem_P%2!=0)) {
    int x14 = 1300;
    int y14 = 500;
    text(ivss +" km/h", x14, y14);
  }
 //xxxxxxxxxxxxx Compare Distance xxxxxxxxxxxxxxxx//
  int currentMillis = millis();
  P_1 = sqrt(iRof*iRof - (iR - 0.5*A)*(iR - 0.5*A))/15;
  P_2 = sqrt(iRof*iRof - iR*iR)/15;
  P_3 = sqrt(iRof*iRof - (iR + 0.5*A)*(iR + 0.5*A))/15;
  T_3 = sqrt(iRof*iRof - (iR - 0.5*A)*(iR - 0.5*A))/15;
  T_2 = sqrt(iRof*iRof - iR*iR)/15;
  T_1 = sqrt(iRof*iRof - (iR + 0.5*A)*(iR + 0.5*A))/15;
  
if (idirections == 0) {
    if((iDistance_1 <= T_1) && (iDistance_1 >= 21)) {
        if (currentMillis - previousMillis1 >= interval) {
              previousMillis1 = currentMillis;
              circleVisible1 = !circleVisible1;
        }
  
        if (circleVisible1) {
              fill(255, 255, 0);  
              noStroke();
              ellipse(342+T_1, 435, 20, 20); 
        }
    } 
     if((iDistance_2 <= T_2) && (iDistance_2 >= 21)) {
          if (currentMillis - previousMillis2 >= interval) {
              previousMillis2 = currentMillis;
              circleVisible2 = !circleVisible2;
          }
    
          if (circleVisible2) {
              fill(255, 255, 0);  
              noStroke();
              ellipse(342+T_2, 480, 20, 20); 
          }
      }
      if((iDistance_3 <= T_3) && (iDistance_3 >= 21)) {
          if (currentMillis - previousMillis3 >= interval) {
              previousMillis3 = currentMillis;
              circleVisible3 = !circleVisible3;
          }
  
          if (circleVisible3) {
              fill(255, 255, 0);  
              noStroke();
              ellipse(342+T_3, 530, 20, 20); 
          }
      }
} else {
    if(iDistance_1 <= P_1) {
        if (currentMillis - previousMillis1 >= interval) {
              previousMillis1 = currentMillis;
              circleVisible1 = !circleVisible1;
          }
  
          if (circleVisible1) {
              fill(255, 255, 0);  
              noStroke();
              ellipse(342+P_1, 435, 20, 20); 
          }
      } 
     if(iDistance_2 <= P_2) {
          if (currentMillis - previousMillis2 >= interval) {
              previousMillis2 = currentMillis;
              circleVisible2 = !circleVisible2;
          }
    
          if (circleVisible2) {
              fill(255, 255, 0);  
              noStroke();
              ellipse(342+P_2, 480, 20, 20); 
          }
      }
      if(iDistance_3 <= P_3) {
          if (currentMillis - previousMillis3 >= interval) {
              previousMillis3 = currentMillis;
              circleVisible3 = !circleVisible3;
          }
  
          if (circleVisible3) {
              fill(255, 255, 0);  
              noStroke();
              ellipse(342+P_3, 530, 20, 20); 
          }
      }
    }
}

//xxxxxxxxxxxxxxx - Simulation Radar - Obstacle - xxxxxxxxxxxxxxx//
void drawSimul() {
// xxxxxxx P - (1) xxxxxxxxx
  pushMatrix();
  translate(1050, 450); 
  float distance_1 = map(sin(angle1), -1, 1, 0.9*iDistance_1, iDistance_1);
  int colorValue_1 = (int) map(distance_1, 0, iDistance_1, 0, 255);
  fill(0, colorValue_1, 0, 170); 
  noStroke();
  float startAngle1 = -radians(10); 
  float endAngle1 = radians(10); 
  arc(-705, -10, distance_1 * 2, distance_1 * 2, startAngle1, endAngle1);
  popMatrix();
  angle1 += radians(5);

  if(iDistance_1 != 0) {
    fill(200,100,100); 
    rect(342 + iDistance_1 + 5, 435, 10, 10,5,5,5,5); 
  }
// xxxxxxx P - (2) xxxxxxxxx
  pushMatrix();
  translate(1050, 450); 
  float distance_2 = map(sin(angle2), -1, 1, 0.9*iDistance_2, iDistance_2);
  int colorValue_2 = (int) map(distance_2, 0, iDistance_2, 0, 255);
  fill(0, colorValue_2, 0, 170); 
  noStroke();
  float startAngle2 = -radians(10); 
  float endAngle2 = radians(10); 
  arc(-693, 36, distance_2 * 2, distance_2 * 2, startAngle2, endAngle2);
  popMatrix();
  angle2 += radians(5); 
  
  if(iDistance_2 != 0) {
    fill(200,100,100);
    rect(352 + iDistance_2 + 5, 480, 10, 10,5,5,5,5); 
  }
// xxxxxxx P - (3) xxxxxxxxx
  pushMatrix();
  translate(1050, 450); 
  float distance_3 = map(sin(angle3), -1, 1, 0.9*iDistance_3, iDistance_3);
  int colorValue_3= (int) map(distance_3, 0, iDistance_3, 0, 255);
  fill(0, colorValue_3, 0, 170); 
  noStroke();
  float startAngle3 = -radians(6); 
  float endAngle3 = radians(14); 
  arc(-705, 81, distance_3 * 2, distance_3 * 2, startAngle3, endAngle3);
  popMatrix();
  angle3 += radians(5); 

  if(iDistance_3 != 0) {
    fill(200,100,100); 
    rect(342 + iDistance_3 + 5, 530, 10, 10,5,5,5,5); 
  }
  
// xxxxxxxxxxx Mirror - (T) xxxxxxxxx
  pushMatrix();
  translate(1050, 450); 
  float distance_5 = map(sin(angle5), -1, 1, 0.9*iDistance_5, iDistance_5);
  int colorValue_5 = (int) map(distance_5, 0, iDistance_5, 0, 255);
  fill(0, colorValue_5, 0, 170); 
  noStroke();
  float startAngle5 = -radians(30); 
  float endAngle5 = radians(0); 
  arc(-838, -33, distance_5 * 2, distance_5 * 2, startAngle5, endAngle5);
  popMatrix();
  angle5 += radians(5); 

  if(iDistance_5 != 0) {
    fill(200,100,100); 
    rect(205 + iDistance_5 + 10, 400, 10, 10,5,5,5,5); 
  }
// xxxxxxxxxxx Mirror - (P) xxxxxxxxx
  pushMatrix();
  translate(1050, 520); 

  float distance_4 = map(sin(angle4), -1, 1, 0.9*iDistance_4, iDistance_4);
  int colorValue_4 = (int) map(distance_4, 0, iDistance_4, 0, 255);

  fill(0, colorValue_4, 0, 170); 
  noStroke();
  float startAngle4 = radians(0); 
  float endAngle4 = radians(30); 
  arc(-838, 37, distance_4 * 2, distance_4 * 2, startAngle4, endAngle4);
  popMatrix();
  angle4 += radians(5); 

  if(iDistance_4 != 0) {
    fill(200,100,100); 
    rect(205 + iDistance_4 + 10, 570, 10, 10,5,5,5,5); 
  }

// xxxxxxxxxxx (T) xxxxxxxxx
  if(idem_T % 2 != 0) {
    pushMatrix();
    translate(1050, 520); 

    float distance_6 = map(sin(angle6), -1, 1, 0.9*iDistance_6, iDistance_6);
    int colorValue_6 = (int) map(distance_6, 0, iDistance_6, 0, 255);

    fill(0, colorValue_6, 0, 170); 
    noStroke();
    float startAngle6 = radians(80); 
    float endAngle6 = radians(100); 
    arc(-722, 14, distance_6 * 2, distance_6 * 2, startAngle6, endAngle6);
    popMatrix();
    angle6 += radians(5); 
  }
  
// xxxxxxxxxxx (P) xxxxxxxxx
  if(idem_P % 2 != 0) {
    pushMatrix();
    translate(1050, 520); 

    float distance_7 = map(sin(angle7), -1, 1, 0.9*iDistance_7, iDistance_7);
    int colorValue_7 = (int) map(distance_7, 0, iDistance_7, 0, 255);

    fill(0, colorValue_7, 0, 170); 
    noStroke();
    float startAngle7 = -radians(100); 
    float endAngle7 = -radians(80); 
    arc(-722, -82, distance_7 * 2, distance_7 * 2, startAngle7, endAngle7);
    popMatrix();
    angle7 += radians(5); 
  }
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
}
