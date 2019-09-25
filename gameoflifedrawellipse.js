let w;
let columns;
let rows;
let board;
let next;
let paused;
let emptiness;
var faces;
//var shapes;


//var xebraState;
function preload(){
    faces = loadImage('images/happyface.png');

}

function setup() {
  emptiness = 135;
  paused = false;
  createCanvas( 500, 500);
  w = 27;
 // connectXebra();
  // Adjust frameRate to change speed of generation/tempo of music
  frameRate(1 );

  // Calculate columns and rows
  columns = floor(width / w);
  rows = floor(height / w);

  // Wacky way to make a 2D array is JS
  board = new Array(columns);
  for (let i = 0; i < columns; i++) {
    board[i] = new Array(rows);
  }

  // Going to use multiple 2D arrays and swap them
  next = new Array(columns);
  for (i = 0; i < columns; i++) {
    next[i] = new Array(rows);
  }
  init();
}

function draw() {
  background(emptiness);
  if (!paused) {generate();}
  
  for ( let i = 0; i < columns;i++) {
    for ( let j = 0; j < rows;j++) {
      if ((board[i][j] == 1)) {
        fill(46,230,237);
      }
      else {
      //stroke(emptiness);
      image(faces,(i * w)+w/2, (j * w)+w/2,w);
      //ellipse((i * w)+w/2, (j * w)+w/2, w, w);
     // sendToMax(board);
      }
   }

  }
}



function sendToMax(val) {
  
}



// Fill board randomly
function init() {
  for (let i = 0; i < columns; i++) {
    for (let j = 0; j < rows; j++) {
      // Lining the edges with 0s
      if (i == 0 || j == 0 || i == columns-1 || j == rows-1)          {           board[i][j] = 0;}
      // Filling the rest randomly
      else {board[i][j] = floor(random(2));}
      next[i][j] = 0;
    }
  }
}

// The process of creating the new generation
function generate() {
  // Loop through every spot in our 2D array and check spots neighbors
  for (let x = 1; x < columns - 1; x++) {
    for (let y = 1; y < rows - 1; y++) {
      let newborns = [];
      // Add up all the states in a 3x3 surrounding grid
      let neighbors = 0;
      for (let i = -1; i <= 1; i++) {
        for (let j = -1; j <= 1; j++) {
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
       /* xebraState.sendMessageToChannel("fromp5_born", ['hi',x,y]);*/
      } 
      else next[x][y] = board[x][y];  // Stasis

    }
  }
  // Swap!
  let temp = board;
  board = next;
  next = temp;
 }


function mousePressed() {
  paused= true;
  let i = round((mouseX-(w/2))/w);
  let j = round((mouseY-(w/2))/w);
  if (board[i][j] == 0){
    board[i][j] = 1;
  } else{
     board[i][j]= 0;
    }
}

function keyPressed(){
  if (keyCode === DOWN_ARROW)
  {paused=false;}
  if (keyCode === ENTER) {
  puased = false;
  
  init();
}
}


function connectXebra() {
  var options = {
    hostname : "127.0.0.1", // localhost
    port : 8086,
    supported_objects : Xebra.SUPPORTED_OBJECTS
  };

  xebraState = new Xebra.State(options);

  xebraState.connect();
}