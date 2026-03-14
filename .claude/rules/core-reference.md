---
paths:
  - "lib/core/**"
  - "lib/features/*/data/**"
  - "lib/features/*/presentation/**"
---

# Referencia lib/core - Clyvo Mobile

Mapeamento de todos os modulos disponiveis em `lib/core/`.
Antes de criar algo novo, verifique se ja existe aqui.

---

## UI - Buttons (`lib/core/ui/buttons/`)

- `clyvo_button.dart` - Botao principal do design system Clyvo
- `clyvo_primary_button.dart` - Botao de acao primaria
- `clyvo_action_button.dart` - Botao de acao secundaria
- `clyvo_filter_chip.dart` - Chip de filtro/toggle
- `app_button.dart` - Botao generico (legacy)
- `app_icon_button.dart` - Botao com icone
- `custom_button.dart` - Botao customizavel
- `photo_upload_button.dart` - Botao de upload de foto
- `primary_button.dart` - Botao primario (legacy)
- `modern_button.dart` - Botao moderno

## UI - Feedback (`lib/core/ui/feedback/`)

- `clyvo_snackbar.dart` - Snackbar do design system
- `app_snackbar.dart` - Snackbar (legacy)
- `clyvo_loading_indicator.dart` - Indicador de carregamento animado
- `clyvo_loading_widget.dart` - Widget de loading
- `clyvo_empty_widget.dart` - Estado vazio
- `clyvo_error_widget.dart` - Widget de erro
- `clyvo_icon_message.dart` - Mensagem com icone
- `clyvo_alert_banner.dart` - Banner de alerta
- `clyvo_banner_snackbar.dart` - Snackbar estilo banner
- `clyvo_page_indicators.dart` - Indicadores de paginacao/steps
- `battery_optimization_banner.dart` - Banner de otimizacao de bateria

## UI - Inputs (`lib/core/ui/inputs/`)

- `clyvo_search_field.dart` - Campo de busca
- `custom_text_field.dart` - Campo de texto customizavel
- `app_text_field.dart` - Campo de texto generico
- `app_form_fields.dart` - Wrapper para agrupar campos
- `phone_input_field.dart` - Campo de telefone com formatacao
- `custom_password_field.dart` - Campo de senha com toggle de visibilidade
- `clyvo_checkbox.dart` - Checkbox do design system
- `clyvo_radio.dart` - Radio button do design system
- `terms_checkbox.dart` - Checkbox de termos de uso

## UI - Cards (`lib/core/ui/cards/`)

- `app_card.dart` - Card container generico
- `clyvo_info_card.dart` - Card informativo do design system

## UI - Dialogs (`lib/core/ui/dialogs/`)

- `app_dialog.dart` - Dialog/modal padrao
- `clyvo_confirmation_bottom_sheet.dart` - Bottom sheet de confirmacao
- `country_selector_bottom_sheet.dart` - Seletor de pais

## UI - Navigation (`lib/core/ui/navigation/`)

- `clara_app_bar.dart` - AppBar principal
- `clyvo_bottom_navigation_bar.dart` - Bottom navigation do design system
- `app_bottom_navigation_bar.dart` - Bottom navigation (legacy)
- `app_tab_bar.dart` - Tab bar para telas com abas
- `registration_app_bar.dart` - AppBar do fluxo de cadastro
- `title_in_app_bar.dart` - Widget de titulo para AppBar

## UI - Screens (`lib/core/ui/screens/`)

- `clyvo_base_screen.dart` - Wrapper base para telas com layout padrao
- `loading_screen.dart` - Tela de loading fullscreen
- `not_found_screen.dart` - Tela 404
- `document_capture_screen.dart` - Tela de captura de documentos

## UI - Widgets (`lib/core/ui/widgets/`)

- `clyvo_avatar.dart` - Avatar do design system
- `app_avatar_widget.dart` - Avatar (legacy)
- `clyvo_logo_header.dart` - Header com logo do app
- `clyvo_gradient_background.dart` - Background gradiente
- `clyvo_pulsing_mic.dart` - Microfone animado pulsante
- `clyvo_watermark_logo.dart` - Logo em marca d'agua
- `clyvo_error_message.dart` - Mensagem de erro
- `profile_avatar.dart` - Avatar de perfil
- `profile_header.dart` - Header de perfil
- `profile_menu_item.dart` - Item de menu do perfil
- `document_upload_widget.dart` - Upload de documentos
- `duration_picker.dart` - Seletor de duracao
- `registration_header.dart` - Header de cadastro
- `app_top_bar.dart` - Top bar (legacy)
- `holiday_calendar_widget.dart` - Calendario de feriados
- `holiday_card_widget.dart` - Card de feriado

## UI - Modal (`lib/core/ui/modal/`)

- `feedback_modal.dart` - Modal de feedback do usuario

---

## Error Handling (`lib/core/error/`)

- `exceptions.dart` - NetworkException, TimeoutException, ServerException, BadRequestException, UnauthorizedException, ForbiddenException, NotFoundException, RequestCancelledException, CacheException, AuthenticationException
- `failures.dart` - NetworkFailure, ServerFailure, TimeoutFailure, CacheFailure, ValidationFailure, AuthFailure, UnauthorizedFailure, InputFailure, NotFoundFailure, ForbiddenFailure, RequestCancelledFailure, AudioFailure

## Presentation (`lib/core/presentation/`)

- `error_handler.dart` - `ErrorHandler.getMessage(failure)`, `ErrorHandler.isRecoverable(failure)`
  > **Atenção:** o padrão atual é `_mapFailure(Failure)` com switch exaustivo em cada Notifier — ver `@.claude/rules/presentation-layer.md`. `ErrorHandler` pode ser usado como fallback ou referência, mas não como padrão principal.

## Extensions (`lib/core/extensions/`)

- `either_extensions.dart` - `foldWithMessage()`, `getOrHandleError()` para Either
- `failure_extensions.dart` - `failure.userMessage`, `failure.isRecoverable`
  > **Atenção:** `failure.userMessage` é o padrão antigo. O padrão atual é `_mapFailure()` no Notifier — ver `@.claude/rules/presentation-layer.md`.

## Extensions Utils (`lib/core/utils/extensions/`)

- `build_context_extensions.dart` - Extensions para BuildContext
- `date_time_extensions.dart` - Helpers para DateTime
- `iterable_extensions.dart` - Helpers para Iterable
- `string_extensions.dart` - Helpers para String
- `widget_extensions.dart` - Helpers para Widget

---

## Logging (`lib/core/logging/`)

- `console_logger.dart` - Logger com tags: `ConsoleLogger(tag: 'TAG')` com `.d()`, `.i()`, `.w()`, `.e()`
- `logger.dart` - Interface base do logger
- `logger_provider.dart` - Provider do logger (LoggerMixin)

## Network (`lib/core/network/`)

- `api_client.dart` - Cliente HTTP (Dio) com interceptors
- `network_info.dart` - Verificacao de conectividade
- `network_exceptions.dart` - Exceptions de rede
- `offline_sync_service.dart` - Sincronizacao offline
- `offline_sync_providers.dart` - Providers de sync offline
- `token_refresh_service.dart` - Servico de refresh de token
- `auth/auth_interceptor.dart` - Interceptor que injeta token Bearer
- `auth/token_refresh_handler.dart` - Handler de refresh automatico
- `auth/token_refresh_policy.dart` - Politica de refresh
- `auth/public_endpoint_config.dart` - Config de endpoints publicos
- `auth/auth_endpoint_enum.dart` - Enum de endpoints de auth

## Storage (`lib/core/storage/`)

- `local_storage_service.dart` - Hive (dados gerais)
- `secure_storage_service.dart` - FlutterSecureStorage (tokens)
- `storage_key_enum.dart` - 39 chaves de storage (authToken, refreshToken, userData, etc)
- `cache_manager.dart` - Gerenciador de cache
- `cache/cache_config.dart` - Configuracao de cache
- `cache/cache_manager.dart` - Manager de cache
- `cache/cacheable_repository.dart` - Mixin para repos com cache
- `cache/disk_cache_manager.dart` - Cache em disco
- `cache/memory_cache_manager.dart` - Cache em memoria

---

## Services (`lib/core/services/`)

- `audio_recording_service.dart` - Gravacao de audio com permissoes e base64
- `audio_transcription_service.dart` - Transcricao de audio
- `speech_service.dart` - Speech-to-text em tempo real
- `media_picker_service.dart` - Picker de fotos/videos/documentos
- `share_service.dart` - Compartilhamento nativo de arquivos
- `call_notification_service.dart` - Notificacoes de chamada (CallKit iOS)
- `battery_optimization_service.dart` - Otimizacao de bateria
- `document_validation_service.dart` - Validacao de documentos
- `signature_foreground_service.dart` - Servico de assinatura em foreground
- `shared_file_handler.dart` - Handler de arquivos compartilhados
- `temporary_registration_service.dart` - Registro temporario

## Auth (`lib/core/auth/`)

- `biometric_service.dart` - Interface de biometria
- `local_biometric_service.dart` - Implementacao local de biometria
- `biometric_providers.dart` - Providers de biometria

## Notifications (`lib/core/notifications/`)

- `notification_service.dart` - Servico de notificacoes
- `notification_providers.dart` - Providers de notificacoes

---

## Utils (`lib/core/utils/`)

- `app_utils.dart` - `hasNetworkConnection()`, `showSnackBar()`, `showSnackBarError()`, `formatDate()`, `formatCurrency()`, `createPhoneMaskFormatter()`
- `validators.dart` - Validadores de formulario
- `password_validator.dart` - Validador de senha
- `permission_handler.dart` - Handler de permissoes do sistema
- `jwt_utils.dart` - Utilitarios para JWT
- `session_activity_tracker.dart` - Tracker de atividade de sessao

## Formatters (`lib/core/formatters/`)

- `cpf_formatter.dart` - Formatador de CPF
- `phone_number_formatter.dart` - Formatador de telefone

## Mixins (`lib/core/mixins/`)

- `exception_handler_mixin.dart` - Mixin para tratamento de exceptions em DataSources

---

## Enums (`lib/core/enum/`)

- `user_type_enum.dart`, `patient_type_enum.dart`, `user_status_enum.dart`
- `consultation_status_enum.dart`, `consultation_type_enum.dart`, `consultation_priority_enum.dart`
- `document_type_enum.dart`, `payment_status_enum.dart`, `payment_method_enum.dart`
- `gender_enum.dart`, `blood_type_enum.dart`, `verification_status_enum.dart`
- `ai_processing_status_enum.dart`, `sort_order_enum.dart`, `user_sort_field_enum.dart`

---

## Providers (`lib/core/providers/`)

- `app_providers.dart` - Providers globais do app
- `storage_providers.dart` - Providers de storage
- `cache_providers.dart` - Providers de cache
- `theme_providers.dart` - Providers de tema
- `localization_providers.dart` - Providers de localizacao
- `user_providers.dart` - Providers de usuario

## Theme (`lib/core/theme/`)

- `app_colors.dart` - Cores do design system (primary, success, warning, error, gray)
- `app_styles.dart` - 40+ estilos de texto pre-definidos
- `app_theme.dart` - Tema do app

## Router (`lib/core/router/`)

- `app_router.dart` - Rotas do app (68+ rotas com go_router)

## Constants (`lib/core/constants/`)

- `api_constants.dart` - Endpoints da API
- `app_constants.dart` - Constantes do app

## UseCases (`lib/core/usecases/`)

- `usecase.dart` - `UseCase<T, Params>` base e `NoParams`
