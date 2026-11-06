#!/usr/bin/env bash
# Script de compilação automatizada do artigo no formato ABRALIN (2026)
set -e

echo "==> 1. Compilando Markdown para DOCX via Pandoc com modelo ABRALIN de referência..."
pandoc A_Lingua_em_Perpetua_Transmutacao_Abralin.md \
  --lua-filter=pandoc_crossref.lua \
  --reference-doc=reference_abralin_perfeita.docx \
  -o A_Lingua_em_Perpetua_Transmutacao_Abralin.docx

echo "==> 2. Formatando DOCX com estilos estritos da ABRALIN..."
python3 formatar_abralin_docx.py

echo "==> 3. Exportando DOCX para PDF vetorial via LibreOffice..."
libreoffice --headless --convert-to pdf A_Lingua_em_Perpetua_Transmutacao_Abralin.docx

echo "==> 4. Concluído com sucesso!"
echo "   - [DOCX]: A_Lingua_em_Perpetua_Transmutacao_Abralin.docx"
echo "   - [PDF]:  A_Lingua_em_Perpetua_Transmutacao_Abralin.pdf"
pdfinfo A_Lingua_em_Perpetua_Transmutacao_Abralin.pdf | grep Pages
