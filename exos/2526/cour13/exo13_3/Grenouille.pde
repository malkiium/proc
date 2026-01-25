class Grenouille {
    int sauts;
    int mouche;

    Grenouille() {
        sauts = 1;
        mouche = 0;
    }

    void sauter() {
        while (sauts < 11) {
            if (sauts%2 == 0) {
                println(sauts);
                mangerMouche();
            }
            sauts += 1;
        }
    }

    void mangerMouche() {
        mouche += 1;
        print("mouche manger ! ");
        println(mouche);
    }
}