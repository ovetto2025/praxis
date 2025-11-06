import 'package:flutter/material.dart';

class ContentContainerWidget extends StatelessWidget {
  final String title;
  final String description;

  const ContentContainerWidget({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: ColoredBox(
        color: colors.surface,
        child: Padding(
          padding: const EdgeInsets.all(24),

          // ✅ STEP 5: cambiato da mainAxisSize.min → mainAxisSize.max
          //    in modo che lo Spacer possa spingere il footer verso il basso
          child: Column(
            mainAxisSize: MainAxisSize.max, // ← MODIFICATO QUI
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ----- Titolo -----
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.displayLarge,
              ),

              const SizedBox(height: 12),

              // ----- Descrizione -----
              Text(
                description,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),

              // ✅ STEP 5: Inserito Spacer
              // Questo fa “spingere” il footer verso il fondo del pannello
              const Spacer(), // ← AGGIUNTO QUI

              // ✅ STEP 5: Footer placeholder (solo UI, servirà come riferimento)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Footer (UI in arrivo)", // ← sarà sostituito col footer vero
                  style: textTheme.bodyMedium!.copyWith(
                    color: colors.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
