import 'package:flutter/material.dart';

class CircularArrowButton extends StatelessWidget {
  /// Se true → freccia verso sinistra (←)
  /// Se false → freccia verso destra (→)
  final bool reversed;

  /// Callback opzionale (NON usata ora = no logica)
  /// TODO(logic): collegare quando aggiungiamo la navigazione
  final VoidCallback? onPressed;

  /// Dimensione del bottone (quadrato)
  final double size;

  const CircularArrowButton({
    super.key,
    this.reversed = false,
    this.onPressed,
    this.size = 56, // ✅ dimensione fissa come da tua richiesta
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed, // ora è null → nessuna logica (perfetto)
      borderRadius: BorderRadius.circular(20), // ✅ clic coerente con bordi

      child: Container(
        width: size,
        height: size,

        // ✅ STEP -> stile definito correttamente
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.5), // rosso 50%
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.primary, width: 2),
        ),

        alignment: Alignment.center,

        child: Icon(
          reversed ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
          color: Colors.white, // ✅ icona bianca → leggibile su rosso
          size: size * 0.45,   // proporzione equilibrata
        ),
      ),
    );
  }
}
