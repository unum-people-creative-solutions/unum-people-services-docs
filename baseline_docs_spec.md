# Baseline Documentation Specification - unum-people-services-docs

**Data:** 2026-05-19
**Versão:** 1.0.0
**Status:** Baseline (Current State)

Este documento descreve o estado atual do repositório de documentação da Unum People.

---

## 1. Visão Geral
Repositório central de guias, documentação técnica e referência de API para usuários e integradores da Unum People.

## 2. Estrutura e Hospedagem
- **Tecnologia:** HTML/JS estático.
- **Hospedagem:** GitHub Pages (custom domain: `docs.unumpeople.com.br`).
- **Conteúdo:**
    - `index.html`: Landing page da documentação.
    - `crm/`: Documentação específica do CRM e OpenAPI (Swagger UI).
    - `images/`: Assets visuais (Logos e ícones).

## 3. Principais Documentos
- **Guia de Ingestão:** Instruções para desenvolvedores conectarem LPs externas.
- **Referência API:** Swagger UI carregando o `openapi.yaml` do backend.
- **Guia Google Ads:** Passo a passo para conexão OAuth2.

---

## 4. Padrões de Manutenção
- Toda mudança em endpoints no Backend deve ser sincronizada com o `openapi.yaml` deste repositório.
- Imagens e logos devem seguir a identidade visual da Unum.
