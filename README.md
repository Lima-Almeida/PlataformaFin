# PlataformaFin
Repositório do projeto da matéria MC656 (Engenharia de Software), que consiste em uma plataforma de controle financeiro.

Nomes:
- Mateus de Lima Almeida 242827
- Ana Carolina de Almeida Cardoso 246914
- Arthur Tsuyoshi Kina 260370
- Victor Hoshikawa Satoh 260711
- Matheus Seiji Luna Noda 230921

## Descrição da Arquitetura

O estilo arquitetural que optamos por utilizar foi o MVC (Model-View-Controller). Essa escolha foi feita pois esse estilo permite separar responsabilidades, tornando nosso sistema mais modular e facilitando a manutenção e evolução futura. Consideramos isso essencial para nosso sistema, visto que ele lida com dados sensíveis e múltiplas funcionalidades de controle financeiro. Nossa aplicação foi dividida em três módulos independentes, cada um com suas próprias funcionalidades e funções:

- **Model:** Gerencia dados e regras de negócio da nossa aplicação. Em nosso sistema, o Model atua armazenando e processando dados, fornecendo as informações necessárias para os outros módulos de forma organizada.
- **View:** Interface com o usuário, ou seja, o "front-end". Ele apresenta os dados ao usuário e recebe interações. Dentro do nosso sistema, o View é onde o usuário interage diretamnte com as informações e ações disponíveis. 
- **Controller:** Sincroniza o Model e o View, processando as interações do usuário adequadamente e exibindo as respostas corretamente. Os Controllers recebem ações do usuário pela interface, processam essas informações no Model e utilizam o View conforme necessidade.

Além dos componentes principais do MVC, nosso aplicativo também se integra a um banco de dados centralizado (Firebase) que armazena dados dos usuários, como transações bancárias, de forma segura. Em alguns casos, o app faz chamadas a APIs de serviços bancários para sincronizar informações de contas e atualizações financeiras em tempo real, o que facilita o gerenciamento financeiro automático de forma a exibir dados atualizados para o usuário.

### Benefícios

A separação entre dados (Model), interface (View) e controle (Controller) proporciona uma estrutura modular, que facilita a manutenção e a atualização do sistema sem impactar as outras camadas. Essa organização torna o sistema mais seguro e confiável, pois permite o tratamento isolado de dados sensíveis, como informações bancárias.

## Diagrama em Nível de Componentes

Na figura abaixo, apresentamos o diagrama de componentes para modelar a arquitetura utilizada em nosso projeto. Nesse modelo, o usuário interage com a aplicação mobile, e cada requisição é tratada por uma feature específica.  

![MC656  Avaliação A4 - Diagrama C4 (6)](https://github.com/user-attachments/assets/01f6fa02-8423-4412-a4fe-95597c5a032e)

O diagrama da aplicação é composto pelos seguintes componentes:

- **Componente de autenticação:** Gerencia o login e a autenticação dos usuários, assegurando a proteção e a privacidade dos dados financeiros.
- **Componente de Cadastro de Receitas e Despesas:** Permite que o usuário registre entradas e saídas financeiras, categorizando-as para uma análise mais detalhada da saúde financeira do usuário.
- **Componente de Integração Bancária**: Conecta o aplicativo a contas bancárias externas, sincronizando de forma automática movimentações financeiras.
- **Componente de Relatórios e Gráficos:** Gera relatórios financeiros periódicos e gráficos de consumo por categoria, fornecendo uma visão completa do comportamento financeiro do usuário.
- **Componente de Limite de Gastos:** Permite ao usuário definir limites de gastos por categoria e monitorar o cumprimento desses limites, de forma que ele mantenha o orçamento sob controle.
- **Componente de Notificação:** Envia notificações push para o usuário sobre o status de gastos, alertando-o em caso de aproximação ou ultrapassagem dos limites definidos. 
