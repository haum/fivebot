

// Left Motor  --> M1+
// Right Motor --> M2-


// digital pins

// Serial RX -> pin0
// Serial TX -> pin1
// AVR INT0 --> pin2
// AVR INT1 --> pin3

unsigned char E1=5;      // Motor
unsigned char E2=6;
unsigned char M1=4;
unsigned char M2=7;

unsigned char bumperL_pin=8;  // Bumper
unsigned char bumperC_pin=9;
unsigned char bumperR_pin=10;

unsigned char fallL_pin=11;  // falling preventing
unsigned char fallR_pin=12;

//unsigned char led_pin=13;    // led

// analog pins

unsigned char irL0_pin=0;
unsigned char irC0_pin=1;
unsigned char irR0_pin=2;


#define SPEED 25
#define MAXSPEED 80
#define MINSPEED 0
//volatile unsigned char MAXSPEED=SPEED;
//volatile unsigned char MINSPEED=SPEED:

#define UNKNOWN 0
#define ADVANCE 1
#define BACKOFF 2
#define TURNL   3
#define TURNR	4

int _state=UNKNOWN;

volatile unsigned long _pulses_left;
volatile unsigned long _pulses_right;
volatile unsigned char _speed_left;
volatile unsigned char _speed_right;
volatile int _pulses_delta;
//volatile unsigned long current=0;

void pulses_balance() {
	//if(_pulses_left<10 || _pulses_right<10) return;
        //if(_pulses_left<10) return;
/*
        if(_pulses_left<_pulses_right) {
		if(_speed_left<MAXSPEED) ++_speed_left;  // speed up
		//if(_speed_right>MINSPEED) --_speed_right; // slow down
                //_speed_left=_speed_right+(_pulses_right-_pulses_left);
	} else if(_pulses_left>_pulses_right) {
		//++_speed_right;
		if(_speed_left>MINSPEED) --_speed_left;  // slow down
		//if(_speed_right<MAXSPEED) ++_speed_right; // speed up
                //_speed_left=_speed_right-(_pulses_left-_pulses_right);
	}
 */
         _pulses_delta=_speed_right+_pulses_right-_pulses_left;
         if(_pulses_delta<=MINSPEED) _speed_left=MINSPEED;
         else if(_pulses_delta>=MAXSPEED) _speed_left=MAXSPEED;
         else _speed_left=_pulses_delta;
 
	switch(get_state()) {
		case ADVANCE:
			advance(_speed_left,_speed_right);
			break;
		case BACKOFF:
			back_off(_speed_left,_speed_right);
			break;
		case TURNL:
			turn_left(_speed_left,_speed_right);
			break;
		case TURNR:
			turn_right(_speed_left,_speed_right);
			break;
	}
	return;
}
// interrupt functions
void _pulses_left_balance() {
	++_pulses_left;
	pulses_balance();
	return;
}
void _pulses_right_balance() {
	++_pulses_right;
	pulses_balance();
	return;
}

void pulses_init() {
	_pulses_left=0;
	_pulses_right=0;
}

int get_state() {
	return _state;
}
int set_state(int state) {
	switch(state) {
		case ADVANCE:
			_state=state;
			break;
		case BACKOFF:
			_state=state;
			break;
		case TURNL:
			_state=state;
			break;
		case TURNR:
			_state=state;
			break;
		default:
			_state=UNKNOWN;
	}
	return _state;
}


void init_balance(unsigned char left,unsigned char right) {
	_speed_left=left;
	_speed_right=right;
	
	noInterrupts();
	pulses_init();
	interrupts();
	return;
}
void advance_balance(unsigned char left,unsigned char right) {
	if(get_state()==ADVANCE) return;
	set_state(ADVANCE);
	init_balance(left,right);
	advance(_speed_left,_speed_right);

	return;
}
void back_off_balance(unsigned char left,unsigned char right) {
	if(get_state()==BACKOFF) return;
	set_state(BACKOFF);
	init_balance(left,right);
	back_off(_speed_left,_speed_right);
	
	return;
}
void turn_left_balance(unsigned char left,unsigned char right) {
	if(get_state()==TURNL) return;
	set_state(TURNL);
	init_balance(left,right);
	turn_left(_speed_left,_speed_right);

	return;
}
void turn_right_balance(unsigned char left,unsigned char right) {
	if(get_state()==TURNR) return;
	set_state(TURNR);
	init_balance(left,right);
	turn_right(_speed_left,_speed_right);

        return;
}

void stop() {
	digitalWrite(E1,LOW);
	digitalWrite(E2,LOW);
	delay(500);
}
void advance(unsigned char left,unsigned char right) {
        //Serial.println("advance");
	analogWrite(E1,left);
	digitalWrite(M1,HIGH);
	analogWrite(E2,right);
	digitalWrite(M2,HIGH);
	return;
}

void back_off(unsigned char left,unsigned char right) {
        //Serial.println("back off");
	analogWrite(E1,left);
	digitalWrite(M1,LOW);
	analogWrite(E2,right);
	digitalWrite(M2,LOW);
	return;
}
void turn_left(unsigned char left,unsigned char right) {
        //Serial.println("turn left");
	analogWrite(E1,left);
	digitalWrite(M1,LOW);
	analogWrite(E2,right);
	digitalWrite(M2,HIGH);
	return;
}
void turn_right(unsigned char left,unsigned char right) {
        //Serial.println("turn right");
	analogWrite(E1,left);
	digitalWrite(M1,HIGH);
	analogWrite(E2,right);
	digitalWrite(M2,LOW);
	return;
}

int ultrasonic_distance(unsigned char input,unsigned char output) {
	digitalWrite(output,LOW);
	delayMicroseconds(2);
	digitalWrite(output,HIGH);
	delayMicroseconds(25);
	digitalWrite(output,LOW);
	
	int distance=pulseIn(input,HIGH)/58;
	//Serial.println(distance);
	return distance;
}

int ir_distance(unsigned char ir) {
	int val=analogRead(ir);
	return (6762/(val-9))-4;
}

void debug_motor() {
    Serial.print("S: ");
    Serial.print(get_state(),DEC);
	Serial.print("  L: ");
	Serial.print(_speed_left,DEC);
	Serial.print(", ");
	Serial.print(_pulses_left,DEC);
	Serial.print("  R: ");
	Serial.print(_speed_right,DEC);
	Serial.print(", ");
	Serial.println(_pulses_right,DEC);
	return;
}

void debug_distance(int ul,int irl,int irc,int irr,boolean static_irL,boolean static_irR) {
    Serial.print("U: ");
    Serial.print(ul,DEC);
	Serial.print("  L: ");
	Serial.print(irl,DEC);
	Serial.print("  C: ");
	Serial.print(irc,DEC);
	Serial.print("  R: ");
	Serial.print(irr,DEC);
        Serial.print("  SL: ");
        Serial.print(static_irL,DEC);
        Serial.print("  SR: ");
        Serial.println(static_irR,DEC);
	return;
}

void debug_ir(int irL0,int irL1,int irC0,int irR0,int irR1) {
  Serial.print("irL0: ");
  Serial.print(irL0,DEC);
  Serial.print("  irL1: ");
  Serial.print(irL1,DEC);
  Serial.print("  irC0: ");
  Serial.print(irC0,DEC);
  Serial.print("  irR0: ");
  Serial.print(irR0,DEC);
  Serial.print("  irR1: ");
  Serial.println(irR1,DEC);  
}

// debug
/*
void square_wave_generator(unsigned int slot,unsigned int times) {
  for(int i=0;i<times;++i) {
    digitalWrite(square_wave_pin,HIGH);
    //delay(slot);
    delayMicroseconds(slot);
    digitalWrite(square_wave_pin,LOW);
    //delay(slot);
    delayMicroseconds(slot);
  }
  return;
}
 */

/******************************************************************/

#define urm_TX HIGH
#define urm_RX LOW
#define urm_bufSize 8

//#define urm_baud 115200
#define urm_baud 19200
#define urm_duration 80

unsigned char keyS7=3;
//unsigned int urm_delay=160;
unsigned int urm_delay=1;

unsigned int urm_total=3;

//unsigned char XX[]={'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
unsigned char urm_rcvbuf[8];

unsigned char urm_control=13; //HIGH:SEND, LOW:RECV

unsigned char urm11Addr[]={0x55,0xaa,0xab,0x01,0x55,0x11,0x11};
unsigned char urm11Act[]={0x55,0xaa,0x11,0x00,0x01,0x11};
unsigned char urm11Get[]=   {0x55,0xaa,0x11,0x00,0x02,0x12};

unsigned char urm12Addr[]={0x55,0xaa,0xab,0x01,0x55,0x12,0x12};
unsigned char urm12Act[]={0x55,0xaa,0x12,0x00,0x01,0x12};
unsigned char urm12Get[]=   {0x55,0xaa,0x12,0x00,0x02,0x13};

unsigned char urm13Addr[]={0x55,0xaa,0xab,0x01,0x55,0x13,0x13};
unsigned char urm13Act[]={0x55,0xaa,0x13,0x00,0x01,0x13};
unsigned char urm13Get[]=   {0x55,0xaa,0x13,0x00,0x02,0x14};

unsigned char urm14Addr[]={0x55,0xaa,0xab,0x01,0x55,0x12,0x14};
unsigned char urm14Act[]={0x55,0xaa,0x14,0x00,0x01,0x14};
unsigned char urm14Get[]=   {0x55,0xaa,0x14,0x00,0x02,0x15};
/*
unsigned char urm15Addr[]={0x55,0xaa,0xab,0x01,0x55,0x12,0x15};
unsigned char urm15Act[]={0x55,0xaa,0x15,0x00,0x01,0x15};
unsigned char urm15Get[]=   {0x55,0xaa,0x15,0x00,0x02,0x16};

unsigned char urm16Addr[]={0x55,0xaa,0xab,0x01,0x55,0x12,0x16};
unsigned char urm16Act[]={0x55,0xaa,0x16,0x00,0x01,0x16};
unsigned char urm16Get[]=   {0x55,0xaa,0x16,0x00,0x02,0x17};

unsigned char urm17Addr[]={0x55,0xaa,0xab,0x01,0x55,0x12,0x17};
unsigned char urm17Act[]={0x55,0xaa,0x17,0x00,0x01,0x17};
unsigned char urm17Get[]=   {0x55,0xaa,0x17,0x00,0x02,0x18};

unsigned char urm18Addr[]={0x55,0xaa,0xab,0x01,0x55,0x12,0x18};
unsigned char urm18Act[]={0x55,0xaa,0x18,0x00,0x01,0x18};
unsigned char urm18Get[]=   {0x55,0xaa,0x18,0x00,0x02,0x19};
   
unsigned char XX[]={'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
 */

int urm_setMode(int mode);
unsigned char urm_sendCmd(unsigned char urm[],unsigned char size);
unsigned char urm_recvDat(unsigned char size=sizeof(urm_rcvbuf));
int urm_checksum(unsigned char size=sizeof(urm_rcvbuf));
void urm_showDat(unsigned char size=sizeof(urm_rcvbuf));
void urm_initAddr();
void urm_init();
int urm_action(unsigned char* act0,unsigned char act0_size,unsigned char* act1,unsigned char act1_size);
unsigned int urm_update(unsigned int total);
unsigned int urm_getDis(unsigned char* cmd,unsigned int size);

/*******************************************************/



/*******************************************************/


int urm_setMode(int mode) {		// HIGH:urm_TX, LOW:urm_RX
	digitalWrite(urm_control,mode);
	return mode;
}

unsigned char urm_sendCmd(unsigned char urm[],unsigned char size) {
  //digitalWrite(urm_control,HIGH);
	urm_setMode(urm_TX);
  //delay(10);
  //Serial.write(urm,size);
  for(int i=0;i<size;++i) {
      Serial.print(urm[i]);
  }
  return size;
}
unsigned char urm_recvDat(unsigned char size) {
  for(int i=0;i<sizeof(urm_rcvbuf);++i) {
      urm_rcvbuf[i]=0;
  }
  //digitalWrite(urm_control,LOW);
	urm_setMode(urm_RX);
  //delay(10);
  //for(int i=0,j=0;i<size&&j<1000;++j) {
   for(int i=0,j=0;i<size&&j<5000;++j) {
    unsigned char ibyte=Serial.read();
    if(0<=ibyte && ibyte<0xff) {
        urm_rcvbuf[i++]=ibyte;
     //   ++i;
     //   LCD_Data_Write(XX[ibyte>>4]);
     //   LCD_Data_Write(XX[ibyte%16]);
    }
    //delayMicroseconds(5);
  }
}
int urm_checksum(unsigned char size) {
    unsigned char sum=0;
    if(urm_rcvbuf[0]==0) return -1;
    for(int i=0;i<size-1;++i) {
        sum+=urm_rcvbuf[i];
    }
    if(sum!=urm_rcvbuf[size-1]) return -1;
    else return 0;
}
void urm_showDat(unsigned char size) {
    //LCD_SET_XY(0,0);
    //if(urm_checksum(size)<0) {
    //    LCD_Write_String(0,0,"Checksum Error");
    //    return;
    //}


    //for(int i=0;i<size;++i) {
    //    LCD_Data_Write(XX[urm_rcvbuf[i]>>4]);
    //    LCD_Data_Write(XX[urm_rcvbuf[i]%16]);
    //}

    //digitalWrite(urm_control,HIGH);
	urm_setMode(urm_TX);
    for(int i=0;i<size;++i) {
		Serial.print(urm_rcvbuf[i],HEX);
                Serial.print(" ");
    }
    Serial.println("");
}
void urm_initAddr() {
    unsigned int startTime=millis();
    unsigned int delta=0;
    boolean got_key=false;
    
    while(digitalRead(keyS7)==LOW) {
        got_key=true;
    //    LCD_Write_String(0,0,"Got keyS7:(ms)");
    //    LCD_Write_Number(0,1,delta=millis()-startTime);
        delay(100);
        Serial.println(delta=millis()-startTime,DEC);
    }
    if(got_key==true) {
    //    digitalWrite(urm_control,HIGH);
		urm_setMode(urm_TX);
        Serial.print("Got keyS7:(ms) ");
        Serial.println(delta=millis()-startTime,DEC);
    }
/*
    if(delta>=8000)      urm_sendCmd(urm18Addr,sizeof(urm18Addr));
    else if(delta>=7000) urm_sendCmd(urm17Addr,sizeof(urm17Addr));
    else if(delta>=6000) urm_sendCmd(urm16Addr,sizeof(urm16Addr));
    else if(delta>=5000) urm_sendCmd(urm15Addr,sizeof(urm15Addr));
 */
    if(delta>=4000) urm_sendCmd(urm14Addr,sizeof(urm14Addr));
    else if(delta>=3000) urm_sendCmd(urm13Addr,sizeof(urm13Addr));
    else if(delta>=2000) urm_sendCmd(urm12Addr,sizeof(urm12Addr));
    else if(delta>=1000)  urm_sendCmd(urm11Addr,sizeof(urm11Addr));
    else got_key=false;
    if(got_key) {
        delay(1);
        //delayMicroseconds(200);
        urm_recvDat(7);
        urm_showDat(7);  
    }
}




void urm_init() {
    //LCD_init();  
    //Serial.begin(19200);
    Serial.begin(urm_baud);
    pinMode(urm_control,OUTPUT);
    //digitalWrite(urm_control,HIGH);
	urm_setMode(urm_TX);
    
    //pinMode(keyS7,INPUT);    // addressing in setup()
    //delay(1000);
    //urm_initAddr();   
    
    delay(500);
    //Wire.begin(); 
}




int urm_action(unsigned char* act0,unsigned char act0_size,unsigned char* act1,unsigned char act1_size) {
  //LCD_Command_Write(0x01);
  //LCD_SET_XY(0,LINE=!LINE);

  urm_sendCmd(act0,act0_size);
  delay(urm_duration);
  urm_sendCmd(act1,act1_size);

  //delayMicroseconds(urm_delay);    // 150 - 240 us
  delay(urm_delay);
  
  urm_recvDat(8);
  //LCD_SET_XY(0,0);
  urm_showDat();
  
  if(urm_checksum(urm_bufSize)==0)
      return (urm_rcvbuf[5]<<8)+urm_rcvbuf[6];
  return 0; // not available distance
                             
}

/****************************************************************/








/******************************************************************/


void setup() {
	Serial.begin(38400);
        //Serial.begin(115200);
	//pinMode(led_pin,OUTPUT);;

	// digital pins
        pinMode(bumperL_pin,INPUT);
        pinMode(bumperC_pin,INPUT);
        pinMode(bumperR_pin,INPUT);

        pinMode(fallL_pin,INPUT);
        pinMode(fallR_pin,INPUT);

	pinMode(E1,OUTPUT);
	pinMode(E2,OUTPUT);
	pinMode(M1,OUTPUT);
	pinMode(M2,OUTPUT);

        urm_init();

	// analog pins

	// interrupts
	attachInterrupt(0,_pulses_left_balance,RISING);		// AVR Interrupt 0 --> pin2
	attachInterrupt(1,_pulses_right_balance,RISING);	// AVR Interrupt 1 --> pin3
}

/*
                       dis12
        left    dis11         dis13      Right

 */


void loop() {
	//noInterrupts();
        boolean bumperL=!digitalRead(bumperL_pin);
        boolean bumperC=!digitalRead(bumperC_pin);
        boolean bumperR=!digitalRead(bumperR_pin);
        
        //boolean fallL=digitalRead(fallL_pin);
        //boolean fallR=digitalRead(fallR_pin);
        
	int irL0=ir_distance(irL0_pin);
	int irC0=ir_distance(irC0_pin);
        int irR0=ir_distance(irR0_pin);
         
        int dis11=urm_action(urm11Act,sizeof(urm11Act),urm11Get,sizeof(urm11Get));
        int dis12=urm_action(urm12Act,sizeof(urm12Act),urm12Get,sizeof(urm12Get));
        int dis13=urm_action(urm13Act,sizeof(urm13Act),urm13Get,sizeof(urm13Get));
         
        //delay(100);
        
        
    /*
        if(fallL || fallR) {
          Serial.println("falling sensor");
          back_off_balance(SPEED,SPEED);
          delay(200);
          if(fallL) turn_right_balance(SPEED,SPEED); //back_off(SPEED,SPEED<<1);  // back off and turn right
          else turn_left_balance(SPEED,SPEED);       //back_off(SPEED<<1,SPEED);  // back off and turn left
          //delay(200);
        } else 
        */



        if(bumperL || bumperC || bumperR) {
          Serial.println("bumper sensor");
          back_off_balance(SPEED,SPEED);
          delay(200);
          if(bumperL || bumperC) turn_right_balance(SPEED,SPEED); //back_off(SPEED,SPEED<<1);  // back off and turn right
          else turn_left_balance(SPEED,SPEED);      //back_off(SPEED<<1,SPEED);                // back off and turn left
          //delay(200);
        } 
        
        else if(0<irL0 && irL0<30 || 0<irC0 && irC0<40) {
        //} else if(0<irL0 && irL0<30 || 0<irL1 && irL1<30 || 0<irC0 && irC0<40 || 0<irR0 && irR0<30 || 0<irR1 && irR1<30) {
          Serial.println("ir sensor");
          turn_right_balance(SPEED,SPEED);  
        } else if(0<irR0 && irR0<30) {
          turn_left_balance(SPEED,SPEED);   
        }
         
        else if(0<dis11 && dis11<30 || 0<dis12 && dis12<40 || 0<dis13 && dis13<30) {
          Serial.println("sr sensor");
          turn_right_balance(SPEED,SPEED);               
        }
        
        else { 
        //  digitalWrite(led_pin,HIGH);
          advance_balance(SPEED,SPEED); 
        }
          
	//debug_motor();
        //debug_ir(irL0,irL1,irC0,irR0,irR1);
        //delay(100);

}



