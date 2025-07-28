#import "@preview/codly:1.0.0": *
#import "lib.typ": *
#import "@preview/timeliney:0.1.0"

/* ************************************* CODLY SETTINGS ************************************* */

#set par(
  first-line-indent: 1em,
  spacing: 1.6em,
  justify: true,
  linebreaks: "optimized"
)

#show: codly-init.with()

#codly(
  languages: (
    c: (
      name: "C",
      color: rgb("#FED766")
    ),
    txt: (
      name: "text",
      color: rgb("#8C8A93")
    )
  )
)

#codly(
  zebra-fill: none
)

/* ************************************* GENERAL SETTINGS ************************************* */

#show outline.entry.where(
  level: 1
): it => {
  v(20pt, weak: true)
  strong(it)
  v(-5pt, weak: true)
}

#show: project.with(
  title: "Implementação de um Escalonador de Processos utilizando o Algoritmo Round-Robin com Feedback",
  subtitle: "Trabalho 1 - Relatório Técnico",
  authors: (
    "Pedro Saito: 122149392",
    "Halison Souza: ",
    "Allan Kildare"
  ),
  mentors: (
    "Valeria Menezes Bastos",
  ),
  branch: "Arquitetura de Computadores e Sistemas Operacionais",
  university: "Universidade Federal do Rio de Janeiro",
  academic-year: "2024",
  footer-text: "RELATÓRIO",
  school-logo: image("images/ufrj-logo.svg")
)

#set text(lang:"pt")

#set footnote(numbering: "1")

/* ************************************* GLOBAL VARS ************************************* */

#let QUANTUM = 3
#let MAXIMO_PROCESSOS = 5
#let TEMPO_MIN_CPU = 3
#let TEMPO_MAX_CPU = 16
#let TEMPO_MAX_CHEGADA = 10

// Operações de IO
#let TEMPO_DISCO = 2
#let TEMPO_FITA = 3
#let QUANTIDADE_TIPOS_IO = 3
#let TEMPO_IO_PADRAO = -1

#let MAX_LINHA = 100
#let NUM_FILAS = 4

/* ************************************* INTRODUÇÃO ************************************* */

= Introdução

Nos sistemas operacionais modernos, o escalonamento de processos é responsável
por determinar qual dos *processos*, ou programas em execução, receberá a
próxima fatia de tempo da UCP (Unidade Central de Processamento). Esse mecanismo
é primordial para a distribuição equitativa dos recursos do processador,
evitando que processos monopolizem a UCP e, consequentemente, prevenindo a
_starvation_ — situação em que um processo é continuamente negado os recursos
necessários para sua execução, frequentemente devido a concorrência com
processos mais prioritários. @stallings2010

Para mitigar esse problema, utilizam-se algoritmos que determinam a alocação de
curto prazo de todos os processos prontos para a execução. Tais abordagens visam
maximizar a utilização da UCP, sendo fundamentais no contexto de
multiprogramação. Nesse sentido, é necessário compreender as particularidades
das diferentes metodologias de escalonamento e suas características. @amit2023

== Objetivos

O presente estudo tem como objetivo simular o algoritmo de escalonamento
Round-Robin com feedback, também conhecido como escalonamento circular, no contexto de realização de operações de entrada e saída em ambientes de tempo compartilhado.

Especificamente, estamos interessados em:

#block(
  above: 0.5em,
  below: 0.5em,
  inset: 1em,
  [
    - Implementar um simulador do escalonador Round-Robin com feedback, incorporando filas de diferentes prioridades e operações de entrada e saída.
    - Detalhar cada componente de código desenvolvido, explicando as estruturas e funções utilizadas na implementação.
    - Promover fins didáticos, facilitando a compreensão do algoritmo e demonstrando sua aplicação na prática no gerenciamento de processos.
  ]
)

Ao final, espera-se demonstrar a eficácia e funcionamento desse algoritmo de escalonamento, demonstrando sua relevância na gestão de processos e otimização dos recursos do sistema.

#pagebreak()

/* ************************************* PREMISSAS ************************************* */

== Premissas

Para o desenvolvimento do simulador, foram estabelecidas algumas premissas, listadas a seguir:

- *Limite Máximo de Processos Criados* (`MAX_PROCESSOS`): Define-se um limite máximo de #MAXIMO_PROCESSOS processos que podem ser criados, independentemente de seu estado. Cada processo recebe um identificador único (`PID`), variando entre 0 e `MAX_PROCESSOS`-1.

- *Fatia de Tempo* (`QUANTUM`): Define-se uma fatia de tempo de #QUANTUM unidades de tempo para cada processo em execução.

- *Tempos de Serviço Máximo e Mínimo* (`TEMPO_CPU_MAX`, `TEMPO_CPU_MIN`): Estabelece o intervalo de duração para a execução de cada processo, com valores máximo e mínimo de #TEMPO_MAX_CPU e #TEMPO_MIN_CPU unidades de tempo, respectivamente.

- *Tempo de Chegada Máximo* (`TEMPO_CHEGADA_MAX`): Define o limite superior de #TEMPO_MAX_CHEGADA unidades de tempo para a chegada dos processos no sistema.

*Especificação das Operações de Entrada e Saída*: Implementamos dois tipos de dispositivos de I/O, especificados abaixo:

  - *Disco* (`TEMPO_DISCO`): Define-se o tempo máximo para a operação de disco na variável `TEMPO_DISCO`, que corresponde a #TEMPO_DISCO unidades de tempo. Após essa operação, o processo retorna para a fila de baixa prioridade.

  - *Fita magnética*: Define-se o tempo máximo para a operação de fita magnética na variável `TEMPO_FITA`, que corresponde a #TEMPO_FITA unidades de tempo. Após essa operação, o processo retorna para a fila de alta prioridade.

  - *Tempo de entrada e saída padrão* (`TEMPO_IO_PADRAO`): Inicializado como #TEMPO_IO_PADRAO para processos sem operações de entrada e saída.

Para assegurar a eficiência e o controle dos processos, adotamos as seguintes medidas de escalonamento:

  - *Definição do PID* (`processo.pid`): O identificador único do processo, também conhecido como `PID`, pode ser atribuído de duas formas dependendo da escolha do usuário no menu:

    +  *Importação Manual de Dados*: Ao importar dados de um CSV, o usuário deve fornecer o `PID` manualmente, com validação para evitar duplicidade ou inconsistência.

    + *Geração Automática de Dados*: Na geração aleatória, o `PID` é atribuído de forma incremental à medida que cada processo é criado.

- *Filas do Escalonador*: O escalonador possui quatro filas, divididas em duas de prioridades — alta e baixa — e duas filas individuais para as operações de entrada e saída de disco e fita.

- *Ordem de Entrada na Fila de Prontos*: A ordem prevista para a entrada de processos está descrita abaixo:

    1. Processos recém-chegados entram na fila de alta prioridade.
    2. Processos que retornaram de operações de entrada/saída.
    3. Processos que sofreram preempção retornam para a fila de baixa prioridade.

*Observação*: Se um processo concluir uma operação de disco e retornar no mesmo instante em que outro processo sofreu preempção, excepcionalmente, o processo preemptado virá à frente na fila de baixa prioridade em relação ao processo que retornou do I/O.

Por fim, implementamos uma série de premissas adicionais que, embora não tenham
sido especificadas na descrição original do trabalho, são importantes para o
funcionamento do escalonador:

/* REVISE ISSO AQUI */

- *Requisições de Operações de Entrada e Saída*: Estabelecemos as seguintes limitações:

    - Um processo não pode realizar duas operações de entrada e saída simultaneamente.
    - Um processo não pode solicitar uma operação de entrada e saída no seu *último instante de execução*, apenas no penúltimo se for o caso.
    - Um processo não pode repetir a mesma operação de entrada e saída.

- *Leitura de Arquivo CSV*: Ao importar processos de um arquivo CSV, implementamos validações para garantir a consistência dos dados e evitar erros de execução. As verificações incluem:

    - Detecção de caracteres inválidos em campos numéricos.
    - Remoção de linhas em branco e caracteres especiais.
    - Identificação de valores fora dos limites permitidos para cada campo (por exemplo, instante de chegada negativo).
    - Número máximo de caracteres por linha (`MAX_LINHA`): Define-se o número máximo permitido de caracteres por linha do CSV como #MAX_LINHA.

/* ************************************* ALGORITMO ************************************* */

= Algoritmo

O algoritmo de escalonamento Round-Robin é um dos métodos preemptivos
#footnote[O sistema operacional pode interromper um processo em execução para
alocar a UCP a outro.] mais amplamente empregados no escalonamento de processos
e redes na computação. Essa abordagem concede a cada processo uma fatia de tempo
estática de forma cíclica, sendo considerado _starvation free_,  impedindo que
qualquer processo seja permanentemente preterido em favor de outros. É popular
em sistemas de tempo compartilhado e multitarefa, onde vários processos precisam
ser executados simultaneamente. @singh2010

== Funcionamento

Antes de descrever o processo de escalonamento, precisamos realizar uma série de hipóteses, listadas a seguir:

    + O conjunto de tarefas consistem em processos executáveis aguardando a UCP.    
    + Todos os processos são independentes e competem por recursos.
    + A função do escalonador é alocar de forma justa os recursos limitados da UCP aos diferentes processos de modo a otimizar algum critério de desempenho. @zouaoui2019

// Descrição do Algoritmo de Round-Robin Simples

Com base nisso, passamos a detalhar os fundamentos do algoritmo de escalonamento Round-Robin:

- Os processos são organizados em uma fila circular seguindo a ordem de chegada.
- Cada processos recebe uma fatia de tempo fixa (_Time Slice_) para execução.
- Ao término da fatia de tempo atribuída, o processo é interrompido, retornando para o fim da fila, permitindo que os demais processos sejam executados.

// Descrição do Algoritmo de Round-Robin + Múltiplas Filas de Feedback

No entanto, o objetivo desse projeto é simular o Round-Robin com _feedback_, isto é, uma variação do algoritmo Round-Robin que ajusta dinamicamente os processos segundo o tempo solicitado de UCP. Nesse sentido, a fila de _feedback_ multinível estende o escalonamento padrão com os seguintes requisitos:

- Classificar os processos em múltiplas filas de prontos conforme a demanda da UCP.
- Priorizar processos de curta duração (_CPU-Bound_).
- Priorizar processos com elevados períodos de E/S (_IO-Bound_) .

Na prática, isso implica que, ao esgotar sua fatia de tempo, um
processo é removido fila atual e transferido para uma fila de prioridade mais
baixa. Em nossa implementação, utilizamos apenas duas filas: uma de alta
prioridade, onde os processos novos são inseridos, e outra de baixa prioridade,
na qual os processos aguardam a conclusão dos anteriores para sua execução.

Um processo pode realizar operações de entrada e saída, interrompendo-se até sua conclusão. Nesse período, ele é movido para a fila de espera, liberando a UCP para outros processos. Após a operação, o processo retorna à fila de alta ou baixa prioridade. Foram implementadas duas filas de entrada e saída: Fita magnética e Disco.

// Exemplo Prático

Aqui está um exemplo prático de funcionamento do algoritmo, que veremos posteriormente na impressão do escalonamento. Considere a seguinte tabela de processos:

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.5pt + black)
  },
  align: (x, y) => (
    if x == 0 { center }
    else { center }
  )
)

#table(
  columns: 4,
  table.header(
    [*PID*],
    [*Tempo de Início*],
    [*Tempo de Serviço*],
    [*E/S (Tempo de Início)*]
  ),
  [P0],[3],[3],[Vazio],
  [P1], [1], [5], [Fita (1)],
  [P2], [2], [3], [Disco (1)],
  [P3], [0], [5], [Fita (3)]
)

Aqui está o gráfico correspondente, criado com base no nosso escalonador:

#figure(
  timeliney.timeline(
    show-grid: true,
    {
      import timeliney: *

      // Header with time instants from 0 to 15
      headerline(group(([*Tempo*], 16)))
      headerline(
        group(..range(16).map(n => strong(str(n))))
      )

      // Processes
      taskgroup(title: [*P0*], {
        task("E", (5, 8), style: (stroke: 2pt + blue))
        task("A", (3, 5), style: (stroke: 2pt + gray))
      })

      taskgroup(title: [*P1*], {
        task("E", (3, 4),(10, 13),(15, 16), style: (stroke: 2pt + blue))
        task("IO", (4, 9), style: (stroke: 2pt + green))
        task("A", (9, 10),(13,15), style: (stroke: 2pt + gray))
      })

      taskgroup(title: [*P2*], {
        task("E", (4, 5),(13, 15), style: (stroke: 2pt + blue))
        task("IO", (5, 7), style: (stroke: 2pt + green))
        task("A", (7, 13), style: (stroke: 2pt + gray))
      })

      taskgroup(title: [*P3*], {
        task("E", (0, 3),(8, 10), style: (stroke: 2pt + blue))
        task("IO", (3, 6), style: (stroke: 2pt + green))
        task("A", (6, 8), style: (stroke: 2pt + gray))
      })

      // Milestones indicating process completion
      milestone(
        at: 8,
        style: (stroke: (dash: "dashed")),
        align(center, [
          *P0 fim*
        ])
      )

      milestone(
        at: 15,
        style: (stroke: (dash: "dashed")),
        align(center, [
          *P1 fim*
        ])
      )

      milestone(
        at: 14,
        style: (stroke: (dash: "dashed")),
        align(center, [
          *P2 fim*
        ])
      )

      milestone(
        at: 10,
        style: (stroke: (dash: "dashed")),
        align(center, [
          *P3 fim*
        ])
      )
    }
  ),
  caption: [
    "Linha azul: Execução (E); linha verde: E/S (IO); Linha cinza: Aguardando."
  ]
)

/* ************************************* CODING ************************************* */

= Código

Nesta seção, descrevemos a implementação do simulador do escalonador Round-Robin com feedback, incluindo estruturas de dados, arquivos de cabeçalho e funções principais. O código em C segue práticas de modularidade e simplicidade.

== Organização do Projeto

O projeto tem quatro arquivos de cabeçalho, cada um com um arquivo `.c` correspondente, exceto o `main.c`. As funções estão declaradas nos arquivos de cabeçalho. Abaixo está a estrutura do projeto:

#codly-disable()
```txt
├── LICENSE
├── Makefile
├── README.md
├── include
│   ├── escalonador.h
│   ├── fila.h
│   ├── interface.h
│   ├── processo.h
│   └── utilitarios.h
├── main
├── processos.csv
└── src
    ├── escalonador.c
    ├── fila.c
    ├── interface-pretty.c
    ├── interface.c
    ├── main.c
    ├── processo.c
    └── utilitarios.c
```
#codly-enable()

Os diretórios e arquivos do projeto estão organizados da seguinte forma:

- *`include/`*: Arquivos de cabeçalho (`.h`).

    - `utilitarios.h`: Funções auxiliares.
    - `escalonador.h`: Funções do escalonador.
    - `fila.h`: Funções para filas.
    - `interface.h`: Interface com o usuário.
    - `processo.h`: Funções dos processos.

- *`src/`*: Arquivos de implementação (`.c`).

    - `utilitarios.c`: Implementação das funções auxiliares.
    - `escalonador.c`: Implementação do escalonador.
    - `fila.c`: Implementação das filas.
    - `interface.c`: Implementação da interface.
    - `interface-pretty.c`: Implementação da interface com caracteres Unicode.
    - `processo.c`: Implementação dos processos.
    - `main.c`: Função principal.

== Estruturas e Enumerações

Durante a implementação do escalonador, foram definidas estruturas de dados que
representam os processos, filas e operações. Além disso, enumerações foram
aplicadas para padronizar estados e tipos, facilitando a manipulação e leitura
de código.

Abaixo, entro em detalhes sobre cada uma das estruturas e enumerações utilizadas.

=== Lista de Processos

A estrutura `ListaProcessos` engloba as estruturas de processos e aloca uma
quantidade fixa de processos, isto é, `MAXIMO_PROCESSOS`. Contém as seguintes
variáveis:

#table(
  columns: (1fr, auto),
  align: (left, left),
  table.header([Variável], [Descrição]),
  [*`processos`*], [Vetor de `Processos` com até `MAXIMO_PROCESSOS`.],
  [*`quantidade`*], [Nº de processos alocados.],
)

=== Processo

A estrutura `Processo` representa um processo no escalonamento, contendo as seguintes variáveis:

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  table.header([Variável], [Descrição]),
  [*`pid`*], [ID do processo.],
  [*`instante_chegada`*], [Instante de criação.],
  [*`tempo_cpu`*], [Duração requisitada.],
  [*`tempo_turnaround`*], [Tempo total no sistema.],
  [*`tempo_quantum_restante`*], [Tempo até preempção.],
  [*`tempo_cpu_restante`*], [Processamento restante.],
  [*`tempo_cpu_atual`*], [Processamento atual.],
  [*`num_operacoes_io`*], [Nº de operações I/O.],
  [*`tipo_io_atual`*], [Tipo de I/O (0: Disco, 1: Fita).],
  [*`operacoes_io`*], [Vetor de I/O.],
  [*`status_processo`*], [Status do processo.],
)

=== Operações de Entrada e Saída

A estrutura `OperacaoIO` representa uma operação de entrada, possuindo as seguintes variáveis:

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  table.header([Variável], [Descrição]),
  [*`tipo_io`*], [Enum com tipos de I/O.],
  [*`presente`*], [Flag: 1 para presente, 0 para ausente.],
  [*`tempo_inicio`*], [Início relativo à UCP.],
  [*`tempo_restante`*], [Tempo para finalizar o I/O.],
)

=== Tipo de Operação de Entrada e Saída

A enumeração `OperacaoIO` indica o tipo de operação de entrada, possuindo as seguintes variáveis:

#table(
  columns: (1fr, 1fr, 1fr),
  align: (left, left, center),
  table.header([Enumeração], [Descrição], [Valor]),
  [*`DISCO`*], [Entrada/Saída em disco.], [0],
  [*`FITA`*], [Entrada/Saída em fita.], [1],
  [*`QUANTIDADE_TIPOS_IO`*], [Total de tipos de I/O.], [2]
)

A constante `QUANTIDADE_TIPOS_IO` é utilizada para representar o número total de tipos de I/O disponíveis, possuindo o valor 2.

=== Status do Processo

A enumeração `StatusProcesso` identifica o estado atual em que o processo se encontra.

#table(
  columns: (1fr, 1fr, 1fr),
  align: (left, left, center),
  table.header([Enumeração], [Descrição], [Valor]),
  [*`EXECUTANDO`*], [Estado de Execução.], [0],
  [*`ENTRADA_SAIDA`*], [Estado de Entrada/Saída.], [1],
)

Embora o status `PRONTO` exista, ele não foi relevante durante a implementação do escalonador.

=== Lista de Filas

A estrutura `ListaFila` engloba a estrutura de Filas, alocando um vetor fixo de tamanho `NUM_FILAS` para armazenar cada uma das filas.

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  table.header([Variável], [Descrição]),
  [*`filas`*], [Vetor de `Fila` com até `NUM_FILAS`.],
)

=== Fila

A estrutura `Fila` é a implementação padrão de uma lista de encadeadas de nós, em que cada um deles contém um processo.

#table(
  columns: (1fr, auto),
  align: (left, left),
  table.header([Variável], [Descrição]),
  [*`inicio`*], [Ponteiro para primeira estrutura `No` da fila.],
  [*`fim`*], [Ponteiro para última estrutura `No` da fila.],
)

=== Tipo da Fila

A enumeração `TipoFila` indica o tipo das fila dentre as #NUM_FILAS filas possíveis.

#table(
  columns: (1fr, 1fr, 1fr),
  align: (left, left, center),
  table.header([Enumeração], [Descrição], [Valor]),
  [*`FILA_ALTA_PRIORIDADE`*], [Fila de alta prioridade], [0],
  [*`FILA_BAIXA_PRIORIDADE`*], [Fila de baixa prioridade.], [1],
  [*`FILA_DISCO`*], [Fila do disco.], [2],
  [*`FILA_FITA`*], [Fila da fita magnética.], [3],
  [*`NUM_FILAS`*], [Nº máximo de filas.], [4],
)

=== Nó

A estrutura `No` é responsável por conter o processo atual e apontar para o próximo item da lista encadeada.

#table(
  columns: (1fr, 1fr),
  align: (left, left, center),
  table.header([Enumeração], [Descrição]),
  [*`processo`*], [Ponteiro para o processo.],
  [*`prox`*], [Ponteiro para  o próximo nó da fila.],
)

== Funções

Nesta seção, descrevemos detalhadamente as principais funções implementadas no
simulador, responsáveis por executar as diversas operações essenciais ao
funcionamento do escalonador Round-Robin com feedback. As funções estão
organizadas em módulos conforme suas responsabilidades específicas, como
gerenciamento de processos, interface com o usuário, operação do escalonador e
utilitários auxiliares.

=== Processos

Iniciaremos a análise das funções de gerenciamento de processos, enfatizando as relacionadas à criação de processos.

+ `criar_processo_aleatorio(void)`  

    - Gera um processo com variáveis aleatórias dentro os limites permitidos, utilizando a _seed_ baseada no tempo atual.
    - Retorna um objeto da estrutura `Processo`.

+ `criar_lista_processo_aleatorio(void)`  

    - Gera uma lista de processos por meio da função anterior. Define o `PID` de cada processo de forma incremental.
    - Retorna um objeto da estrutura `ListaProcessos`.

+ `criar_lista_processos_csv(const char *nome_arquivo)`

    - Gera uma lista de processos a partir de um arquivo CSV, tratando erros de leitura e arquivos vazios.
    - Retorna um objeto da estrutura `ListaProcessos`.

+ `trim_novalinha(char *str)`

    - Remove caracteres de *quebra de linha* e *retorno de carro*.
    - Não possui valor de retorno.

+ `executa_processo(Processo *processo)`

    - Simula a execução do processo em uma unidade de tempo.
    - Atualiza as variáveis `tempo_cpu_restante`, `tempo_cpu_atual` e `tempo_quantum_restante`.
    - Não possui valor de retorno.

+ `processo_finalizado(Processo *processo)`

    - Verifica se o processo finalizou sua execução; Desenfileira o processo se for o caso.
    - Não possui valor de retorno.

+ `tempo_inicio_io(Processo *processo)`

    - Verifica se o processo possui operação de entrada e saída pendente; Enfileira o processo na operação de entrada e saída correspondente.
    - Retorna 1 em caso de sucesso; 0, caso contrário.

+ `executa_io(Processo *processo)`

    - Simula e execução a operação de entrada e saída do processo.
    - Não possui valor de retorno.

+ `io_finalizada(Processo *processo)`

    - Verifica se a operação de entrada e saída foi concluída; Enfileira o processo na fila de prioridade.
    - Retorna 1 em caso de sucesso; 0, caso contrário.

+ `tempo_quantum_completo(Processo *processo)`

    - Verifica se o processo finalizou seu quantum; Enfileira o processo na fila de baixa prioridade.
    - Retorna 1 em caso de sucesso; 0, caso contrário.
    
Agora, vamos nos voltar para as funções cujo objetivo é disponibilizar uma interface ao usuário.

=== Interface

Vamos começar descrevendo funções destinadas à criação da interface gráfica para o usuário:

+ `imprime_menu(void)`
 
   - Exibe um menu contendo as opções: "Carregar dados de arquivo externo (CSV)", "gerar dados aleatoriamente" e "Sair".
   - Não possui valor de retorno.

+ `processa_menu(ListaProcessos *lista_processos)`

   - Convoca a função anterior e atualiza a lista processos com base na escolha do usuário (1: Extração do CSV) ou (2: Geração aleatória).
   - Não possui valor de retorno.

+ `imprime_instante(int tempo_atual)`

   - Exibe um cabeçalho contendo o instante atual.
   - Não possui valor de retorno.

+ `imprime_fim_escalonador(void)`

   - Exibe um cabeçalho informando o fim do escalonamento.
   - Não possui valor de retorno.

+ `imprime_fila(const char *nome_fila, Fila *fila)`

   - Exibe o nome da fila juntamente de sua representação, começando do início até o fim.
   - Não possui valor de retorno.

+ `imprime_todas_filas(ListaFila *lista_filas)`

    - Engloba a função anterior, imprime todas as filas especificadas.
    - Não possui valor de retorno.

+ `imprime_tabela_processos(ListaProcessos *lista_processos)`

    - Exibe a tabela de processos contendo o `PID`, `instante_chegada`, `tempo_cpu` e operações de entrada e saída para cada um dos processos.
    - Não possui valor de retorno.
    
+ `imprime_turnaround_processos(ListaProcessos lista_processos)`

    - Imprime os tempos de turnaround e de espera para cada processo.
    - Não possui valor de retorno.

=== Escalonador

+ `processa_fila_io(Fila *fila_prioridade, ListaFila *lista_filas, ListaProcessos *lista_processos, int instante_atual, int *processos_finalizados)`

    - Executa a operação de entrada e saída atual, verifica finalização dessa operação ou do processo.
    - Não possui valor de retorno.

+ `processa_fila_prioridade(Fila *fila_io, Fila *fila_destino, const char *prioridade, int instante_atual, int *processos_finalizados)`

    - Executa o processo atual, verifica finalização, operações de entrada e saída pendentes ou mudança de prioridade de filas.
    - Não possui valor de retorno.

+ `escalonador(ListaFila *lista_filas, ListaProcessos *lista_processos)`

    - Função central do programa, gerencia o fluxo das filas de prioridade e de entrada e saída. Pode ser descrita nas seguintes etapas:

        + Impressão das informações de cada processo descrito na tabela de processos.
        + Solicitação da entrada do usuário para prosseguir a execução.
        + Realização de um _loop_ para cada instante de execução do escalonador.
        + Verificação se novos processos chegaram.
        + Função `processa_fila_prioridade` para `FILA_ALTA_PRIORIDADE`.
        + Função `processa_fila_prioridade` para `FILA_BAIXA_PRIORIDADE`.
        + Função `processa_fila_io` para `FILA_DISCO`.
        + Função `processa_fila_io` para `FILA_FITA`.
        + Verificação se todas as filas estão vazias com `todas_filas_vazias()`.
        + Finalização do escalonamento se todas as filas estiverem vazias.

+ `todas_filas_vazias(ListaFila todas_filas)`

    - Verifica se todas as #NUM_FILAS estão vazias.
    - Retorna 1 em caso de sucesso; 0, caso contrário.

+ `verifica_novos_processos(Fila *fila, ListaProcessos *lista_processos, int instante_atual)`

    - Enfileira processos que chegaram no instante atual.
    - Não possui valor de retorno.

+ `envia_para_io(Processo *processo, ListaFila *lista_filas)`

    - Enfileira processo na fila de I/O correspondente no instante atual.
    - Não possui valor de retorno.

+ `atualiza_turnaround(Processo *processo_atual, int instante_fim)`

    - Atualiza o tempo de turnaround dos processos: $"Instante fim" - "Instante chegada"$.
    - Não possui valor de retorno.

=== Utilitários

+ `enviar_mensagem_erro(const char *mensagem)`

    - Exibe uma mensagem de erro no `stderr` e encerra o programa.
    - Não possui valor de retorno.
    
+ `obter_entrada_caractere(const char *mensagem, char* variavel, char min, char max)`

    - Recebe a entrada do usuário durante a escolha do menu.
    - Não possui valor de retorno.

+ `valida_entrada_char(const char *mensagem, char *variavel)`

    - Verifica se a entrada inserida é válida.
    - Não possui valor de retorno.
    
+ `gerar_dado_aleatorio(int min, int max)`

    - Retorna um inteiro aleatório dentro do limite especificado.

+ `seleciona_tempo_io(TipoIO tipo_io)`

    - Define a duração da operação de IO conforme o tipo de IO escolhido.
    - Retorna o valor inteiro correspondente à duração
    
+ `parse_linha_csv(char *linha, Processo *processo)`

    - Extrai variáveis dos processos separadas por vírgulas.
    - Retorna 1 em caso de sucesso; 0, caso contrário.
    
+ `seleciona_tipo_io(TipoIO tipo_io)`

    - Define a duração da operação de IO conforme o tipo de IO escolhido.
    - Retorna o valor inteiro correspondente à duração

=== Macros e Constantes

A descrição e o valor de todas as constantes e macros empregadas se encontram abaixo:

#table(
  columns: (1fr, auto, 1fr),
  align: (left, left, center),
  table.header([Constante], [Descrição], [Valor]),
  [*`QUANTUM`*], [Fatia de tempo], [#QUANTUM],
  [*`MAXIMO_PROCESSOS`*], [Máximo de processos], [#MAXIMO_PROCESSOS],
  [*`TEMPO_MIN_CPU`*], [Serviço mínimo], [#TEMPO_MIN_CPU],
  [*`TEMPO_MAX_CPU`*], [Serviço máximo], [#TEMPO_MAX_CPU],
  [*`TEMPO_MAX_CHEGADA`*], [Chegada máxima], [#TEMPO_MAX_CHEGADA],
  [*`TEMPO_DISCO`*], [I/O do disco], [#TEMPO_DISCO],
  [*`TEMPO_FITA`*], [I/O da fita], [#TEMPO_FITA],
  [*`TEMPO_IO_PADRAO`*], [Sem operação de I/O], [#TEMPO_IO_PADRAO],
  [*`NUM_FILAS`*], [Máximo de filas], [#NUM_FILAS],
  [*`MAX_LINHAS`*], [Máximo de caracteres por linha], [#MAX_LINHA],
)

= Instruções

Para realizar a configuração e a compilação do projeto, é necessário que o ambiente do usuário atenda a alguns pré-requisitos. Primeiramente, certifique-se de que o utilitário `make` está instalado na máquina, assim como o compilador `gcc`.

A utilização do `make` permite automatizar a compilação por meio de um arquivo Makefile, que organiza as dependências e simplifica o processo. O compilador `gcc`, por sua vez, será responsável por traduzir os arquivos de código fonte em binários executáveis.

Existem duas opções disponíveis para compilar o projeto, dependendo da interface desejada:

#block(
  above: 0.5em,
  below: 0.5em,
  inset: 1.2em,
  [
    + *Interface Padrão*: Utiliza caracteres `ASCII` para visualizar as filas. Para compilar, execute:

    ```bash
    make clean
    make
    ```
    
    + *Interface com Caracteres Unicode*: Utiliza caracteres Unicode para uma visualização mais sofisticada. Para compilar, execute:

    ```bash
    make clean
    make pretty
    ```
  ]
)

*Observações*: O comando `make clean` permite remover os binários antigos para a nova compilação. Após a compilação, o programa é executado automaticamente.

Após a execução, o usuário visualizará o menu do simulador com as seguintes opções:

#block(
  above: 0.5em,
  below: 0.5em,
  inset: 1.2em,
  [
    + "Carregar dados de um arquivo externo (CSV)"
    + "Gerar dados aleatoriamente"
    + "Encerrar o programa"
  ]
)

O usuário deve selecionar uma opção inserindo um valor numérico entre 1 e 3. Em seguida, será exibida a tabela de processos, permitindo decidir se deseja prosseguir com o escalonamento ou não. A saída será apresentada conforme o formato descrito na próxima seção.

= Saída

```txt
╔══════════════════════════════════════════════╗
║      SIMULADOR ROUND ROBIN COM FEEDBACK      ║
╚══════════════════════════════════════════════╝
│  1. Carregar dados de arquivo externo (CSV). │
│  2. Gerar dados aleatoriamente.              │
│  3. Sair.                                    │
└──────────────────────────────────────────────┘
Escolha uma opção (1 - 3): 1
═══════════════════════════ PROCESSOS ═══════════════════════════
 PID	Tempo de Início		Tempo de Serviço	E/S (Tempo de Inicio)		
─────────────────────────────────────────────────────────────────
 P0		      3			             3		      Nenhuma operacao de E/S.
 P1		      1			             5		      Fita (1)
 P2		      2			             3		      Disco (1)
 P3		      0			             5		      Fita (3)
═════════════════════════════════════════════════════════════════
Aqui estão os dados dos processos, deseja prosseguir? (s/N): s
┌────────────────────────────────────┐
│         >>> INSTANTE 00 <<<        │
└────────────────────────────────────┘
 P3 entrou na fila de alta prioridade.
 P3 executou por 1 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┐
  │   P3    │
  └─────────┘
 BAIXA PRIORIDADE : Vazia

 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 01 <<<        │
└────────────────────────────────────┘
 P1 entrou na fila de alta prioridade.
 P3 executou por 1 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┬─────────┐
  │   P3    │   P1    │
  └─────────┴─────────┘
 BAIXA PRIORIDADE : Vazia

 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 02 <<<        │
└────────────────────────────────────┘
 P2 entrou na fila de alta prioridade.
 P3 executou por 1 u.t.
 P3 foi para a fila de E/S (Fita).

 ALTA PRIORIDADE  :
  ┌─────────┬─────────┐
  │   P1    │   P2    │
  └─────────┴─────────┘
 BAIXA PRIORIDADE : Vazia

 DISCO : Vazia

️ FITA :
  ┌─────────┐
  │   P3    │
  └─────────┘

┌────────────────────────────────────┐
│         >>> INSTANTE 03 <<<        │
└────────────────────────────────────┘
 P0 entrou na fila de alta prioridade.
 P1 executou por 1 u.t.
 P1 foi para a fila de E/S (Fita).
 P3 executou 1 u.t. da sua E/S de Fita, faltam 2 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┬─────────┐
  │   P2    │   P0    │
  └─────────┴─────────┘
 BAIXA PRIORIDADE : Vazia

 DISCO : Vazia

️ FITA :
  ┌─────────┬─────────┐
  │   P3    │   P1    │
  └─────────┴─────────┘

┌────────────────────────────────────┐
│         >>> INSTANTE 04 <<<        │
└────────────────────────────────────┘
 P2 executou por 1 u.t.
 P2 foi para a fila de E/S (Disco).
 P3 executou 1 u.t. da sua E/S de Fita, faltam 1 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┐
  │   P0    │
  └─────────┘
 BAIXA PRIORIDADE : Vazia

 DISCO :
  ┌─────────┐
  │   P2    │
  └─────────┘
️ FITA :
  ┌─────────┬─────────┐
  │   P3    │   P1    │
  └─────────┴─────────┘

┌────────────────────────────────────┐
│         >>> INSTANTE 05 <<<        │
└────────────────────────────────────┘
 P0 executou por 1 u.t.
 P2 executou 1 u.t. da sua E/S de Disco, faltam 1 u.t.
 P3 executou 1 u.t. da sua E/S de Fita, faltam 0 u.t.
 P3 finalizou sua E/S de Fita, P3 completou I/O e vai para a fila de alta prioridade.

 ALTA PRIORIDADE  :
  ┌─────────┬─────────┐
  │   P0    │   P3    │
  └─────────┴─────────┘
 BAIXA PRIORIDADE : Vazia

 DISCO :
  ┌─────────┐
  │   P2    │
  └─────────┘
️ FITA :
  ┌─────────┐
  │   P1    │
  └─────────┘

┌────────────────────────────────────┐
│         >>> INSTANTE 06 <<<        │
└────────────────────────────────────┘
 P0 executou por 1 u.t.
 P2 executou 1 u.t. da sua E/S de Disco, faltam 0 u.t.
 P2 finalizou sua E/S de Disco, P2 completou I/O e vai para a fila de baixa prioridade.
 P1 executou 1 u.t. da sua E/S de Fita, faltam 2 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┬─────────┐
  │   P0    │   P3    │
  └─────────┴─────────┘
 BAIXA PRIORIDADE :
  ┌─────────┐
  │   P2    │
  └─────────┘
 DISCO : Vazia

️ FITA :
  ┌─────────┐
  │   P1    │
  └─────────┘

┌────────────────────────────────────┐
│         >>> INSTANTE 07 <<<        │
└────────────────────────────────────┘
 P0 executou por 1 u.t.
 P0 finalizou sua execucao.

[ TURNAROUND DE P0 ] : 5

 P1 executou 1 u.t. da sua E/S de Fita, faltam 1 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┐
  │   P3    │
  └─────────┘
 BAIXA PRIORIDADE :
  ┌─────────┐
  │   P2    │
  └─────────┘
 DISCO : Vazia

️ FITA :
  ┌─────────┐
  │   P1    │
  └─────────┘

┌────────────────────────────────────┐
│         >>> INSTANTE 08 <<<        │
└────────────────────────────────────┘
 P3 executou por 1 u.t.
 P1 executou 1 u.t. da sua E/S de Fita, faltam 0 u.t.
 P1 finalizou sua E/S de Fita, P1 completou I/O e vai para a fila de alta prioridade.

 ALTA PRIORIDADE  :
  ┌─────────┬─────────┐
  │   P3    │   P1    │
  └─────────┴─────────┘
 BAIXA PRIORIDADE :
  ┌─────────┐
  │   P2    │
  └─────────┘
 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 09 <<<        │
└────────────────────────────────────┘
 P3 executou por 1 u.t.
 P3 finalizou sua execucao.

[ TURNAROUND DE P3 ] : 10

 ALTA PRIORIDADE  :
  ┌─────────┐
  │   P1    │
  └─────────┘
 BAIXA PRIORIDADE :
  ┌─────────┐
  │   P2    │
  └─────────┘
 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 10 <<<        │
└────────────────────────────────────┘
 P1 executou por 1 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┐
  │   P1    │
  └─────────┘
 BAIXA PRIORIDADE :
  ┌─────────┐
  │   P2    │
  └─────────┘
 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 11 <<<        │
└────────────────────────────────────┘
 P1 executou por 1 u.t.

 ALTA PRIORIDADE  :
  ┌─────────┐
  │   P1    │
  └─────────┘
 BAIXA PRIORIDADE :
  ┌─────────┐
  │   P2    │
  └─────────┘
 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 12 <<<        │
└────────────────────────────────────┘
 P1 executou por 1 u.t.
 P1 sofreu preempcao, vai pra fila de baixa prioridade.

 ALTA PRIORIDADE  : Vazia

 BAIXA PRIORIDADE :
  ┌─────────┬─────────┐
  │   P2    │   P1    │
  └─────────┴─────────┘
 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 13 <<<        │
└────────────────────────────────────┘
 P2 executou por 1 u.t.

 ALTA PRIORIDADE  : Vazia

 BAIXA PRIORIDADE :
  ┌─────────┬─────────┐
  │   P2    │   P1    │
  └─────────┴─────────┘
 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 14 <<<        │
└────────────────────────────────────┘
 P2 executou por 1 u.t.
 P2 finalizou sua execucao.

[ TURNAROUND DE P2 ] : 13

 ALTA PRIORIDADE  : Vazia

 BAIXA PRIORIDADE :
  ┌─────────┐
  │   P1    │
  └─────────┘
 DISCO : Vazia

️ FITA : Vazia

┌────────────────────────────────────┐
│         >>> INSTANTE 15 <<<        │
└────────────────────────────────────┘
 P1 executou por 1 u.t.
 P1 finalizou sua execucao.

[ TURNAROUND DE P1 ] : 15

Nenhuma fila com processos, o processador está ocioso.

[+] Todos os processos foram finalizados com sucesso.

┌─────────────────────────────────────────┐
│           FIM DO ESCALONAMENTO          │
└─────────────────────────────────────────┘

Tempos de turnaround dos processos:
═══════════════════════════ TURNAROUND ══════════════════════════
 PID	Tempo de Turnaround	  Tempo de Espera
─────────────────────────────────────────────────────────────────
 P0		      5 u.t.		        2 u.t.
 P1		      15 u.t.		        10 u.t.
 P2		      13 u.t.		        10 u.t.
 P3		      10 u.t.		        5 u.t.
══════════════════════════════════════════════════════════════════
 Turnaround médio: 10.75 u.t.
 Tempo de espera médio: 6.75 u.t.
```

#pagebreak(weak: true)

#bibliography("resources/referencias.bib")
