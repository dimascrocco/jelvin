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
int SETUP_SAMPLE = 15;
int setupValue = -1;
long diff, lastValue;

bool setupOK = false;
bool isPlaying = false;

int playCount = 0;
int MAX_PLAY_COUNT = 5;
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
  
 randomSeed(analogRead(0));

 playJazz();
}

  
void loop() {
  // isThereAnyBodyInThere() 

  // playRock(); playRock(); playRock(); playRock(); playRock();
  // playJazz(); playJazz(); playJazz(); playJazz(); playJazz();
  // DONT USE THIS! playBlah(); playBlah(); playBlah(); playBlah(); playBlah();
  
  int cm = getDistance();
  Serial.print(cm);
  Serial.println(" cm");

  if (isPlaying) {
    if (playCount <= MAX_PLAY_COUNT) {
      playCount++;
      play(); 
    } else {
      isPlaying = false;
      playCount = 0;
      musicID = random(2); // NEXT MUSIC TO PLAY
    }

    return;
  }


  // TODO take the mean value plz
  // MOVE TO calibration
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
      if (diff > THRESHOLD && cm != 0) {
        Serial.println("* found somebody! let's play!");

        // TODO choose random genre to play
        isPlaying = true;
      }     

      delay(250);
    }
  }
}

void play() {
  if (musicID == 0) {
    playJazz();  
  } else {
    playRock();  
  }
}

/* BEWARE DONT USE.. IT HURTS THE ROBOT!
void playBlah() {
  Serial.println("# blah");
  int v = 100;
  int pause = 0;

  up('B'); delay(100);
  down('B'); delay(100);
  release('B');

  up('A'); delay(100);
  down('A'); delay(100);
  up('A'); delay(100);
  down('A'); delay(100);

  up('B'); delay(100);
  down('B'); delay(100);
  up('B'); delay(100);
  down('B'); delay(100);
  release('B');

  up('A'); delay(100);
  down('A'); delay(100);
}
*/

void playRock() {
  Serial.println("# rock");
  int v = 100;
  int pause = 0;

  up('A'); delay(100);
  down('A'); delay(100);
  up('A'); delay(100);
  down('A'); delay(100);
  release('A');

  up('B'); delay(100);
  down('B'); delay(100);
}

void playJazz() {
  Serial.println("# jazz");
   int vuA = 100;
   int vdA = 100; 
   
   int vuB = 100;
   int vdB = 100; 

  up('A'); delay(vuA); // A up
  hold('A'); delay(20); // A stop
 
  up('B'); delay(vuB); // B up
  hold('B'); delay(20); // B stop
  //checkDistance();
  
  down('A'); delay(vdA); // A down
  hold('A'); delay(20); // A stop
 
  down('B'); delay(vdB); // B down
  hold('B'); delay(20); // B stop
}

void up(char target) {
  if ('A' == target) {
    digitalWrite(IN1, HIGH); digitalWrite(IN2, LOW);
  } else if ('B' == target) {
    digitalWrite(IN3, LOW); digitalWrite(IN4, HIGH);
  }
}

void down(char target) {
  if ('A' == target) {
    digitalWrite(IN1, LOW); digitalWrite(IN2, HIGH);
  } else if ('B' == target) {
    digitalWrite(IN3, HIGH); digitalWrite(IN4, LOW);
  }
}

void hold(char target) {
  if ('A' == target) {
    digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); delay(20); // A stop
  } else if ('B' == target) {
    digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); delay(20); // B stop
  }
}

void release(char target) {
  if ('A' == target) {
    digitalWrite(IN1, LOW); digitalWrite(IN2, LOW); // A off
  } else if ('B' == target) {
    digitalWrite(IN3, LOW); digitalWrite(IN4, LOW); // B off
  }  
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
