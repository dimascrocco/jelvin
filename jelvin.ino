//Programa : Controle 2 motores DC usando Ponte H L298N
//Autor : FILIPEFLOP
 
//Definicoes pinos Arduino ligados a entrada da Ponte H
int IN1 = 2;
int IN2 = 3;
int IN3 = 6;
int IN4 = 7;

int ECHO = 12;
int TRIGGER = 13;

void setup()
{
  //Define os pinos como saida
 pinMode(IN1, OUTPUT);
 pinMode(IN2, OUTPUT);
 pinMode(IN3, OUTPUT);
 pinMode(IN4, OUTPUT);
 
 pinMode(TRIGGER, OUTPUT);
 pinMode(ECHO, INPUT);
 
 Serial.begin(9600);
}

  
void loop()
{
 /*
   int vuA = 100;
   int vdA = 100; 
   
   int vuB = 100;
   int vdB = 100; 

  digitalWrite(IN1, HIGH); digitalWrite(IN2, LOW); delay(vuA); // A up
  digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); delay(20); // A stop
 
  digitalWrite(IN3, LOW); digitalWrite(IN4, HIGH); delay(vuB); // B up
  digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); delay(20); // B stop
  
  digitalWrite(IN1, LOW); digitalWrite(IN2, HIGH); delay(vdA); // A down
  digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); delay(20); // A stop
 
  digitalWrite(IN3, HIGH); digitalWrite(IN4, LOW); delay(vdB); // B down
  digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); delay(20); // B stop
 */

  int v = 100;
  int pause = 0;

  digitalWrite(IN1, HIGH); digitalWrite(IN2, LOW); // A up
  digitalWrite(IN3, HIGH); digitalWrite(IN4, LOW); // B down
  delay(v);
  digitalWrite(IN3, LOW); digitalWrite(IN4, LOW); // B off
  
  digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); // A stop
  digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); // B stop
  delay(pause); 
  checkDistance();


  
  digitalWrite(IN3, LOW); digitalWrite(IN4, HIGH); // B up  
  digitalWrite(IN1, LOW); digitalWrite(IN2, HIGH); // A down
  delay(v);
  digitalWrite(IN1, LOW); digitalWrite(IN2, LOW); // A down
  
  // digitalWrite(IN1, HIGH); digitalWrite(IN2, HIGH); delay(20); // A stop
  // digitalWrite(IN3, HIGH); digitalWrite(IN4, HIGH); delay(20); // B stop

}

void checkDistance() {
  long duration, distance;
  
  digitalWrite(TRIGGER, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER, LOW);
  
  duration = pulseIn(ECHO, HIGH);
  distance = (duration/2) / 29.1;
  
    Serial.print(distance);
    Serial.println(" cm");

}
