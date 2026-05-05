# unum-people-services-docs

Repositório central da **Central de Ajuda** e **Documentação Técnica** do ecossistema Unum People.

## 1. Estrutura do Projeto
- `/index.html`: Portal principal (Hub de Documentação).
- `/crm/index.html`: Central de Ajuda específica do CRM, integrando manuais e Swagger UI.
- `/crm/openapi.yaml`: Especificação oficial da Lead Ingestion API.
- `/images/`: Ativos visuais de marca e ilustrações dos manuais.

## 2. Tecnologias
- **HTML5/Tailwind CSS:** Interface responsiva e moderna.
- **Swagger UI:** Renderização dinâmica da documentação OpenAPI.
- **Netlify/GitHub Pages:** Hospedagem estática de alta performance.

## 3. Como Atualizar a API
Para atualizar a documentação da API, modifique o arquivo `./crm/openapi.yaml`. O Swagger UI carregará as mudanças automaticamente na aba "API Docs" do portal.

## 4. Como configurar uma ação de conversão
Para que o sistema reporte as vendas corretamente para o Google Ads, você precisa criar uma ação de conversão específica do tipo "Importação de Cliques".

Aqui está o passo a passo para configurar e obter o ID necessário:

### 4.1. Criar a Ação de Conversão no Google Ads
1. Acesse sua conta do Google Ads.
2. No menu superior, clique em **Objetivos** (ícone de alvo) > **Conversões** > **Resumo**.
3. Clique no botão azul **+ Nova ação de conversão**.
4. Escolha a opção **Importação**.
5. Selecione **CRMs, arquivos ou outras fontes** e escolha **Rastrear conversões de cliques**.
6. Clique em **Continuar**.

### 4.2. Detalhes da Configuração
* **Nome da conversão:** Escolha algo claro, como `Venda CRM Unum`.
* **Categoria:** Selecione `Compra` ou `Venda`.
* **Valor:** Recomendamos selecionar "Usar valores diferentes para cada conversão" (o sistema enviará o valor da venda do CRM) ou um valor fixo se preferir.
* **Contagem:** Selecione `Todas` (para computar todas as vendas do mesmo lead) ou `Uma` (apenas a primeira venda).
* **Janela de conversão de clique:** Geralmente 90 dias (é o tempo máximo que o Google permite associar um clique a uma venda).
* **Modelo de atribuição:** Recomendamos `Baseado em dados`.

Ao finalizar, clique em **Criar e continuar**. Na tela seguinte, o Google perguntará como você quer configurar o método de importação; selecione **Pular e finalizar**.

### 4.3. Recuperar o AdsConversionActionID
Agora que a ação foi criada, você precisa do ID dela:

1. Na lista de conversões (Resumo), clique no nome da conversão que você acabou de criar (`Venda CRM Unum`).
2. Olhe para a URL do seu navegador. Você verá algo parecido com isto:
   `...&ctId=123456789&...`
3. O número logo após `ctId=` é o seu **AdsConversionActionID**.

**Exemplo:**
Se a URL for `https://ads.google.com/.../details?ocid=...&ctId=987654321`, o seu ID é `987654321`.
