import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

class TarefaCardWidget extends StatelessWidget {
  final TarefaEntity tarefa;
  final VoidCallback onDeletar;

  const TarefaCardWidget({
    super.key,
    required this.tarefa,
    required this.onDeletar,
  });

  String get _tempoFormatado {
    if (tarefa.horasGastas == 0) return '${tarefa.minutosGastos}m';
    if (tarefa.minutosGastos == 0) return '${tarefa.horasGastas}h';
    return '${tarefa.horasGastas}h ${tarefa.minutosGastos}m';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.primary.withOpacity(0.4)),
              ),
              child: Text(
                _tempoFormatado,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarefa.titulo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (tarefa.descricao != null && tarefa.descricao!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        tarefa.descricao!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: colorScheme.error,
              onPressed: onDeletar,
              tooltip: 'Excluir tarefa',
            ),
          ],
        ),
      ),
    );
  }
}
