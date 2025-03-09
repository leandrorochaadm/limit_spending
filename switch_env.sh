#!/bin/bash

# Verifica se um argumento foi passado
if [ -z "$1" ]; then
    echo "❌ ERRO: Você precisa informar 'dev' ou 'prod'."
    exit 1
fi

ENV=$1

# Define os caminhos dos arquivos
DEV_GOOGLE_SERVICE="ios/Runner/Firebase/dev/GoogleService-Info.plist"
PROD_GOOGLE_SERVICE="ios/Runner/Firebase/prod/GoogleService-Info.plist"
DEST_GOOGLE_SERVICE="ios/Runner/GoogleService-Info.plist"

DEV_FIREBASE_OPTIONS="lib/firebase_options_dev.dart"
PROD_FIREBASE_OPTIONS="lib/firebase_options_prod.dart"
DEST_FIREBASE_OPTIONS="lib/firebase_options.dart"

# Função para verificar se a cópia foi bem-sucedida e exibir mensagem personalizada
verify_copy() {
    local source_file=$1
    local destination_file=$2
    local message=$3

    if diff "$source_file" "$destination_file" > /dev/null; then
        echo "✅ $message"
    else
        echo "❌ ERRO ao copiar o arquivo: $destination_file"
    fi
}

# Executa a cópia conforme o ambiente selecionado
if [ "$ENV" == "dev" ]; then
    echo "🚀 Alterando para ambiente de DESENVOLVIMENTO..."
    cp -f "$DEV_GOOGLE_SERVICE" "$DEST_GOOGLE_SERVICE"
    cp -f "$DEV_FIREBASE_OPTIONS" "$DEST_FIREBASE_OPTIONS"

    verify_copy "$DEV_GOOGLE_SERVICE" "$DEST_GOOGLE_SERVICE" "Google Service atualizado para DEV"
    verify_copy "$DEV_FIREBASE_OPTIONS" "$DEST_FIREBASE_OPTIONS" "Firebase Options atualizado para DEV"

    echo "✅ Ambiente DEV configurado com sucesso!"
elif [ "$ENV" == "prod" ]; then
    echo "🚀 Alterando para ambiente de PRODUÇÃO..."
    cp -f "$PROD_GOOGLE_SERVICE" "$DEST_GOOGLE_SERVICE"
    cp -f "$PROD_FIREBASE_OPTIONS" "$DEST_FIREBASE_OPTIONS"

    verify_copy "$PROD_GOOGLE_SERVICE" "$DEST_GOOGLE_SERVICE" "Google Service atualizado para PROD"
    verify_copy "$PROD_FIREBASE_OPTIONS" "$DEST_FIREBASE_OPTIONS" "Firebase Options atualizado para PROD"

    echo "✅ Ambiente PROD configurado com sucesso!"
elif [ "$ENV" == "configure" ]; then
    flutterfire configure --project=limit-spending --out="$PROD_FIREBASE_OPTIONS"
    flutterfire configure --project=limit-spending-dev --out="$DEV_FIREBASE_OPTIONS"
else
    echo "❌ ERRO: Argumento inválido. Use 'dev' ou 'prod'."
    exit 1
fi

