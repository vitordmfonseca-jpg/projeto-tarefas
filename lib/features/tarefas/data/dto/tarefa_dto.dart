import 'package:tarefas_calendario/features/tarefas/domain/entities/tarefa_entity.dart';

class TarefaDto {
  final int? id;
  final String titulo;
  final String? descricao;
  final String data;
  final int horasGastas;
  final int minutosGastos;

  const TarefaDto({
    this.id,
    required this.titulo,
    this.descricao,
    required this.data,
    required this.horasGastas,
    required this.minutosGastos,
  });

  factory TarefaDto.fromMap(Map<String, dynamic> map) {
    return TarefaDto(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      data: map['data'],
      horasGastas: map['horas_gastas'],
      minutosGastos: map['minutos_gastos'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
      'horas_gastas': horasGastas,
      'minutos_gastos': minutosGastos,
    };
  }

  TarefaEntity toEntity() {
    final partes = data.split('-');
    return TarefaEntity(
      id: id,
      titulo: titulo,
      descricao: descricao,
      data: DateTime(
        int.parse(partes[0]),
        int.parse(partes[1]),
        int.parse(partes[2]),
      ),
      horasGastas: horasGastas,
      minutosGastos: minutosGastos,
    );
  }

  factory TarefaDto.fromEntity(TarefaEntity entity) {
    return TarefaDto(
      id: entity.id,
      titulo: entity.titulo,
      descricao: entity.descricao,
      data:
          '${entity.data.year}-${entity.data.month.toString().padLeft(2, '0')}-${entity.data.day.toString().padLeft(2, '0')}',
      horasGastas: entity.horasGastas,
      minutosGastos: entity.minutosGastos,
    );
  }
}
