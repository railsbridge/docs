var CHUNK = {
  canvasWidth: 800,
  canvasHeight: 600,
  pixelSize: 40,
  KEY_MAPPING: {
    39: "right",
    40: "down",
    37: "left",
    38: "up"
  },
  started: true,
  attrs: {},
  gameHeight: function() {
    return this.attrs.gameHeight || (this.attrs.gameHeight = this.canvasHeight / this.pixelSize);
  },
  gameWidth: function() {
    return this.attrs.gameWidth || (this.attrs.gameWidth = this.canvasWidth / this.pixelSize);
  },
  canvas: function() {
    if (CHUNK.context) { return CHUNK.context; }
    var canvas = document.getElementById("chunk-game");
    CHUNK.context = canvas.getContext("2d");
    return CHUNK.context;
  },
  executeNTimesPerSecond: function(tickCallback, gameSpeed) {
    tickCallback();
    CHUNK.processID = setInterval(function() {
      tickCallback();
    }, 1000 / gameSpeed);
  },
  onArrowKey: function(callback) {
    document.addEventListener('keydown', function(e) {
      if (CHUNK.KEY_MAPPING[e.which]) {
        e.preventDefault();
        callback(CHUNK.KEY_MAPPING[e.which]);
      }
    });
  },
  endGame: function() {
    this.started = false
    clearInterval(CHUNK.processID);
  },
  draw: function(objects) {
    if (this.started) {
     CHUNK.clear();
     CHUNK.drawObjects(objects);
    }
  },
  clear: function() {
    CHUNK.canvas().clearRect(0, 0, CHUNK.canvasWidth, CHUNK.canvasHeight);
  },
  drawObjects: function(objects) {
    var ui = this;
    objects.forEach(function(object) {
      object.pixels.forEach(function(pixel) {
        ui.drawPixel(object.color, pixel);
      });
    });
  },
  drawPixel: function(color, pixel) {
    CHUNK.canvas().fillStyle = color;
    var translatedPixel = CHUNK.translatePixel(pixel);
    CHUNK.context.fillRect(translatedPixel.left, translatedPixel.top, CHUNK.pixelSize, CHUNK.pixelSize);
  },
  translatePixel: function(pixel) {
    return { left: pixel.left * CHUNK.pixelSize,
             top: pixel.top * CHUNK.pixelSize }
  },
  gameBoundaries: function() {
    if (this.attrs.boundaries) { return this.attrs.boundaries; }
    this.attrs.boundaries = [];
    for (var top = -1; top <= CHUNK.gameHeight(); top++) {
      this.attrs.boundaries.push({ top: top, left: -1});
      this.attrs.boundaries.push({ top: top, left: this.gameWidth() + 1});
    }
    for (var left = -1; left <= CHUNK.gameWidth(); left++) {
      this.attrs.boundaries.push({ top: -1, left: left});
      this.attrs.boundaries.push({ top: this.gameHeight() + 1, left: left });
    }
    return this.attrs.boundaries;
  },
  detectCollisionBetween: function(objectA, objectB) {
    return objectA.some(function(pixelA) {
      return objectB.some(function(pixelB) {
        return pixelB.top === pixelA.top && pixelB.left === pixelA.left;
      });
    });
  },
  randomLocation: function() {
    return {
      top: Math.floor(Math.random()*CHUNK.gameHeight()),
      left: Math.floor(Math.random()*CHUNK.gameWidth()),
    }
  },
  flashMessage: function(message) {
    var canvas = document.getElementById("chunk-game");
    var context = canvas.getContext('2d');
    context.font = '20pt Calibri';
    context.fillStyle = 'yellow';
    context.fillText(message, 275, 100);
  }
}
