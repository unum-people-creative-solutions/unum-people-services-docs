# TECH DESIGN: Revitalização da Documentação Unum People

**Data:** 2026-06-03
**Status:** Em Revisão
**Autor:** Gemini CLI

## 1. Objetivo
Transformar a documentação atual (pobre e desatualizada) em um guia completo, amigável e tecnicamente preciso para usuários e administradores do CRM Unum People.

## 2. Nova Estrutura de Navegação (Backlog de Conteúdo)

### 2.1. Começando
- **Acesso ao Sistema:** Como realizar login e recuperação de senha.
- **Configuração Inicial (Onboarding):** Passo a passo para novos usuários configurarem seu negócio e nicho.

### 2.2. Gestão de Leads
- **O Funil Kanban:** Explicação das colunas e fluxo de trabalho.
- **Cadastrando Leads:** Manualmente vs. Automático.
- **Alertas de Inatividade:** O que significam as cores (Azul, Laranja, Vermelho) e como agir.
- **Edição de Leads:** Campos disponíveis (CPF, Telefone, E-mail) e anotações.
- **Movimentação e Organização:** Arrastar e soltar, busca e filtros.

### 2.3. Vendas e Resultados
- **Registrando uma Venda:** Como converter um lead em faturamento.
- **Acompanhamento de Resultados:** Onde visualizar o faturamento gerado.

### 2.4. Integrações
- **Google Ads:** Como conectar sua conta e qual o benefício.
- **API Key para Landing Pages:** Guia para desenvolvedores sobre ingestão de leads externa.

### 2.5. Configurações e Segurança
- **Perfil do Usuário:** Gerenciar seus dados.
- **Notificações Push:** Como ativar alertas em tempo real.
- **Privacidade e LGPD:** Exportação de dados e exclusão de conta.

### 2.6. Administração (Agências)
- **Gestão de Clientes (Tenants):** Como criar e alternar entre clientes.
- **Equipe:** Convidando novos usuários para um tenant.
- **Gestão de API Keys:** Como fornecer acesso técnico para seus clientes.

## 3. Padrão de Conteúdo (Template)
Cada artigo deve seguir o formato:
1.  **Título Direto:** (Ex: "Como cadastrar um lead manualmente")
2.  **Contexto:** Uma frase explicando para que serve a funcionalidade.
3.  **Passo a Passo:** Lista numerada com ações claras.
4.  **Dica Pro/Destaque:** Informação extra de valor (Ex: Alerta de inatividade).
5.  **Resultado Esperado:** O que acontece após o processo.

## 4. Mudanças Técnicas no Projeto `docs`
- Atualização do `crm/index.html` para incluir um sistema de abas ou navegação lateral mais robusto.
- Separação do conteúdo em arquivos menores (opcional) ou uso de seções bem definidas com IDs para links diretos.
- Manutenção da identidade visual (Tailwind + Cores Unum).

## 5. Próximos Passos (TASKS)
1.  [ ] Criar novo layout de navegação no `crm/index.html`.
2.  [ ] Escrever conteúdo para "Primeiros Passos".
3.  [ ] Escrever conteúdo para "Gestão de Leads".
4.  [ ] Escrever conteúdo para "Vendas".
5.  [ ] Escrever conteúdo para "Integrações & Administração".
6.  [ ] Revisão final e validação de links.
