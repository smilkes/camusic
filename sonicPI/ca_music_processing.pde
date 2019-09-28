import oscP5.*;
import netP5.*;

int w;
int columns;
int rows;
int[][] board;
int[][] next;
boolean paused;
int emptiness;
boolean send_message;
int column_counter = 0;
boolean board_sent = false;
int[] save_send_num;
//var faces;
//var shapes;

OscP5 osc;
NetAddress sonic_pi;

////var xebraState;
//function preload(){
//    faces = loadImage('images/happyface.png');

//}

void setup() {
  emptiness = 155;
  paused = false;
  send_message = true;
  osc = new OscP5(this, 12000);
  sonic_pi = new NetAddress("127.0.0.1", 4559);
  //createCanvas( 500, 500);
  size(500, 500);
  w = 25;
 // connectXebra();
  // Adjust frameRate to change speed of generation/tempo of music

  // Calculate columns and rows
  columns = floor(width / w);
  rows = floor(height / w);
  
  board = new int[columns][rows];
  next = new int[columns][rows];

  // create board and next array of the right size and populate with 0s 
  for (int i = 0; i < columns; i++) {
    for(int j = 0; j < rows; j++) {
      board[i][j] = 0;
      next[i][j] = 0;
    }
  }
  init();
  draw_board(board);
}

void draw() {
  
  if (send_message) {
    int num_ones = 0;
    for (int j = 0; j < rows; j++) {
      if (board[column_counter][j] == 1) {
        num_ones += 1;
        fill(255,0,0);
        ellipse((column_counter * w)+w/2, (j * w)+w/2, w, w);
      }
    }
    int[] send_num = new int[num_ones];
    int counter = 0;
    for (int j = 0; j < rows; j++) {
      if (board[column_counter][j] == 1) {
        send_num[counter] = j;
        counter += 1;
      }
    }
    if (column_counter > 0) {
      OscMessage msg1 = new OscMessage("/trigger/notes");
      msg1.add(save_send_num);
      osc.send(msg1, sonic_pi);
      for (int j = 0; j < rows; j++) {
        if (board[column_counter-1][j] == 1) {
          fill(46,230,237);
          ellipse(((column_counter-1) * w)+w/2, (j * w)+w/2, w, w);
        }
      }
    }
    save_send_num = send_num;
    delay(200);
    column_counter += 1;
    if (column_counter == columns) {
      column_counter = 0;
      board_sent = true;
    }
  }
  
  
  if (!paused && board_sent) {
     generate();
   }
   
  if (board_sent) { 
    board_sent = false;
    background(emptiness);
    draw_board(board);
  }
}


void draw_board(int[][] board) {
  for ( int i = 0; i < columns; i++) {
    for ( int j = 0; j < rows; j++) {
      if (board[i][j] == 1) {
        fill(46,230,237);
        ellipse((i * w)+w/2, (j * w)+w/2, w, w);
      }
      else {
        stroke(emptiness);
        //image(faces,(i * w)+w/2, (j * w)+w/2,w);
        fill(5);
        ellipse((i * w)+w/2, (j * w)+w/2, w, w);
      }
   }
  }
}


// Fill board randomly
void init() {
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      // Lining the edges with 0s
      if (i == 0 || j == 0 || i == columns-1 || j == rows-1){
         board[i][j] = 0;
       }
      // Filling the rest randomly
      else {
          board[i][j] = floor(random(2));
      }
      next[i][j] = 0;
    }
  }
}

// The process of creating the new generation
void generate() {
  // Loop through every spot in our 2D array and check spots neighbors
  for (int x = 1; x < columns - 1; x++) {
    for (int y = 1; y < rows - 1; y++) {
      // Add up all the states in a 3x3 surrounding grid
      int neighbors = 0;
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          neighbors += board[x+i][y+j];
        }
      }

      // A little trick to subtract the current cell's state since
      // we added it in the above loop
      neighbors -= board[x][y];
      // Rules of Life
      if      ((board[x][y] == 1) && (neighbors <  2)) next[x][y] = 0;            // Loneliness
      else if ((board[x][y] == 1) && (neighbors >  3)) next[x][y] = 0;            // Overpopulation
      else if ((board[x][y] == 0) && (neighbors == 3)) {                          // Reproduction 
        next[x][y] = 1;
      } 
      else next[x][y] = board[x][y];  // Stasis
    }
  }
  // Swap!
  int[][] temp = board;
  board = next;
  next = temp;
 }


void mousePressed() {
  paused= true;
  int i = round((mouseX-(w/2))/w);
  int j = round((mouseY-(w/2))/w);
  if (board[i][j] == 0){
    board[i][j] = 1;
  } else {
     board[i][j]= 0;
  }
}

void keyPressed(){
  if (keyCode == DOWN){
      paused = false;
  }
  if (key == ENTER || key == RETURN) {
    paused = false;
    init();
  }
}
