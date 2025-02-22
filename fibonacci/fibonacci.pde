int[] fibo;
float zoomFactor = 1.0; // Initial zoom level
float zoomSpeed = 0.01; // Speed of zoom
float spiralCenterX, spiralCenterY; // Center of the spiral
color[] squareColors; // Array to store colors for each square

void setup() {
    size(1597, 987);
    fibo = new int[20];
    initializeFibonacci();
    
    // Calculate the center of the spiral
    calculateSpiralCenter();
    
    // Initialize colors for each square
    initializeSquareColors();
}

void initializeFibonacci() {
    fibo[0] = 0;
    fibo[1] = 1;
    for (int i = 2; i < fibo.length; i++) {
        fibo[i] = fibo[i - 1] + fibo[i - 2];
    }
}

void calculateSpiralCenter() {
    // Simulate drawing the spiral to find its center
    int x = 0;
    int y = 0;
    int dir = 0;
    
    for (int i = 16; i >= 2; i--) {
        if (dir == 0) {
            x += fibo[i];
        } else if (dir == 1) {
            x += fibo[i - 2];
            y += fibo[i];
        } else if (dir == 2) {
            x -= fibo[i - 1];
            y += fibo[i - 2];
        } else {
            y -= fibo[i - 1];
        }
        dir = (dir + 1) % 4;
    }
    
    // The center of the spiral is the final position of (x, y)
    spiralCenterX = x + fibo[2] / 2; // Adjust for the center of the last square
    spiralCenterY = y + fibo[2] / 2;
}

void initializeSquareColors() {
    // Generate a random color for each square in the spiral
    squareColors = new color[16 - 2 + 1]; // Number of squares from i=16 to i=2
    for (int i = 0; i < squareColors.length; i++) {
        squareColors[i] = color(random(128, 255), random(128, 255), random(128, 255));
    }
}

void draw() {
    background(255); // Clear the screen each frame
    dessinerSpirale(16);
}

void dessinerSpirale(int n) {
    int x = 0;
    int y = 0;
    int dir = 0;
    textAlign(CENTER, CENTER);
    
    int colorIndex = 0; // Index to access colors from squareColors array
    
    for (int i = n; i >= 2; i--) {
        // Use the pre-generated color for this square
        fill(squareColors[colorIndex]);
        rect(x, y, fibo[i], fibo[i]);
        
        fill(0);
        if (fibo[i] > 20) {
            text(fibo[i], x + fibo[i] / 2, y + fibo[i] / 2);
        }
        
        ellipseMode(RADIUS);
        noFill();
        
        if (dir == 0) {
            arc(x + fibo[i], y + fibo[i], fibo[i], fibo[i], PI, 3 * PI / 2);
            x += fibo[i];
        } else if (dir == 1) {
            arc(x, y + fibo[i], fibo[i], fibo[i], -PI / 2, 0);
            x += fibo[i - 2];
            y += fibo[i];
        } else if (dir == 2) {
            arc(x, y, fibo[i], fibo[i], 0, PI / 2);
            x -= fibo[i - 1];
            y += fibo[i - 2];
        } else {
            arc(x + fibo[i], y, fibo[i], fibo[i], PI / 2, PI);
            y -= fibo[i - 1];
        }
        
        dir = (dir + 1) % 4;
        colorIndex++; // Move to the next color in the array
    }
}