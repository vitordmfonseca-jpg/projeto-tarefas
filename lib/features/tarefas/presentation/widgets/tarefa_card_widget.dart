import 'package:flutter/material.dart';
import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

class TarefaCardWidget extends StatelessWidget {
  final TarefaEntity tarefa;
  final VoidCallback onDeletar;
  final VoidCallback onEditar;

  const TarefaCardWidget({
    super.key,
    required this.tarefa,
    required this.onDeletar,
    required this.onEditar,
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
      child: InkWell(
        onTap: onEditar,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          leading: SizedBox(
            width: 64,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                _tempoFormatado,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          title: Tooltip(
            message: tarefa.titulo,
            child: Text(
              tarefa.titulo,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          subtitle: tarefa.descricao != null && tarefa.descricao!.isNotEmpty
              ? Text(
                  tarefa.descricao!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                )
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            color: colorScheme.error,
            onPressed: onDeletar,
            tooltip: 'Excluir tarefa',
          ),
        ),
      ),
    );
  }
}
