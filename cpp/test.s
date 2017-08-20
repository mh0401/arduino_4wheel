   1              		.file	"test.c"
   2              		.text
   3              	.Ltext0:
   4              		.globl	test_socket_data
   6              	test_socket_data:
   7              	.LFB0:
   8              		.file 1 "test.c"
   1:test.c        **** #include <stdio.h>
   2:test.c        **** #include <stdlib.h>
   3:test.c        **** #include <string.h>
   4:test.c        **** #include <unistd.h>
   5:test.c        **** #include <errno.h>
   6:test.c        **** #include <termios.h>
   7:test.c        **** #include "mysocket.h"
   8:test.c        **** #include "mylib.h"
   9:test.c        **** 
  10:test.c        **** /*
  11:test.c        **** ***************************************************
  12:test.c        **** *
  13:test.c        **** * DATA TYPES
  14:test.c        **** *
  15:test.c        **** ***************************************************
  16:test.c        **** */
  17:test.c        **** typedef struct run_struct_t {
  18:test.c        ****   mysocket_conn_t *c;
  19:test.c        ****   int done;
  20:test.c        **** } run_t;
  21:test.c        **** 
  22:test.c        **** /*
  23:test.c        **** ***************************************************
  24:test.c        **** *
  25:test.c        **** * GLOBALS
  26:test.c        **** *
  27:test.c        **** ***************************************************
  28:test.c        **** */
  29:test.c        **** 
  30:test.c        **** /*
  31:test.c        **** ***************************************************
  32:test.c        **** *
  33:test.c        **** * TESTING FUNCTIONS
  34:test.c        **** *
  35:test.c        **** ***************************************************
  36:test.c        **** */
  37:test.c        **** 
  38:test.c        **** /*
  39:test.c        ****  * Test sending data to SERVER
  40:test.c        ****  */
  41:test.c        **** void test_socket_data(mysocket_conn_t *c, char *str)
  42:test.c        **** {
   9              		.loc 1 42 0
  10              		.cfi_startproc
  11 0000 55       		pushq	%rbp
  12              		.cfi_def_cfa_offset 16
  13              		.cfi_offset 6, -16
  14 0001 4889E5   		movq	%rsp, %rbp
  15              		.cfi_def_cfa_register 6
  16 0004 4883EC10 		subq	$16, %rsp
  17 0008 48897DF8 		movq	%rdi, -8(%rbp)
  18 000c 488975F0 		movq	%rsi, -16(%rbp)
  43:test.c        ****   memset(c->buf, 0, MYSOCKET_BUFFSIZE);
  19              		.loc 1 43 0
  20 0010 488B45F8 		movq	-8(%rbp), %rax
  21 0014 488B4048 		movq	72(%rax), %rax
  22 0018 BA000800 		movl	$2048, %edx
  22      00
  23 001d BE000000 		movl	$0, %esi
  23      00
  24 0022 4889C7   		movq	%rax, %rdi
  25 0025 E8000000 		call	memset
  25      00
  44:test.c        ****   strcpy((char *) c->buf, str);
  26              		.loc 1 44 0
  27 002a 488B45F8 		movq	-8(%rbp), %rax
  28 002e 488B4048 		movq	72(%rax), %rax
  29 0032 488B55F0 		movq	-16(%rbp), %rdx
  30 0036 4889D6   		movq	%rdx, %rsi
  31 0039 4889C7   		movq	%rax, %rdi
  32 003c E8000000 		call	strcpy
  32      00
  45:test.c        ****   mysocket_send(c);
  33              		.loc 1 45 0
  34 0041 488B45F8 		movq	-8(%rbp), %rax
  35 0045 4889C7   		movq	%rax, %rdi
  36 0048 E8000000 		call	mysocket_send
  36      00
  46:test.c        ****   mysocket_recv(c);
  37              		.loc 1 46 0
  38 004d 488B45F8 		movq	-8(%rbp), %rax
  39 0051 4889C7   		movq	%rax, %rdi
  40 0054 E8000000 		call	mysocket_recv
  40      00
  47:test.c        **** }
  41              		.loc 1 47 0
  42 0059 C9       		leave
  43              		.cfi_def_cfa 7, 8
  44 005a C3       		ret
  45              		.cfi_endproc
  46              	.LFE0:
  48              		.section	.rodata
  49              		.align 8
  50              	.LC0:
  51 0000 47455420 		.string	"GET / HTTP/1.0\nFrom: %s, User-Agent: %s\n\n"
  51      2F204854 
  51      54502F31 
  51      2E300A46 
  51      726F6D3A 
  52              	.LC1:
  53 002a 476F7420 		.string	"Got CMD: %s, DEG: %s\n"
  53      434D443A 
  53      2025732C 
  53      20444547 
  53      3A202573 
  54              		.align 8
  55              	.LC2:
  56 0040 53656E64 		.string	"Sending HTTP MSG: %s, LENGTH: %d\n\n"
  56      696E6720 
  56      48545450 
  56      204D5347 
  56      3A202573 
  57              		.text
  58              		.globl	send_socket_data
  60              	send_socket_data:
  61              	.LFB1:
  48:test.c        **** 
  49:test.c        **** /*
  50:test.c        ****  * Send data thru socket
  51:test.c        ****  */
  52:test.c        **** void send_socket_data(mysocket_conn_t *c, char *strcmd, char *strdeg)
  53:test.c        **** {
  62              		.loc 1 53 0
  63              		.cfi_startproc
  64 005b 55       		pushq	%rbp
  65              		.cfi_def_cfa_offset 16
  66              		.cfi_offset 6, -16
  67 005c 4889E5   		movq	%rsp, %rbp
  68              		.cfi_def_cfa_register 6
  69 005f 4881ECC0 		subq	$192, %rsp
  69      000000
  70 0066 4889BD58 		movq	%rdi, -168(%rbp)
  70      FFFFFF
  71 006d 4889B550 		movq	%rsi, -176(%rbp)
  71      FFFFFF
  72 0074 48899548 		movq	%rdx, -184(%rbp)
  72      FFFFFF
  73              		.loc 1 53 0
  74 007b 64488B04 		movq	%fs:40, %rax
  74      25280000 
  74      00
  75 0084 488945F8 		movq	%rax, -8(%rbp)
  76 0088 31C0     		xorl	%eax, %eax
  54:test.c        ****   char cmd[128] = "";
  77              		.loc 1 54 0
  78 008a 48C78570 		movq	$0, -144(%rbp)
  78      FFFFFF00 
  78      000000
  79 0095 488DB578 		leaq	-136(%rbp), %rsi
  79      FFFFFF
  80 009c B8000000 		movl	$0, %eax
  80      00
  81 00a1 BA0F0000 		movl	$15, %edx
  81      00
  82 00a6 4889F7   		movq	%rsi, %rdi
  83 00a9 4889D1   		movq	%rdx, %rcx
  84 00ac F348AB   		rep stosq
  55:test.c        ****   int s = 0;
  85              		.loc 1 55 0
  86 00af C78568FF 		movl	$0, -152(%rbp)
  86      FFFF0000 
  86      0000
  56:test.c        ****   int l = sprintf(cmd, "GET / HTTP/1.0\nFrom: %s, User-Agent: %s\n\n", 
  87              		.loc 1 56 0
  88 00b9 488B8D48 		movq	-184(%rbp), %rcx
  88      FFFFFF
  89 00c0 488B9550 		movq	-176(%rbp), %rdx
  89      FFFFFF
  90 00c7 488D8570 		leaq	-144(%rbp), %rax
  90      FFFFFF
  91 00ce BE000000 		movl	$.LC0, %esi
  91      00
  92 00d3 4889C7   		movq	%rax, %rdi
  93 00d6 B8000000 		movl	$0, %eax
  93      00
  94 00db E8000000 		call	sprintf
  94      00
  95 00e0 89856CFF 		movl	%eax, -148(%rbp)
  95      FFFF
  57:test.c        ****                   strcmd, strdeg);
  58:test.c        **** 
  59:test.c        ****   printf("Got CMD: %s, DEG: %s\n", strcmd, strdeg);
  96              		.loc 1 59 0
  97 00e6 488B9548 		movq	-184(%rbp), %rdx
  97      FFFFFF
  98 00ed 488B8550 		movq	-176(%rbp), %rax
  98      FFFFFF
  99 00f4 4889C6   		movq	%rax, %rsi
 100 00f7 BF000000 		movl	$.LC1, %edi
 100      00
 101 00fc B8000000 		movl	$0, %eax
 101      00
 102 0101 E8000000 		call	printf
 102      00
  60:test.c        ****   s = mysocket_connect(c);
 103              		.loc 1 60 0
 104 0106 488B8558 		movq	-168(%rbp), %rax
 104      FFFFFF
 105 010d 4889C7   		movq	%rax, %rdi
 106 0110 E8000000 		call	mysocket_connect
 106      00
 107 0115 898568FF 		movl	%eax, -152(%rbp)
 107      FFFF
  61:test.c        ****   if (s == 0) {
 108              		.loc 1 61 0
 109 011b 83BD68FF 		cmpl	$0, -152(%rbp)
 109      FFFF00
 110 0122 7538     		jne	.L3
  62:test.c        ****     printf("Sending HTTP MSG: %s, LENGTH: %d\n\n", cmd, l);
 111              		.loc 1 62 0
 112 0124 8B956CFF 		movl	-148(%rbp), %edx
 112      FFFF
 113 012a 488D8570 		leaq	-144(%rbp), %rax
 113      FFFFFF
 114 0131 4889C6   		movq	%rax, %rsi
 115 0134 BF000000 		movl	$.LC2, %edi
 115      00
 116 0139 B8000000 		movl	$0, %eax
 116      00
 117 013e E8000000 		call	printf
 117      00
  63:test.c        ****     test_socket_data(c, cmd);
 118              		.loc 1 63 0
 119 0143 488D9570 		leaq	-144(%rbp), %rdx
 119      FFFFFF
 120 014a 488B8558 		movq	-168(%rbp), %rax
 120      FFFFFF
 121 0151 4889D6   		movq	%rdx, %rsi
 122 0154 4889C7   		movq	%rax, %rdi
 123 0157 E8000000 		call	test_socket_data
 123      00
 124              	.L3:
  64:test.c        ****     /*mysocket_connect(&client);
  65:test.c        ****       test_socket_data(&client, "GET / HTTP/1.0\nFrom: REV, User-Agent: 0\n\n");
  66:test.c        ****      mysocket_destroy(&client);*/
  67:test.c        ****   }
  68:test.c        ****   mysocket_destroy(c);
 125              		.loc 1 68 0
 126 015c 488B8558 		movq	-168(%rbp), %rax
 126      FFFFFF
 127 0163 4889C7   		movq	%rax, %rdi
 128 0166 E8000000 		call	mysocket_destroy
 128      00
  69:test.c        ****   printf("\n");
 129              		.loc 1 69 0
 130 016b BF0A0000 		movl	$10, %edi
 130      00
 131 0170 E8000000 		call	putchar
 131      00
  70:test.c        **** }
 132              		.loc 1 70 0
 133 0175 488B45F8 		movq	-8(%rbp), %rax
 134 0179 64483304 		xorq	%fs:40, %rax
 134      25280000 
 134      00
 135 0182 7405     		je	.L4
 136 0184 E8000000 		call	__stack_chk_fail
 136      00
 137              	.L4:
 138 0189 C9       		leave
 139              		.cfi_def_cfa 7, 8
 140 018a C3       		ret
 141              		.cfi_endproc
 142              	.LFE1:
 144              		.section	.rodata
 145              	.LC3:
 146 0063 0A2A2A2A 		.string	"\n**** CALIBRATION ****"
 146      2A204341 
 146      4C494252 
 146      4154494F 
 146      4E202A2A 
 147 007a 00000000 		.align 8
 147      0000
 148              	.LC4:
 149 0080 0A546573 		.string	"\nTesting functionality of ITOA"
 149      74696E67 
 149      2066756E 
 149      6374696F 
 149      6E616C69 
 150              	.LC5:
 151 009f 49544F41 		.string	"ITOA neg %s, "
 151      206E6567 
 151      2025732C 
 151      2000
 152              	.LC6:
 153 00ad 706F7320 		.string	"pos %s;\n"
 153      25733B0A 
 153      00
 154              	.LC7:
 155 00b6 0A43616C 		.string	"\nCalibrating %s degree left\n"
 155      69627261 
 155      74696E67 
 155      20257320 
 155      64656772 
 156              	.LC8:
 157 00d3 49544F41 		.string	"ITOA cal neg %s;\n"
 157      2063616C 
 157      206E6567 
 157      2025733B 
 157      0A00
 158              	.LC9:
 159 00e5 46574400 		.string	"FWD"
 160              	.LC10:
 161 00e9 52455600 		.string	"REV"
 162              	.LC11:
 163 00ed 53544F50 		.string	"STOP"
 163      00
 164              	.LC12:
 165 00f2 0A43616C 		.string	"\nCalibrating %s degree right\n"
 165      69627261 
 165      74696E67 
 165      20257320 
 165      64656772 
 166              	.LC13:
 167 0110 49544F41 		.string	"ITOA cal pos %s;\n"
 167      2063616C 
 167      20706F73 
 167      2025733B 
 167      0A00
 168              	.LC14:
 169 0122 0A2A2A2A 		.string	"\n**** END CALIBRATION ****"
 169      2A20454E 
 169      44204341 
 169      4C494252 
 169      4154494F 
 170              		.text
 171              		.globl	calibrate
 173              	calibrate:
 174              	.LFB2:
  71:test.c        **** 
  72:test.c        **** /*
  73:test.c        **** ***************************************************
  74:test.c        **** *
  75:test.c        **** * MAIN SUB-FUNCTIONS
  76:test.c        **** *
  77:test.c        **** ***************************************************
  78:test.c        **** */
  79:test.c        **** 
  80:test.c        **** /*
  81:test.c        ****  * Run calibration for left/right turn
  82:test.c        ****  */
  83:test.c        **** void calibrate(mysocket_conn_t *c)
  84:test.c        **** {
 175              		.loc 1 84 0
 176              		.cfi_startproc
 177 018b 55       		pushq	%rbp
 178              		.cfi_def_cfa_offset 16
 179              		.cfi_offset 6, -16
 180 018c 4889E5   		movq	%rsp, %rbp
 181              		.cfi_def_cfa_register 6
 182 018f 4883EC20 		subq	$32, %rsp
 183 0193 48897DE8 		movq	%rdi, -24(%rbp)
  85:test.c        ****   int i = 0;
 184              		.loc 1 85 0
 185 0197 C745F400 		movl	$0, -12(%rbp)
 185      000000
  86:test.c        ****   char *sdeg = calloc(3, sizeof(char));
 186              		.loc 1 86 0
 187 019e BE010000 		movl	$1, %esi
 187      00
 188 01a3 BF030000 		movl	$3, %edi
 188      00
 189 01a8 E8000000 		call	calloc
 189      00
 190 01ad 488945F8 		movq	%rax, -8(%rbp)
  87:test.c        **** 
  88:test.c        ****   printf("\n**** CALIBRATION ****\n");
 191              		.loc 1 88 0
 192 01b1 BF000000 		movl	$.LC3, %edi
 192      00
 193 01b6 E8000000 		call	puts
 193      00
  89:test.c        ****   for (i = 0; i < 7; i++) {
 194              		.loc 1 89 0
 195 01bb C745F400 		movl	$0, -12(%rbp)
 195      000000
 196 01c2 E96A0100 		jmp	.L6
 196      00
 197              	.L7:
  90:test.c        ****     printf("\nTesting functionality of ITOA\n");
 198              		.loc 1 90 0 discriminator 2
 199 01c7 BF000000 		movl	$.LC4, %edi
 199      00
 200 01cc E8000000 		call	puts
 200      00
  91:test.c        ****     mylib_itoa(i*-1, sdeg);
 201              		.loc 1 91 0 discriminator 2
 202 01d1 8B45F4   		movl	-12(%rbp), %eax
 203 01d4 F7D8     		negl	%eax
 204 01d6 89C2     		movl	%eax, %edx
 205 01d8 488B45F8 		movq	-8(%rbp), %rax
 206 01dc 4889C6   		movq	%rax, %rsi
 207 01df 89D7     		movl	%edx, %edi
 208 01e1 E8000000 		call	mylib_itoa
 208      00
  92:test.c        ****     printf("ITOA neg %s, ", sdeg);
 209              		.loc 1 92 0 discriminator 2
 210 01e6 488B45F8 		movq	-8(%rbp), %rax
 211 01ea 4889C6   		movq	%rax, %rsi
 212 01ed BF000000 		movl	$.LC5, %edi
 212      00
 213 01f2 B8000000 		movl	$0, %eax
 213      00
 214 01f7 E8000000 		call	printf
 214      00
  93:test.c        ****     mylib_itoa(i, sdeg);
 215              		.loc 1 93 0 discriminator 2
 216 01fc 488B55F8 		movq	-8(%rbp), %rdx
 217 0200 8B45F4   		movl	-12(%rbp), %eax
 218 0203 4889D6   		movq	%rdx, %rsi
 219 0206 89C7     		movl	%eax, %edi
 220 0208 E8000000 		call	mylib_itoa
 220      00
  94:test.c        ****     printf("pos %s;\n", sdeg);
 221              		.loc 1 94 0 discriminator 2
 222 020d 488B45F8 		movq	-8(%rbp), %rax
 223 0211 4889C6   		movq	%rax, %rsi
 224 0214 BF000000 		movl	$.LC6, %edi
 224      00
 225 0219 B8000000 		movl	$0, %eax
 225      00
 226 021e E8000000 		call	printf
 226      00
  95:test.c        **** 
  96:test.c        ****     // cal left
  97:test.c        ****     mylib_itoa(i*-15, sdeg);
 227              		.loc 1 97 0 discriminator 2
 228 0223 8B55F4   		movl	-12(%rbp), %edx
 229 0226 89D0     		movl	%edx, %eax
 230 0228 C1E004   		sall	$4, %eax
 231 022b 29D0     		subl	%edx, %eax
 232 022d F7D8     		negl	%eax
 233 022f 488B55F8 		movq	-8(%rbp), %rdx
 234 0233 4889D6   		movq	%rdx, %rsi
 235 0236 89C7     		movl	%eax, %edi
 236 0238 E8000000 		call	mylib_itoa
 236      00
  98:test.c        ****     printf("\nCalibrating %s degree left\n", sdeg);
 237              		.loc 1 98 0 discriminator 2
 238 023d 488B45F8 		movq	-8(%rbp), %rax
 239 0241 4889C6   		movq	%rax, %rsi
 240 0244 BF000000 		movl	$.LC7, %edi
 240      00
 241 0249 B8000000 		movl	$0, %eax
 241      00
 242 024e E8000000 		call	printf
 242      00
  99:test.c        ****     printf("ITOA cal neg %s;\n", sdeg);
 243              		.loc 1 99 0 discriminator 2
 244 0253 488B45F8 		movq	-8(%rbp), %rax
 245 0257 4889C6   		movq	%rax, %rsi
 246 025a BF000000 		movl	$.LC8, %edi
 246      00
 247 025f B8000000 		movl	$0, %eax
 247      00
 248 0264 E8000000 		call	printf
 248      00
 100:test.c        ****     send_socket_data(c, "FWD", sdeg);
 249              		.loc 1 100 0 discriminator 2
 250 0269 488B55F8 		movq	-8(%rbp), %rdx
 251 026d 488B45E8 		movq	-24(%rbp), %rax
 252 0271 BE000000 		movl	$.LC9, %esi
 252      00
 253 0276 4889C7   		movq	%rax, %rdi
 254 0279 E8000000 		call	send_socket_data
 254      00
 101:test.c        ****     send_socket_data(c, "REV", sdeg);
 255              		.loc 1 101 0 discriminator 2
 256 027e 488B55F8 		movq	-8(%rbp), %rdx
 257 0282 488B45E8 		movq	-24(%rbp), %rax
 258 0286 BE000000 		movl	$.LC10, %esi
 258      00
 259 028b 4889C7   		movq	%rax, %rdi
 260 028e E8000000 		call	send_socket_data
 260      00
 102:test.c        ****     send_socket_data(c, "STOP", sdeg);
 261              		.loc 1 102 0 discriminator 2
 262 0293 488B55F8 		movq	-8(%rbp), %rdx
 263 0297 488B45E8 		movq	-24(%rbp), %rax
 264 029b BE000000 		movl	$.LC11, %esi
 264      00
 265 02a0 4889C7   		movq	%rax, %rdi
 266 02a3 E8000000 		call	send_socket_data
 266      00
 103:test.c        **** 
 104:test.c        ****     // cal right
 105:test.c        ****     mylib_itoa(i*15, sdeg);
 267              		.loc 1 105 0 discriminator 2
 268 02a8 8B55F4   		movl	-12(%rbp), %edx
 269 02ab 89D0     		movl	%edx, %eax
 270 02ad C1E004   		sall	$4, %eax
 271 02b0 29D0     		subl	%edx, %eax
 272 02b2 89C2     		movl	%eax, %edx
 273 02b4 488B45F8 		movq	-8(%rbp), %rax
 274 02b8 4889C6   		movq	%rax, %rsi
 275 02bb 89D7     		movl	%edx, %edi
 276 02bd E8000000 		call	mylib_itoa
 276      00
 106:test.c        ****     printf("\nCalibrating %s degree right\n", sdeg);
 277              		.loc 1 106 0 discriminator 2
 278 02c2 488B45F8 		movq	-8(%rbp), %rax
 279 02c6 4889C6   		movq	%rax, %rsi
 280 02c9 BF000000 		movl	$.LC12, %edi
 280      00
 281 02ce B8000000 		movl	$0, %eax
 281      00
 282 02d3 E8000000 		call	printf
 282      00
 107:test.c        ****     printf("ITOA cal pos %s;\n", sdeg);
 283              		.loc 1 107 0 discriminator 2
 284 02d8 488B45F8 		movq	-8(%rbp), %rax
 285 02dc 4889C6   		movq	%rax, %rsi
 286 02df BF000000 		movl	$.LC13, %edi
 286      00
 287 02e4 B8000000 		movl	$0, %eax
 287      00
 288 02e9 E8000000 		call	printf
 288      00
 108:test.c        ****     send_socket_data(c, "FWD", sdeg);
 289              		.loc 1 108 0 discriminator 2
 290 02ee 488B55F8 		movq	-8(%rbp), %rdx
 291 02f2 488B45E8 		movq	-24(%rbp), %rax
 292 02f6 BE000000 		movl	$.LC9, %esi
 292      00
 293 02fb 4889C7   		movq	%rax, %rdi
 294 02fe E8000000 		call	send_socket_data
 294      00
 109:test.c        ****     send_socket_data(c, "REV", sdeg);
 295              		.loc 1 109 0 discriminator 2
 296 0303 488B55F8 		movq	-8(%rbp), %rdx
 297 0307 488B45E8 		movq	-24(%rbp), %rax
 298 030b BE000000 		movl	$.LC10, %esi
 298      00
 299 0310 4889C7   		movq	%rax, %rdi
 300 0313 E8000000 		call	send_socket_data
 300      00
 110:test.c        ****     send_socket_data(c, "STOP", sdeg);
 301              		.loc 1 110 0 discriminator 2
 302 0318 488B55F8 		movq	-8(%rbp), %rdx
 303 031c 488B45E8 		movq	-24(%rbp), %rax
 304 0320 BE000000 		movl	$.LC11, %esi
 304      00
 305 0325 4889C7   		movq	%rax, %rdi
 306 0328 E8000000 		call	send_socket_data
 306      00
  89:test.c        ****     printf("\nTesting functionality of ITOA\n");
 307              		.loc 1 89 0 discriminator 2
 308 032d 8345F401 		addl	$1, -12(%rbp)
 309              	.L6:
  89:test.c        ****     printf("\nTesting functionality of ITOA\n");
 310              		.loc 1 89 0 is_stmt 0 discriminator 1
 311 0331 837DF406 		cmpl	$6, -12(%rbp)
 312 0335 0F8E8CFE 		jle	.L7
 312      FFFF
 111:test.c        ****   }
 112:test.c        ****   printf("\n**** END CALIBRATION ****\n");
 313              		.loc 1 112 0 is_stmt 1
 314 033b BF000000 		movl	$.LC14, %edi
 314      00
 315 0340 E8000000 		call	puts
 315      00
 113:test.c        ****   free(sdeg);
 316              		.loc 1 113 0
 317 0345 488B45F8 		movq	-8(%rbp), %rax
 318 0349 4889C7   		movq	%rax, %rdi
 319 034c E8000000 		call	free
 319      00
 114:test.c        **** }
 320              		.loc 1 114 0
 321 0351 C9       		leave
 322              		.cfi_def_cfa 7, 8
 323 0352 C3       		ret
 324              		.cfi_endproc
 325              	.LFE2:
 327              		.section	.rodata
 328              	.LC15:
 329 013d 0A456E74 		.string	"\nEntered %c\n"
 329      65726564 
 329      2025630A 
 329      00
 330              	.LC16:
 331 014a 343500   		.string	"45"
 332              	.LC17:
 333 014d 3000     		.string	"0"
 334              	.LC18:
 335 014f 2D343500 		.string	"-45"
 336              	.LC19:
 337 0153 3500     		.string	"5"
 338              	.LC20:
 339 0155 53545000 		.string	"STP"
 340              	.LC21:
 341 0159 2D3500   		.string	"-5"
 342              		.text
 343              		.globl	sendcmd
 345              	sendcmd:
 346              	.LFB3:
 115:test.c        **** 
 116:test.c        **** /*
 117:test.c        ****  * Send CMD thru socket
 118:test.c        ****  */
 119:test.c        **** void sendcmd(char cin, run_t *ds)
 120:test.c        **** {
 347              		.loc 1 120 0
 348              		.cfi_startproc
 349 0353 55       		pushq	%rbp
 350              		.cfi_def_cfa_offset 16
 351              		.cfi_offset 6, -16
 352 0354 4889E5   		movq	%rsp, %rbp
 353              		.cfi_def_cfa_register 6
 354 0357 4883EC10 		subq	$16, %rsp
 355 035b 89F8     		movl	%edi, %eax
 356 035d 488975F0 		movq	%rsi, -16(%rbp)
 357 0361 8845FC   		movb	%al, -4(%rbp)
 121:test.c        ****   printf("\nEntered %c\n", cin);
 358              		.loc 1 121 0
 359 0364 0FBE45FC 		movsbl	-4(%rbp), %eax
 360 0368 89C6     		movl	%eax, %esi
 361 036a BF000000 		movl	$.LC15, %edi
 361      00
 362 036f B8000000 		movl	$0, %eax
 362      00
 363 0374 E8000000 		call	printf
 363      00
 122:test.c        ****   switch (cin) {
 364              		.loc 1 122 0
 365 0379 0FBE45FC 		movsbl	-4(%rbp), %eax
 366 037d 83E831   		subl	$49, %eax
 367 0380 83F808   		cmpl	$8, %eax
 368 0383 0F870B01 		ja	.L9
 368      0000
 369 0389 89C0     		movl	%eax, %eax
 370 038b 488B04C5 		movq	.L11(,%rax,8), %rax
 370      00000000 
 371 0393 FFE0     		jmp	*%rax
 372              		.section	.rodata
 373 015c 00000000 		.align 8
 374              		.align 4
 375              	.L11:
 376 0160 00000000 		.quad	.L10
 376      00000000 
 377 0168 00000000 		.quad	.L12
 377      00000000 
 378 0170 00000000 		.quad	.L13
 378      00000000 
 379 0178 00000000 		.quad	.L14
 379      00000000 
 380 0180 00000000 		.quad	.L15
 380      00000000 
 381 0188 00000000 		.quad	.L16
 381      00000000 
 382 0190 00000000 		.quad	.L17
 382      00000000 
 383 0198 00000000 		.quad	.L18
 383      00000000 
 384 01a0 00000000 		.quad	.L19
 384      00000000 
 385              		.text
 386              	.L19:
 123:test.c        ****   case '9': send_socket_data(ds->c, "FWD", "45"); break;
 387              		.loc 1 123 0
 388 0395 488B45F0 		movq	-16(%rbp), %rax
 389 0399 488B00   		movq	(%rax), %rax
 390 039c BA000000 		movl	$.LC16, %edx
 390      00
 391 03a1 BE000000 		movl	$.LC9, %esi
 391      00
 392 03a6 4889C7   		movq	%rax, %rdi
 393 03a9 E8000000 		call	send_socket_data
 393      00
 394 03ae E9EC0000 		jmp	.L20
 394      00
 395              	.L18:
 124:test.c        ****   case '8': send_socket_data(ds->c, "FWD", "0"); break;
 396              		.loc 1 124 0
 397 03b3 488B45F0 		movq	-16(%rbp), %rax
 398 03b7 488B00   		movq	(%rax), %rax
 399 03ba BA000000 		movl	$.LC17, %edx
 399      00
 400 03bf BE000000 		movl	$.LC9, %esi
 400      00
 401 03c4 4889C7   		movq	%rax, %rdi
 402 03c7 E8000000 		call	send_socket_data
 402      00
 403 03cc E9CE0000 		jmp	.L20
 403      00
 404              	.L17:
 125:test.c        ****   case '7': send_socket_data(ds->c, "FWD", "-45"); break;
 405              		.loc 1 125 0
 406 03d1 488B45F0 		movq	-16(%rbp), %rax
 407 03d5 488B00   		movq	(%rax), %rax
 408 03d8 BA000000 		movl	$.LC18, %edx
 408      00
 409 03dd BE000000 		movl	$.LC9, %esi
 409      00
 410 03e2 4889C7   		movq	%rax, %rdi
 411 03e5 E8000000 		call	send_socket_data
 411      00
 412 03ea E9B00000 		jmp	.L20
 412      00
 413              	.L16:
 126:test.c        ****   case '6': send_socket_data(ds->c, "FWD", "5"); break;
 414              		.loc 1 126 0
 415 03ef 488B45F0 		movq	-16(%rbp), %rax
 416 03f3 488B00   		movq	(%rax), %rax
 417 03f6 BA000000 		movl	$.LC19, %edx
 417      00
 418 03fb BE000000 		movl	$.LC9, %esi
 418      00
 419 0400 4889C7   		movq	%rax, %rdi
 420 0403 E8000000 		call	send_socket_data
 420      00
 421 0408 E9920000 		jmp	.L20
 421      00
 422              	.L15:
 127:test.c        ****   case '5': send_socket_data(ds->c, "STP", "0"); break;
 423              		.loc 1 127 0
 424 040d 488B45F0 		movq	-16(%rbp), %rax
 425 0411 488B00   		movq	(%rax), %rax
 426 0414 BA000000 		movl	$.LC17, %edx
 426      00
 427 0419 BE000000 		movl	$.LC20, %esi
 427      00
 428 041e 4889C7   		movq	%rax, %rdi
 429 0421 E8000000 		call	send_socket_data
 429      00
 430 0426 EB77     		jmp	.L20
 431              	.L14:
 128:test.c        ****   case '4': send_socket_data(ds->c, "FWD", "-5"); break;
 432              		.loc 1 128 0
 433 0428 488B45F0 		movq	-16(%rbp), %rax
 434 042c 488B00   		movq	(%rax), %rax
 435 042f BA000000 		movl	$.LC21, %edx
 435      00
 436 0434 BE000000 		movl	$.LC9, %esi
 436      00
 437 0439 4889C7   		movq	%rax, %rdi
 438 043c E8000000 		call	send_socket_data
 438      00
 439 0441 EB5C     		jmp	.L20
 440              	.L13:
 129:test.c        ****   case '3': send_socket_data(ds->c, "REV", "45"); break;
 441              		.loc 1 129 0
 442 0443 488B45F0 		movq	-16(%rbp), %rax
 443 0447 488B00   		movq	(%rax), %rax
 444 044a BA000000 		movl	$.LC16, %edx
 444      00
 445 044f BE000000 		movl	$.LC10, %esi
 445      00
 446 0454 4889C7   		movq	%rax, %rdi
 447 0457 E8000000 		call	send_socket_data
 447      00
 448 045c EB41     		jmp	.L20
 449              	.L12:
 130:test.c        ****   case '2': send_socket_data(ds->c, "REV", "0"); break;
 450              		.loc 1 130 0
 451 045e 488B45F0 		movq	-16(%rbp), %rax
 452 0462 488B00   		movq	(%rax), %rax
 453 0465 BA000000 		movl	$.LC17, %edx
 453      00
 454 046a BE000000 		movl	$.LC10, %esi
 454      00
 455 046f 4889C7   		movq	%rax, %rdi
 456 0472 E8000000 		call	send_socket_data
 456      00
 457 0477 EB26     		jmp	.L20
 458              	.L10:
 131:test.c        ****   case '1': send_socket_data(ds->c, "REV", "-45"); break;
 459              		.loc 1 131 0
 460 0479 488B45F0 		movq	-16(%rbp), %rax
 461 047d 488B00   		movq	(%rax), %rax
 462 0480 BA000000 		movl	$.LC18, %edx
 462      00
 463 0485 BE000000 		movl	$.LC10, %esi
 463      00
 464 048a 4889C7   		movq	%rax, %rdi
 465 048d E8000000 		call	send_socket_data
 465      00
 466 0492 EB0B     		jmp	.L20
 467              	.L9:
 132:test.c        ****   default : ds->done = 1;
 468              		.loc 1 132 0
 469 0494 488B45F0 		movq	-16(%rbp), %rax
 470 0498 C7400801 		movl	$1, 8(%rax)
 470      000000
 471              	.L20:
 133:test.c        ****   }
 134:test.c        ****   send_socket_data(ds->c, "STP", "0");
 472              		.loc 1 134 0
 473 049f 488B45F0 		movq	-16(%rbp), %rax
 474 04a3 488B00   		movq	(%rax), %rax
 475 04a6 BA000000 		movl	$.LC17, %edx
 475      00
 476 04ab BE000000 		movl	$.LC20, %esi
 476      00
 477 04b0 4889C7   		movq	%rax, %rdi
 478 04b3 E8000000 		call	send_socket_data
 478      00
 135:test.c        **** }
 479              		.loc 1 135 0
 480 04b8 C9       		leave
 481              		.cfi_def_cfa 7, 8
 482 04b9 C3       		ret
 483              		.cfi_endproc
 484              	.LFE3:
 486              		.section	.rodata
 487              		.align 8
 488              	.LC22:
 489 01a8 0A0A456E 		.string	"\n\nEnter command..Press any key other than dir to quit.."
 489      74657220 
 489      636F6D6D 
 489      616E642E 
 489      2E507265 
 490              		.text
 491              		.globl	runcmd
 493              	runcmd:
 494              	.LFB4:
 136:test.c        **** 
 137:test.c        **** /*
 138:test.c        ****  * Get and send the actual command to control the robot
 139:test.c        ****  */
 140:test.c        **** void* runcmd(run_t *ds)
 141:test.c        **** {
 495              		.loc 1 141 0
 496              		.cfi_startproc
 497 04ba 55       		pushq	%rbp
 498              		.cfi_def_cfa_offset 16
 499              		.cfi_offset 6, -16
 500 04bb 4889E5   		movq	%rsp, %rbp
 501              		.cfi_def_cfa_register 6
 502 04be 4883EC20 		subq	$32, %rsp
 503 04c2 48897DE8 		movq	%rdi, -24(%rbp)
 142:test.c        ****   char cin = 0;
 504              		.loc 1 142 0
 505 04c6 C645FF00 		movb	$0, -1(%rbp)
 506              	.L22:
 143:test.c        ****   do {
 144:test.c        ****     printf("\n\nEnter command..Press any key other than dir to quit..\n");
 507              		.loc 1 144 0 discriminator 1
 508 04ca BF000000 		movl	$.LC22, %edi
 508      00
 509 04cf E8000000 		call	puts
 509      00
 145:test.c        ****     cin = getchar();
 510              		.loc 1 145 0 discriminator 1
 511 04d4 E8000000 		call	getchar
 511      00
 512 04d9 8845FF   		movb	%al, -1(%rbp)
 146:test.c        ****     sendcmd(cin, ds);
 513              		.loc 1 146 0 discriminator 1
 514 04dc 0FBE45FF 		movsbl	-1(%rbp), %eax
 515 04e0 488B55E8 		movq	-24(%rbp), %rdx
 516 04e4 4889D6   		movq	%rdx, %rsi
 517 04e7 89C7     		movl	%eax, %edi
 518 04e9 E8000000 		call	sendcmd
 518      00
 147:test.c        ****   } while (!ds->done);
 519              		.loc 1 147 0 discriminator 1
 520 04ee 488B45E8 		movq	-24(%rbp), %rax
 521 04f2 8B4008   		movl	8(%rax), %eax
 522 04f5 85C0     		testl	%eax, %eax
 523 04f7 74D1     		je	.L22
 148:test.c        ****   return 0;
 524              		.loc 1 148 0
 525 04f9 B8000000 		movl	$0, %eax
 525      00
 149:test.c        **** }
 526              		.loc 1 149 0
 527 04fe C9       		leave
 528              		.cfi_def_cfa 7, 8
 529 04ff C3       		ret
 530              		.cfi_endproc
 531              	.LFE4:
 533              		.section	.rodata
 534              	.LC23:
 535 01e0 54432047 		.string	"TC GET attr error %s"
 535      45542061 
 535      74747220 
 535      6572726F 
 535      72202573 
 536              	.LC24:
 537 01f5 4943414E 		.string	"ICANON %d\n"
 537      4F4E2025 
 537      640A00
 538              	.LC25:
 539 0200 49202564 		.string	"I %d, O %d, C %d, L %d\n"
 539      2C204F20 
 539      25642C20 
 539      43202564 
 539      2C204C20 
 540              	.LC26:
 541 0218 4943414E 		.string	"ICANON clear L %d\n"
 541      4F4E2063 
 541      6C656172 
 541      204C2025 
 541      640A00
 542              		.text
 543              		.globl	config_term
 545              	config_term:
 546              	.LFB5:
 150:test.c        **** 
 151:test.c        **** /*
 152:test.c        ****  * Configure Terminal to respond to immediate keying
 153:test.c        ****  */
 154:test.c        **** void config_term()
 155:test.c        **** {
 547              		.loc 1 155 0
 548              		.cfi_startproc
 549 0500 55       		pushq	%rbp
 550              		.cfi_def_cfa_offset 16
 551              		.cfi_offset 6, -16
 552 0501 4889E5   		movq	%rsp, %rbp
 553              		.cfi_def_cfa_register 6
 554 0504 4883EC60 		subq	$96, %rsp
 555              		.loc 1 155 0
 556 0508 64488B04 		movq	%fs:40, %rax
 556      25280000 
 556      00
 557 0511 488945F8 		movq	%rax, -8(%rbp)
 558 0515 31C0     		xorl	%eax, %eax
 156:test.c        ****   struct termios terml = {};
 559              		.loc 1 156 0
 560 0517 488D55B0 		leaq	-80(%rbp), %rdx
 561 051b B8000000 		movl	$0, %eax
 561      00
 562 0520 B9070000 		movl	$7, %ecx
 562      00
 563 0525 4889D7   		movq	%rdx, %rdi
 564 0528 F348AB   		rep stosq
 565 052b 4889FA   		movq	%rdi, %rdx
 566 052e 8902     		movl	%eax, (%rdx)
 567 0530 4883C204 		addq	$4, %rdx
 157:test.c        ****   int status = 0;
 568              		.loc 1 157 0
 569 0534 C745AC00 		movl	$0, -84(%rbp)
 569      000000
 158:test.c        **** 
 159:test.c        ****   // get attribute of current terminal
 160:test.c        ****   if (tcgetattr(STDIN_FILENO, &terml) < 0) {
 570              		.loc 1 160 0
 571 053b 488D45B0 		leaq	-80(%rbp), %rax
 572 053f 4889C6   		movq	%rax, %rsi
 573 0542 BF000000 		movl	$0, %edi
 573      00
 574 0547 E8000000 		call	tcgetattr
 574      00
 575 054c 85C0     		testl	%eax, %eax
 576 054e 7922     		jns	.L25
 161:test.c        ****     printf("TC GET attr error %s", strerror(errno));
 577              		.loc 1 161 0
 578 0550 E8000000 		call	__errno_location
 578      00
 579 0555 8B00     		movl	(%rax), %eax
 580 0557 89C7     		movl	%eax, %edi
 581 0559 E8000000 		call	strerror
 581      00
 582 055e 4889C6   		movq	%rax, %rsi
 583 0561 BF000000 		movl	$.LC23, %edi
 583      00
 584 0566 B8000000 		movl	$0, %eax
 584      00
 585 056b E8000000 		call	printf
 585      00
 586 0570 EB7B     		jmp	.L24
 587              	.L25:
 162:test.c        ****   } else {
 163:test.c        ****     printf("ICANON %d\n", ICANON);
 588              		.loc 1 163 0
 589 0572 BE020000 		movl	$2, %esi
 589      00
 590 0577 BF000000 		movl	$.LC24, %edi
 590      00
 591 057c B8000000 		movl	$0, %eax
 591      00
 592 0581 E8000000 		call	printf
 592      00
 164:test.c        ****     printf("I %d, O %d, C %d, L %d\n", 
 593              		.loc 1 164 0
 594 0586 8B75BC   		movl	-68(%rbp), %esi
 595 0589 8B4DB8   		movl	-72(%rbp), %ecx
 596 058c 8B55B4   		movl	-76(%rbp), %edx
 597 058f 8B45B0   		movl	-80(%rbp), %eax
 598 0592 4189F0   		movl	%esi, %r8d
 599 0595 89C6     		movl	%eax, %esi
 600 0597 BF000000 		movl	$.LC25, %edi
 600      00
 601 059c B8000000 		movl	$0, %eax
 601      00
 602 05a1 E8000000 		call	printf
 602      00
 165:test.c        ****            terml.c_iflag, terml.c_oflag, terml.c_cflag, terml.c_lflag);
 166:test.c        **** 
 167:test.c        ****     // clear ICANON if set
 168:test.c        ****     if (terml.c_lflag & ICANON) {
 603              		.loc 1 168 0
 604 05a6 8B45BC   		movl	-68(%rbp), %eax
 605 05a9 83E002   		andl	$2, %eax
 606 05ac 85C0     		testl	%eax, %eax
 607 05ae 743D     		je	.L24
 169:test.c        ****       terml.c_lflag = terml.c_lflag & ~ICANON;
 608              		.loc 1 169 0
 609 05b0 8B45BC   		movl	-68(%rbp), %eax
 610 05b3 83E0FD   		andl	$-3, %eax
 611 05b6 8945BC   		movl	%eax, -68(%rbp)
 170:test.c        ****       printf("ICANON clear L %d\n", terml.c_lflag);
 612              		.loc 1 170 0
 613 05b9 8B45BC   		movl	-68(%rbp), %eax
 614 05bc 89C6     		movl	%eax, %esi
 615 05be BF000000 		movl	$.LC26, %edi
 615      00
 616 05c3 B8000000 		movl	$0, %eax
 616      00
 617 05c8 E8000000 		call	printf
 617      00
 171:test.c        ****       tcsetattr(STDIN_FILENO, TCSANOW, &terml);
 618              		.loc 1 171 0
 619 05cd 488D45B0 		leaq	-80(%rbp), %rax
 620 05d1 4889C2   		movq	%rax, %rdx
 621 05d4 BE000000 		movl	$0, %esi
 621      00
 622 05d9 BF000000 		movl	$0, %edi
 622      00
 623 05de E8000000 		call	tcsetattr
 623      00
 172:test.c        **** 
 173:test.c        ****       // check again per recommendation in TERMIOS
 174:test.c        ****       config_term();
 624              		.loc 1 174 0
 625 05e3 B8000000 		movl	$0, %eax
 625      00
 626 05e8 E8000000 		call	config_term
 626      00
 627              	.L24:
 175:test.c        ****     }
 176:test.c        ****   }
 177:test.c        **** }
 628              		.loc 1 177 0
 629 05ed 488B45F8 		movq	-8(%rbp), %rax
 630 05f1 64483304 		xorq	%fs:40, %rax
 630      25280000 
 630      00
 631 05fa 7405     		je	.L27
 632 05fc E8000000 		call	__stack_chk_fail
 632      00
 633              	.L27:
 634 0601 C9       		leave
 635              		.cfi_def_cfa 7, 8
 636 0602 C3       		ret
 637              		.cfi_endproc
 638              	.LFE5:
 640              		.section	.rodata
 641              	.LC27:
 642 022b 0A2A2A2A 		.string	"\n**** CONFIGURE TERMINAL ****"
 642      2A20434F 
 642      4E464947 
 642      55524520 
 642      5445524D 
 643              	.LC28:
 644 0249 2A2A2A2A 		.string	"**** END CONFIG TERMINAL ****"
 644      20454E44 
 644      20434F4E 
 644      46494720 
 644      5445524D 
 645              	.LC29:
 646 0267 0A2A2A2A 		.string	"\n**** RUN ****"
 646      2A205255 
 646      4E202A2A 
 646      2A2A00
 647              	.LC30:
 648 0276 0A2A2A2A 		.string	"\n**** END RUN ****"
 648      2A20454E 
 648      44205255 
 648      4E202A2A 
 648      2A2A00
 649              		.text
 650              		.globl	run
 652              	run:
 653              	.LFB6:
 178:test.c        **** 
 179:test.c        **** /*
 180:test.c        ****  * Run program to control robot
 181:test.c        ****  */
 182:test.c        **** void run(run_t *ds)
 183:test.c        **** {
 654              		.loc 1 183 0
 655              		.cfi_startproc
 656 0603 55       		pushq	%rbp
 657              		.cfi_def_cfa_offset 16
 658              		.cfi_offset 6, -16
 659 0604 4889E5   		movq	%rsp, %rbp
 660              		.cfi_def_cfa_register 6
 661 0607 4883EC10 		subq	$16, %rsp
 662 060b 48897DF8 		movq	%rdi, -8(%rbp)
 184:test.c        ****   // STDIN will need to be changed to respond 
 185:test.c        ****   // to immediate key input
 186:test.c        ****   printf("\n**** CONFIGURE TERMINAL ****\n");
 663              		.loc 1 186 0
 664 060f BF000000 		movl	$.LC27, %edi
 664      00
 665 0614 E8000000 		call	puts
 665      00
 187:test.c        ****   config_term();
 666              		.loc 1 187 0
 667 0619 B8000000 		movl	$0, %eax
 667      00
 668 061e E8000000 		call	config_term
 668      00
 188:test.c        ****   printf("**** END CONFIG TERMINAL ****\n");
 669              		.loc 1 188 0
 670 0623 BF000000 		movl	$.LC28, %edi
 670      00
 671 0628 E8000000 		call	puts
 671      00
 189:test.c        **** 
 190:test.c        ****   printf("\n**** RUN ****\n");
 672              		.loc 1 190 0
 673 062d BF000000 		movl	$.LC29, %edi
 673      00
 674 0632 E8000000 		call	puts
 674      00
 191:test.c        ****   runcmd(ds);
 675              		.loc 1 191 0
 676 0637 488B45F8 		movq	-8(%rbp), %rax
 677 063b 4889C7   		movq	%rax, %rdi
 678 063e E8000000 		call	runcmd
 678      00
 192:test.c        ****   printf("\n**** END RUN ****\n");
 679              		.loc 1 192 0
 680 0643 BF000000 		movl	$.LC30, %edi
 680      00
 681 0648 E8000000 		call	puts
 681      00
 193:test.c        **** }
 682              		.loc 1 193 0
 683 064d C9       		leave
 684              		.cfi_def_cfa 7, 8
 685 064e C3       		ret
 686              		.cfi_endproc
 687              	.LFE6:
 689              		.section	.rodata
 690              	.LC31:
 691 0289 3139322E 		.string	"192.168.1.102"
 691      3136382E 
 691      312E3130 
 691      3200
 692              	.LC32:
 693 0297 7878782E 		.string	"xxx.xxx.xxx.xxx"
 693      7878782E 
 693      7878782E 
 693      78787800 
 694              		.text
 695              		.globl	main
 697              	main:
 698              	.LFB7:
 194:test.c        **** 
 195:test.c        **** /*
 196:test.c        **** **************************************************
 197:test.c        **** *
 198:test.c        **** * MAIN
 199:test.c        **** *
 200:test.c        **** **************************************************
 201:test.c        **** */
 202:test.c        **** int main(int argc, char *argv[])
 203:test.c        **** {
 699              		.loc 1 203 0
 700              		.cfi_startproc
 701 064f 55       		pushq	%rbp
 702              		.cfi_def_cfa_offset 16
 703              		.cfi_offset 6, -16
 704 0650 4889E5   		movq	%rsp, %rbp
 705              		.cfi_def_cfa_register 6
 706 0653 53       		pushq	%rbx
 707 0654 4881EC88 		subq	$136, %rsp
 707      000000
 708              		.cfi_offset 3, -24
 709 065b 89BD7CFF 		movl	%edi, -132(%rbp)
 709      FFFF
 710 0661 4889B570 		movq	%rsi, -144(%rbp)
 710      FFFFFF
 711              		.loc 1 203 0
 712 0668 64488B04 		movq	%fs:40, %rax
 712      25280000 
 712      00
 713 0671 488945E8 		movq	%rax, -24(%rbp)
 714 0675 31C0     		xorl	%eax, %eax
 204:test.c        ****   mysocket_conn_t client = {};
 715              		.loc 1 204 0
 716 0677 488D7590 		leaq	-112(%rbp), %rsi
 717 067b B8000000 		movl	$0, %eax
 717      00
 718 0680 BA0A0000 		movl	$10, %edx
 718      00
 719 0685 4889F7   		movq	%rsi, %rdi
 720 0688 4889D1   		movq	%rdx, %rcx
 721 068b F348AB   		rep stosq
 205:test.c        **** 
 206:test.c        ****   client.ip_dest = "192.168.1.102";
 722              		.loc 1 206 0
 723 068e 48C74590 		movq	$.LC31, -112(%rbp)
 723      00000000 
 207:test.c        ****   client.ip_src = "xxx.xxx.xxx.xxx";
 724              		.loc 1 207 0
 725 0696 48C74598 		movq	$.LC32, -104(%rbp)
 725      00000000 
 208:test.c        ****   client.port = atoi(argv[1]);
 726              		.loc 1 208 0
 727 069e 488B8570 		movq	-144(%rbp), %rax
 727      FFFFFF
 728 06a5 4883C008 		addq	$8, %rax
 729 06a9 488B00   		movq	(%rax), %rax
 730 06ac 4889C7   		movq	%rax, %rdi
 731 06af E8000000 		call	atoi
 731      00
 732 06b4 8945A0   		movl	%eax, -96(%rbp)
 209:test.c        ****   client.ip_af = AF_INET;
 733              		.loc 1 209 0
 734 06b7 C745A402 		movl	$2, -92(%rbp)
 734      000000
 210:test.c        ****   client.sock_if = NULL;
 735              		.loc 1 210 0
 736 06be 48C745B0 		movq	$0, -80(%rbp)
 736      00000000 
 211:test.c        ****   client.sock_ifi = NULL;
 737              		.loc 1 211 0
 738 06c6 48C745B8 		movq	$0, -72(%rbp)
 738      00000000 
 212:test.c        ****   client.sock_fd = -1;
 739              		.loc 1 212 0
 740 06ce C745A8FF 		movl	$-1, -88(%rbp)
 740      FFFFFF
 213:test.c        ****   client.sock_type = SOCK_STREAM;
 741              		.loc 1 213 0
 742 06d5 C745AC01 		movl	$1, -84(%rbp)
 742      000000
 214:test.c        ****   client.dest = MYSOCKET_SERVER;
 743              		.loc 1 214 0
 744 06dc C745D001 		movl	$1, -48(%rbp)
 744      000000
 215:test.c        **** 
 216:test.c        ****   if (atoi(argv[2])) {
 745              		.loc 1 216 0
 746 06e3 488B8570 		movq	-144(%rbp), %rax
 746      FFFFFF
 747 06ea 4883C010 		addq	$16, %rax
 748 06ee 488B00   		movq	(%rax), %rax
 749 06f1 4889C7   		movq	%rax, %rdi
 750 06f4 E8000000 		call	atoi
 750      00
 751 06f9 85C0     		testl	%eax, %eax
 752 06fb 740C     		je	.L30
 217:test.c        ****     calibrate(&client);
 753              		.loc 1 217 0
 754 06fd 488D4590 		leaq	-112(%rbp), %rax
 755 0701 4889C7   		movq	%rax, %rdi
 756 0704 E8000000 		call	calibrate
 756      00
 757              	.L30:
 218:test.c        ****   }
 219:test.c        ****   if (atoi(argv[3])) {
 758              		.loc 1 219 0
 759 0709 488B8570 		movq	-144(%rbp), %rax
 759      FFFFFF
 760 0710 4883C018 		addq	$24, %rax
 761 0714 488B00   		movq	(%rax), %rax
 762 0717 4889C7   		movq	%rax, %rdi
 763 071a E8000000 		call	atoi
 763      00
 764 071f 85C0     		testl	%eax, %eax
 765 0721 742B     		je	.L31
 766              	.LBB2:
 220:test.c        ****     run_t ds = {};
 767              		.loc 1 220 0
 768 0723 48C74580 		movq	$0, -128(%rbp)
 768      00000000 
 769 072b 48C74588 		movq	$0, -120(%rbp)
 769      00000000 
 221:test.c        ****     ds.c = &client;
 770              		.loc 1 221 0
 771 0733 488D4590 		leaq	-112(%rbp), %rax
 772 0737 48894580 		movq	%rax, -128(%rbp)
 222:test.c        ****     ds.done = 0;
 773              		.loc 1 222 0
 774 073b C7458800 		movl	$0, -120(%rbp)
 774      000000
 223:test.c        ****     run(&ds);
 775              		.loc 1 223 0
 776 0742 488D4580 		leaq	-128(%rbp), %rax
 777 0746 4889C7   		movq	%rax, %rdi
 778 0749 E8000000 		call	run
 778      00
 779              	.L31:
 780              	.LBE2:
 224:test.c        ****   }
 225:test.c        ****   return 0;
 781              		.loc 1 225 0
 782 074e B8000000 		movl	$0, %eax
 782      00
 226:test.c        **** }
 783              		.loc 1 226 0
 784 0753 488B5DE8 		movq	-24(%rbp), %rbx
 785 0757 6448331C 		xorq	%fs:40, %rbx
 785      25280000 
 785      00
 786 0760 7405     		je	.L33
 787 0762 E8000000 		call	__stack_chk_fail
 787      00
 788              	.L33:
 789 0767 4881C488 		addq	$136, %rsp
 789      000000
 790 076e 5B       		popq	%rbx
 791 076f 5D       		popq	%rbp
 792              		.cfi_def_cfa 7, 8
 793 0770 C3       		ret
 794              		.cfi_endproc
 795              	.LFE7:
 797              	.Letext0:
 798              		.file 2 "/usr/include/x86_64-linux-gnu/bits/termios.h"
 799              		.file 3 "/usr/include/x86_64-linux-gnu/bits/sockaddr.h"
 800              		.file 4 "/usr/include/x86_64-linux-gnu/bits/socket.h"
 801              		.file 5 "//home/marcel/Proj/lib/cpp/c/mysocket.h"
 802              		.file 6 "/usr/include/x86_64-linux-gnu/bits/socket_type.h"
