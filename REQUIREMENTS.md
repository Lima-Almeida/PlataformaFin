# Atividade 3: Elicitação de Requisitos

Nesse documento, iremos apresentar a especificação de requisitos gerais obtidos por dois processos de elicitação de requisitos com base na temática geral da aplicação feita pelo nosso
grupo. Vale, então, lembrar a ideia geral da aplicação: uma plataforma de controle financeiro, que irá ajudar o usuário a fazer escolhas melhores referentes às suas finanças. 

Para obtermos
os requisitos, foram utilizadas as técnicas do benchmark e das entrevistas.

## Primeira atividade de elicitação de requisitos: Benchmark
A primeira atividade realizada pelo grupo para elicitar os requisitos do nosso projeto foi o benchmarking. Para fazer isso, escolhemos estudar as features de dois aplicativos pertinentes para a nossa aplicação: o Mobills e o Organizze.

### Benchmark: Mobills
Aplicativo para controle de finanças pessoais que visa facilitar o gerenciamento de economias e despesas.

### Documentação de features e funcionalidades
Para esta etapa, exploramos as seguintes páginas do aplicativo: página principal, tansações e adição de movimentações financeiras. 
As features que se destacaram durante nossa análise estão listadas abaixo. 

- **Página principal**

Aqui, são exibidas algumas informações importantes para o usuário, como seu saldo atual em contas (explicitado pelas receitas e pelas despesas). São exibidos também gráficos com insights importantes para o usuário, como suas despesas divididas em categorias e um balanço mensal de suas receitas e despesas. Outro detalhe relevante dessa página é a possibilidade de integrar uma conta bancária ao aplicativo, o que fará com que movimentações bancárias sejam adicionadas automaticamente ao app.

![Integrar banco - Mobills](https://github.com/user-attachments/assets/8f80c3db-8fc7-4a0e-b400-89a43e354240) ![Saldo atual total - Mobills](https://github.com/user-attachments/assets/42447e86-b87e-46eb-a48d-19087cb914ce) ![Saldo em cada conta - Mobills](https://github.com/user-attachments/assets/bc60acec-4a02-4898-b6ea-84d713109e00) ![Gráfico circular de despesas por categoria - Mobills](https://github.com/user-attachments/assets/d28b1dc8-9dab-4722-ad7c-025027f5fadd) ![Gráfico em barras do balanço mensal - Mobills](https://github.com/user-attachments/assets/772af240-a993-4655-8154-737f9dfde6ba)

*Exemplo de funcionalidades na página principal.*

- **Transações**

Nesta página, conseguimos visualizar todas as movimentações financeiras que o aplicativo possui acesso, sejam elas manuais (ou seja, colocadas manualmente pelo próprio usuário) ou automáticas (obtidas automaticamente pelo aplicativo pela integração com contas bancárias). As entradas e saídas são diferenciadas por cores (verde para as primeiras, vermelho para as segundas). É possível ver também o saldo atual do usuário, bem como um balanço mensal atrelado a cartões de crédito. Algumas funcionalidades interessantes dessa pág

![Transações financeiras - Mobills](https://github.com/user-attachments/assets/2d15df46-cdcf-4aa2-9706-856cfb77f94e)

*Página de transações financeiras.*

- **Adição de movimentações financeiras**

Existem ao todo 4 tipo de movimentações que podem ser adicionadas: transferências, receitas, despesas e despesas de cartão. A interface para adicionar cada tipo de movimentação é similar. Uma característica relevante dessa feature é que é possível dividir as despesas em categorias, como compras, mercado, lazer, etc. Além disso, pode ser adicionado de forma manual ou automática (caso haja integração com conta bancária) em que banco ou carteira tal transação foi realizada, além de outras características relevantes. 

![Escolher que tipo de movimentação será adicionada - Mobills](https://github.com/user-attachments/assets/3339fdd9-e50f-4014-b884-d9bef173371c) ![Adicionar movimentação financeira - Mobills](https://github.com/user-attachments/assets/766798ea-24b5-46e2-b039-3481680a4bae)

*Exemplo de como funciona a adição de movimentações financeiras.*

#### Pontos positivos e negativos
- **Positivos**
    - Embora seja necessário ter uma assinatura para aproveitar todas as funcionalidades do aplicativo, o valor dessa assinatura é relativamente baixo (aproximadamente R$ 8,25/mês).
    - Informações visuais eficazes em relação aos gastos do usuário, exibidas por gráficos.
    - Interface agradável visualmente e intuitiva.
    - Como há a possibilidade de integrar contas bancárias ao aplicativo, a plataforma acaba sendo muito prática, visto que movimentações bancárias não precisam ser cadastradas manualmente pelo usuário.
- **Negativos**
    - Algumas funcionalidades não estão disponíveis para usuários que não possuem assinatura do aplicativo.
    - Excesso de informações e imagens que visam convencer o usuário a assinar o aplicativo.
    - As categorias das movimentações financeiras, em geral, devem ser indicadas pelo próprio usuário, o que faz com que o app perca um pouco da sua praticidade.
    - Existe um limite de transações que podem ser cadastradas manualmente no app. Se esse limite for ultrapassado, é necessário assistir propagandas para liberar mais cadastros.
    - A integração bancária, feature que visa deixar o uso do app mais prático, pode gerar insegurança em alguns usuários.
 
### Benchmark: Organizze

O Organizze visa ajudar aqueles que desejam equilibrar suas finanças de forma eficiente e descomplicada. Ele visa simplificar o controle de gastos, ajudando os usuários a alcançar suas metas financeiras com facilidade.

### Documentação de features e funcionalidades

Assim como na etapa anterior, realizamos o uso típico da aplicação, conferindo todas as suas páginas e funcionalidades. Fizemos isso a fim de verificar quais features poderiam ser utilizadas ou adaptadas em nosso projeto.

As features de maior relevância do app estão explicitadas abaixo. 

- **Página inicial**

Um destaque que damos para essa página é a possibilidade de personalização, o que permite que ela seja ajustada de forma a exibir as informações mais relevantes para cada usuário. Por padrão, são exibidas as seguintes informações: 
  - Saldo geral do usuário, bem como seu saldo em outras plataformas (contas bancárias, cofrinho ou carteira).
  - Faturas de cartões do usuário.

Além disso, é possível visualizar outras informações nesta página, sendo elas: o limite de gastos por categoria e o equilíbrio financeiro do usuário, onde são dadas informações sobre quais gastos são essenciais e quais não são. 
Nas imagens abaixo, é possível conferir as informações padrão dessa página, bem como algumas informações que o usuário pode selecionar para serem exibidas.

![Saldos](https://github.com/user-attachments/assets/f43fc2d3-11c1-4edd-b649-1d832cc70dd1) ![Fatura dos cartões](https://github.com/user-attachments/assets/3d473e8f-b008-4fd5-9892-031db503c85b) ![Opções de customização da tela inicial - Organizze](https://github.com/user-attachments/assets/3f75d5ae-98da-41a9-942c-7de53fa6fe20)

*Funcionalidades de destaque presentes na página inicial.*

- **Fluxo de caixa**
Nessa página, é possível visualizar o histórico de caixa em cada mês, além do total de entradas, o total de saídas e o saldo total do usuário. Os gastos podem ser encaixados em categorias,
sendo que cada categoria possui um ícone distinto para representá-la.

![Histórico de caixa - Organizze](https://github.com/user-attachments/assets/cb39aff1-dff9-44b1-9027-14698ff24616) 

*Fluxo de caixa.*

- **Relatórios**
Essa página contém alguns gráficos para que o usuário possa visualizar melhor os seus gastos. Assim como no aplicativo Mobills, existem dois tipos de gráfico: um circular que detalha a divisão
de despesas por categorias, bem como um em barras para exibir o total de entradas e o total de saídas.

![Gráficos - Organizze](https://github.com/user-attachments/assets/fb2b0148-324f-4330-90fe-57a9826a2030)

*Relatórios financeiros em formato de gráficos.*

- **Lançamento financeiro**
Essa funcionalidade permite adicionar alguma movimentação financeira, que é dividida em despesas, tranferências e receitas. É possível detalhar um pouco melhor cada movimentação, com informações como:
  - De qual banco, carteira ou cofrinho ela veio.
  - Quando ela ocorreu.
  - Categoria.
  - Descrição do lançamento.

![Adicionar despesa - Organizze](https://github.com/user-attachments/assets/aa998d63-6584-4cb9-97e2-ef6934d058c9) ![Adicionar receita - Organizze](https://github.com/user-attachments/assets/2e4efafd-fc3e-4514-9404-7404ba2bf2a4) ![Detalhar lançamento - Organizze](https://github.com/user-attachments/assets/484ea71a-76ca-4cef-9d80-a729f894050c)

*Cadastro de lançamentos financeiros.*

- **Limite de gastos**
Uma funcionalidade muito interessante do Organizze é a definição de um limite de gastos, podendo ser geral ou por categorias específicas. Com a definição desses limites, o aplicativo consegue
dar insights pro usuário referentes à sua saúde financeira (funcionalidade que já foi abordada anteriormente). O limite de gastos pode ser personalizado: por exemplo, ele pode ser um limite
recorrente (ou seja, todo mês esse limite será o mesmo) ou único em um mês. 
 
![Limite de gastos por categoria - Organizze](https://github.com/user-attachments/assets/cb277f5a-0144-4901-8041-d7dcbd620696)

*Definição de um orçamento limite para uma categoria de gastos.*

#### Pontos positivos e negativos
- **Positivos**
    - Em comparação ao Mobills, a interface do Organizze é bem mais limpa e agradável para o usuário.
    - Organização e coerência entre cada página.
    - Embora seja necessário ter uma assinatura para usurfruir de todas as funcionalidades, ele possui bem menos imagens e textos para convencer o usuário a fazer essa assinatura, o que
    deixa a plataforma bem mais limpa e agradável.
    - App intuitivo e de fácil manuseio.
    - Divide os lançamentos em apenas três categorias, ao contrário do Mobills, o que pode facilitar o cadastro de lançamentos.
    
- **Negativos**
    - Assim como o Mobills, o usuário deve pagar para conseguir usurfruir de todas as funcionalidades.
    - Não oferece a possibilidade de integração com contas bancárias, o que torna a experiência do usuário um pouco menos prática.
    - Mais caro do que o Mobills (R$ 20,83/mês em caso de assinatura anual).
 
### Requisitos

Com base nas duas aplicações estudadas, podemos expor alguns requisitos obtidos pelas análias:

- O sistema deve mostrar o saldo atualizado das contas e dos cartões de crédito.
- O sistema deve ter um registro manual ou automático de despesas, receitas e transferências.
- O sistema deve apresentar gráficos visuais, como o gráfico de pizza e gráficos de barras, a fim de oferecer uma visualização de transações financeiras de forma intuitiva.
- O sistema deve apresentar a opção do usuário integrar suas contas bancárias para automatizar a entrada de dados financeiros.
- O sistema deve oferecer a possibilidade de estipular limites de gastos por categorias e alertar quando esse limite estiver próximo de ser atingido.

## Segunda atividade de elicitação de requisitos: Entrevista
