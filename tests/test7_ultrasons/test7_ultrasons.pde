#define urm_TX HIGH
#define urm_RX LOW
#define urm_bufSize 8

//#define urm_baud 115200
#define urm_baud 19200
#define urm_duration 80


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



void setup() {
	Serial.begin(9600);
}


void loop() {
        int dis11=urm_action(urm11Act,sizeof(urm11Act),urm11Get,sizeof(urm11Get));
        int dis12=urm_action(urm12Act,sizeof(urm12Act),urm12Get,sizeof(urm12Get));
        int dis13=urm_action(urm13Act,sizeof(urm13Act),urm13Get,sizeof(urm13Get));
         
	Serial.println("D : ");
	Serial.print(dis11,DEC);
	Serial.print("C : ");
	Serial.print(dis12,DEC);
	Serial.print("G : ");
	Serial.println(dis13,DEC);
	delay(100);
}

// vim: ft=arduino
