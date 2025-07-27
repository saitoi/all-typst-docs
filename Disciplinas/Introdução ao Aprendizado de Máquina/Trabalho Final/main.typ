#import "@preview/codly:1.0.0": *
#import "@preview/touying:0.5.3": *
#import themes.university: *
#import "@preview/cetz:0.3.1"
#import "@preview/numbly:0.1.0": numbly

/* ******************** CONFIGURAÇÕES ******************** */

#set text(lang: "pt")
#set math.equation(numbering: "(1)")
#show figure.caption: set text(size: 18pt)

#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))

// https://github.com/touying-typ/touying/blob/main/themes/university.typ

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Trabalho Final de Introdução ao Aprendizado de Máquina],
    subtitle: [Aplicando Modelos Supervisionados para Classificação de Quitação de Empŕestimos],
    author: [João Pedro Sousa, Milton Salgado e Pedro Saito],
    date: datetime.today(),
    institution: [
      Universidade Federal do Rio de Janeiro
    ],
    ),
    config-page(
    header: place(
      bottom + right,
      dx: -26.6cm,
      dy: 14.0cm,
      image("images/ufrj-logo.png", width: 78pt, height: 72pt)
    )
  )
)

#set heading(numbering: numbly("{1}.", default: "1.1"))
#show: codly-init.with()
#codly(zebra-fill: none, number-format: none)

#let icon = text(size: 1pt, "\u{ebbe}")

#title-slide()

/* ******************** SLIDES ******************** */


= Introdução

== Contexto

#v(.7em)

Algoritmos de classificação supervisionada aprendem padrões em dados rotulados para classificar novas amostras.  Possuem amplas aplicações em dados financeiros, especialmente para gerenciamento de risco em empréstimos bancários.

O Banco Mundial mantém dados históricos de empréstimos concedidos a países em desenvolvimento, incluindo quantias, datas, taxas de juros e tipos de empréstimos.
Este trabalho utiliza registros de abril de 2011 a maio de 2025, agregando-os em duas categorias ("quitado" e "não-quitado") para propor um problema de classificação binária, avaliando diferentes algoritmos de aprendizado supervisionado através de métricas como acurácia e F1-score.

#pagebreak()

= Pré-processamento

== Base de Dados Inicial

#v(.7em)

*Base de Dados:* _IBRD Statement of Loans and Guarantees - Historical Data do Grupo do Banco Mundial_, (05/25).

O dataset reúne registros mensais desde abril de 2011, contendo empréstimos e garantias concedidos pelo _IBRD_ para projetos internacionais.

#v(1.1em)

#align(center)[
#image("ibrd_logo.png", width: 49%)
]

#pagebreak()

#v(.7em)

Os dados incluem tipo de operação, valor contratado, _status_ e características
contratuais. Para cada dívida, identificou-se o primeiro registro cronológico e
seu estado conclusivo, criando a variável alvo `last_loan_status`.

Os registros foram particionados em duas categorias: dívidas totalmente quitadas
(Fully Repaid = 1) e dívidas em andamento ou concluídas sem quitação integral (=
0). Foi aplicada amostragem de _Bernoulli_ para selecionar aproximadamente 60%
do grupo quitado e 40% do restante.

#pagebreak()

#v(2em)

#figure(
  image("tabela_status_divida.png", width: 93%),
  caption: [_Descrição do status de pagamento da dívida._]
)

#pagebreak()

== Filtragem de Atributos

*Critérios de Remoção:*

- Baixa Variância (60% de valores idênticos):
- Due 3rd Party, Undisbursed Amount, Exchange Adjustment
- Borrower's Obligation, Sold 3rd Party, Repaid 3rd Party
- Due to IBRD, Loans Held, Currency of Commitment

*Variáveis de Identificação:*

- Loan Number, Project ID
- Features Relacionadas:
- Guarantor Country removida devido à redundância com Country Code

#v(20pt)


== Análise de Correlação

#v(.7em)

Foram utilizados dois métodos para calcular correlação com a variável alvo dicotômica:

*Variáveis Contínuas:* Coeficiente de Ponto Bisserial para calcular associação entre variável contínua e dicotômica.

*Variáveis Categóricas:* Coeficiente V de Cramér com teste χ².

*Critério de Seleção:* Variáveis com magnitude de correlação superior a 0,2.

#show table.cell: set text(size: 16pt)
#show table.cell.where(y: 0): set text(weight: "bold")

#let correlations = csv("2025-07-03T02_15_41+00_00_hj0e.csv")

#let col_size = 157pt

#align(center)[
  #figure(
  table(
    columns: (col_size + 89pt, col_size, col_size - 69pt, col_size + 26pt),
    align: (left, left, left),
    ..correlations.flatten().slice(0, 36),
  ),
  caption: [_Análise de correlação._]
  )
]

*Avaliação de Redundância:* Correlação de Spearman para pares numéricos, V de Cramér para categóricas e ponto bisserial para contínua-dicotômica.



== *Features Finais*
Após uma análise de redundâncias entre features, selecionamos os seguintes
atributos para compor as variáveis de entrada.

- loan_status 
- repaid_percentage 
- agreement_signing_date_timestamp 
- interest_rate — Taxa de juros aplicada ao empréstimo.
- loan_type (SNGL CRNCY, SCP USD, POOL LOAN, FSL, NON POOL)
- first_repayment_date_timestamp
- original_principal_amount

== Transformação dos Dados

#v(.7em)


*Codificação de Variáveis:*

- One-hot encoding para variáveis categóricas
- Codificação ordinal para loan_status respeitando progressão temporal
- StandardScaler para padronização de variáveis numéricas

*Validação Cruzada:*

- Repeated Stratified K-Fold: 5 folds × 6 repetições = 30 splits
- Manutenção da proporção de classes em cada fold
- Random state fixo para reprodutibilidade

#pagebreak()

#v(.7em)

*Dataset Final:*

- 6.945 registros, 11 features
- Distribuição: 39,58% classe 0, 60,42% classe 1

*Principais métricas utilizadas:*

- Acurácia.
- F1-Score.

= Experimentos

== Ambiente Computacional

#v(.7em)

*Especificações do Sistema*:

CPU: Intel(R) Core(TM) i7-10700 $\ttext(@)$ 2.90GHz
- Sistema: Debian GNU/Linux 12 (bookworm)
- Memória: 94GB
- Cores: 16
- Disco: 907GB

*Garantia de Homogeneidade*:

- Todos os experimentos executados no mesmo ambiente
- Controle de variáveis externas
- Reprodutibilidade dos resultados

== Hiperparâmetros Otimizados

#v(.7em)

*SVM:*

- Kernel: Radial Basis Function (rbf)
- Parâmetro de regularização: $C = 100$
- Máximo de iterações: 10.000
- Alcance de influência: $gamma = 1,0$

*Redes Neurais:*

- Função de ativação: tangente hiperbólica
- Camadas ocultas: 2 (100, 50 neurônios)
- Máximo de iterações: 500

#linebreak()


*Árvore de Decisão:*

- Critério: Entropia
- Profundidade máxima: 10
- Amostras mínimas para divisão: 10

_Os demais parâmetros seguem o padrão das implementações do scikit-learn_

== Resultados do Grid Search

Performance dos Modelos Otimizados:

#figure(
  image("tabela_grid.png"),
  caption: [_Tabela de performance dos modelos com otimização._]
)
// *Observações:*

// - melhor performance e eficiência computacional
// - Diferenças pequenas mas consistentes entre métodos
// - _Trade-off_ claro entre tempo de execução e performance

= Discussão dos Resultados

== SVM

#figure(
  image("hiperplano_svm_2d_3d.png", width: 80%),
  caption: [_Análise de duas e três primeiras componentes principais (PCA)._]
)

#pagebreak()

*Análise de Separabilidade:*
- Baixo grau de separabilidade entre quitadas (1) e não quitadas (0).
- Classe 1 concentra-se em valores positivos de PC1 e PC2

*Largura da Margem:*
- $gamma = 2/norm(w) = 0,0002$
- Confirma quantitativamente a estreita região de separação
- Justifica uso da função RBF (não-linear)

*Limitações:*
- Máximo de 10.000 iterações para evitar treinamento prolongado
- Necessidade de kernel não-linear devido à baixa separabilidade linear

== Redes Neurais (MLP)

#v(.7em)

*Configuração e Convergência:*
- Média de 485 iterações até convergência
- Função de perda final: aproximadamente 0,0856
- Tangente hiperbólica capturou não-linearidades adequadamente

*Análise de Performance:*
- Arquitetura (100, 50 neurônios) foi adequada para modelar complexidade
- Proximidade das iterações com o máximo (500)
- Sugere necessidade de mais iterações ou ajuste na taxa de aprendizado
#pagebreak()
#v(.8em)
*Desafios:*
- Múltiplos hiperparâmetros podem causar flutuações no comportamento
- Alto custo computacional comparado aos demais modelos

#align(center)[
#image("perda.png", width: 62%)
]
== Árvore de Decisão
#v(.7em)
*Performance Robusta:*
- Configuração ótima apareceu em 7 dos 30 folds
- Critério de entropia permitiu divisões mais balanceadas
- Profundidade 10: captura complexidade sem *overfitting* excessivo

*Estabilidade:*
- Desvio padrão: apenas 0,0060
- Mínimo 5 amostras: evita regras muito específicas
- Tempo médio: 0,01s por fold (total: 0,33s)

*Eficiência:*
  - Robustez em Métricas
  - Tempo de excução de 0.37s em 30 folds
// - Melhor relação performance-tempo computacional
// - Melhoria de 0,52% no F1-score em relação ao *baseline*

== Comparação Estatística

#v(.7em)

*Teste de Friedman *($alpha = 5%$):

#v(1em)

#figure(
  image("teste_friedman.png", width: 63%),
  caption: [Resultados Teste de Friedman]
)

#pagebreak()

#v(.7em)

*Matriz de p-valores do teste pareado de Neminyi *($alpha = 5%$):

#figure(
  image("tabela_p_valor_matriz.png", width: 93%),
  caption: [_Resultados dos testes de hipótese usando a acurácia e F1-Score._]
)

// *Diferenças Estatisticamente Significativas:*
// - Árvore de Decisão  ao SVM $(p < 0,0001)$.
// - Árvore de Decisão superior às Redes Neurais $(p < 0,001)$.
// - Redes Neurais superior ao SVM $(p < 0,05)$.

= Trabalhos Relacionado

== Trabalho Relacionado

#v(2em)

+ *Dados*: 326,000 empréstimos _IBRD_ (1980–2018), sendo 18,000 cancelados.
+ *Pré-processamento*: remoção de colunas com muitos faltantes, imputação de juros por país e criação de métricas temporais
+ *Variáveis*: 7 no total (4 numéricas, 3 categóricas), todas com diferenças estatisticamente significativas entre “repaid” e “cancelled”
// + *Desbalanceamento das classes*: classes equilibradas manualmente; baseline Naive Bayes (f1≈0,47)
+ *Modelos*: _Decision Tree_ teve robustez maior que SVC e Gradient Boosting, alcançando acurácia e F1-Score de aproximadamente 0,99.

== Resultado

// #show table.cell.where(y: 0): strong
// #set table(
//   stroke: (x, y) => if y == 0 {
//     (bottom: 0.7pt + black)
//   },
//   align: (x, y) => (
//     if x > 0 { center }
//     else { left }
//   )
// )

#grid(
  columns: 3,
  align: center + horizon,
  table(
    columns: (1fr, 1fr, 1fr),
    inset: 12pt,
    table.header(
      [_Decision Tree_],
      [_Predicted Repaid_],
      [_Predicted Cancelled_]
    ),
    [*_True Repaid_*], [1757], [3],
    [*_True Cancelled_*], [0], [1760],
  ),
  figure(
    image("feature_importance.png", width: 83%),
    caption: [_Features ordenadas por relevância._],
  )
)

// #figure(
//   image("decision_tree_confusion_matrix.png"),
//   caption: [_Matriz de confusão do trabalho relacionado._],
// )

= Conclusões

== Conclusões da Comparação
#v(.7em)

*Ranking Final:*
+ *Árvore de Decisão*: 96,26% (performance robusta + eficiência)
+ *Redes Neurais*: 95,65% (boa performance, alto custo computacional)
+ *SVM*: 95,34% (performance adequada, baixo custo computacional)

*Recomendação:* Árvore de Decisão combina alta acurácia, estabilidade entre folds e eficiência computacional.

*Considerações Finais:*
- Todas as diferenças são estatisticamente significativas
- Interpretabilidade da Árvore de Decisão é vantagem adicional
- Tempo de processamento varia drasticamente entre os métodos

= Obrigado!

== 

#text(size: 18pt)[
  #bibliography(
    "referencias.bib",
    title: "Referências",
    full: true,
    style: "american-chemical-society",
  )
]
