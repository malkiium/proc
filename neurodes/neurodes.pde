ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Connection> connections = new ArrayList<Connection>();
int lastTime = 0;
float connectionProbability = 0.15;
float clusterProbability = 0.7; // Probability that a new node forms within existing cluster
int maxConnections = 3;
float minDistance = 50;
float colorVariability = 0.1; // How much color varies within a cluster
PVector centerPoint;
float circleRadius = 250; // Radius of the target circle

class Node {
  PVector position;
  PVector velocity;
  color nodeColor;
  int clusterID;
  float size;
  float targetAngle; // Target position on the circle
  
  Node(float x, float y, color c, int cluster) {
    position = new PVector(x, y);
    velocity = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));
    nodeColor = c;
    clusterID = cluster;
    size = random(8, 12);
    targetAngle = random(TWO_PI);
  }
  
  void update() {
    // Apply velocity to position
    position.add(velocity);
    
    // Apply damping
    velocity.mult(0.95);
    
    // Bounce off edges
    if (position.x < 0 || position.x > width) {
      velocity.x *= -0.9;
      position.x = constrain(position.x, 0, width);
    }
    if (position.y < 0 || position.y > height) {
      velocity.y *= -0.9;
      position.y = constrain(position.y, 0, height);
    }
  }
  
  void display() {
    noStroke();
    fill(nodeColor);
    ellipse(position.x, position.y, size, size);
  }
}

class Connection {
  Node from;
  Node to;
  
  Connection(Node from, Node to) {
    this.from = from;
    this.to = to;
  }
  
  void display() {
    stroke(red(from.nodeColor), green(from.nodeColor), blue(from.nodeColor), 100);
    strokeWeight(1);
    line(from.position.x, from.position.y, to.position.x, to.position.y);
  }
}

void setup() {
  size(800, 800);
  background(20);
  centerPoint = new PVector(width/2, height/2);
  
  // Start with a few initial nodes of different colors
  createInitialNodes();
}

void createInitialNodes() {
  // Create 3 separate small clusters with different colors
  createCluster(width * 0.25, height * 0.25, color(50, 250, 50), 0, 3); // Green cluster
  createCluster(width * 0.75, height * 0.25, color(250, 70, 70), 1, 3); // Red cluster
  createCluster(width * 0.5, height * 0.75, color(50, 50, 250), 2, 2); // Blue cluster
}

void createCluster(float x, float y, color c, int clusterID, int size) {
  // Create a small initial cluster
  Node centerNode = new Node(x, y, c, clusterID);
  centerNode.size = 14; // Make center node larger
  nodes.add(centerNode);
  
  // Add a few nodes around it
  for (int i = 0; i < size; i++) {
    float angle = random(TWO_PI);
    float distance = random(40, 80);
    float nx = x + cos(angle) * distance;
    float ny = y + sin(angle) * distance;
    
    // Create a node with slight color variation
    color nodeColor = color(
      constrain(red(c) + random(-25, 25), 0, 255),
      constrain(green(c) + random(-25, 25), 0, 255),
      constrain(blue(c) + random(-25, 25), 0, 255)
    );
    
    Node newNode = new Node(nx, ny, nodeColor, clusterID);
    nodes.add(newNode);
    
    // Connect to center
    connections.add(new Connection(centerNode, newNode));
    
    // Connect some nodes to each other within the cluster
    for (int j = nodes.size() - 2; j >= 0 && j > nodes.size() - 4; j--) {
      if (nodes.get(j).clusterID == clusterID && random(1) < 0.3) {
        connections.add(new Connection(newNode, nodes.get(j)));
      }
    }
  }
}

void draw() {
  background(20);
  
  // Update forces between nodes
  updateForces();
  
  // Update node positions
  for (Node node : nodes) {
    node.update();
  }
  
  // Draw connections
  for (Connection conn : connections) {
    conn.display();
  }
  
  // Draw nodes
  for (Node node : nodes) {
    node.display();
  }
  
  // Add new nodes periodically
  if (millis() - lastTime >= 1500) {
    lastTime = millis();
    addNewNodes();
  }
  
  // Visualize target circle (for debugging) - comment this out when not needed
  // stroke(50, 50, 50, 100);
  // noFill();
  // ellipse(centerPoint.x, centerPoint.y, circleRadius * 2, circleRadius * 2);
}

void updateForces() {
  // Assign target angles for clusters if not already assigned
  boolean needToAssignAngles = true;
  for (Node node : nodes) {
    if (node.targetAngle != 0) {
      needToAssignAngles = false;
      break;
    }
  }
  
  if (needToAssignAngles) {
    assignClusterTargetPositions();
  }
  
  for (int i = 0; i < nodes.size(); i++) {
    Node nodeA = nodes.get(i);
    PVector totalForce = new PVector(0, 0);
    
    // Calculate target position on the circle for this node
    // Nodes of the same cluster should be positioned near each other
    float clusterAngleRange = PI/4; // Range of the cluster on the circle
    float nodeAngleOffset = random(-clusterAngleRange/2, clusterAngleRange/2);
    float angle = nodeA.targetAngle + nodeAngleOffset * 0.1; // Small variation within cluster
    
    // Calculate target position
    PVector targetPos = new PVector(
      centerPoint.x + cos(angle) * circleRadius,
      centerPoint.y + sin(angle) * circleRadius
    );
    
    // Add force toward the target position on the circle
    PVector circleForce = PVector.sub(targetPos, nodeA.position);
    float distToTarget = circleForce.mag();
    
    // Apply stronger force when further from target
    float circleForceStrength = 0.03 * constrain(distToTarget / 100, 0.5, 2.0);
    circleForce.normalize().mult(circleForceStrength);
    totalForce.add(circleForce);
    
    // Process other forces between nodes
    for (int j = 0; j < nodes.size(); j++) {
      if (i != j) {
        Node nodeB = nodes.get(j);
        PVector force = PVector.sub(nodeB.position, nodeA.position);
        float distance = force.mag();
        
        // Skip if nodes are in exactly the same position
        if (distance == 0) continue;
        
        boolean connected = false;
        
        // Check if nodes are connected
        for (Connection conn : connections) {
          if ((conn.from == nodeA && conn.to == nodeB) || 
              (conn.from == nodeB && conn.to == nodeA)) {
            connected = true;
            break;
          }
        }
        
        if (connected) {
          // Connected nodes attract each other (but not too strongly)
          float idealDistance = 60; // Reduced for tighter clusters
          force.normalize();
          
          if (distance > idealDistance) {
            // Attraction
            force.mult(0.03 * (distance - idealDistance));
            totalForce.add(force);
          } else if (distance < idealDistance * 0.7) {
            // Repulsion when too close
            force.mult(-0.05 * (idealDistance * 0.7 - distance));
            totalForce.add(force);
          }
        } else {
          // All nodes repel each other when too close
          if (distance < minDistance) {
            force.normalize();
            force.mult(-0.3 * (minDistance - distance) / minDistance);
            totalForce.add(force);
          }
          
          // Nodes in the same cluster have a weak attraction
          if (nodeA.clusterID == nodeB.clusterID && distance < 150) {
            force.normalize();
            force.mult(0.01);
            totalForce.add(force);
          }
          
          // Nodes in different clusters have a stronger repulsion
          if (nodeA.clusterID != nodeB.clusterID && distance < 100) {
            force.normalize();
            force.mult(-0.05);
            totalForce.add(force);
          }
        }
      }
    }
    
    // Also add a gentle force toward the center of the screen
    PVector centerForce = PVector.sub(centerPoint, nodeA.position);
    float distToCenter = centerForce.mag();
    
    // Only apply if node is far from center
    if (distToCenter > 300) {
      centerForce.normalize().mult(0.01 * (distToCenter - 300) / 100);
      totalForce.add(centerForce);
    }
    
    // Apply the total force
    nodeA.velocity.add(totalForce);
    
    // Add a tiny bit of randomness to prevent perfect equilibrium
    nodeA.velocity.add(new PVector(random(-0.05, 0.05), random(-0.05, 0.05)));
    
    // Limit velocity
    nodeA.velocity.limit(1.5);
  }
}

void assignClusterTargetPositions() {
  // Get all unique cluster IDs
  ArrayList<Integer> clusterIDs = new ArrayList<Integer>();
  for (Node node : nodes) {
    if (!clusterIDs.contains(node.clusterID)) {
      clusterIDs.add(node.clusterID);
    }
  }
  
  // Assign target angles to each cluster
  float angleStep = TWO_PI / clusterIDs.size();
  for (int i = 0; i < clusterIDs.size(); i++) {
    int id = clusterIDs.get(i);
    float clusterAngle = i * angleStep;
    
    // Assign this angle to all nodes in this cluster
    for (Node node : nodes) {
      if (node.clusterID == id) {
        // Add slight variation for each node
        node.targetAngle = clusterAngle + random(-0.1, 0.1);
      }
    }
  }
}

void addNewNodes() {
  int numToAdd = int(random(1, 4)); // Add 1-3 nodes at a time
  
  for (int n = 0; n < numToAdd; n++) {
    if (random(1) < clusterProbability && nodes.size() > 0) {
      // Add to an existing cluster
      addNodeToCluster();
    } else {
      // Start a new cluster
      createNewCluster();
    }
  }
  
  // Reassign target positions when clusters change
  assignClusterTargetPositions();
}

void addNodeToCluster() {
  // Pick a random existing node to branch from
  Node parent = nodes.get(int(random(nodes.size())));
  
  // Create a new node near the parent
  float angle = random(TWO_PI);
  float distance = random(40, 100);
  float newX = parent.position.x + cos(angle) * distance;
  float newY = parent.position.y + sin(angle) * distance;
  
  // Keep within bounds
  newX = constrain(newX, 50, width - 50);
  newY = constrain(newY, 50, height - 50);
  
  // Create a node with slight color variation from parent
  color nodeColor = color(
    constrain(red(parent.nodeColor) + random(-25, 25), 0, 255),
    constrain(green(parent.nodeColor) + random(-25, 25), 0, 255),
    constrain(blue(parent.nodeColor) + random(-25, 25), 0, 255)
  );
  
  Node newNode = new Node(newX, newY, nodeColor, parent.clusterID);
  newNode.targetAngle = parent.targetAngle + random(-0.05, 0.05); // Similar angle as parent
  nodes.add(newNode);
  
  // Connect to parent
  connections.add(new Connection(parent, newNode));
  
  // Maybe connect to some other nearby nodes in the same cluster
  for (Node node : nodes) {
    if (node != parent && node != newNode && node.clusterID == parent.clusterID) {
      float d = dist(newNode.position.x, newNode.position.y, node.position.x, node.position.y);
      // Connect only to nearby nodes with some probability
      if (d < 120 && random(1) < 0.2) {
        connections.add(new Connection(newNode, node));
      }
    }
  }
}

void createNewCluster() {
  // Create a new cluster with a random color
  color clusterColor;
  int clusterID = nodes.size() > 0 ? getMaxClusterID() + 1 : 0;
  
  // Randomly select one of three main colors, with occasional gray clusters
  float colorRandom = random(1);
  if (colorRandom < 0.45) {
    clusterColor = color(50, 250, 50); // Green
  } else if (colorRandom < 0.8) {
    clusterColor = color(250, 70, 70); // Red
  } else if (colorRandom < 0.95) {
    clusterColor = color(50, 50, 250); // Blue
  } else {
    clusterColor = color(200, 200, 200); // Gray
  }
  
  // Find an empty space for the new cluster
  float x, y;
  boolean validPosition = false;
  int attempts = 0;
  
  do {
    x = random(100, width - 100);
    y = random(100, height - 100);
    validPosition = true;
    
    // Check if position is far enough from existing nodes
    for (Node node : nodes) {
      float d = dist(x, y, node.position.x, node.position.y);
      if (d < 150) {
        validPosition = false;
        break;
      }
    }
    
    attempts++;
  } while (!validPosition && attempts < 20);
  
  if (validPosition) {
    // Create 1-3 nodes for the new cluster
    int clusterSize = int(random(1, 4));
    Node centerNode = new Node(x, y, clusterColor, clusterID);
    centerNode.size *= 1.3; // Make the first node a bit larger
    
    // Assign a random target angle for this new cluster
    float newAngle = random(TWO_PI);
    centerNode.targetAngle = newAngle;
    
    nodes.add(centerNode);
    
    // Add a few more nodes to the new cluster
    for (int i = 0; i < clusterSize - 1; i++) {
      float angle = random(TWO_PI);
      float distance = random(30, 70);
      Node newNode = new Node(
        x + cos(angle) * distance,
        y + sin(angle) * distance,
        color(
          constrain(red(clusterColor) + random(-25, 25), 0, 255),
          constrain(green(clusterColor) + random(-25, 25), 0, 255),
          constrain(blue(clusterColor) + random(-25, 25), 0, 255)
        ),
        clusterID
      );
      newNode.targetAngle = newAngle + random(-0.05, 0.05);
      nodes.add(newNode);
      
      // Connect to center
      connections.add(new Connection(centerNode, newNode));
    }
  }
}

int getMaxClusterID() {
  int max = -1;
  for (Node node : nodes) {
    if (node.clusterID > max) {
      max = node.clusterID;
    }
  }
  return max;
}

// Mouse interaction
void mousePressed() {
  color newNodeColor;
  int newClusterID;
  
  // Determine if we should attach to an existing cluster
  Node closestNode = null;
  float minDist = 150; // Maximum distance to consider
  
  for (Node node : nodes) {
    float d = dist(mouseX, mouseY, node.position.x, node.position.y);
    if (d < minDist) {
      minDist = d;
      closestNode = node;
    }
  }
  
  if (closestNode != null) {
    // Add to existing cluster
    newNodeColor = color(
      constrain(red(closestNode.nodeColor) + random(-25, 25), 0, 255),
      constrain(green(closestNode.nodeColor) + random(-25, 25), 0, 255),
      constrain(blue(closestNode.nodeColor) + random(-25, 25), 0, 255)
    );
    newClusterID = closestNode.clusterID;
  } else {
    // Create a new cluster
    float colorRandom = random(1);
    if (colorRandom < 0.45) {
      newNodeColor = color(50, 250, 50); // Green
    } else if (colorRandom < 0.8) {
      newNodeColor = color(250, 70, 70); // Red
    } else if (colorRandom < 0.95) {
      newNodeColor = color(50, 50, 250); // Blue
    } else {
      newNodeColor = color(200, 200, 200); // Gray
    }
    newClusterID = nodes.size() > 0 ? getMaxClusterID() + 1 : 0;
  }
  
  // Create the new node
  Node newNode = new Node(mouseX, mouseY, newNodeColor, newClusterID);
  
  // Assign target angle
  if (closestNode != null) {
    newNode.targetAngle = closestNode.targetAngle + random(-0.05, 0.05);
  } else {
    newNode.targetAngle = random(TWO_PI);
    // Reassign all target angles when a new cluster is created
    assignClusterTargetPositions();
  }
  
  nodes.add(newNode);
  
  // Connect to closest node if applicable
  if (closestNode != null) {
    connections.add(new Connection(closestNode, newNode));
    
    // Maybe connect to other nearby nodes in the same cluster
    for (Node node : nodes) {
      if (node != closestNode && node != newNode && node.clusterID == newClusterID) {
        float d = dist(newNode.position.x, newNode.position.y, node.position.x, node.position.y);
        if (d < 100 && random(1) < 0.2) {
          connections.add(new Connection(newNode, node));
        }
      }
    }
  }
}

// Adjust circle radius with keyboard
void keyPressed() {
  if (key == '+' || key == '=') {
    circleRadius += 25;
  } else if (key == '-' || key == '_') {
    circleRadius = max(50, circleRadius - 25);
  } else if (key == 'r' || key == 'R') {
    // Reassign positions
    assignClusterTargetPositions();
  }
}