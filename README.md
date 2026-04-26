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
