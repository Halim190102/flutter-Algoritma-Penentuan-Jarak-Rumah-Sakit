import 'dart:math';

List antColony(List<String> cities, List<List<double>> distances) {
  int antCount = 25;
  double rho = 0.5;
  double alpha = 1;
  double beta = 2;
  double Q = 1;
  int maxIterations = 100;

  List<int> bestPath = [];
  double bestDistance = double.infinity;
  List<List<double>> pheromone = List.generate(
    cities.length,
    (_) => List<double>.filled(cities.length, 1.0),
  );

  for (int iteration = 0; iteration < maxIterations; iteration++) {
    List<List<double>> deltaPheromone = List.generate(
      cities.length,
      (_) => List<double>.filled(cities.length, 0.0),
    );

    for (int ant = 0; ant < antCount; ant++) {
      List<int> path = constructPath(cities, distances, alpha, beta, pheromone);
      double distance = calculateDistance(distances, path);

      if (distance < bestDistance) {
        bestDistance = distance;
        bestPath = path;
      }

      double deltaTau = calculateDeltaTau(Q, distance);

      for (int i = 0; i < cities.length - 1; i++) {
        int city1 = path[i];
        int city2 = path[i + 1];
        deltaPheromone[city1][city2] += deltaTau;
        deltaPheromone[city2][city1] += deltaTau;
      }
    }

    for (int i = 0; i < cities.length; i++) {
      for (int j = 0; j < cities.length; j++) {
        pheromone[i][j] = evaporateTau(pheromone[i][j], rho);
        pheromone[i][j] += deltaPheromone[i][j];
      }
    }
  }
  List hasil = [bestPath, bestDistance];

  return hasil;
}

List<int> constructPath(List<String> cities, List<List<double>> distances,
    double alpha, double beta, List<List<double>> pheromone) {
  List<int> path = [0];
  List<bool> visited = List<bool>.filled(cities.length, false);
  visited[0] = true;

  for (int i = 0; i < cities.length - 1; i++) {
    int currentCity = path.last;
    int nextCity = selectNextCity(
        cities, distances, alpha, beta, currentCity, visited, pheromone);
    path.add(nextCity);
    visited[nextCity] = true;
  }

  return path;
}

int selectNextCity(
    List<String> cities,
    List<List<double>> distances,
    double alpha,
    double beta,
    int currentCity,
    List<bool> visited,
    List<List<double>> pheromone) {
  double total = 0.0;

  for (int i = 0; i < cities.length; i++) {
    if (!visited[i]) {
      double probability = calculateProbability(
          cities, distances, alpha, beta, currentCity, i, pheromone);
      total += probability;
    }
  }

  double randomValue = Random().nextDouble();
  double cumulative = 0.0;

  for (int i = 0; i < cities.length; i++) {
    if (!visited[i]) {
      double probability = calculateProbability(
          cities, distances, alpha, beta, currentCity, i, pheromone);
      cumulative += probability / total;

      if (cumulative >= randomValue) {
        return i;
      }
    }
  }

  return -1; // Should never reach here
}

double calculateProbability(
    List<String> cities,
    List<List<double>> distances,
    double alpha,
    double beta,
    int city1,
    int city2,
    List<List<double>> pheromone) {
  double tau = pheromone[city1][city2];
  double eta = 1.0 / distances[city1][city2];

  return (pow(tau, alpha) * pow(eta, beta)) as double;
}

double calculateDeltaTau(double q, double distance) {
  return q / distance;
}

double evaporateTau(double tau, double rho) {
  return (1 - rho) * tau;
}

double calculateDistance(List<List<double>> distances, List<int> path) {
  double distance = 0.0;
  for (int i = 0; i < path.length - 1; i++) {
    int city1 = path[i];
    int city2 = path[i + 1];
    distance += distances[city1][city2];
  }
  return distance;
}
