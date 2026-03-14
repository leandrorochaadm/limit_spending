# Template: Documentação de Model

## Classe — Herança e serialização

```dart
/// Model para conversão de dados de saque da API.
///
/// Estende [WithdrawEntity] e adiciona lógica de serialização/deserialização.
///
/// A API retorna valores monetários como strings formatadas (ex: "R$ 1.000,00"),
/// este model converte para [double] removendo formatação.
class WithdrawModel extends WithdrawEntity {
```

## Construtor — Herda da Entity

```dart
  /// Cria uma instância de [WithdrawModel].
  const WithdrawModel({
    required super.id,
    required super.amount,
    required super.status,
    required super.createdAt,
    super.processedAt,
  });
```

## Factory fromJson/fromApi — Documente conversões

```dart
  /// Cria um [WithdrawModel] a partir de um Map da API.
  ///
  /// Converte strings formatadas da API para tipos apropriados:
  /// * 'amount': String ("R$ 1.000,00") → double (1000.00)
  /// * 'status': String → [WithdrawStatus] enum
  /// * 'created_at': String (ISO 8601) → [DateTime]
  ///
  /// Exemplo de [map] esperado:
  /// ```json
  /// {
  ///   "id": "123",
  ///   "amount": "R$ 1.000,00",
  ///   "status": "pending",
  ///   "created_at": "2024-01-15T10:30:00Z"
  /// }
  /// ```
  factory WithdrawModel.fromApi({required Map<String, dynamic> map}) {
```

## Métodos auxiliares de conversão

```dart
  /// Converte string formatada "R$ 1.000,00" para double 1000.00.
  ///
  /// Remove símbolos de moeda, pontos de milhar e converte vírgula para ponto.
  static double _parseAmount(String formattedAmount) {
```

## Com @JsonSerializable

```dart
/// Model para dados de paciente da API.
///
/// Usa [JsonSerializable] para gerar código de serialização automaticamente.
/// Arquivo gerado: `patient_model.g.dart`.
@JsonSerializable()
class PatientModel extends PatientEntity {
  /// Cria um [PatientModel] a partir de JSON.
  ///
  /// Gerado automaticamente por `json_serializable`.
  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  /// Converte para JSON.
  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
```

## Checklist

- [ ] Classe documenta herança da Entity e propósito
- [ ] Documenta conversões não triviais (formato API → tipo Dart)
- [ ] Factory `fromJson`/`fromApi` tem exemplo de JSON esperado
- [ ] Métodos auxiliares privados documentados se lógica não óbvia
- [ ] Referencia Entity base com `[]`
