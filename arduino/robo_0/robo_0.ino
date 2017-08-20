#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <SPI.h>
#include <WiFi.h>

#define SHORT_RESP       1
#define MAX_TIMEOUT      5
#define WIFI_PORT        49000
#define WIFI_SSID        "TP-LINK_7CBA"
#define WIFI_PASS        "NUOOfEhBrYkBs2MT4RkSlm"
#define MOTOR_TURN_RES   10 //turn resolution in (ms)
#define MOTOR_A          1
#define MOTOR_B          2
#define MOTOR_BOTH       3
#define MOTOR_FWD        1
#define MOTOR_REV        2
#define MOTOR_STOP       3
#define MOTOR_EN(m)     (m == MOTOR_A) ? 3 : 11
#define MOTOR_DIR(m)    (m == MOTOR_A) ? 12 : 13
#define MOTOR_BRK(m)    (m == MOTOR_A) ? 9 : 8

WiFiServer wserver(WIFI_PORT);

/*
 *====================================================
 * SETUP
 *====================================================
 */

/*
 * Initialize Serial interface. Debug check of WLAN0
 */
void init(int baud) 
{
  int i = 0;
  Serial.begin(baud);
  while (!Serial);
  Serial.println("====== INIT ======");
  Serial.println("INIT: Checking status of WLAN0....");
  Serial.println("INIT: ETH0");
  system("ifconfig eth0 | grep 'inet' > /dev/ttyGS0");
  Serial.println("INIT: WLAN0");
  system("ifconfig wlan0 | grep 'inet' > /dev/ttyGS0");
  Serial.println("INIT: Max Port number");
  system("cat /proc/sys/net/ipv4/ip_local_port_range > /dev/ttyGS0");
  Serial.println("INIT: Done init");
  Serial.println("===================");
}

/*
 * Setup WLAN0 interface for GALILEO if not already setup
 * Store setup result in SOCKET class
 */
void setup_wifi()
{
  int i = 0;
  boolean timedout = false;

  Serial.println("====== SETUP ======");
  
  while (WiFi.status() == WL_NO_SHIELD);
  Serial.println("SETUP_WIFI: Shield available");
  
  while (WiFi.status() != WL_CONNECTED && !timedout) {
    Serial.print("Connecting...");
    Serial.println(i);
    WiFi.begin(WIFI_SSID, WIFI_PASS);
    i++;
    timedout = (i == MAX_TIMEOUT);
    // wait 5 seconds for connection:
    delay(5000);
  }
  if (!timedout) {
    print_wifi();
    wserver.begin();
  }
  Serial.println("SETUP_WIFI: Done");
  Serial.println("==================");
}

/*
 * Setup motor controller
 */
void setup_motor(int motor)
{
  int enPin = MOTOR_EN(motor);
  int dirPin = MOTOR_DIR(motor);
  int brakePin = MOTOR_BRK(motor);

  Serial.println("====== SETUP ======");
  Serial.print("MOTOR: ");
  Serial.println(motor);
  Serial.print("EN: ");
  Serial.println(enPin);
  Serial.print("DIR: ");
  Serial.println(dirPin);
  Serial.print("BRAKE: ");
  Serial.println(brakePin);
  
  // Disable
  pinMode(enPin, OUTPUT);
  digitalWrite(enPin, LOW);
  delay(10);  

  // Direction - STOP motor first
  pinMode(brakePin, OUTPUT);
  digitalWrite(brakePin, HIGH);
  pinMode(dirPin, OUTPUT);
  digitalWrite(dirPin, HIGH);
  delay(1);

  // enable pin
  digitalWrite(enPin, HIGH);
  delay(10);

  Serial.println("");
  Serial.println("TEST FWD");
  control_motor(motor, MOTOR_FWD, 1000);
  Serial.println("TEST STOP");
  control_motor(motor, MOTOR_STOP, 1000);
  Serial.println("TEST REV");
  control_motor(motor, MOTOR_REV, 1000);
  Serial.println("TEST STOP");
  control_motor(motor, MOTOR_STOP, 1000);
  Serial.println("");
  
  // end
  Serial.println("SETUP_MOTOR: Done");
  Serial.println("==================");  
}

/*
 *====================================================
 * SUPPORT
 *====================================================
 */
 
/*
 * Print info related to current WIFI connection
 */
void print_wifi()
{
  Serial.println("");
  Serial.println("WIFI-Connection");
  switch (WiFi.status()) {
    case WL_CONNECTED      : Serial.print("Status: Connected, "); break;
    case WL_NO_SHIELD      : Serial.print("Status: No shield, "); break;
    case WL_IDLE_STATUS    : Serial.print("Status: Idle, "); break;
    case WL_NO_SSID_AVAIL  : Serial.print("Status: No SSID, "); break;
    case WL_SCAN_COMPLETED : Serial.print("Status: Scan completed, "); break;
    case WL_CONNECT_FAILED : Serial.print("Status: Connect failed, "); break;
    case WL_CONNECTION_LOST: Serial.print("Status: Connection lost, "); break;
    default: Serial.print("Status: Disconnected, ");
  }
  Serial.println(WiFi.status());
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());
  Serial.print("IP Addr: ");
  Serial.println(WiFi.localIP());
  Serial.print("Port: ");
  Serial.println(WIFI_PORT);
  Serial.print("Subnet: ");
  Serial.println(WiFi.subnetMask());
  Serial.print("Gateway: ");
  Serial.println(WiFi.gatewayIP());
  Serial.println("");
}

/*
 * Print out client connectivity provided by WIFI-CLIENT
 */
void print_connectivity(WiFiClient *wc)
{
  Serial.print("Client: ");
  Serial.print(*wc);
  Serial.print(", connected: ");
  Serial.print((*wc).connected());
  Serial.print(", available: ");
  Serial.println((*wc).available());
}

/*
 *====================================================
 * ENGINE
 *====================================================
 */
 
/*
 * Control the motors
 */
void control_motor(int motor, int dir, int dly)
{
  int enPin = MOTOR_EN(motor);
  int dirPin = MOTOR_DIR(motor);
  int brakePin = MOTOR_BRK(motor);
  
  // Direction/brake pin first
  switch (dir) {
    case MOTOR_FWD : 
      digitalWrite(dirPin, HIGH); 
      digitalWrite(brakePin, LOW);
      break;
    case MOTOR_REV : 
      digitalWrite(dirPin, LOW);
      digitalWrite(brakePin, LOW);
      break;
    default: 
      digitalWrite(dirPin, HIGH);
      digitalWrite(brakePin, HIGH);
  }
  // settle to steady state
  delay(dly);
}

/*
 * Make robot do something
 */
void command_robot(String *cmd, int *deg)
{
   int mcmd = (*cmd == "FWD") ? MOTOR_FWD : ((*cmd == "REV") ? MOTOR_REV : MOTOR_STOP);
   int motor = (*deg == 0) ? MOTOR_BOTH : ((*deg > 0) ? MOTOR_A : MOTOR_B);
   
   if (motor == MOTOR_BOTH || mcmd == MOTOR_STOP) {
     control_motor(MOTOR_A, mcmd, 1);
     control_motor(MOTOR_B, mcmd, 10);
   } else {
     control_motor(motor, mcmd, abs(*deg)*MOTOR_TURN_RES);
   }
}

/*
 * Parse request by CLIENT
 */
int parse_request(String *req, String *cmdp, int *degp, int *st)
{
  Serial.print("PARSE: ");
  Serial.println(*cmdp);
  
  // Parse direction FWD/REV
  int idx = req->indexOf("From:");
  if (idx > 0) {
    *cmdp = req->substring(idx+6, idx+9);
  } else {
    *st = *st | 1;
  }
  // Check if command is valid
  *st = *st | (2*(*cmdp != "FWD" && *cmdp != "REV" && *cmdp != "STP"));

  // Parse degree for rotation
  idx = req->indexOf("User-Agent:");
  if (idx > 0) {
    *degp = req->substring(idx+12, idx+15).toInt();
  } else {
    *st = *st | 3;
  }
  Serial.print("CMD: ");
  Serial.println(*cmdp);
  Serial.print("DEG: ");
  Serial.println(*degp);
  return *st;
}

/*
 * Construct response to CLIENT based on status
 */
String construct_response(int st)
{
  char buf[5] = "";
  String resp = "";
  
  Serial.print("RESPONSE: status: ");
  Serial.println(st);
  
  // Parse status and send it as part of response
  if (st > 0) {
    sprintf(buf, "%d", st);
    resp = "400 Bad Request ";
    resp.concat(buf);
  } else {
    resp = "200 OK";
  }
  Serial.print("RESPONSE: Parsed...");
  Serial.println(resp);
  
  // Combine with FULL response
#ifdef SHORT_RESP
  resp = "HTTP/1.1 "+resp+"\nConnection: Closed\n";
#else
  resp = "HTTP/1.1 "+resp+"\nContent-Type: text/html\nDate: today\nConnection: Closed\n";
  resp = resp + "<!DOCTYPE HTML>\n<html>\n<body>\n<h1>Hello, World!</h1>\n</body>\n</html>";
#endif
  Serial.print("RESPONSE: Full...");
  Serial.println(resp);
  return resp;
}

/*
 * Respond to REQUEST coming in from CLIENT
 */
int respond(WiFiClient *wc, String *abuf)
{
  String resp;
  String cmd = "";
  int deg = 0;
  int stat = 0;
  
  // Parse
  parse_request(abuf, &cmd, &deg, &stat);
  // Command
  if (stat == 0) command_robot(&cmd, &deg);
  // Respond
  resp = construct_response(stat);
  Serial.println(resp);
  wc->println(resp);
  
  return stat;
}

/*
 *--------------------------------------------------------------
 *
 *--------------------------------------------------------------
 */

void setup() {
  // put your setup code here, to run once:
  init(9600);
  setup_wifi();
  setup_motor(MOTOR_A);
  setup_motor(MOTOR_B);
}

void loop() {
  // put your main code here, to run repeatedly:
  WiFiClient wclient = wserver.available();
  String buf;
  char c;
  boolean currentLineIsBlank = true;
  
  // for debug
  //print_connectivity(&wclient);
  
  while (wclient != 0 && wclient.connected()) {
    if (wclient.available()) {
      c = wclient.read();
      buf = buf + c;
      if (c == '\n' && currentLineIsBlank) {
        Serial.println("====== LOOP ======");
        Serial.println(buf);
        respond(&wclient, &buf);
        break;
      }
      if (c == '\n') {
        // you're starting a new line
        currentLineIsBlank = true;
      } else if (c != '\r') {
        // you've gotten a character on the current line
        currentLineIsBlank = false;
      }
    }
  }
  // give the web browser time to receive the data
  delay(1);
  wclient.stop();
  wclient.flush();  
  if (c == '\n' && currentLineIsBlank) {
    Serial.println("End connection");
    Serial.println("==================");
  }
}
