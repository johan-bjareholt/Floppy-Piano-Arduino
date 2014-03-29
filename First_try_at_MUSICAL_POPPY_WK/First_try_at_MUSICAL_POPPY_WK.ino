#include <TimerOne.h>
/*
 Biblotek som hanterar första timern på ATmega328P chippet.

 Timerns exakthet beror på procesorhastighet och frekvens. 
 TimerOnes klockhastighet definieras genom att ställa in en nämnare.
 Denna kan ställas på: 1, 8, 64, 256 or 1024.

 För 20MHz:

 Nämnare	Tid per räknar tick	Max period
 1	        0.05 uS  	        6.5536 mS
 8	        0.4 uS	                52.4288 mS
 64	        3.2 uS	                419.4304 mS
 256	        12.8 uS	                1677.216 mS
 1024	        51.2 uS	                6710.8864mS

 uS = mikrosekunder

 Formler
 Max period = (Nämnare)*(1/Frekvens)*(2^17)
 Tid per Tick = (Nämnare)*(1/Frekvens)
*/
boolean firstRun = true; // Used for one-run-only stuffs;

// First pin being used for floppies, and the last pin.  Used for looping over all pins.
const byte FIRST_PIN = 2;
const byte PIN_MAX = 17;
#define RESOLUTION 40 // Microsecond resolution for notes. Upplösningen.

short assigned[] = {0,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0};

/*NOTE: Many of the arrays below contain unused indexes.  This is 
 to prevent the Arduino from having to convert a pin input to an alternate
 array index and save as many cycles as possible.  In other words information 
 for pin 2 will be stored in index 2, and information for pin 4 will be 
 stored in index 4.*/

//Array containing all periods we are interested in using. 0-48
const int microPeriods[] = {
        30578, 28861, 27242, 25713, 24270, 22909, 21622, 20409, 19263, 18182, 17161, 16198, //C1 - B1
        15289, 14436, 13621, 12856, 12135, 11454, 10811, 10205, 9632, 9091, 8581, 8099, //C2 - B2
        7645, 7218, 6811, 6428, 6068, 5727, 5406, 5103, 4816, 4546, 4291, 4050, //C3 - B3
        3823, 3609, 3406, 3214, 3034, 2864, 2703, 2552, 2408, 2273, 2146, 2025 //C4 - B4        
};

/*An array of maximum track positions for each step-control pin.  Even pins
 are used for control, so only even numbers need a value here.  3.5" Floppies have
 80 tracks, 5.25" have 50.  These should be doubled, because each tick is now
 half a position (use 158 and 98).
 */
byte MAX_POSITION[] = {
  0,0,158,0,158,0,158,0,158,0,158,0,158,0,158,0,158,0};

//Array to track the current position of each floppy head.  (Only even indexes (i.e. 2,4,6...) are used)
byte currentPosition[] = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

/*Array to keep track of state of each pin.  Even indexes track the control-pins for toggle purposes.  Odd indexes
 track direction-pins.  LOW = forward, HIGH=reverse
 */
int currentState[] = {
  0,0,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW,LOW
};

//Current period assigned to each pin.  0 = off.  Each period is of the length specified by the RESOLUTION
//variable above.  i.e. A period of 10 is (RESOLUTION x 10) microseconds long.
unsigned int currentPeriod[] = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

//Current tick
unsigned int currentTick[] = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
};

//Stuffs for multiplexing
int bit0 = 0;
int bit1 = 0;
int bit2 = 0;
int bit3 = 0;

int count = 0;
short values[] = {1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1};
short prevValues[] = {1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1};

boolean changed = false;

//Setup pins (Even-odd pairs for step control and direction
void setup(){
  pinMode(2, OUTPUT); // Step control 1
  pinMode(3, OUTPUT); // Direction 1
  pinMode(4, OUTPUT); // Step control 2
  pinMode(5, OUTPUT); // Direction 2
  pinMode(6, OUTPUT); // Step control 3
  pinMode(7, OUTPUT); // Direction 3
  pinMode(8, OUTPUT); // Step control 4
  pinMode(9, OUTPUT); // Direction 4
  
  pinMode(A0, OUTPUT); // Control 1 for multiplexing
  pinMode(A1, OUTPUT); // Control 2 for multiplexing
  pinMode(A2, OUTPUT); // Control 3 for multiplexing
  pinMode(A3, OUTPUT); // Control 4 for multiplexing
 
  pinMode(13, INPUT_PULLUP); // Input from multiplexer

  Timer1.initialize(RESOLUTION); 
  /* 
   Set up a timer at the defined resolution. 
   
   Denna metod måste anropas för att kunna använda Timer1 på ATmega chipet.
   Här definierar du timerns period, i uS(=microsekunder), default är 1 sekund. Här är den dock 40uS. 
  */
  Timer1.attachInterrupt(tick); 
  /*
   Attach the tick function
   
   Denna metod kräver två "argument" en funktion och en period. 
   Dessa tillhandahålls av "tick" en bit ner.
  */
  
  Serial.begin(9600);
}

void loop(){

  // The first loop, reset all the drives, and wait 2 seconds...
  // Sänder tillbaka alla läshuvuden till sin grundposition.
  if (firstRun)
  {
    firstRun = false;
    resetAll();
    delay(2000);
  }
  
  readKeyes();
  
  if(changed){
   for(int i = 0; i <= 15; i++){
    if(values[i] == 0){
     for(int j = 2; j <= 8; j+2){
      if(assigned[j] < 0){
       currentPeriod[j] = (microPeriods[i])/(RESOLUTION*2);
       assigned[j] = i;
       j = 9;
      }
     }
    }   
   
    else if(values[i] == 1){
     for(int j = 2; j <= 8; j+2){
      if(assigned[j] == i){
       currentPeriod[j] = 0;
       assigned[j] = -1;
       j = 9;
     }      
    }
   }
  } 
 }
} 
  
   /*
   Current period assigned to each pin.  0 = off.  Each period is of the length specified by the RESOLUTION
   variable above.  i.e. A period of 10 is (RESOLUTION x 10) microseconds long.
      
   currentPeriod är den nuvarande perioden satt för var definierad pin. 
   Var period definieras av upplösningen(RESOLUTION) tidigare definierad som 40 uS. 
   Alltså är en period om 10: (RESOLUTION*10)= 400uS lång.
   */


/*
Called by the timer inturrupt at the specified resolution.

Anropad av Timer1s interuppt vid den definierade upplösningen(RESOLUTION) 40 uS.
 */
void tick()
{
  /* 
   If there is a period set for control pin 2, count the number of
   ticks that pass, and toggle the pin if the current period is reached.
   
   Om det finns en period definierad för pin 2: 
   Räkna hur många ticks som har passera, och toggla pin 2 om nuvarande period är uppnådd.
   */
  for(int i = 2; i <= 8; i+2){
   if (currentPeriod[i]>0){
     currentTick[i]++;
     if (currentTick[i] >= currentPeriod[i]){
       int j = i++;
       togglePin(i, j);
       currentTick[i]=0;
     }
    } 
  }
}

void togglePin(byte pin, byte direction_pin) {

  //Switch directions if end has been reached
  if (currentPosition[pin] >= MAX_POSITION[pin]) {
    currentState[direction_pin] = HIGH;
    digitalWrite(direction_pin,HIGH);
  } 
  else if (currentPosition[pin] <= 0) {
    currentState[direction_pin] = LOW;
    digitalWrite(direction_pin,LOW);
  }

  //Update currentPosition
  if (currentState[direction_pin] == HIGH){
    currentPosition[pin]--;
  } 
  else {
    currentPosition[pin]++;
  }

  //Pulse the control pin
  digitalWrite(pin,currentState[pin]);
  currentState[pin] = ~currentState[pin];
}

void readKeyes(){
  for(int i = 0; i<=15; i++){
    prevValues[i] = values[i];
  }
  changed = false;
  
  for(count = 0; count<=15; count++){
  
  bit0 = bitRead(count, 0);
  bit1 = bitRead(count, 1);
  bit2 = bitRead(count, 2);
  bit3 = bitRead(count, 3);
  
  digitalWrite(A0, bit0);
  digitalWrite(A1, bit1);
  digitalWrite(A2, bit2);
  digitalWrite(A3, bit3);
  
  values[count] = digitalRead(13);
  
  if(values[count] != prevValues[count]){
    changed = true; 
  }
  }
delay(5);  
}


//
//// UTILITY FUNCTIONS
//

//Not used now, but good for debugging...
void blinkLED(){
  digitalWrite(13, HIGH); // set the LED on
  delay(250);              // wait for a second
  digitalWrite(13, LOW); 
}

//For a given controller pin, runs the read-head all the way back to 0
void reset(byte pin)
{
  digitalWrite(pin+1,HIGH); // Go in reverse
  for (byte s=0;s<MAX_POSITION[pin];s+=2){ //Half max because we're stepping directly (no toggle)
    digitalWrite(pin,HIGH);
    digitalWrite(pin,LOW);
    delay(5);
  }
  currentPosition[pin] = 0; // We're reset.
  digitalWrite(pin+1,LOW);
  currentPosition[pin+1] = 0; // Ready to go forward.
}

//Resets all the pins
void resetAll(){

  // Old one-at-a-time reset
  //for (byte p=FIRST_PIN;p<=PIN_MAX;p+=2){
  //  reset(p);
  //}

  //Stop all notes (don't want to be playing during/after reset)
  for (byte p=FIRST_PIN;p<=PIN_MAX;p+=2){
    currentPeriod[p] = 0; // Stop playing notes
  }

  // New all-at-once reset
  for (byte s=0;s<80;s++){ // For max drive's position
    for (byte p=FIRST_PIN;p<=PIN_MAX;p+=2){
      digitalWrite(p+1,HIGH); // Go in reverse
      digitalWrite(p,HIGH);
      digitalWrite(p,LOW);
    }
    delay(5);
  }

  for (byte p=FIRST_PIN;p<=PIN_MAX;p+=2){
    currentPosition[p] = 0; // We're reset.
    digitalWrite(p+1,LOW);
    currentState[p+1] = 0; // Ready to go forward.
  }

}
