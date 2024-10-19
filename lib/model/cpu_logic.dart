import 'dart:math';

class Computador {
  // Atributos
  String? nickname;
  int maxRetirar;

  // Construtor
  Computador({required this.maxRetirar, this.nickname});

  // Métodos
  int? jogar(int qtdPalitos) {
    int jogadaAleatoria = Random().nextInt(maxRetirar) +
        1; // random entre 1 e o atributo máximo dado na construção

    if (qtdPalitos == 0) {
      return null;
    }

    if (qtdPalitos == 1) {
      return 1;
    }

    // Evita o computador de perder o jogo personalizado e se possível ganhar
    if (qtdPalitos - jogadaAleatoria <= 0 &&
        qtdPalitos > 1 &&
        jogadaAleatoria > 1 &&
        jogadaAleatoria >= qtdPalitos) {
      return jogadaAleatoria - 1;
    }

    // Se não é o caso da condição acima, o computador pode jogar normalmente
    else if (jogadaAleatoria > 0 && jogadaAleatoria <= qtdPalitos) {
      return jogadaAleatoria;
    }
    return jogadaAleatoria;
  }
}
