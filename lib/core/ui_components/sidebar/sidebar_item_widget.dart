import 'package:flutter/material.dart';

class SidebarItemWidget extends StatelessWidget {
  final IconData icone;
  final String label;
  final bool selecionado;
  final bool expandida;
  final VoidCallback onTap;

  const SidebarItemWidget({
    super.key,
    required this.icone,
    required this.label,
    required this.selecionado,
    required this.expandida,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final corAtiva = colorScheme.primary;
    final corInativa = colorScheme.onSurface.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selecionado
              ? corAtiva.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisSize: expandida ? MainAxisSize.max : MainAxisSize.min,
                spacing: 8.0,
                children: [
                  Flexible(
                    child: Icon(
                      icone,
                      size: 20,
                      color: selecionado ? corAtiva : corInativa,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: AnimatedOpacity(
                      opacity: expandida ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selecionado
                              ? FontWeight.w600
                              : FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          color: selecionado ? corAtiva : corInativa,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
