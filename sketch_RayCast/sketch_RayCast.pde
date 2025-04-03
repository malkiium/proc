import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

ArrayList<Line> lineList = new ArrayList<Line>();

RayCaster particule;
ExecutorService executor;

public void setup() {
    size(800, 800);
    fill(255);
    stroke(255);
    for (int i = 0; i < 15; i++) {
        Line ligne = new Line(random(0, width), random(0, height), random(-1000, 1000), random(-1000, 1000), random(150, 400));
        lineList.add(ligne);
    }

    particule = new RayCaster(width / 2, height / 2);
    executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors()); // Create a thread pool
}

public void draw() {
    background(0);
    particule.x = mouseX;
    particule.y = mouseY;
    particule.updateRays();

    // Multithreaded look function
    executor.execute(() -> particule.look(lineList));

    for (Line l : lineList) {
        l.afficher();
    }

}

public void genRandomWall() {
    lineList.clear();
    for (int i = 0; i < 15; i++) {
        Line ligne = new Line(random(0, width), random(0, height), random(-1000, 1000), random(-1000, 1000), random(150, 400));
        lineList.add(ligne);
    }
}

public void keyPressed() {
    if (key == 'r') {
        genRandomWall();
    }
}

public void exit() {
    executor.shutdown(); // Shutdown the thread pool when the sketch exits
    try {
        if (!executor.awaitTermination(800, TimeUnit.MILLISECONDS)) { // Wait for tasks to complete
            executor.shutdownNow(); // Force shutdown if tasks are still running
        }
    } catch (InterruptedException e) {
        executor.shutdownNow();
    }
    super.exit();
}
