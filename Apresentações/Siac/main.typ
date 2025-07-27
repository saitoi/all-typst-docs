// Typst version: 0.12.0

#import "@preview/codly:1.0.0": *
#import "@preview/touying:0.5.3": *
#import themes.university: *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.1" as fletcher: node, edge
#import "@preview/ctheorems:1.1.2": *
#import "@preview/numbly:0.1.0": numbly

/* ******************** CONFIGURAÇÕES ******************** */

#set text(lang: "pt")
#set math.equation(numbering: "(1)")
#show figure.caption: set text(size: 18pt)

#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let observation = thmplain("observação", "Observação", fill: rgb("#f8f4a6"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: university-theme.with(
  aspect-ratio: "16-9",
 // config-common(handout: true),
  config-info(
    title: [Otimização de Performance em Bancos de Dados],
    subtitle: [Eficiência e Análise em Ambientes Relacionais],
    author: [Pedro Henrique Honorio Saito],
    date: datetime.today(),
    institution: [
      Laboratório de Métodos de Suporte à Tomada de Decisão
      
      Universidade Federal do Rio de Janeiro
    ],
    ),
    config-page(
    header: place(
      bottom + right,
      dx: -26.6cm,
      dy: 14.0cm,
      image("images/lamdec.svg", width: 57pt, height: 60pt)
    )
  )
)

#set heading(numbering: numbly("{1}.", default: "1.1"))
#show: codly-init.with()
#codly(zebra-fill: none, number-format: none)


#let icon = text(size: 1pt, "\u{ebbe}")

#title-slide()

/* ******************** SLIDES ******************** */

// Mencionar que o Matheus já comentou..
// 
== Outline <touying:hidden>

#components.adaptive-columns(outline(title: [Sumário], indent: 1em))

= Introdução

== Contexto

#v(14pt)

// Falar brevemente aqui sobre score 
// Cópia do Banco de Dados primeira
// Objetivo final: Alimentar um dashboard como ferramenta de tomada de decisão dos procuradores
// Resumo introdutório do Paulo

_Resumo :_ O LAMDEC, em parceria com a Procuradoria Geral do Município do Rio de Janeiro (PGM),
desenvolveu um projeto para *analisar* e *classificar* devedores, otimizando a
gestão das Certidões de Dívida Ativa (CDAs).

#v(13pt)

As *Certidões de Dívida Ativa* formalizam débitos públicos, viabilizando cobranças administrativas ou judiciais.

#v(24pt)

// Falar sobre a quantidade de CDAs em cada uma dessas categorias
// Processo de Filtragem dos Dados
// Explicar que IVVC significa, que TAP e TIS não estão sendo trabalhadas

#align(center)[
#grid(
    columns: 4,
    gutter: 5em,
    [
      *IPTU*
      
      *ISS*
    ],
    [
      *ITBI*

      *IVVC*
    ],
    [
      *TAXAS*

      *MULTAS*
    ],
    [
      *TAP*
  
      *TIS*
    ]
)
]

#pagebreak()

#v(20pt)

O ciclo de vida das CDAs é extenso e não linear, geralmente abrange as seguintes *situações*:

#v(43pt)

#align(center)[
#grid(
    columns: 3,
    gutter: 5em,
    [
      // CDA é formalizada após a dívida pública não ter sido quitada a tempo
      *INSCRITA*

      // Tentativa de recuperação do crédio por meio de cobranças administrativas
      *COBRANÇA*

      // Devedor e credor podem chegar a um acordo para regularização da dívida
      *NEGOCIADA*

      *PARCELADA*
    ],
    [
      *IRREGULAR*
      
      *PAGA*
      
      // Encerramento Formal da dívida
      *QUITADA*

      // Cobrança é interrompida temporariamente
      *SUSPENSA*
    ],
    [
      // CDA é invalidada, decisão administrativa ou erro
      *CANCELADA*
      
      // Extinta
      *EXTINTA*
      
      // Bens do devedor são arrematados em leilão
      // No caso do IPTU seriam os imóveis
      *ARREMATAÇÃO*

      // Bens do devedor foram leiloados
      *LEILOADA*
   ]
)
]

#pagebreak()

#v(20pt)

O processo, por sua vez, de cobrança passa por diferentes *fases*:

#v(111pt)

#align(center)[
#grid(
    columns: 3,
    gutter: 5em,
    [
      *AMIGÁVEL*
    ],
    [
      *PROTESTO*
    ],
    [
      *JUDICIAL*
    ],
)
]

#v(60pt)

#align(center)[
*EXECUÇÃO FISCAL*
]

#pagebreak()

#v(20pt)

Os devedores são distribuídos entre *Pessoa Física* ou *Pessoa Jurídica*, identificados, respectivamente, pelo *CPF* e *CNPJ*.

// Falar que vai explicar melhor depois
#v(58pt)

#align(center)[
  #block(
    width: 67%,
    height: 91pt,
    stroke: 2pt + black,
    inset: 19pt,
    [
  _Problema :_ Uma pequena parcela das CDAs possuem devedores atrelados.
    ]
  )
]

== Banco de Dados

#v(12pt)

// Sistemas transacionais pro processamento cotidiano da empresa
O banco de dados da procuradoria é relacional, proprietário e orientado ao *Processamento
de Transações Online (OLTP)*, sistemas transacionais destinados ao processamento
cotidiano da empresa.

// Focado em operações concorrentes realizadas por múltiplos usuários

#v(37pt)

#align(center,
       block(
         width: 100%,
         scale(200%, $ arrow.b.filled $)
       ))
       
#v(37pt)

Banco de dados orientado ao *Processamento Analítico Online (OLAP)*. Sistemas OLAP são projetados para análises complexas em grandes volumes de dados, focando em consultas agregadas e tomadas de decisões.

= Problemas

== Banco de Dados

#v(14pt)

// Banco de Dados Mal-estruturado, relacionamentos N-N

// Redundância
- Normalização Irregular das Tabelas

// Associação entre identidade <-> CDA
- Relacionamentos `N-N` entre identidades, CDAs e nomes dos devedores.

- Armazenamento de identificadores (CPF/CNPJ) como `BIGINT`.

// Excesso de índices não clusterizados, redundantes
- Desconhecimento de técnicas de *indexação.*

- `HistoricoCDA` : Tabela com mais de 500 milhões de tuplas.

#v(19pt)

#align(center)[
#grid(
    columns: 2,
    gutter: 5em,
    [
      `BARRA DA TNECTIOIJUCA`
    ],
    [
      `1905`
    ]
)
]

#v(24pt)

#align(center)[
  `LEOPOLDINA ESTEVES`
]

== Consulta

#text(size: 16.81pt)[
    ```sql
SELECT 
  HistoricoCDA.numCDA, 
  MAX( CASE WHEN codSituacaoCDA IN (6, 95) THEN 1 ELSE 0 END ) AS fg_historico_leilao, 
  MAX( CASE WHEN codSituacaoCDA IN (7, 96) THEN 1 ELSE 0 END ) AS fg_historico_parcelada, 
  MAX( CASE WHEN codSituacaoCDA IN (10, 94) THEN 1 ELSE 0 END ) AS fg_historico_suspensa, 
  MAX( CASE WHEN codSituacaoCDA IN (16) THEN 1 ELSE 0 END ) AS fg_historico_arrematacao, 
  MAX( CASE WHEN codSituacaoCDA IN (30) THEN 1 ELSE 0 END ) AS fg_historico_negociada, 
  MAX( CASE WHEN codSituacaoCDA IN (45) THEN 1 ELSE 0 END ) AS fg_historico_parcelamento_irregular 
INTO lamdec.t_historico_cda_iptu
FROM HistoricoCDA 
LEFT JOIN lamdec.t_tableaux3_iptu tt3
  on tt3.numCDA = HistoricoCDA.numCDA
WHERE tt3.numCDA IS NULL
GROUP BY HistoricoCDA.numCDA;
    ```
]

#pagebreak()

#v(21pt)

Vamos analisar a consulta mais de perto..

#pause

- Variáveis acessadas: `numCDA` e `codSituacaoCDA`.

- Uso em excesso de `JOINS`.

- Função de agregação `MAX()` e condicional `CASE WHEN`.

- "Anti-Join" com `t_tableaux3_iptu`.

#pause

#v(10pt)

*Soluções*

- Filtragem prévia dos dados.

- Índice clusterizado na coluna `numCDA`

= Solução

== Remodelamento do Banco de Dados

#v(22pt)

// CDAs desmembradas
- Tratamento de Nulos e datas inconsistentes.
// Memoização
- Criação de um esquema analítico.

- Eleição do campo `numCDA` para indexação das consultas.

- Técnica de *memoização*.

- Geração de tabelas intermediárias.

- Agendador de processos.

- Informações da *Serpro.*

// Tabelas Intermediárias

== Aplicação Final

#figure(
  image("images/OLTP-to-OLAP.png"),
  caption: []
)
