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

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Apache Nifi #box(image("nifi-logo.png", width: 9%))],
    subtitle: [Automação e Integração de Dados],
    author: [Pedro Saito e Milton Salgado],
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

== Outline <touying:hidden>

#components.adaptive-columns(outline(title: [Sumário], indent: 1em))

= Introdução

== História

#v(.7em)

_Contexto:_ O Apache Nifi foi inicialmente desenvolvido pela *NSA* (_National Security Agency_) em 2006, anteriormente conhecido por _"NiagaraFiles"_, para ser uma ferramenta de *automação de fluxo de dados*. 

Em 2014, o projeto foi incorporado pelo *Apache Software Foundation* como um projeto _Open Source_.

Baseado no paradigma *FBP* (_Flow-Based Programming_).

#v(1em)

#align(center)[
#grid(
    columns: 3,
    column-gutter: 4em,
    [
      #text(size: 1.2em,fill: rgb(236, 186, 1), weight: "bold")[#sym.star.filled] 5.4k *Github*
    ],
    [
      510 *Contribuintes*
    ],
    [
      #text(fill: rgb(100, 50, 0), weight: "bold")[#emoji.coffee #h(5pt) Java 21]
    ]
)
]

#pagebreak()

== Definição

#v(.7em)

Ferramenta _low-code_ de automação de fluxo de dados em tempo real (_streaming data_).

*Plataforma primária*: Aplicação Web *Nativa (Java 21)* ou *Docker*. 

// *PLATAFORMA PRIMÁRIA: BROWSER* - Interface web intuitiva para criação visual de fluxos.

// *Garantias:* Baixa latência, alta vazão (performance), alta banda em prioridade.

Casos de uso principais:

- Workflows moderados de ETL (_real time_ ou _event-driven_).

- Processos interconectados e em constante mudança.

- Migração de dados entre sistemas legados e modernos

- Sincronização de bancos de dados em tempo real

#pagebreak()

== Funcionalidades

#v(.7em)

- Gerenciamento de múltiplos usuários com diferentes permissões.

- *Data Lineage*: Monitoramento e rastreabilidade dos dados 

- Subir uma instância no _Tailscale_ para uso interno.

- *Tolerância a falhas* com retry automático e dead-letter queues.

- *Escalabilidade horizontal* com clustering gerenciado pelo ZooKeeper.

#v(20pt)

#align(center)[
  #text(blue)[#underline[https://localhost:8443/nifi/]]
]

#pagebreak()

== Automatização de Tarefas

#v(.7em)

O Apache NiFi automatiza diversas tarefas críticas:

#grid(
    columns: 2,
    column-gutter: 2.1em,
    [
      *Cibersegurança*#linebreak()
      Coleta de logs de segurança
      Correlação de eventos suspeitos
      Análise de tráfego real
      #v(1.26em)
      *Observabilidade*#linebreak()
      Métricas agregadas#linebreak()
      Logs em tempo real#linebreak()
      Dashboards automáticos#linebreak()
      // Monitoramento de SLA //??
    ],
    [
      *Compliance e Auditoria*
      Rastreamento de dados sensíveis#linebreak()
      Relatórios automáticos#linebreak()
      Políticas de retenção#linebreak()
      Conformidade LGPD/GDPR
      
      *Detecção de Anomalias*
      Análise de padrões em transações#linebreak()
      Comportamentos anômalos#linebreak()
      Integração com ML models#linebreak()
      Alertas em tempo real#linebreak()
    ]
)

= Componentes

== Terminologia

#v(.7em)

- _*Dataflow Manager*_ : Usuário Nifi com permissões para adicionar, remover ou modificar os componentes do _Nifi Flow_.

- *FlowFile*: Unidade básica de dados. Composta pelos _Attributes_ (metadados) e o _Content_ (conteúdo). Principais metadados:

  - *UUID*: Identificador único universal de 128 bits (RFC 4122 do IETF).

  - *Filename*: Nome do arquivo/dado.

  - *Path*: Diretório estruturado para armazenamento no disco ou serviço externo.

#pagebreak()

#v(.7em)

- *Processor*: Componente lógico básico responsável pelas tarefas:

  - Exemplos de _Processors_: `GetFile`, `PutFile`, `ExecuteSQL`, `InvokeHTTP`, `ReplaceText`, `UpdateAttribute`, `LogAttribute`, `RouteOnAttribute`.
  
#grid(
    columns: 3,
    column-gutter: 4em,
    [
      *Ingestão*
      // (ou do próprio fluxo)
    ],
    [
      *Transformação*
      // de dados
    ],
    [
      *Roteamento*
      // do FlowFile
    ]
)

- *Relacionamentos*: Cada processador pode ter zero ou mais relacionamentos definidos. Saída lógica do processador (#text(fill: green, weight: "bold")[Success] ou #text(fill: red, weight: "bold")[Failure]). Após o término do processamento, o FlowFile deve ser roteado/transferido para outro componente escolhido pelo DataFlow Manager.

#pagebreak()

#v(.7em)

- *Canvas*: Interface visual primária para o _design_, gerenciamento e monitoramento dos _dataflows_.

- *Conexão*: Componente "físico" que interliga quaisquer dois elementos do _dataflow_ (sobretudo _Processors_). Ligação física entre 2 componentes do fluxo de dados.

- *Bulletin*: Os componentes podem reportar _bulletins_, isto é, equivalente a mensagens de _logs_ com tempo e nível de severidade (_Debug_, _Info_, _Warning_ e _Error_).

#pagebreak()

#v(.7em)

- *Controller Service*: Componente que provê funcionalidades e configurações para outros elementos (sobretudo _Processors_).

  - *Exemplo*: `DBCPConnectionPool` fornece serviço de pool de conexões para um ou mais processadores. Propriedades obrigatórias:
  
    - *Database Connection URL*: `jdbc:sqlserver://ip;port;db`
    
    - *Database Driver Class Name*: com.Microsoft.sqlserver.jdbc.SQL
    
    - *Driver's Path*: `~/mssql-drivers/ptb/jars`

    - *Database User & Password*: sa \*\*\*\*

#pagebreak()

#v(.7em)

- *Funnel*: Componente que permite combinar dados de diferentes conexões em uma só.

- *Process Group*: Agrupamento lógico de _Processors_ para facilitar o gerenciamento do _dataflow_.

- *Remote Process Group*: Transferência de dados (_FlowFiles_) para uma instância remota do _Nifi_.

- *Reporting Tasks*: Tasks executadas no _background_ que providenciam relatórios de utilização e monitoramento da instância _Nifi_.

  - Exemplos: `MonitorDiskUsage`, `MonitorMemory`.

= Aplicação

== Exemplo

#figure(
  image("nifi-dataflow-example.png", width: 93%),
  caption: [_Fluxo de consulta do `base64`, decodificação e extração de texto_.],
)

#align(center)[
#box(
  text(size: 16.81pt)[
      ```sql
      SELECT TOP 10 base64encode
      FROM [pgmconsultaprocesso].[dbo].[documentos]
      WHERE
          sucesso = 1
      AND ext = '.pdf'
      ```
  ],
  width: 56%
)
]

#align(
  left,
  block(
    width: 100%,
    scale(200%, $ arrow.b.filled $)
  )
)

#align(center)[
  #block(
  fill: luma(230),
  inset: 8pt,
  radius: 5pt,
  text[*Base64* #box(scale(122%, $med arrow.r med$)) *Binary*],
  )
  
]

#align(
  left,
  block(
    width: 100%,
    scale(200%, $ arrow.b.filled $)
  )
)

// Apache Tika: Ferramenta de extração de texto e metadados de uma variedade de docs
// Exs.: Markup (HTML, XML, RTF), Microsoft (docx, xlsx, pptx), Portáveis (PDF, EPUB), 
//       Estruturado (CSV, TSV), Imagens (JPEG, PNG, TIFF), Audio (MP3, MP4, WAV)
#align(center)[
  #image("tika-logo.png", width: 20%)
]

= Códigos

== Scripts

Dois _Processors_ primordiais para execução de comandos externos:

- *ExecuteScript*: Executa scripts em linguagens como Python, Groovy, JavaScript diretamente no processador.

- *ExecuteStreamCommand*: Passa o conteúdo do _FlowFile_ como input, executa uma série de comandos arbitrários e retorna o resultado da transformação.

#figure(
  box(
  text(size: 18.23pt)[
      ```python
import sys, json
from datetime import datetime
data = json.load(sys.stdin)
data['modificada_em'] = datetime.utcnow().isoformat()
json.dump(data, sys.stdout)
      ```
  ], width: 65%
  ),
  caption: [_`ExecuteStreamCommand` para adicionar metadado datetime._]
)

== _Custom Processors_

#v(.7em)

Na ausência de _Processors_ que cumprem a tarefa desejada, pode-se definir seus próprios _Processors_ em #text(fill: red, weight: "bold")[Java] e importá-los no _dataflow_.

#box(
  text(size: 10.23pt)[
      ```java
public class ExampleProcessor extends AbstractProcessor { 
  public static final Relationship REL_FAILURE = new Relationship
    .builder()
    .description("Failed processing")
    .name("failure")
    .build();

  public static final Relationship REL_SUCCESS = new Relationship
      .builder()
      .description("Succeed processing")
      .name("success")
      .build();
  
  @Override
  public Set<Relationship> getRelationships() {
      return new HashSet<>() {{
          add(REL_FAILURE);
          add(REL_SUCCESS);
      }};
  }
}
      ```
  ],
  width: 56%
)#box(scale(234%, $quad arrow.r.filled $), height: 7em)#h(2em)#box(".Nar (Nifi Archive)", height: 6.82em)

= Comparações

== Airflow

#v(.7em)

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { center }
    else { left }
  )
)

#align(center)[
  #table(
    columns: (1fr, 1fr, 1.4fr),
    row-gutter: 10pt,
    column-gutter: 1pt,
    table.header(
      [Atributos],
      [Apache Nifi],
      [Apache Airflow],
    ),
    [*Interface*], [GUI _Drag-and-Drop_], [Código Python (DAGs)],
    [*Escalabilidade*], [Cluster horizontal], [Executors],
    [*Periodicidade*], [_Event-Driven_], [Time-based schedules],
    [*Utilização*], [Interface Gráfica], [Python _script_],
    [*Monitoramento*], [_Provenance events_], [Logging + interface],
    [*Concorrência*], [Back-pressure, priorização, load-balancing entre nós], [Execução paralela via Executors (Celery, Kubernetes, Local)],
    [*Data Handling*], [_FlowFiles_ com conteúdo + atributos; streaming ou micro-batch], [Task outputs persistidos (XComs, arquivos, databases); principalmente batch],
    [*Failure Handling*], [Retry automático, dead-letter queues, rastreamento de proveniência], [Políticas de retry por task, alertas SLA, intervenção manual],
  )
]

== Desvantagens

#v(.7em)

- *Reproducibilidade*: Dificuldade para copiar um _workflow_ de uma instância do _Nifi_ para outra. É preciso recriar cada componente manualmente.

- *Dinamidicidade*: Dificuldade na modelagem de _dataflows_ que se ajustam constantemente (mais complexos).

  - Exemplo: SQL Dinâmico.

- *Depuração*: Herda características do paradigma *FBP* que concebem os _Processadores_ como #underline[caixas pretas]. Em algum momento será preciso olhar por de trás dos panos.

// #pagebreak()

// #v(.7em)

// - *Computação Intensiva*: Não é ideal para processamento batch pesado ou treinamento de modelos ML.

// - *Workflows Simples*: Pode ser excessivo para fluxos de dados muito simples e estáticos. 

== Vantagens

#v(.7em)

- *Facilidade no Uso*: Interface simples para construção de fluxos "comuns", desde que não exigem funcionalidades externas.

- *Escalabilidade Horizontal*: _Deploy_ de um Cluster de servidores do _Nifi_ geridos pelo _ZooKeeper_.

- *Variedade das Fontes de Dados*: Variedade razoável de _Processors_ para ingestão de dados.

  - Exemplos: Sistemas de Arquivo, Banco de Dados, APIs e Protocolos de Transferência, E-mail, Serviços de Streaming como Kafka.

- *Processamento em Tempo Real*: Event-driven com baixa latência e alta performance.

#pagebreak()

#v(.7em)

- *Data Lineage Completo*: Rastreabilidade total dos dados para compliance e auditoria.

- *Tolerância a Falhas*: Recuperação automática e gerenciamento de erros robusto.

- *Governança de Dados*: Controle granular de acesso, segurança e políticas de dados.

#pagebreak()

== Quando Usar NiFi

#v(.7em)

#grid(
    columns: 2,
    column-gutter: 3em,
    [
      *#sym.checkmark Ideal para:*#linebreak()
      Fluxos complexos e dinâmicos#linebreak()#v(-8pt)
      Rastreabilidade completa#linebreak()#v(-8pt)
      Processamento em tempo real#linebreak()#v(-8pt)
      Integração de múltiplas fontes#linebreak()#v(-8pt)
      Equipes não-técnicas#linebreak()#v(-8pt)
      Workflows _event-driven_
    ],
    [
      *#sym.crossmark Não recomendado para:*#linebreak()
      Transformações complexas#linebreak()#v(-8pt)
      Processamento batch pesado#linebreak()#v(-8pt)
      Computação intensiva#linebreak()#v(-8pt)
      // Projetos com recursos limitados#linebreak()#v(-8pt)
      Modelagem com DAGs é preferível#linebreak()#v(-8pt)
      // - Workflows simples e estáticos
    ]
)

== Tchau

#v(.8em)

#figure(
  image("niagara-falls.png", width: 64%),
  caption: [_Niagara falls._]
)



// Essa parte daqui não existe na real kk

// = Solução

// == Aplicação Final

// #v(.7em)

// *Principais benefícios da solução:*

// - *Monitoramento em tempo real* do pipeline de dados
// - *Escalabilidade automática* baseada no volume de dados
// - *Recuperação automática* em caso de falhas
// - *Auditoria completa* de todas as transformações
// - *Interface visual* para modificações rápidas do fluxo
