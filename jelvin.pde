/*
 * Jelvin - Robaterista
 *
 * Uso ponte H: FELIPEFLOP (Controle 2 motores DC usando Ponte H L298N)
 */

int IN1 = 2;
int IN2 = 3;
int IN3 = 6;
int IN4 = 7;

int ECHO = 12;
int TRIGGER = 13;

int setupCount = 0;
long THRESHOLD = 30;
int SETUP_SAMPLE = 30;
int setupValue = -1;
long diff, lastValue;

bool setupOK = false;
bool isPlaying = false;

int playCount = 0;
int MAX_PLAY_COUNT = 10;
int musicID = 0;


void setup() {
  //Define os pinos como saida
 pinMode(IN1, OUTPUT);
 pinMode(IN2, OUTPUT);
 pinMode(IN3, OUTPUT);
 pinMode(IN4, OUTPUT);
 
 pinMode(TRIGGER, OUTPUT);
 pinMode(ECHO, INPUT);
 
 Serial.begin(9600);

 playJazz();
}

  
void loop() {
  // isThereAnyBodyInThere() 

  int cm = getDistance();
  Serial.print(cm);
  Serial.println(" cm");

  if (isPlaying) {
    if (playCount <= MAX_PLAY_COUNT) {
      playCount++;
      playJazz(); // TODO random music every new music cycle 
    } else {
      isPlaying = false;
      playCount = 0;
    }
    return;
  }

  // TODO take the mean value plz
  if (setupCount < SETUP_SAMPLE) {
    if (cm > 0) {
      setupCount++;
      setupValue = cm;
      Serial.print(setupCount); Serial.print(" : setup sample @ "); Serial.println(cm);
   
    }
    delay(500);
  } else {
    if (!setupOK) {
      setupOK = true;
      playJazz();
    } else {
      Serial.println("* checking audience...");

      diff = setupValue - cm;
      if (diff < 0)
        diff = diff * -1;
      if (diff > THRESHOLD) {
        Serial.println("* found somebody! let's play!");

        // TODO choose random genre to play
        isPlaying = true;
      }     

      delay(250);
    }
  }


    // playJazz();
    // playRandom();
    // playRock();
}

void playRandom() {
  Serial.println("# random");
  int v = 100;
  int pause = 0;

  digitalWrite(IN1, HIGH); digitalWrite(IN2, LOW); // A up
  digitalWrite(IN3, HIGH); digitalWrite(IN4, LOW); // B down
  delay(v);
  digitalWrite(IN3, LOW); digitalWrite(IN4, LOW); // B off
  
  digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); // A stop
  digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); // B stop
  //delay(pause); 
  //checkDistance();
  
  digitalWrite(IN3, LOW); digitalWrite(IN4, HIGH); // B up  
  digitalWrite(IN1, LOW); digitalWrite(IN2, HIGH); // A down
  delay(v);
  digitalWrite(IN1, LOW); digitalWrite(IN2, LOW); // A down
  
  // digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); delay(20); // A stop
  // digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); delay(20); // B stop

}

void playJazz() {
  Serial.println("# jazz");
   int vuA = 100;
   int vdA = 100; 
   
   int vuB = 100;
   int vdB = 100; 

  digitalWrite(IN1, HIGH); digitalWrite(IN2, LOW); delay(vuA); // A up
  digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); delay(20); // A stop
 
  digitalWrite(IN3, LOW); digitalWrite(IN4, HIGH); delay(vuB); // B up
  digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); delay(20); // B stop
  //checkDistance();
  
  digitalWrite(IN1, LOW); digitalWrite(IN2, HIGH); delay(vdA); // A down
  digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); delay(20); // A stop
 
  digitalWrite(IN3, HIGH); digitalWrite(IN4, LOW); delay(vdB); // B down
  digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); delay(20); // B stop
}

/**
 * how far is the audience? (centimeters)
 */
int getDistance() {
  long duration, distance;
  
  digitalWrite(TRIGGER, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER, HIGH);
  delayMicroseconds(5);
  digitalWrite(TRIGGER, LOW);
  
  duration = pulseIn(ECHO, HIGH);
  distance = (duration/2) / 29.1;
  
  return distance;
}
