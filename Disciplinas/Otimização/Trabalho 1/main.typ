#import "lib.typ": *
#import "@preview/plotst:0.2.0": *

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
  title: "Dimensionamento de Lotes e Programação em Fundições",
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

        Este texto foi apresentado como relatório do primeiro trabalho da disciplina de Otimização, oferecida pelo Instituto de Computação da UFRJ no primeiro semestre de 2025. O objetivo é abordar o problema de dimensionamento de lotes e programação de produção em fundições de médio porte. A análise considera restrições operacionais como capacidade de produção, custos de preparação e possibilidade de atrasos na entrega. O trabalho discute a modelagem matemática do problema, detalha as variáveis e restrições envolvidas e heurísticas utilizadas.
      ],
    )

/*

ARTIGO: https://www.scielo.br/j/pope/a/J7kZr9bxwrcxSvG3XxgfYbL/?format=pdf&lang=pt

A partir da sugestão alguns problemas cl ́assicos de programação linear o grupo
deve escolher um para estudar, modelar ou mesmo encontrar modelos prontos. Cabe
então discutir a modelagem, as vari ́aveis de decisão escolhidas, as restrições, suas relações com o problema modelado. Deve ser escrito um relatório
claro, explicando o problema em si e todos os aspectos da modelagem estudados.
As referências bibliográficas que forem utilizadas, devem ser citadas no relatório.

*/

= Introdução

A Programação Linear é uma das ferramentas científicas mais fundamentais da
pesquisa operacional, devido a sua capacidade de modelar uma ampla gama de
problemas reais por meio de estruturas simples, isto é, funções e restrições
lineares @carnegieLP. Neste trabalho, escolhemos estudar um problema integrado de
*dimensionamento de lotes* e *programação da produção*, inspirado em um cenário
real encontrado em fundições de pequeno e médio porte.

O caso envolve uma fundição que opera com um único forno, que representa o principal gargalo do processo produtivo, e diversas máquinas de moldagem paralelas. A
produção exige que diferentes itens, cada um com demanda conhecida, sejam
fabricados a partir de ligas metálicas específicas. A cada período, duas
decisões, estas são:

1. _Qual liga será fundida no forno?_
2. _Como alocar a produção dos itens entre as máquinas disponíveis?_

Tais decisões devem considerar restrições de capacidade, custos de preparação 
 para troca de liga, e penalidades por atrasos na entrega.

// É bom mudar essa parte..

Apresentamos um modelo de *programação linear mista* que representa o processo
produtivo em fundições, incluindo a seleção de ligas, a alocação do tempo de
cada máquina para produzir cada item e o controle de estoques e atrasos.
Analisamos suas principais restrições operacionais e estruturais, assim como o
impacto dessas restrições na qualidade da solução. Este relatório detalha a
modelagem proposta, destaca seus aspectos fundamentais e avalia estratégias de solução fundamentadas na literatura.

#pagebreak()

== Objetivos

O presente estudo tem como objetivo modelar um problema de dimensionamento de lotes e programação da produção em fundições, em um ambiente com máquinas de moldagem paralelas e restrições operacionais.

Especificamente, estamos interessados em:

- Formular e interpretar a função objetivo do problema.
- Definir as variáveis de decisão e as restrições do modelo.
- Avaliar as estratégias de relaxação e heurísticas aplicáveis.

= Modelagem

// texto

A fundição opera com um único forno e $M$ máquinas de moldagem paralelas,
responsáveis pela produção de diferentes moldes com demandas conhecidas. A
produção é dividida em $T$ períodos, os quais podem variar quanto à duração e às
demandas de cada item.

O forno tem uma capacidade limitada de produção de liga por hora em cada
período, sendo que cada liga pode atender um ou mais itens. Uma vez fundida a
liga, os itens compatíveis podem ser produzidos nas máquinas de moldagem, cada
uma com uma taxa produtiva de $a_(i m)$, que indica a quantidade do item $i$ que
a máquina $m$ é capaz de produzir por hora.

Além disso, produção pode ser adiantada ou atrasada em relação ao período de demanda, mas isso gera penalidades: Estocar tem custo, e atrasar resulta em multa proporcional ao atraso.

// Fluxograma de fabricação

#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, trapezium, diamond, ellipse

#let blob(pos, label, tint: white, ..args) = node(
	pos, align(center, label),
	width: 28mm,
	fill: tint.lighten(60%),
	stroke: 1pt + tint.darken(20%),
	corner-radius: 5pt,
	..args,
)

#figure(
  diagram(
  	spacing: 8pt,
  	cell-size: (8mm, 10mm),
  	edge-stroke: 1pt,
  	edge-corner-radius: 5pt,
  	mark-scale: 70%,
  
  	blob((-3,.2), [Matéria-prima], shape: diamond, width: 30mm, height: 10mm, tint: yellow, name: <materia-prima>),
  	edge("dd", "-|>"),
  	blob((-3,2.2), [Forno], shape: trapezium, width: 23mm, height: 10mm, tint: red, name: <forno>),
  	edge("rrr", "-|>"),
  	blob((-0.4,.2), [Máquinas\ Moldagem], tint: gray, shape: hexagon, name: <maquina>),
  	// edge("rr", "-|>"),
  	blob((-.4,2.2), [Liga], tint: orange, shape: ellipse, name: <liga>),
  	edge(<liga>, <molde>, "-|>"),
  	blob((2,.2), [Molde], tint: green, shape: rect, name: <molde>),
  	edge(<maquina>, <molde>, "-|>"),
  	edge("dd", "-|>"),
  	blob((2,2.2), [Produto Final], tint: purple, shape: rect),
  ),
  caption: [_Fluxograma simplificado do processo produtivo._]
)

Onde:

- *Matéria-prima*: Refere-se a conjuntos de materiais compostos pela mesma liga metálica, incluindo sucatas, lingotes fundidos (provenientes de refino de minérios), e outros insumos.

- *Forno*: Equipamento único do processo produtivo, responsável pela fusão da matéria-prima e pela produção das ligas metálicas. Representa o principal *gargalo*, opera sob restrições a cada período.

- *Molde*: Estrutura de areia onde a liga fundida é vertida para adquirir a forma final do item. Cada molde corresponde ao formato específico do produto.

- *Máquina de Moldagem*: Equipamentos responsáveis pela conformação dos itens a partir da liga fundida, conforme a demanda e capacidade produtiva.

- *Produto final*: Resultado final do processo, obtido após a moldagem e solidificação da liga no molde correspondente.

#pagebreak()

Índices e dados gerais para resolução do problema:

#set table.hline(stroke: .6pt)

#figure(
  table(
    stroke: none,
    columns: (auto, 295pt),
    [Índices e Dados], [Definição],
    table.hline(),
    [$m=1,dots,M$], [Máquinas de moldagem.],
    [$t=1,dots,T$], [Períodos de tempo.],
    [$i=1,dots,N$], [Tipos de itens.],
    [$k=1,dots,K$], [Tipos de ligas.],
    table.hline(),
    [$a_(i m)$], [Quantidade de itens $i$ produzidos pela máquina por hora.],
    [$C a p_t$], [Quantidade máxima de liga produzida pelo forno por hora no período $t$.],
    [$d_(i t)$], [Demanda de itens do tipo $i$ no período $t$.],
    [$h_t$], [Número de horas no período $t$.],
    [$H_i^+$], [Custo de estocar uma unidade do item $i$ de um período para o próximo.],
    [$H_i^-$], [Penalidade por atrasar uma unidade do item $i$ de um período para o próximo.],
    [$c s_k$], [Penalidade por preparar a liga $k$.],
    [$S_k$], [Conjunto de itens utilizados na liga $k$.],
    [$G$], [Um número grande.],
  ),
  caption: [_Índices e dados fornecidos pelo problema._]
)

Variáveis de decisão utilizadas:

#figure(
  table(
    stroke: none,
    columns: (auto, 295pt),
    [Variáveis], [Definição],
    table.hline(),
    [$X_(i m t)$], [Tempo usado no período $t$ para produzir o item $i$ na máquina $m$;],
    [$I_(i t)^+$], [Estoque do item $i$ no final do período $t thin (I_(i 0)^+=0);$],
    [$I_(i t)^-$], [Quantidade atrasada do item $i$ no final do período $t thin (I_(i 0)^-=0)$;],
    [$Y_t^(k)$], [Variável binária que indica se a liga $k$ é produzida no período $t$;],
    [$Z_t^k$], [Variável binária que indica se há custo de preparação para a liga $k$ no período $t$.],
  ),
  caption: [_Variáveis de decisão._]
)

#pagebreak()

O problema de programação linear (PPL) pode ser descrito da forma:

#import "@preview/equate:0.3.1": equate

#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(1.1)")

#let end-spacing = $quad thick quad thick thick$

$
"min" thick med &sum_(m=1)^N sum_(t=1)^T (H_i^- I_(i t)^- + H_i^+ I_(i t)^+) + sum_(k=1)^K sum_(t=1)^T (c s_k Z_t^k) & #<1.1> \ 
"s.a:" &sum_(m=1)^M a_(i m)h_t X_(i m t) - I_(i t)^+I_(i t)^- + I_(i(t-1))^+ - I_(i(t-1))^- = d_(i t) & i=1,dots,N quad t=1,dots,T #end-spacing #<1.2> \
&sum_(i=1)^N sum_(m=1)^M h_t a_(i m) X_(i m t) lt.eq italic("Cap")_t h_t & t=1,dots,T #end-spacing #<1.3> \
&sum_(i in S_k) X_(i m t) lt.eq (1-Y_t^k)G + 1 & k=1,dots,K quad m=1,dots,M quad t=1,dots,T #end-spacing #<1.4> \
&sum_(i in.not S_k) X_(i m t) lt.eq (1-Y_t^k)G & k=1,dots,K quad m=1,dots,M quad t=1,dots,T #end-spacing #<1.5> \
&sum_(k=1)^K Y_t^k = 1 & t=1,dots,T #end-spacing #<1.6> \
&Z_t^k gt.eq Y_t^k - Y_(t-1)^k & k=1,dots,K quad t=1,dots,T #end-spacing #<1.7> \
&X_(i m t) gt.eq 0 & i=1,dots,I quad m=1,dots,K quad t=1,dots,T #end-spacing #<1.8> \
&I_(i t)^+" e "I_(i t)^- gt.eq 0 & i=1,dots,I quad t=1,dots,T #end-spacing #<1.9> \
&Y_t^k in {0, 1} quad (Y_0^k=0) & k=1,dots,K quad t=1,dots,T thick thick #end-spacing #<1.10> \
&Z_t^k gt.eq 0 & k=1,dots,K quad t=1,dots,T thick thick #end-spacing #<1.11>
$

A função objetivo, definida na @1.1, é composta por:

- *Custos de Estoque:* $H_i^+ I_(i t)^+$​ — manter estoque implica em custo.

- *Penalidades por Atraso:* $H_i^- I_(i t)^-$​ — atrasos são penalizados com maior intensidade.

- *Custo de Preparação de Ligas:* $c s_k Z_t^k$​ — cada troca de liga acarreta um custo adicional.

O modelo favorece a produção sem atrasos e com menos trocas de ligas, contribuindo para a eficiência da produção.

== Restrição

#figure(
  table(
    stroke: none,
    columns: (auto, 295pt),
    align: (left, center),
    row-gutter: 7pt,
    [Restrição], [Explicação],
    table.hline(),
    [*Função objetivo*#linebreak()@1.1], [Minimiza os custos de estoque, atrasos e trocas de ligas. O primeiro termo contabiliza o custo de manter estoque e penalidades por atraso, o segundo, os custos de preparação das ligas.],
    [*Balanço de Estoque*#linebreak()@1.2], [Garante a coerência em um período de tempo, para cada item, de sua produção, sua quantidade já em estoque, sua demanda atrasada de períodos anteriores e sua demanda do período atual. Ou seja, garante que não se produza a mais quando um item já está em estoque e que se produza a mais quando há demanda atrasada.],
    [*Capacidade do Forno*#linebreak()@1.3], [Limita a quantidade de itens produzidos em cada período pela quantidade de ligas produzidas no mesmo período.],
    [*Compatibilidade da Liga*#linebreak()@1.4 e @1.5], [Garante que apenas itens compatíveis com a liga produzida no período possam ser fabricados.],
    // [*Compatibilidade da Liga*#linebreak()@1.5], [Garante que apenas itens compatíveis com a liga produzida no período possam ser fabricados.],
    [*Escolha de Liga Única*#linebreak()@1.6], [Apenas uma liga $k$ pode ser produzida por período $t$.],
    [*Controle de Troca de Liga*#linebreak()@1.7], [Define a variável de troca de liga $Z_t^k$​, que penaliza a troca da liga a ser produzida entre períodos.],
    [*Não Negatividade - Tempo*#linebreak()@1.8], [Não é possível produzir quantidades em uma fração de tempo negativa.],
    [*Não Negatividade - Estoques*#linebreak()@1.9], [Os estoques e atrasos não podem assumir valores negativos.],
    [*Variáveis Binárias - Liga*#linebreak()@1.10], [Define a natureza binária da variável de escolha de liga $Y_t^k$],
    [*Não Negatividade - Trocas*#linebreak()@1.11], [A variável de troca de ligas $Z_t^k$],
  ),
  caption: [_Explicação das restrições usadas na modelagem._]
)

#pagebreak()

= Relaxação

Antes de aplicar a heurística para escolher a liga a ser produzida, podemos simplificar o problema removendo temporariamente as restrições sobre a escolha de ligas. Assim, obtemos uma solução inicial com mais facilidade.

== Restrições relaxadas

Na versão _relaxada_ do modelo, as seguintes simplificações são aplicadas:

#figure(
  table(
    stroke: none,
    columns: (auto, 342pt),
    [Restrições], [Descrição],
    table.hline(),
    [@1.1], [Remove o componente de custo de troca de liga $(c s_k Z_k^t)$.],
    [@1.4], [Remove a restrição de produção vinculada à escolha da liga $k$ no período $t$.],
    [@1.5], [Não se exige mais a escolha de apenas uma liga por período.],
    [@1.6], [Elimina o controle de custos de troca de liga entre períodos.],
    [@1.7], [Elimina a necessidade de decidir se a liga será, removendo a variável $Y_t^k$.],
    [@1.8], [A variável de troca de liga $Z_t^k$​ é eliminada do modelo relaxado.],
  ),
  caption: [_Modificações em função do relaxamento._]
)

== Criação de uma nova variável

Com a remoção temporária das restrições relacionadas à seleção de ligas,
iremos introduzir uma variável auxiliar que simplifique o controle
da produção dos itens. Para isso, define-se a variável:

$
P_(i t) = sum_(m=1)^M h_t a_(i m) X_(i m t)
$

onde:

- $P_(i t)$: Quantidade total do item $i$ planejada para ser produzida no período $t$.
- $h_t$: Número de horas disponíveis no período $t$.
- $a_(i m)$: Taxa de produção do item $i$ na máquina $m$ (quantidade de itens por hora).
- $X_(i m t)$: Fração de tempo da máquina $m$ alocada para a produção do item $i$ no período $t$.

A variável $P_(i t)$ consolida a produção de cada item em um único valor agregado por período, independentemente da distribuição entre as máquinas. Isso simplifica o modelo relaxado, permitindo tratar diretamente as quantidades a serem produzidas, sem a necessidade de considerar, neste momento, a alocação detalhada de recursos produtivos ou a restrição de compatibilidade com ligas.

== Modelo relaxado resultante

Como foi dito, podemos desconsiderar as restrições da @1.4 até @1.7 e as da
@1.10 e @1.11. Desse modo, teremos a seguinte PPL:

#let new-spacing = $wide wide wide wide wide wide quad$

$
"min" &sum_(i=1)^N sum_(t=1)^T (H_i^- I_(i t)^- + H_i^+ I_(i t)^+) #new-spacing & #<3.1> \
"s.a:" &I_(i t-1)^+ - I_(i t-1)^- + P_(i t) - I_(i t)^+ + I_(i t)^- = d_(i t) & i=1,dots,N quad t=1,dots,T #<3.2> \
&sum_(i=1)^N P_(i t) lt.eq italic("Cap")_t h_t & t=1,dots,T #<3.3> \
&P_(i t) gt.eq 0 & i=1,dots,N quad t=1,dots,T #<3.4> \
&I_(i t)^+" e "I_(i t)^- gt.eq 0 & i=1,dots,N quad t=1,dots,T #<3.5> \
$

A função objetivo, definida na @3.1, é composta exclusivamente pelos custos de
estoque e penalidades por atraso, eliminando, neste estágio, os custos
associados à preparação e troca de ligas.

#figure(
table(
stroke: none,
columns: (auto, 295pt),
align: (left, center),
row-gutter: 11pt,
[Restrição], [Explicação],
table.hline(),
[*Função Objetivo Relaxada*#linebreak()@3.1], [Minimiza apenas os custos de manutenção de estoque e as penalidades por atraso no atendimento das demandas. Os custos de troca de ligas são desconsiderados neste modelo simplificado.],
[*Balanço de Estoque e Atrasos*#linebreak()@3.2], [Garante que, para cada item e período, a quantidade produzida e o estoque existente sejam suficientes para atender à demanda, contabilizando possíveis atrasos acumulados.],
[*Capacidade do Forno*#linebreak()@3.3], [Limita a quantidade total de produção no período à capacidade máxima do forno, considerada em termos de horas disponíveis.],
[*Não Negatividade - Produção*#linebreak()@3.4], [As quantidades planejadas para produção não podem ser negativas, refletindo a realidade física do sistema produtivo.],
[*Não Negatividade - Estoques*#linebreak()@3.5], [Os estoques finais e os atrasos de cada item devem ser não negativos, garantindo consistência nos cálculos de estoque e atrasos.],
),
caption: [_Explicação das restrições utilizadas no modelo relaxado._]
)

== Heurística -  Escolha das Ligas

Após resolver o problema relaxado, é necessário definir qual liga será produzida em cada período. Como nem sempre uma única liga pode atender a todos os itens demandados, utiliza-se a seguinte heurística estruturada em três passos principais:

*Passo 1*: Determinar Itens Já Atendidos

$
A_(t-1) = S_k_1 union S_k_2 union dots union S_k_(t-1)
$

* **Interpretação:* Este conjunto representa todos os itens que já podem ser atendidos com as ligas produzidas até o período $t-1$. Evita-se considerar novamente esses itens na seleção da próxima liga.

*Passo 2*: Identificar Itens Críticos para o Período Atual

$
B_t = { i | i in.not A_(t-1) " e " d_(i tau) > 0,  tau = 1,2,...,t }
$

- *Interpretação:* São os itens os quais nenhuma liga que os atende foi produzida até o período $t$. Esses itens devem ser priorizados na escolha da liga a ser produzida.

*Passo 3*: Escolha da Liga a Produzir

*Caso 1*: Se $B_t eq.not emptyset$ e existe uma liga capaz de produzir todos os itens de $B_t$:

$
k_t = arg max_(k=1,dots,L) { (sum_(i in S_k) P_(i t))^(abs(B_t inter S_k))- c s_k Z_t^k }
$

Escolhe-se a liga $k$ que maximiza a produção ponderada pelos custos de troca.

*Caso 2*: Se $B_t eq.not emptyset$ e nenhuma liga produz todos os itens de $B_t$:

$
k_t = arg max sum_(k=1,dots,L) (P_(i t) - c s_k Z_t^k)
$

Seleciona-se a liga que oferece a maior cobertura possível dos itens críticos, mesmo que não atenda a todos.

*Caso 3*: Se $B_t = emptyset$:

$
k_t = arg max_(k=1,dots,L) { sum_(i in S_k) (P_i t - c s_k Z_t^k) }
$

Neste caso, não há itens críticos. A escolha da liga visa maximizar a produção futura, considerando os custos de troca.

*Critérios de Desempate:*

Prioriza-se a liga com maior número de itens compatíveis (maior cardinalidade de $S_k$).

Caso permaneça o empate, pode-se considerar o menor custo de troca $c s_k$.

== Programação das Máquinas de Moldagem

Com as ligas definidas na etapa anterior, o próximo passo é planejar de forma eficiente a utilização das máquinas de moldagem, de modo a atender às quantidades $P_(i t)$ de cada item previamente determinadas. Esse planejamento visa equilibrar a carga de trabalho entre as máquinas, evitando sobrecarga e maximizando a eficiência do processo produtivo.

=== Variável de Controle

Precisaremos definir a seguinte variável:

$
X_(i m t): "Fração de tempo que a máquina" m "dedica ao item" i "no período t."
$

* Interpretação:* Representa o percentual do tempo disponível da máquina $m$ que será utilizado na produção do item $i$ durante o período $t$. Esta variável permite a flexibilidade de alocar a produção de um mesmo item em diferentes máquinas.

=== Função Objetivo

$
min (F_t = max { sum_(i=1)^N X_(i m t) }), quad m=1,dots,M
$

*Interpretação*: A função objetivo busca minimizar a maior fração de tempo utilizada por qualquer máquina no período $t$, promovendo o balanceamento da produção entre as máquinas disponíveis. Esse critério é conhecido como minimização do tempo de máquina mais carregada, sendo uma forma de reduzir gargalos no sistema produtivo.

=== Restrições

1. *Capacidade Máxima da Máquina:*

$
sum_(i=1)^N X_(i m t) lt.eq F_t, quad m=1,dots,M
$

Garante que nenhuma máquina ultrapasse a fração de tempo $F_t$ definida na função objetivo.

2. *Atendimento da Quantidade Definida para Cada Item:*

$
sum_(m=1)^M h_t a_(i m) X_(i m t) = P_(i t), quad i=1,dots,N
$

Assegura que a produção planejada $P_(i t)$ de cada item $i$ no período $t$ seja integralmente realizada, considerando a capacidade produtiva das máquinas e o tempo disponível.

3. *Não Negatividade das Variáveis de Produção:*

$
X_(i m t) gt.eq 0, quad m = 1,dots, M, quad i in S_(k_t)
$

Garante que a fração de tempo alocada a cada máquina seja não negativa, ou seja, não é possível utilizar tempo "negativo" de máquina para a produção de qualquer item.

4. *Compatibilidade da Liga Produzida:*

$
X_(i m t) = 0 " se "i in.not S_(k_t)
$

Impede que máquinas sejam alocadas para produzir itens cuja produção não é
compatível com a liga escolhida para o período $t$. Essa restrição respeita as
decisões tomadas na etapa de escolha de ligas.

=== Observações Adicionais

- O modelo de alocação das máquinas é análogo a um *problema de transporte generalizado*, em que se busca alocar recursos de forma ótima para atender à demanda.

- A solução deste modelo pode ser obtida de forma eficiente utilizando pacotes de otimização como AMPL/CPLEX, mesmo para instâncias de maior porte.
  
  Além da função objetivo apresentada, outras métricas de balanceamento da carga de trabalho podem ser utilizadas conforme as necessidades operacionais, como a minimização da soma dos tempos das máquinas ou a minimização da variância da utilização das máquinas.

- Este planejamento eficiente das máquinas é fundamental para garantir o cumprimento dos prazos de produção com o menor custo operacional possível, evitando a ociosidade excessiva ou a sobrecarga de determinados recursos produtivos.

== Conclusão sobre o Algoritmo Geral

O algoritmo geral integra as etapas de relaxação, heurística de seleção de ligas e programação da produção nas máquinas de moldagem. Embora não garanta a obtenção de soluções ótimas globais, o método proposto é eficiente, de baixo custo computacional e apresenta resultados bastante satisfatórios na prática, principalmente em cenários com grande número de itens e restrições de capacidade.

- *Etapas do Algoritmo*

1. *Inicialização:*

   Defina o período inicial $t = 1$.

2. *Resolução do Modelo Relaxado:*

   Resolva o modelo relaxado apresentado na Seção 4.1 para determinar os valores de $P_(i t)$, que indicam a quantidade ideal de cada item a ser produzida em cada período, sem considerar as restrições de liga.

3. *Heurística de Escolha das Ligas (Seção 4.2):*

   Com base nos valores de $P_(i t)$, aplique a heurística para definir qual liga $k_t$ será produzida no período $t$.
   Se for possível atender toda a produção planejada $P_(i t)$ com a liga escolhida, avance para o próximo período.
   Caso contrário, ajuste $P_(i t)$ eliminando as quantidades dos itens que não podem ser produzidos com a liga selecionada e reavalie a escolha da liga.

4. *Iteração ao Longo do Horizonte de Planejamento:*

   Repita os passos 2 e 3 para todos os períodos $t = 1, 2, dots, T$, garantindo que todas as ligas sejam escolhidas de forma coerente ao longo do horizonte de planejamento.

5. *Programação das Máquinas de Moldagem (Seção 4.3):*

   Após definir as ligas a serem produzidas em cada período, resolva o problema de alocação de produção entre as máquinas, garantindo o atendimento das quantidades $P_{i t}$ por meio da definição das variáveis $X_(i m t)$.
   Esta etapa busca minimizar o tempo máximo de utilização das máquinas em cada período, balanceando a carga de trabalho entre elas.


#bibliography(
  title: [Bibliografia],
  "referencias.bib",
  full: true,
  style: "springer-fachzeitschriften-medizin-psychologie",
)

// original

// #figure(
//   diagram(
//   	spacing: 8pt,
//   	cell-size: (8mm, 10mm),
//   	edge-stroke: 1pt,
//   	edge-corner-radius: 5pt,
//   	mark-scale: 70%,
  
//   	blob((0,1), [Add & Norm], tint: yellow, shape: hexagon),
//   	edge(),
//   	blob((0,2), [Máquinas\ Moldagem], tint: orange),
//   	blob((0,4), [Forno], shape: trapezium,
//   		width: auto, tint: red),
  
//   	for x in (-.3, -.1, +.1, +.3) {
//   		edge((0,2.8), (x,2.8), (x,2), "-|>")
//   	},
//   	edge((0,2.8), (0,4)),
  
//   	edge((0,3), "l,uu,r", "--|>"),
//   	edge((0,1), (0, 0.35), "r", (1,3), "r,u", "-|>"),
//   	edge((1,2), "d,rr,uu,l", "--|>"),
  
//   	blob((2,0), [Softmax], tint: green),
//   	edge("<|-"),
//   	blob((2,1), [Add & Norm], tint: yellow, shape: hexagon),
//   	edge(),
//   	blob((2,2), [Feed\ Forward], tint: blue),
//   ),
//   caption: []
// )