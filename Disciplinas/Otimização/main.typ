#import "lib.typ": *
#import "@preview/plotst:0.2.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)
#codly(zebra-fill: none, number-format: none)

#set text(lang: "pt")
#set heading(numbering: "1.")

#show table.cell.where(y: 0): strong

#set page(
  header: [
    _Otimização_
    #h(1fr)
    Universidade Federal do Rio de Janeiro
  ]
  ,margin: auto
)

#set math.equation(numbering: "(1)")

#show: article.with()
#show heading.where(level: 1): it => [
  #it
  #v(.7em)
]
#show heading.where(level: 2): it => [
  #it
  #v(.3em)
]

#maketitle(
  title: "Trabalho Final - Implementação do Simplex em C",
  subtitle: "Otimização 2025.1",
  authors: ("Pedro Saito\n122149392", "Marcos Silva\n122133854", "Milton Salgado\n122169279"),
)

#pad(
      x: 3em,
      top: 1em,
      bottom: 0.4em,
      align(center)[
        #heading(
          outlined: false,
          numbering: none,
          text(0.85em, [Resumo]),
        )
        #set par(justify: true)
        #set text(hyphenate: false)

Este texto foi apresentado como relatório do trabalho final da disciplina de Otimização, oferecida pelo Instituto de Computação da UFRJ no primeiro semestre de 2025. O objetivo deste trabalho é implementar o algoritmo simplex na linguagem de programação C. Um problema de otimização linear será modelado e solucionado com a implementação desenvolvida, e os resultados computacionais serão reportados, incluindo tempo de solução, número de iterações realizadas e valor da função objetivo. O relatório detalhará a arquitetura do código em C, as escolhas de implementação, as instâncias de teste selecionadas e os critérios de avaliação adotados.
      ],
    )

= Introdução

Para compreender as origens do método Simplex, é preciso regressar ao contexto
da Segunda Guerra Mundial, quando o cientista matemático George Dantzig, então
trabalhando em métodos de planejamento para a Força Aérea dos EUA, passou a
formular seus problemas como sistemas de desigualdades lineares. Inspirado pelas
matrizes de insumo-produto de Wassily Leontief, Dantzig inicialmente não incluiu
nelas uma função objetivo, o que permitia infinitas soluções viáveis e exigia um
conjunto de “regras básicas” militares para guiar a escolha de um plano. Somente
em meados de 1947, ao perceber que essas regras podiam ser traduzidas em uma
única função linear a ser maximizada, o problema tornou-se matematicamente
tratável e deu origem ao algoritmo que hoje conhecemos como Simplex.

O método evoluiu gradualmente ao longo de cerca de um ano, tempo em que Dantzig
aprimorou sua formulação, incorporou o conceito de função objetivo, baseado em
sua tese de doutorado sobre multiplicadores de Lagrange para programas lineares
em variáveis contínuas, e comprovou a eficácia prática do esquema de colunas
que viria a constituir o cerne do Simplex.

= Organização

Este documento está estruturado da seguinte forma:

+ Na Seção 3 apresentamos as três instâncias avaliadas (viável, ilimitado e inviável).
+ Nesta mesma seção descrevemos a formulação matemática do problema de transporte e definições teóricas do Simplex.
+ Na Seção 4 detalhamos a implementação em C do método Simplex de duas fases.
+ Na Seção 5 exibimos os resultados computacionais, incluindo os tempos de execução e número de iterações.
+ Por fim, na Seção 6 discutimos conclusões e direções para trabalhos futuros.

#pagebreak()

= Problemas

Para avaliar sistematicamente nosso algoritmo de duas fases, selecionamos três instâncias de programação linear, cada uma ilustrando um cenário distinto:

- *Viável e limitado*: O clássico problema de transporte, que possui solução ótima finita.
- *Ilimitado*: Exemplo no qual a função objetivo cresce sem restrições.
- *Inviável*: Problema no qual nenhuma solução satisfaz simultaneamente todas as restrições.

// Nas subseções seguintes, detalhamos cada um desses problemas e analisamos o comportamento do Simplex em cada caso.

== Problema 1 (Viável e Limitado)

Neste trabalho, escolheu-se como estudo de caso o _Problema de Transporte_ aplicado a produtos organizados por categorias, inspirado na situação real enfrentada pela empresa _Protecter & Gamble_ (P&G). O objetivo é ilustrar 

*Enunciado*: A Procter & Gamble (P&G) fabrica e comercializa mais de 300 marcas
de bens de consumo em todo o mundo. A empresa tem crescido continuamente ao
longo de sua longa história, que remonta à década de 1830. Para manter e
acelerar esse crescimento, foi realizado um importante estudo de Pesquisa
Operacional (OR) com o objetivo de fortalecer a eficácia global da P&G.

Antes do estudo, a cadeia de suprimentos da empresa era composta por centenas de
fornecedores, mais de 50 categorias de produtos, mais de 60 fábricas, 15 centros
de distribuição e mais de 1.000 zonas de clientes. No entanto, à medida que a
empresa avançava rumo à consolidação de marcas globais, a gestão percebeu a
necessidade de consolidar fábricas para reduzir os custos de fabricação,
melhorar a velocidade de chegada ao mercado e diminuir os investimentos em
capital. Por isso, o estudo se concentrou no redesenho do sistema de produção e
distribuição da empresa para suas operações na América do Norte. O resultado foi
uma redução de quase 20% no número de fábricas na América do Norte, gerando uma
economia superior a 200 milhões de dólares em custos antes dos impostos por ano.

Uma parte essencial do estudo envolveu a formulação e resolução de problemas de
transporte para categorias individuais de produtos. Para cada opção em relação
às fábricas que deveriam permanecer abertas, e assim por diante, resolver o
problema de transporte correspondente a uma categoria de produto mostrava qual
seria o custo de distribuição para o envio daquela categoria das fábricas aos
centros de distribuição e zonas de clientes.

#figure(
  image("usa-map.png", width: 75%),
  caption: [_Localização das fábricas de conservas e armazéns no problema da empresa P & T._]
)

#v(2.5em)

// Tabela 1 apresenta os custos unitários de transporte (US\$/carga) entre três conservas e quatro depósitos, além das disponibilidades em cada origem e das demandas em cada destino. Esses dados servem de base ao modelo de transporte para minimizar o custo total.

// Visão geral dos dados de custo de transporte para _P & T_:

// #show table.cell.where(y: 0): set text(
//   fill: white,
//   weight: "bold",
// )

#let black-cells = ((0, 2), (1, 0),(1, 1), (1, 2), (2, 2), (3, 2), (4, 2), (5, 2), (0, 6))
#let stroke-cells = ((1, 2), (2, 2),(3, 2), (4, 2), (5, 2))

#figure(
  table(
    columns: (.8fr,  1fr, 1fr, 1fr, 1fr, .7fr),
    align: (x, y) => if x == 0 and y == 0 { left } else { center },
    stroke: (x, y) => (
      left: if stroke-cells.contains((x, y)) { white } else { black },
      // bottom: if stroke-cells.contains((x, y)) { white } else { black },
      rest: black,
    ),
    fill: (x, y) => if black-cells.contains((x, y)) { black },
  
    table.header(
      [],
      table.cell(colspan: 4, [#text( fill: white, weight: "bold", [Custo de Envio (US\$) por Carga de Caminhão])]),
      [],
    ),
    [], table.cell(colspan: 4, [#text( fill: white, weight: "bold", [Depósito])]), [],
    [#text( fill: white, weight: "bold", [Conservas])], [#text( fill: white, weight: "bold", [1])], [#text( fill: white, weight: "bold", [2])], [#text( fill: white, weight: "bold", [3])], [#text( fill: white, weight: "bold", [4])], [#text( fill: white, weight: "bold", [Produção])],
    [1], [464], [513], [654], [867], [75],
    [2], [352], [416], [690], [791], [125],
    [3], [995], [682], [388], [685], [100],
    [#text( fill: white, weight: "bold", [Demanda])], [80], [65], [70], [85], []
  ),
  caption: [_Custos de transporte e demanda para a empresa P & T._]
) <tab:min_pl>

== Modelagem

A partir dos dados apresentados na @tab:min_pl, podemos modelar o problema de transporte da empresa _P & T_ como um problema clássico de Programação Linear. O objetivo consiste em determinar a quantidade de unidades a serem transportadas de cada fábrica de conservaspara cada armazémde modo a *minimizar o custo total de transporte*, respeitando as capacidades de produção das fábricas e as demandas dos armazéns. 

Para isso, define-se:

- $x_(i j):$ Número de cargas transportadas da conserva $i$ para o depósito $j$.
- $c_(i j):$ Custo de transporte por carga entre a conserva $i$ e o depósito $j$.
- $s_i:$ Capacidade de produção da fábrica $i$.
- $d_j:$ Demanda do armazém $j$.

A formulação teórica do problema é dada por:

$
&"Minimize "f(upright(bold(x))) = sum_(i=1)^3 sum_(j=1)^4 c_(i j) dot x_(i j) \
&"Sujeito a" sum_(j=1)^4 x_(i j) <= s_i quad "para "i=1,2,3 "(restrições de oferta)" \
&wide wide sum_(i=1)^3 x_(i j) >= d_j quad "para "j=1,2,3,4 "(restrições de demanda)" \
&wide wide x_(i j) >= 0 quad "para todos "i,j
$

Por outro lado, a formulação numérica do problema está dada abaixo:

$
&"Minimize "f(upright(bold(x))) = 464 x_(1 1) + 513 x_(1 2) + 654 x_(1 3) + 867 x_(1 4) + 352 x_(2 1) + 416 x_(2 2) + 690 x_(2 3) + 791 x_(2 4) + 995 x_(3 1) + \
&wide wide wide wide 682 x_(3 2) + 388 x_(3 3) + 685 x_(3 4) \
&"Sujeito a" wide wide x_(1 1) + x_(1 2) + x_(1 3) + x_(1 4) &thin= 75 \
&wide wide wide wide wide wide wide wide wide x_(2 1) + x_(2 2) + x_(2 3) + x_(2 4) &=125 \
&wide wide wide wide wide wide wide wide wide wide wide wide wide wide x_(3 1) + x_(3 2) + x_(3 3) + x_(3 4) &=100 \
& wide wide wide wide x_(1 1) wide wide wide wide thick thick x_(2 1) wide wide wide wide thick thick x_(3 1) &thin=80 \
& wide wide wide wide wide thick thick x_(1 2) wide wide wide wide thick thick x_(2 2) wide wide wide wide thick thick x_(3 2) &thin=65 \
& wide wide wide wide wide wide thick thick thick thick thick x_(1 3) wide wide wide wide thick thick x_(2 3) wide wide wide wide thick thick x_(3 3) &thin=70 \
& wide wide wide wide wide wide wide wide x_(1 4) wide wide wide wide thick thick x_(2 4) wide wide wide wide thick thick x_(3 4) &thin=85 \
&wide wide x_(i j) >= 0 quad "para todos "i,j
$

== Problema 2 (Ilimitado)

Selecionamos como problema com solução ilimitada um exemplo simples como abaixo, para ilustrar o funcionamento do algoritmo para esse caso:

#align(center)[
#grid(
  columns: 2,
  column-gutter: -31pt,
  $
  &"Maximize "f(upright(bold(x))) = x_1 + x_2 \
  &"Sujeito a" thick med med x_1 - x_2 <= 1 \
  &x_1, x_2 >= 0
  $,
  figure(
    image("pl_ilimitado.png", width: 45%),
    caption: [_A ausência de limites superiores para $x_1$ e $x_2$ permite que a função objetivo cresça indefinidamente._]
  )
)
]


== Problema 3 (Inviável)

Para ilustrar o caso inviável, escolhemos o *Exemplo 13 da Aula 3* dos Slides, cujo enunciado é:


// Podemos facilmente verificar que o problema é ilimitado a partir do gráfico:

#grid(
  columns: 2,
  column-gutter: -31pt,
  $
  &"Minimize "f(upright(bold(x))) = x_1 + 2x_2 \
  &"Sujeito a" thick med med x_1 + x_2 >= 3 \
  &wide wide thin 2x_1 + x_2 <= 2 \
  &x_1, x_2 >= 0
  $,
  figure(
    image("pl_inviavel.png", width: 45%),
    caption: [_Problema inviável: Não existe solução que satisfaça ambas restrições._
  ]
  )
)

== Fundamento Teórico

A seguir, vamos formalizar os conceitos abordados em otimização linear.

*Def. Problema de Otimização*: Um problema de otimização linear consiste em
encontrar, dentre todas as possíveis soluções que satisfazem um conjunto de
restrições, aquela que minimiza ou maximiza uma dada função $f$ que denotaremos
de *função objetivo*.

- *Minimização*: Busca o valor mínimo de $f(upright(bold(x)))$.
- *Maximização*: Busca o valor máximo de $f(upright(bold(x)))$.

*Def. Variáveis de decisão*: Vetor de dimensão $n$, denotado por $upright(bold(x)) = (x_1, dots, x_n)$ que descrevem as opções sobre as quais se decide. Em um problema de otimização, cada $x_j$ representa um nível de recurso, quantidade produzida, investimento, dentre outras ...

*Def. Função objetivo*: Dada por

$
f(upright(bold(x))) = c_1 x_1 + c_2 x_2 + dots + c_n x_n = upright(bold(c^T x))
$

onde $upright(bold(c)) = (c_1, dots, c_n)$ são os coeficientes que quantificam o impacto de cada variável de decisão no valor de $f$. O objetivo é encontrar $upright(bold(x^*))$ de modo que otimize (minimize ou maximize) $f(upright(bold(x)))$.

*Def. Restrições*: Condições que limitam o conjunto de soluções possíveis. Comumente expressadas por inequações (forma canônica) ou igualdades (forma padrão). Em um problema de otimização linear com $n$ variáveis e $m$ restrições,

- *Igualdades lineares*:

$
a_(i 1) x_1 + a_(i 2) x_2 + dots + a_(i n) x_n = b_i, quad i = 1, dots, m
$

- *Desigualdades lineares*:

$
a_(i 1) x_1 + a_(i 2) x_2 + dots + a_(i n) x_n <= b_i thick " ou " thick >= b_i
$

Cada $a_(i j)$ é o coeficiente que relaciona a variável $x_j$ à restrição $i$, e $b_i$ é o limite disponível ou exigido.

*Def. Região viável*: Conjunto de todos os vetores $upright(bold(x))$ que satisfazem simultaneamente todas as restrições e as condições de não negatividade. Em programação linear, essa região forma um politopo convexo.

*Def. Solução viável*: Qualquer ponto, definido pelo vetor $upright(bold(x))$, pertencente à região viável. Nem toda solução viável é ótima, são apenas admissíveis.

*Def. Solução Ótima*: Solução viável $upright(bold(x^*))$ que alcança o valor ótimo (mínimo ou máximo) da função objetivo:

$
f(upright(bold(x^*))) = limits("min")_(upright(bold(x)) in "viável") f(upright(bold(x))) quad "ou" quad limits("max")_(upright(bold(x)) in "viável") f(upright(bold(x)))
$

*Def. Variáveis de Folga ou Excedentes e Artificiais*: Uma variável de folga ou excedente corresponde a uma variável adicionada a uma restrição de desigualdade para transformá-la em uma restrição de igualdade. Uma restrição de não-negatividade também é adicionada a variável de folga. Em termos gerais:

- *Variáveis de folga*: Para converter inequações $<=$ ou $>=$ em igualdades, introduz-se $s_i >= 0$ tal que $sum_j a_(i j) x_j + s_i = b_i$.

- *Variáveis Artificiais*: Em certos casos, quando não podemos começar a partir de uma solução básica viável, acrescentamos uma variável artificial $a_i$ para garantir viabilidade inicial, sendo removida no término da Fase I do Simplex no Método de Duas Fases.

*Def. Base e Solução Básica Viável*: Em um problema de otimização contendo $m$ restrições, escolhe-se um subconjunto de $m$ variáveis para compor a base. Inicialmente, essas variáveis correspondem às variáveis de folga, isto é, sem incluir aquelas presentes na função objetivo.

#pagebreak()

= Experiências Computacionais

A implementação e resolução do modelo apresentado na Seção 2 foram realizadas em um computador pessoal com as seguintes configurações de _hardware_ e _software_:

#align(center)[
#table(
  columns: (.31fr, .6fr, 1fr, 1fr, .4fr, .4fr),
  align: (left, center, center, center, center, center),
  table.header(
    [Setup],
    [Sistema], 
    [CPU], 
    [GPU], 
    [RAM], 
    [Disco], 
  ),
  [1], [macOs],  [M2 8 núcleos],  [Int. 10 núcleos],  [8 GB], [460 GB],
  [2], [BigLinux],    [i7 - 14 núcleos], [RTX 4050],     [16 GB], [296 GB],
  [3], [Ubuntu],   [i5 - 6 núcleos],   [GTX 1660],   [16 GB],   [467 GB],
  )
]

#align(center)[
#table(
  columns: (.18fr, .6fr, .6fr, .6fr),
  align: (left, center, center, center, center, center),
  table.header(
    [Setup], 
    [Duração - PL 1], 
    [Duração - PL 2], 
    [Duração - PL 3],
  ),
  [1],  [0.008850447s], [0.008607634s], [0.008699520s],
  [2],    [0.003s], [0.003s], [0.0029s],
  [3],   [0.00262s],  [0.002872s], [0.002761s],
  )
]

Todos os experimentos foram conduzidos em ambiente local, com uso eficiente de
recursos computacionais, respeitando os limites de memória física e de troca. A
resolução do modelo foi realizada por meio de implementação própria do algoritmo
Simplex em linguagem C, compilado e executado diretamente no sistema descrito
acima.

== Comparação com Gurobi

Para avaliar o desempenho de nossa implementação, comparamos os resultados
obtidos pelo *Simplex em C* com o pacote Python `gurobipy`, executados nas
mesmas configurações de hardware que o simplex anterior. Os indicadores de
iterações, tempo de otimização e valor objetivo estão resumidos na Tabela.

#table(
  columns: (1fr, .8fr, 1fr, 1fr),
  table.header(
    [Método],
    [Iterações],
    [Duração (s)],
    [Valor Ótimo],
  ),
  [Simplex em C],
  [20 (FI: 10 e FII: 10)],
  [0.000022],
  [152535.00],
  [Gurobi (Method=0)],
  [4],
  [0.004],
  [152535.00],
)

Como esperado, ambos os métodos retornaram exatamente a mesma alocação de variáveis básicas na solução ótima:

$
x_(1,2)=20, x_(1,4)=55, x_(2,1)=80, x_(2,2)=45, x_(3,3)=70, x_(3,4)=30.
$


= Código

Nesta seção, descrevemos detalhadamente as principais funções implementadas para a execução do *algoritmo Simplex de duas fases*, responsáveis pelas operações essenciais do método. As funções estão organizadas em módulos conforme suas responsabilidades específicas: inicialização da estrutura *Simplex*, pivoteamento, execução das fases *I* e *II*, remoção de variáveis artificiais e liberação de recursos.

== Estrutura Simplex

A estrutura `Simplex` representa o tableau do método Simplex de duas fases e
contém todas as informações necessárias para resolver problemas de programação
linear. Contém as seguintes variáveis:

#align(center)[
#table(
  columns: (auto, auto),
  align: (left, left),
  table.header([Variável], [Descrição]),
  [`t`], [Tableau unidimensional de tamanho $(m+1) times "col"$.],
  [`m`], [Número de restrições do problema.],
  [`n`], [Número de variáveis originais do problema.],
  [`col`], [Número total de colunas do tableau (incluindo RHS).],
  [`tipo_pl`], [Tipo do problema: 0 para minimização, 1 para maximização.],
  [`ilimitado`], [Flag indicando se o problema possui solução ilimitada.],
  [`inviavel`], [Flag indicando se o problema é inviável.],
  [`basicas`], [Vetor com os índices das variáveis básicas em cada linha.],
  [`c_original`], [Cópia da função objetivo para uso na Fase II.],
  [`total_variaveis`], [Número total de variáveis (excluindo coluna RHS).],
  [`inicio_artificiais`], [Índice onde começam as variáveis artificiais no tableau.],
  [`num_artificiais`], [Número de variáveis artificiais adicionadas.],
  [`iteracoes_fase1`], [Contador de iterações realizadas na Fase I.],
  [`iteracoes_fase2`], [Contador de iterações realizadas na Fase II.],
)
]

== Funções

Nesta seção, descrevemos detalhadamente as principais funções implementadas no
simulador, responsáveis por executar as diversas operações essenciais ao
funcionamento do escalonador Round-Robin com feedback. As funções estão
organizadas em módulos conforme suas responsabilidades específicas, como
gerenciamento de processos, interface com o usuário, operação do escalonador e
utilitários auxiliares.

Iniciaremos a análise das funções de gerenciamento de processos, enfatizando as relacionadas à criação de processos.

+ `criar_simplex_duas_fases(double **A, double *b, double *c, int *tipo_restricao, int m, int n, int tipo_pl)`

  - Inicializa a estrutura `Simplex` para o método das duas fases, com variáveis auxiliares de acordo com a restrição.
  - Monta o tableau da Fase I e configura a função objetivo.
  - Retorna um ponteiro para a estrutura `Simplex` inicializada.

+ `pivotear(Simplex *s, int linha_pivo, int coluna_pivo)`
  - Executa a operação de *pivoteamento*, normalizando a linha e atualizando as demais.
  - Ajusta a variável básica da linha correspondente.
  - Não possui valor de retorno.

+ `executar_simplex(Simplex *s)`
  - Resolve o tableau atual pelo método Simplex.
  - Utiliza a Regra de Bland e o teste de razão mínima.
  - Retorna o número de iterações.

+ `preparar_fase2(Simplex *s)`
  - Remove variáveis artificiais e restaura função objetivo original.
  - Prepara o tableau para a Fase II.
  - Não possui valor de retorno.

+ `resolver_duas_fases(Simplex *s)`
  - Executa as duas fases do método Simplex.
  - Verifica viabilidade e otimiza a função original.
  - Exibe a solução final.
  - Não possui valor de retorno.

+ `liberar_simplex(Simplex *s)`
  - Libera toda a memória alocada para a estrutura `Simplex`.
  - Não possui valor de retorno.

+ `main(void)`
  - Define um problema de transporte com 7 restrições e 12 variáveis.
  - Coordena a criação, execução e liberação do modelo.
  - Exibe o problema e realiza a medição de tempo.
  - Retorna 1 em todos os casos.

// #pagebreak()

== Resultados

=== Resultados Computacionais

O problema de otimização linear foi resolvido com sucesso utilizando o algoritmo
Simplex de duas fases implementado. A execução do algoritmo demonstrou excelente
performance computacional e convergência eficiente para a solução ótima.

=== Análise do Desempenho Algorítmico

O algoritmo convergiu em *20 iterações totais*, distribuídas igualmente entre as duas fases:

- *Fase I*: 10 iterações para estabelecer viabilidade

- *Fase II*: 10 iterações para otimização

A distribuição das iterações nos informa que o problema possui estrutura bem condicionada, sem degeneração significativa ou dificuldades numéricas que poderiam prolongar a convergência.

=== Tempo de Execução

O *tempo total de execução foi em média de .000666 segundos*, demonstrando a eficiência computacional da implementação. Este desempenho temporal é excelente considerando:
- Dimensão do problema: 12 variáveis e 7 restrições
- Natureza do algoritmo: método exato que garante solução ótima global
- Complexidade das operações matriciais envolvidas no pivoteamento

=== Solução Ótima Encontrada

O algoritmo determinou que o *valor ótimo da função objetivo é 152.535*, correspondente ao custo mínimo total do sistema. A solução ótima apresenta a seguinte estrutura:

*Variáveis básicas (não-nulas):* $x_2 = 20, x_4 = 55, x_5 = 80, x_6 = 45, x_11 = 70, x_12 = 30$

*Variáveis não-básicas (nulas):* $x_1 = x_3 = x_7 = x_8 = x_9 = x_10 = 0$

=== Interpretação da Solução // ????

A alocação obtida revela a minimização do custo total sob as capacidades e demandas impostas:

1. *Uso prioritário de rotas de menor custo unitário*: As rotas com custo unitário mais baixo, isto é, $x_5 (352)$ e $x_11 (388)$ são usadas ao máximo $(80 " e " 70)$, esgotando oferta e parte da demanda.

2. *Utiliza parcialmente variáveis de custo intermediário*: $x_2$, $x_4$, $x_6$ e $x_12$ complementam a alocação necessária

3. *Evita completamente variáveis de alto custo*: $x_7$ (690), $x_8$ (791) e $x_9$ (995) permanecem nulas.

=== Verificação de Consistência

A solução satisfaz todas as restrições do problema:
- Restrições de demanda: 75, 125 e 100 unidades atendidas exatamente
- Restrições de oferta: capacidades de 80, 65, 70 e 85 respeitadas
- Condições de não-negatividade: todas as variáveis possuem valores não-negativos

=== Saída

==== Problema Original

```txt
Resolvendo problema de programacao linear:

Minimize 464x1 + 513x2 + 654x3 + 867x4 + 352x5 + 416x6 + 690x7 + 791x8 + 995x9 + 682x10 + 388x11 + 685x12

sujeito a:
x1 + x2 + x3 + x4 = 75
x5 + x6 + x7 + x8 = 125
x1 + x5 + x9 = 80
x2 + x6 + x10 = 65
x3 + x7 + x11 = 70
x4 + x8 + x12 = 85
x9 + x10 + x11 + x12 = 100
x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12 >= 0

=== EXECUTANDO ALGORITMO SIMPLEX DUAS FASES ===

=== RESULTADOS FINAIS ===

Numero de iteracoes:
  Fase I: 10 iteracoes
  Fase II: 10 iteracoes
  Total: 20 iteracoes

Status: Solucao otima encontrada
Valor otimo da funcao objetivo: 152535.00

Solucao completa:
Variaveis basicas:
  x2 = 20.000000
  x4 = 55.000000
  x5 = 80.000000
  x6 = 45.000000
  x11 = 70.000000
  x12 = 30.000000

Tempo de execucao: 0.000022 segundos
```

*Resultados do Gurobi*

```
Restricted license - for non-production use only - expires 2026-11-23
Set parameter Method to value 0
Gurobi Optimizer version 12.0.2 build v12.0.2rc0 (mac64[arm] - Darwin 24.5.0 24F74)

CPU model: Apple M2
Thread count: 8 physical cores, 8 logical processors, using up to 8 threads

Non-default parameters:
Method  0

Optimize a model with 7 rows, 12 columns and 24 nonzeros
Model fingerprint: 0xc923d8aa
Coefficient statistics:
  Matrix range     [1e+00, 1e+00]
  Objective range  [4e+02, 1e+03]
  Bounds range     [0e+00, 0e+00]
  RHS range        [6e+01, 1e+02]
Presolve time: 0.00s
Presolved: 7 rows, 12 columns, 24 nonzeros

Iteration    Objective       Primal Inf.    Dual Inf.      Time
       0    2.3621500e+05   1.150000e+02   6.001905e+06      0s
       4    1.5253500e+05   0.000000e+00   0.000000e+00      0s

Solved in 4 iterations and 0.00 seconds (0.00 work units)
Optimal objective  1.525350000e+05
Tempo de otimização: 0.004 s
Obj: 152535.00
x[1,2] = 20.00
x[1,4] = 55.00
x[2,1] = 80.00
x[2,2] = 45.00
x[3,3] = 70.00
x[3,4] = 30.00
```

==== Problema Ilimitado

```txt
Resolvendo problema de programacao linear:

Maximize 1x1 + 1x2

sujeito a:
x1 -x2 <= 1
x1, x2 >= 0

=== EXECUTANDO ALGORITMO SIMPLEX DUAS FASES ===

=== RESULTADOS FINAIS ===

Numero de iteracoes:
  Fase I: 0 iteracoes
  Fase II: 2 iteracoes
  Total: 2 iteracoes

Status: Solucao ilimitada

Tempo de execucao: 0.000008 segundos
```

==== Problema Inviável

```txt
Resolvendo problema de programacao linear:

Minimize 1x1 + 2x2

sujeito a:
x1 + x2 >= 3
2*x1 + x2 <= 2
x1, x2 >= 0

=== EXECUTANDO ALGORITMO SIMPLEX DUAS FASES ===

RESULTADO: Problema inviavel (valor da Fase I = -1.000000)

Tempo de execucao: 0.000007 segundos
```

#pagebreak()

#bibliography(
  title: [Bibliografia],
  "referencias.bib",
  full: true,
  style: "springer-lecture-notes-in-computer-science",
)

= Conclusão

// Os resultados computacionais demonstram que a implementação do algoritmo Simplex de duas fases é robusta e eficiente, proporcionando solução ótima garantida em tempo computacional mínimo. A convergência rápida e a qualidade da solução encontrada validam tanto a correção do algoritmo quanto a adequação da abordagem metodológica para problemas desta natureza.

Os resultados computacionais mostram que a implementação do método Simplex de
duas fases é ao mesmo tempo robusta e eficiente, garantindo a obtenção da
solução ótima com tempo de processamento reduzido. A rápida convergência e a
qualidade das soluções obtidas atestam tanto a correção do algoritmo quanto a
adequação da abordagem metodológica a este tipo de problema.

Para tornar a ferramenta ainda mais versátil, o código será organizado no futuro em módulos independentes, de modo que novas instâncias de problemas possam ser inseridas de forma simples e rápida, sem a necessidade de modificações na lógica central do algoritmo como está sendo feito no momento. Além disso, será adicionada a possibilidade de leitura da PL diretamente da entrada padrão (`STDIN`) ou de um arquivo externo, simplificando o processo de teste e validação.
