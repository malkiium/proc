int totalNeurons = 10; // Initial number of neurons
ArrayList<PVector> neurons; // List to store neuron positions
ArrayList<ArrayList<Integer>> connections; // List of connections (neuron indices)
int lastTime = 0; // To track the last time update
float connectionProbability = 0.01; // Reduced probability of connection between two neurons
float attractionStrength = 5; // Reduced attraction strength
float maxSpeed = 3; // Reduced maximum speed at which neurons can move toward each other
float easingFactor = 0.1; // Easing factor to smooth neuron movement
float minDistance = 40; // Minimum distance between neurons to avoid overlap
int maxConnections = 3; // Maximum number of connections per neuron

void setup() {
  size(800, 600);
  neurons = new ArrayList<PVector>();
  connections = new ArrayList<ArrayList<Integer>>();
  
  // Initially create neurons in random positions
  for (int i = 0; i < totalNeurons; i++) {
    neurons.add(new PVector(random(width), random(height)));
    connections.add(new ArrayList<Integer>());
  }
}

void draw() {
  background(255);
  
  // Update the positions of neurons with attraction and prevent overlap
  for (int i = 0; i < neurons.size(); i++) {
    PVector neuron = neurons.get(i);
    
    // Move neurons toward each other with smoothness, but only if they are connected
    for (int j = 0; j < neurons.size(); j++) {
      if (i != j) {
        PVector otherNeuron = neurons.get(j);
        float distance = dist(neuron.x, neuron.y, otherNeuron.x, otherNeuron.y);
        
        // Only apply attraction if neurons are connected
        if (connections.get(i).contains(j)) {
          // Attraction force if distance is within a reasonable range
          if (distance < 200) {
            PVector direction = PVector.sub(otherNeuron, neuron);
            direction.normalize();
            direction.mult(attractionStrength);
            
            // Apply easing to smooth the movement
            neuron.add(PVector.mult(direction, easingFactor));
          }
        }
        
        // Prevent overlap: if neurons are too close, apply a repulsion force
        if (distance < minDistance) {
          PVector repulsion = PVector.sub(neuron, otherNeuron);
          repulsion.normalize();
          repulsion.mult(minDistance - distance); // Repel based on how close they are
          neuron.add(repulsion);
        }
      }
    }
  }
  
  // Draw connections between neurons
  stroke(0, 150);
  for (int i = 0; i < neurons.size(); i++) {
    PVector neuron1 = neurons.get(i);
    for (int j : connections.get(i)) {
      PVector neuron2 = neurons.get(j);
      line(neuron1.x, neuron1.y, neuron2.x, neuron2.y);
    }
  }
  
  // Draw neurons as circles
  fill(0);
  noStroke();
  for (PVector neuron : neurons) {
    ellipse(neuron.x, neuron.y, 10, 10);
  }
  
  // Check if it's time to add new neurons (every 2 seconds)
  if (millis() - lastTime >= 2000) {
    lastTime = millis();
    addNeurons();
  }
}

void addNeurons() {
  int newNeuronsCount = int(totalNeurons * 0.3); // Add 30% of current neurons
  
  for (int i = 0; i < newNeuronsCount; i++) {
    PVector newNeuron = new PVector(random(width), random(height));
    neurons.add(newNeuron);
    connections.add(new ArrayList<Integer>());
    
    // Connect the new neuron to existing ones with a lower probability and max of 3 connections
    for (int j = 0; j < neurons.size() - 1; j++) {
      if (random(1) < connectionProbability && connections.get(j).size() < maxConnections) {
        // Only add a connection if the current neuron has fewer than 3 connections
        connections.get(neurons.size() - 1).add(j);
        connections.get(j).add(neurons.size() - 1);
        
        // If the newly added neuron has 3 connections, stop trying to connect it further
        if (connections.get(neurons.size() - 1).size() >= maxConnections) {
          break;
        }
      }
    }
  }
  
  totalNeurons = neurons.size(); // Update the total number of neurons
}
