#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <termios.h>
#include "mysocket.h"
#include "mylib.h"

/*
***************************************************
*
* DATA TYPES
*
***************************************************
*/
typedef struct run_struct_t {
  mysocket_conn_t *c;
  int done;
} run_t;

/*
***************************************************
*
* GLOBALS
*
***************************************************
*/

/*
***************************************************
*
* TESTING FUNCTIONS
*
***************************************************
*/

/*
 * Test sending data to SERVER
 */
void test_socket_data(mysocket_conn_t *c, char *str)
{
  memset(c->buf, 0, MYSOCKET_BUFFSIZE);
  strcpy((char *) c->buf, str);
  mysocket_send(c);
  mysocket_recv(c);
}

/*
 * Send data thru socket
 */
void send_socket_data(mysocket_conn_t *c, char *strcmd, char *strdeg)
{
  char cmd[128] = "";
  int s = 0;
  int l = sprintf(cmd, "GET / HTTP/1.0\nFrom: %s, User-Agent: %s\n\n", 
                  strcmd, strdeg);

  printf("Got CMD: %s, DEG: %s\n", strcmd, strdeg);
  s = mysocket_connect(c);
  if (s == 0) {
    printf("Sending HTTP MSG: %s, LENGTH: %d\n\n", cmd, l);
    test_socket_data(c, cmd);
    /*mysocket_connect(&client);
      test_socket_data(&client, "GET / HTTP/1.0\nFrom: REV, User-Agent: 0\n\n");
     mysocket_destroy(&client);*/
  }
  mysocket_destroy(c);
  printf("\n");
}

/*
***************************************************
*
* MAIN SUB-FUNCTIONS
*
***************************************************
*/

/*
 * Run calibration for left/right turn
 */
void calibrate(mysocket_conn_t *c)
{
  int i = 0;
  char *sdeg = calloc(3, sizeof(char));

  printf("\n**** CALIBRATION ****\n");
  for (i = 0; i < 7; i++) {
    printf("\nTesting functionality of ITOA\n");
    mylib_itoa(i*-1, sdeg);
    printf("ITOA neg %s, ", sdeg);
    mylib_itoa(i, sdeg);
    printf("pos %s;\n", sdeg);

    // cal left
    mylib_itoa(i*-15, sdeg);
    printf("\nCalibrating %s degree left\n", sdeg);
    printf("ITOA cal neg %s;\n", sdeg);
    send_socket_data(c, "FWD", sdeg);
    send_socket_data(c, "REV", sdeg);
    send_socket_data(c, "STOP", sdeg);

    // cal right
    mylib_itoa(i*15, sdeg);
    printf("\nCalibrating %s degree right\n", sdeg);
    printf("ITOA cal pos %s;\n", sdeg);
    send_socket_data(c, "FWD", sdeg);
    send_socket_data(c, "REV", sdeg);
    send_socket_data(c, "STOP", sdeg);
  }
  printf("\n**** END CALIBRATION ****\n");
  free(sdeg);
}

/*
 * Send CMD thru socket
 */
void sendcmd(char cin, run_t *ds)
{
  printf("\nEntered %c\n", cin);
  switch (cin) {
  case '9': send_socket_data(ds->c, "FWD", "45"); break;
  case '8': send_socket_data(ds->c, "FWD", "0"); break;
  case '7': send_socket_data(ds->c, "FWD", "-45"); break;
  case '6': send_socket_data(ds->c, "FWD", "5"); break;
  case '5': send_socket_data(ds->c, "STP", "0"); break;
  case '4': send_socket_data(ds->c, "FWD", "-5"); break;
  case '3': send_socket_data(ds->c, "REV", "45"); break;
  case '2': send_socket_data(ds->c, "REV", "0"); break;
  case '1': send_socket_data(ds->c, "REV", "-45"); break;
  default : ds->done = 1;
  }
  send_socket_data(ds->c, "STP", "0");
}

/*
 * Get and send the actual command to control the robot
 */
void* runcmd(run_t *ds)
{
  char cin = 0;
  do {
    printf("\n\nEnter command..Press any key other than dir to quit..\n");
    cin = getchar();
    sendcmd(cin, ds);
  } while (!ds->done);
  return 0;
}

/*
 * Configure Terminal to respond to immediate keying
 */
void config_term()
{
  struct termios terml = {};
  int status = 0;

  // get attribute of current terminal
  if (tcgetattr(STDIN_FILENO, &terml) < 0) {
    printf("TC GET attr error %s", strerror(errno));
  } else {
    printf("ICANON %d\n", ICANON);
    printf("I %d, O %d, C %d, L %d\n", 
           terml.c_iflag, terml.c_oflag, terml.c_cflag, terml.c_lflag);

    // clear ICANON if set
    if (terml.c_lflag & ICANON) {
      terml.c_lflag = terml.c_lflag & ~ICANON;
      printf("ICANON clear L %d\n", terml.c_lflag);
      tcsetattr(STDIN_FILENO, TCSANOW, &terml);

      // check again per recommendation in TERMIOS
      config_term();
    }
  }
}

/*
 * Run program to control robot
 */
void run(run_t *ds)
{
  // STDIN will need to be changed to respond 
  // to immediate key input
  printf("\n**** CONFIGURE TERMINAL ****\n");
  config_term();
  printf("**** END CONFIG TERMINAL ****\n");

  printf("\n**** RUN ****\n");
  runcmd(ds);
  printf("\n**** END RUN ****\n");
}

/*
**************************************************
*
* MAIN
*
**************************************************
*/
int main(int argc, char *argv[])
{
  mysocket_conn_t client = {};

  client.ip_dest = "192.168.1.102";
  client.ip_src = "xxx.xxx.xxx.xxx";
  client.port = atoi(argv[1]);
  client.ip_af = AF_INET;
  client.sock_if = NULL;
  client.sock_ifi = NULL;
  client.sock_fd = -1;
  client.sock_type = SOCK_STREAM;
  client.dest = MYSOCKET_SERVER;

  if (atoi(argv[2])) {
    calibrate(&client);
  }
  if (atoi(argv[3])) {
    run_t ds = {};
    ds.c = &client;
    ds.done = 0;
    run(&ds);
  }
  return 0;
}
