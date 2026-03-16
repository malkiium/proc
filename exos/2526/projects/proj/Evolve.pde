class Evolution {
  Candidate[] bestCandidates;
  float mutationMin;
  float mutationMax;

  Evolution(int bestCount, float minMut, float maxMut) {
    bestCandidates = new Candidate[bestCount];
    mutationMin = minMut;
    mutationMax = maxMut;
  }

  void evolveGeneration(Balle[] balles) {
    ArrayList<Candidate> candidates = new ArrayList<Candidate>();

    for (Balle b : balles) {
      candidates.add(new Candidate(b.vx, b.ax, b.fitness));
    }

    // sort descending by fitness
    for (int i = 0; i < candidates.size() - 1; i++) {
      for (int j = 0; j < candidates.size() - i - 1; j++) {
        if (candidates.get(j).fitness < candidates.get(j + 1).fitness) {
          Candidate temp = candidates.get(j);
          candidates.set(j, candidates.get(j + 1));
          candidates.set(j + 1, temp);
        }
      }
    }

    // store best candidates
    for (int i = 0; i < bestCandidates.length; i++) {
      bestCandidates[i] = candidates.get(i);
    }

    // generate new generation
    for (Balle b : balles) {
      b.reset();

      int choice = int(random(bestCandidates.length));

      // mutate both velocity and acceleration
      float newVx = bestCandidates[choice].vx + random(mutationMin, mutationMax);
      float newAx = bestCandidates[choice].ax + random(mutationMin, mutationMax);

      b.vx = newVx;
      b.ax = newAx;
    }
  }
}
