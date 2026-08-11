# 📱 Aplicativo de Gestão para Pequenos Empreendedores

> **Projeto de Atividade Extensionista II: Tecnologia Aplicada à Inclusão Digital – Projeto**  
> **Curso:** CST em Análise e Desenvolvimento de Sistemas (UNINTER)  
> **Estudante:** Claudilei Nunes da Silva Junior (RU: 5158446)  
> **Local de Aplicação:** Curitiba - PR

---

## 🔍 Sobre o Projeto

Este aplicativo foi desenvolvido para sanar as dificuldades de pequenos empreendedores locais no controle manual de estoque e vendas. Utilizando uma interface extremamente limpa, simplificada e com funcionamento 100% offline, a solução promove a inclusão digital de comerciantes com pouca familiaridade tecnológica, transformando cadernos e anotações informais em registros digitais seguros.

---

## 🛠️ Tecnologias Utilizadas

*   **Framework:** [Flutter](https://flutter.dev/) (Versão estável)
*   **Linguagem:** [Dart](https://dart.dev/)
*   **Banco de Dados:** SQLite (persistência local via pacote `sqflite`)
*   **Gerenciamento de Estado:** Provider / ChangeNotifiers

---

## 📋 Especificação de Engenharia de Requisitos

### Requisitos Funcionais (RF)

| ID | Descrição do Requisito |
| :--- | :--- |
| **RF-001** | **Cadastro de Produtos:** Permitir cadastrar produtos com nome, preço de custo, preço de venda e quantidade inicial. |
| **RF-002** | **Edição e Exclusão:** Permitir alterar dados cadastrados ou excluir um produto permanentemente. |
| **RF-003** | **Registro de Vendas:** Permitir selecionar um item cadastrado, inserir a quantidade e registrar a venda com cálculo automático do total. |
| **RF-004** | **Atualização Automática de Estoque:** Decrementar automaticamente a quantidade em estoque do produto correspondente após confirmar uma venda. |
| **RF-005** | **Histórico de Vendas:** Disponibilizar consulta detalhada e cronológica de transações realizadas com dados de data, hora e valores totais. |
| **RF-006** | **Alerta de Estoque Baixo:** Destacar visualmente (na cor vermelha ou amarela) qualquer produto com quantidade inferior ou igual a 3 unidades. |

### Requisitos Não Funcionais (RNF)

| ID | Descrição do Requisito |
| :--- | :--- |
| **RNF-001** | **Funcionamento Offline:** Armazenamento local (SQLite) sem necessidade de acesso à internet para operações cotidianas. |
| **RNF-002** | **Desempenho:** Consultas e escritas no banco de dados com tempo de resposta menor que 500ms. |
| **RNF-003** | **Acessibilidade e Usabilidade:** Uso de fontes com tamanho mínimo de 16sp, alto contraste de cores e áreas de clique expandidas. |
| **RNF-004** | **Compatibilidade:** Suporte garantido para sistemas Android a partir da versão 7.0 (Nougat). |

---

## 🔄 Fluxos de Casos de Uso (UML)

### Caso de Uso 1: Registrar Venda e Atualizar Estoque
*   **Ator Principal:** Empreendedor
*   **Pré-condições:** Produto desejado previamente cadastrado e com quantidade de estoque disponível.
*   **Fluxo Principal:**
    1. O empreendedor acessa a tela de "Nova Venda".
    2. O sistema lista os produtos disponíveis.
    3. O empreendedor seleciona um produto e insere a quantidade vendida.
    4. O sistema exibe o preço total calculado em tempo real.
    5. O empreendedor confirma o registro.
    6. O sistema insere a transação no histórico local e decrementa a quantidade vendida na tabela de produtos.
    7. O sistema exibe o aviso: *"Venda registrada com sucesso!"*.
*   **Fluxo Alternativo (Quantidade Insuficiente):**
    1. No passo 3, se a quantidade desejada exceder o saldo em estoque, o sistema bloqueia o botão de confirmação.
    2. O sistema exibe em vermelho o alerta: *"Estoque insuficiente. Saldo atual: X unidades"*.

### Caso de Uso 2: Consultar Alerta de Estoque Baixo
*   **Ator Principal:** Empreendedor
*   **Pré-condições:** Produtos cadastrados no sistema.
*   **Fluxo Principal:**
    1. O empreendedor abre o aplicativo no painel principal ou de estoque.
    2. O sistema consulta as tabelas de produtos no SQLite.
    3. O sistema destaca no topo da visualização as mercadorias que possuem quantidade $\le 3$.
    4. O empreendedor analisa rapidamente quais itens necessitam de reposição imediata junto a fornecedores.

---

## 📐 Metodologia de Desenvolvimento

A linha cronológica e de atividades planejada para este projeto seguiu o fluxo abaixo:

1. **Levantamento de Requisitos (3 dias):** Mapeamento direto de necessidades com comerciantes locais.
2. **Planejamento e Design (5 dias):** Definição de fluxos de navegação e layouts simplificados.
3. **Desenvolvimento do App (10 dias):** Programação em Flutter/Dart e persistência offline.
4. **Validação e Testes (5 dias):** Avaliação de uso prático pelos empreendedores para coleta de feedbacks.
5. **Ajustes e Otimizações (3 dias):** Correções de interface e bugs de campo.
6. **Capacitação e Entrega (10 dias):** Treinamentos assistidos e entrega final da solução.

---

### Pré-requisitos
Certifique-se de possuir o Flutter SDK e Git instalado em sua máquina. Para verificar execute:
```bash
flutter doctor

---

## 🚀 Como Executar o Projeto Localmente pelo Terminal VsCode
1. Abra a pasta do Projeto.
2. Baixe os pacotes necessários pelo Terminal: flutter pub get
3. Execute o aplicativo no navegador Chrome pelo Terminal: flutter run -d chrome
4. O aplicativo vai compilar e abrir uma janela do Google Chrome. Nela você poderá cadastrar produtos e registrar vendas.
