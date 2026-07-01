class TarefaEntity {
  final int? id;
  final String titulo;
  final String? descricao;
  final DateTime data;
  final int horasGastas;
  final int minutosGastos;

  const TarefaEntity({
    this.id,
    required this.titulo,
    this.descricao,
    required this.data,
    this.horasGastas = 0,
    this.minutosGastos = 0,
  });

  TarefaEntity copyWith({
    int? id,
    String? titulo,
    String? descricao,
    DateTime? data,
    int? horasGastas,
    int? minutosGastos,
  }) {
    return TarefaEntity(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      horasGastas: horasGastas ?? this.horasGastas,
      minutosGastos: minutosGastos ?? this.minutosGastos,
    );
  }
}
