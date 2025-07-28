#import "lib.typ": *
#import "@preview/plotst:0.2.0": *
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/arborly:0.3.0": tree

#set text(lang: "pt")
#set heading(numbering: none)

#show table.cell.where(y: 0): strong

#set page(
  header: [
    _Lógica e Computabilidade_
    #h(1fr)
    Universidade Federal do Rio de Janeiro
  ]
  ,numbering: "1"
  ,margin: auto
)

#show: article.with()

#maketitle(
  title: "Lista I",
  authors: ("João Pedro Silva de Sousa\n122122366","Pedro Henrique Honorio Saito\n122149392"),
  id: "",
)

#set math.equation(numbering: "(1)")

#let V = $upright("V")$
#let F = $upright("F")$

= Questão 1

#v(.7em)

Considere um conjunto $X$ de fórmulas da $"LC"$ construídas a partir do conjunto $C = {and, or, arrow.r, arrow.r.l}$ de conectivos. Desejamos provar que, para $phi in X$, temos que:

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 17pt,
    [
  *Proposição*: Para todo $k in bb("N")$, se $phi$ possui $k$ ocorrências de símbolos proposicionais, então o comprimento de $phi$ é dado por $4k - 3$.
    ]
  )
]

Por indução sobre as fórmulas de $X$:

- *Base*: Seja $phi$ um símbolo proposicional pertencente à $X$. Assim, temos que

$
abs(phi) = 4(1) - 3 = 1. quad qed
$

- *Recursivo*: Dada uma fórmula $F in X$ de tamanho $m$ e uma fórmula básica $gamma$ da $"LC"$, a operação $*(F,gamma)$ resultará em:

//  Denotaremos por $*$ qualquer elemento de $C$, assim

$
(F * gamma)," tal que "abs((F * gamma)) = m + 4
$

- *Hipótese de Indução*: Para toda fórmula $F in X$ com $n lt.eq k - 1$ símbolos proposicionais, o comprimento da fórmula é dado por

$
abs(F_n) = 4n - 3,
$ <eq:a>

onde $F_n$ indica uma fórmula com $n$ símbolos proposicionais.

Portanto, partindo da @eq:a, substituindo $n = k - 1$ obteremos:

$
F_(k-1), thin " tal que "abs(F_(k-1))= 4(k - 1) - 3.
$

Aplicando uma operação binária qualquer $*(F_(k-1),phi)$ teremos como resultado:

$
abs((F_(k-1) * phi)) &= (4(k - 1) - 3) + 4 quad "por (2)" \
abs((F_(k-1) * phi)) &= 4(k - 1 + 1) - 3 \
abs((F_(k-1) * phi)) &= 4k - 3 \
$

Desse modo, concluímos que a expressão $4k - 3$ é válida para representar o comprimento de qualquer fórmula da linguagem $"LC"_"C"$ com $k$ símbolos proposicionais. $thin qed$

#pagebreak()

= Questão 3


== Item C

Vamos provar o seguinte resultado:

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 17pt,
    [
  *Proposição*: Nenhum cografo possui $P_4$ como subgrafo induzido.
    ]
  )
]

Por indução na estrutura de cografos:

*Base*: Somente um vértice, logo nada a demonstrar.

*Hipótese de Indução:* Suponha que $F$ seja a união disjunta ou o join de outros dois cografos $G$ e $H$ que não admitem $P_4$ como subgrafo induzido. Assim, vamos analisar cada um dos casos:

- *União disjunta*: Se $F$ é a união disjunta dos cografos $G$ e $H$, por hipótese de indução vale que $G$ e $H$ não possuem $P_4$ como subgrafo induzido. Se $F$ tivesse $P_4$ como subgrafo induzido, os vértices desse caminho estariam todos em $G$ ou em $H$, o que é impossível, já que a hipótese de indução vale para ambos.

- *Join*: Se $F$ é construído a partir do _join_ de $G$  e $H$, então seja $E$ o conjunto das arestas adicionadas entre os vértices de $G$ e $H$ para gerar $F$. Suponhamos por contradição que $P_4$ com vértices ${v_1, v_2, v_3, v_4}$ seja um subgrafo induzido  em $F$. Por hipótese de indução, não pode ocorrer de todos os vértices  estarem em $G$ ou $H$, disso seguem-se dois casos.

*I - * Sem perda de generalidade, se ocorre que $v_1 in G$ e $v_4 in H$,
então ${v_1, v_4} in E$, porém ${v_1, v_4}$ não é uma
aresta do caminho, o que contradiz a afirmação que $P_4$
é um subgrafo induzido.

*II - * Se $v_1, v_4 in G$, então, sem perda de generalidade, teríamos
três outras possibilidades

#let blob(pos, label, tint: white, name, ..args) = node(
	pos,
   label,
	fill: tint.lighten(60%),
	stroke: 1pt + tint.darken(20%),
   shape: circle,
   name: name,
	..args,
)

// Esses grafos vão dar trabalho
#figure(
  grid(columns: 3,
    align: auto,
    rows: (auto, 3pt),
    column-gutter: 60pt,
    // Grafo 1 (canto superior esquerdo da imagem)
    diagram(
      spacing: 2cm,
      blob((0,0), [$v_1$], tint: blue, <v1>),
      blob((1,0), [$v_2$], tint: red, <v2>),
      blob((0,1), [$v_3$], tint: blue, <v3>),
      blob((0,2), [$v_4$], tint: blue, <v4>),
      edge(<v1>, <v2>, "-", stroke: black),
      edge(<v2>, <v3>, "-", stroke: black),
      edge(<v3>, <v4>, "-", stroke: black),
    ),
    // Grafo 2 (canto superior direito da imagem)
    diagram(
      spacing: 2cm,
      blob((0,0), [$v_1$], tint: blue, <v1>),
      blob((1,0), [$v_2$], tint: red, <v2>),
      blob((1,1), [$v_3$], tint: red, <v3>),
      blob((0,1), [$v_4$], tint: blue, <v4>),
      edge(<v1>, <v2>, "-", stroke: black),
      edge(<v2>, <v3>, "-", stroke: black),
      edge(<v3>, <v4>, "-", stroke: black),
    ),
    // Grafo 3 (parte inferior da imagem)
    diagram(
      spacing: 2cm,
      blob((0,0), [$v_1$], tint: blue, <v1>),
      blob((0,1), [$v_2$], tint: blue, <v2>),
      blob((1,1), [$v_3$], tint: red, <v3>),
      blob((0,2), [$v_4$], tint: blue, <v4>),
  
      edge((0, 0), (0, 1), "-", stroke: black),
      edge((0, 1), (1, 1), "-", stroke: black),
      edge((1, 1), (0, 2), "-", stroke: black),
  
      // node((0, 2.5), [G], shape: none),
      // node((1, 1.5), [H], shape: none),
    )
  ),
  caption: [_Possibilidades de distribuição dos vértices de $P_4$ entre $G$ e $H$. Os marcados em azul pertencem a $G$, e os de vermelho a $H$_]
)

No primeiro, temos que $v_2 in H $ e $v_4 in G$, logo ${v_2, v_4} in E$, porém essa aresta não está nas arestas de $P_4$.
Nos outros dois, temos $v_1 in G$ e $v_3 in H$, de modo que ${v_1, v_3} in E$, mas essa aresta também não está em $P_4$
em ambos os casos.

Esgotadas as possibilidades, concluímos então que não é possível $P_4$ ser um
subgrafo induzido de um cografo. Uma vez que provamos para $F$, então pelo Princípio
de Indução Finita, essa propriedade vale para todo cografo . $qed$

== Item D

// encontreu um pacote interessante, parece mais tranquilo: https://typst.app/universe/package/diagraph/
#align(center)[
  #diagram(
    spacing: 1cm,
    node((4,0), [$v_1$], shape: circle, stroke: 0.5pt),
    node((6.7,0.5), [$v_2$], shape: circle, stroke: 0.5pt),
    node((6.7,2), [$v_3$], shape: circle, stroke: 0.5pt),
    node((4.5,3), [$v_4$], shape: circle, stroke: 0.5pt),
    node((3,1), [$v_5$], shape: circle, stroke: 0.5pt),
  
    edge((4,0), (6.7, 2), "-"), //1-3
    edge((6.7, 0.5), (3,1)), //2-5
    edge((6.7, 0.5), (4.5, 3)), //2-4
    edge((3,1), (4.5, 3)), //4-5
    edge((6.7, 2), (3,1)) //3-1
  )
]

Com efeito, se ao removermos $v_2$ e as arestas que esse vértice
participa, obteremos um subgrafo induzido $P_4$, e o grafo acima
não pode ser, pois, um cografo pelo que foi provado no item anterior. 
#align(center)[
  #diagram(
    spacing: 1cm,
    node((4,0), [$v_1$], shape: circle, stroke: 0.5pt),
    //node((6.7,0.5), [$v_2$], shape: circle, stroke: 0.5pt),
    node((6.7,2), [$v_3$], shape: circle, stroke: 0.5pt),
    node((4.5,3), [$v_4$], shape: circle, stroke: 0.5pt),
    node((3,1), [$v_5$], shape: circle, stroke: 0.5pt),
  
    edge((4,0), (6.7, 2), "-"), //1-3
    //edge((6.7, 0.5), (3,1)), //2-5
    //edge((6.7, 0.5), (4.5, 3)), //2-4
    edge((3,1), (4.5, 3)), //4-5
    edge((6.7, 2), (3,1)) //3-1
  )
]$qed$

= Questão 9

#v(.7em)

Sejam $J$ o conjunto dos jogadores do torneio $T$ onde todos os jogadores
enfrentam os demais em partidas que não admitem empates, e $D$ uma
relação binária em $J$ tal que, se $A, B in J$ são jogadores e $(A, B) in D$,
dizemos que "$A$ perdeu para $B$". Se $T$ é um par ordenado
$(J,D)$, então $T$ é um grafo de torneio, isto é, um grafo
direcionado anti-simétrico e completo.

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
  *Proposição*: Em um torneio $T$ sempre há um jogador $A in J$
  tal que, para qualquer outro jogador $B in J$, pelo menos uma
  das afirmações abaixo é satisfeita

  *I* - $(B, A) in D$ #h(19.6em) <I>

  *II* - Existe um jogador $C in J$ tal que $(B, C) in D$ e $(C, A) in D$ <II>
    ]
  )
]

Um jogador $A$ que satisfaz a proposição acima
será referido daqui em diante como _pivô_. Dessa forma
provaremos a proposição por indução no número $n >= 2$ de jogadores no torneio.

*Base:* Com $n = 2$, se $(B, A) in D$, então I é satisfeita com o
pivô $A$. Do contrário, temos que $(A, B) in D$, e I é satisfeito para
$B$ como pivô.

*Hipótese de Indução:* Suponha que a proposição vale para um torneio de $n > 2$ jogadores.

Seja $T$ um torneio de $n+1$ jogadores e $T'$ um subtorneio de $n$ jogadores
de $T$ obtido ao se desconsiderar um jogador $K in J$ e todas as suas partidas.
Em outras palavras, $T'$ é um subgrafo induzido de $T$ ao se remover o vértice 
rotulado por $K$.

Pela hipótese de indução, $T'$ possui um pivô $A in J$. A partir disso,
teremos três casos para o torneio $T$:

*I.* $(K, A) in D$, então #link(<I>)[#underline("I")] é satisfeita. Disso segue que a proposição vale para $T$ com o pivô $A$.

*II.*  $exists" " C in J, ((K, C) in D  " e "  (C, A) in D)$, nesse caso a afirmação II é satisfeita.
Portanto, para esse caso, também vale que $A$ é um pivô do torneio $T$.

*III*. $forall B in J, ((B, K) in D " ou " (A, B) in D)$, ou seja, para qualquer jogador
$B$, se $K$ perdeu para $B$, então $A$ perdeu para $B$. Se o consequente dessa condição
é verdadeiro, então pela hipótese de indução existe $C in J$ tal que

$
(B, C) in D " e " (C, A) in D
$

Uma vez que $C$ perdeu para $A$, então temos que $C$ deve ter perdido para $K$
visto o que está sendo afirmado em *III*. Por conseguinte, temos que $B$ perdeu para "alguém"
que perdeu para $K$. Concluímos então que, para todo B, uma das afirmações é verdadeira

#align(center)[
  _$B$ perdeu para $K$ #v(2pt) $B$ perdeu para alguém que perdeu para $K$._
]

Portanto, a proposição vale para o torneio $T$ com o jogador $K$ como o pivô, e
portanto, para um torneio de $n+1$ jogadores. Pelo Princípio de Indução, como vale 
para um para $n=2$ e para $n+1$ com $n > 2$, então vale para todo $n >= 2$. $qed$

= Questão 13

== Item H

#v(.7em)

Antes de provarmos o resultado da proposição de conectivos completos, vamos estabelecer a seguinte definição:

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
  *Conjuntos de Conectivos Completos*: Seja $C$ um conjunto de conectivos,
  dizemos que $C$ é completo se, para qualquer conjunto $"Prop"$ de proposições,
  para toda fórmula $phi$ da $"LC"("Prop")$, existe $psi in "LC"_"C"("Prop")$
  tal que $(phi tack.double.r psi and psi tack.double.r phi)$.
    ]
  )
]

_Observação._ Por conveniência, usaremos o símbolo $tack.r.l$ para denotar equivalência semântica.

Posto isso, desejamos provar a proposição abaixo:

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
  *Conjuntos de Conectivos Completos*: Mostre que o conjunto $C$ de conectivos ${bot, top, mono("IF-THEN-ELSE")}$ é completo.
    ]
  )
]

Por indução em $phi$ da $upright("LC"("Prop"))$ usual com todos os conectivos:

- *Base*: Se $phi$ é básica, isto é, $phi in upright("Prop")$, então $phi$ está em $upright("LC"_"C"("Prop"))$ também.$thick thin qed$
- *Indutivos*: Agora provaremos para cada um dos conectivos ${not, or, and, arrow.r, arrow.r.l}$ da $upright("LC"_"C" ("Prop"))$.

$upright("R" thin not thin ")")$ Se $phi$ é $(not psi)$, então pela hipótese de
indução existe $beta in upright("LC"_"C" ("Prop"))$  de modo que $psi tack.r.l
beta$. Logo, podemos concluir que $(mono("IF") beta mono("THEN") top
mono("ELSE") bot) tack.r.l (not psi)$.

$upright("R" thin and thin ")")$ Considerando $phi$ igual à $(alpha and beta)$ e $dot(alpha), dot(beta) in upright("LC"_"C" ("Prop"))$ de modo que $alpha tack.r.l dot(alpha)$ e $beta tack.r.l dot(beta)$. Logo, podemos concluir que $(mono("IF") dot(alpha) mono("THEN") dot(beta) mono("ELSE") bot) tack.r.l (alpha and beta)$.

$upright("R" thin or thin ")")$ Considerando $phi$ igual à $(alpha or beta)$ e $dot(alpha), dot(beta) in upright("LC"_"C" ("Prop"))$ de modo que $alpha tack.r.l dot(alpha)$ e $beta tack.r.l dot(beta)$. Logo, podemos concluir que $(mono("IF") dot(alpha) mono("THEN") top mono("ELSE") dot(beta)) tack.r.l (alpha or beta)$.

$upright("R" thin arrow.r thin ")")$ Considerando $phi$ igual à $(alpha arrow.r
beta)$ e $dot(alpha), dot(beta) in upright("LC"_"C" ("Prop"))$ de modo que
$alpha tack.r.l dot(alpha)$ e $beta tack.r.l dot(beta)$. Logo, podemos concluir
que $(mono("IF") dot(alpha) mono("THEN") dot(beta) mono("ELSE") top) tack.r.l
(alpha arrow.r beta)$.

$upright("R" thin arrow.r.l thin ")")$ Considerando $phi$ igual à $(alpha
arrow.r.l beta)$ e $dot(alpha), dot(beta) in upright("LC"_"C" ("Prop"))$ de modo
que $alpha tack.r.l dot(alpha)$ e $beta tack.r.l dot(beta)$. Logo, podemos
concluir que $(mono("IF") dot(alpha) mono("THEN") dot(beta) mono("ELSE")
(mono("IF") dot(beta) mono("THEN") bot mono("ELSE") top)) tack.r.l (alpha
arrow.r.l beta)$.

Para averiguarmos as operação realizadas, podemos montar a tabela verdade para cada um dos conectivos.

#grid(
  columns: (auto, auto),
  rows: (auto, auto, auto),
  row-gutter: 17pt,
  figure(
    table(
      columns: 2,
      table.header(
        [$dot(beta)$], [$mono("IF") dot(beta) mono("THEN") bot mono("ELSE") top$]
      ),
      [V], [F],
      [F], [V],
    ),
   caption: [_Tabela verdade equivalente a $(not beta)$._]
  ),
  figure(
    table(
      columns: 3,
      table.header(
        [$dot(alpha)$], [$dot(beta)$], [$mono("IF") dot(alpha) mono("THEN") dot(beta) mono("ELSE") bot$]
      ),
      [V], [V], [V],
      [V], [F], [F],
      [F], [V], [F],
      [F], [F], [F],
    ),
    caption: [_Tabela verdade equivalente a $(alpha and beta)$._]
  ),
  figure(
    table(
      columns: 3,
      table.header(
        [$dot(alpha)$], [$dot(beta)$], [$mono("IF") dot(alpha) mono("THEN") top mono("ELSE") dot(beta)$]
      ),
      [V], [V], [V],
      [V], [F], [V],
      [F], [V], [V],
      [F], [F], [F],
    ),
    caption: [_Tabela verdade equivalente a $(alpha or beta)$._]
  ),
  figure(
    table(
      columns: 3,
      table.header(
        [$dot(alpha)$], [$dot(beta)$], [$mono("IF") dot(alpha) mono("THEN") dot(beta) mono("ELSE") top$]
      ),
      [V], [V], [V],
      [V], [F], [F],
      [F], [V], [V],
      [F], [F], [V],
    ),
    caption: [_Tabela verdade equivalente a $(alpha arrow.r beta)$._]
  ),
  grid.cell(
  colspan: 2,
  figure(
    table(
      columns: 3,
      table.header(
        [$dot(alpha)$], [$dot(beta)$], [$mono("IF") dot(alpha) mono("THEN") dot(beta) mono("ELSE") (mono("IF") dot(beta) mono("THEN") bot mono("ELSE") top)$]
      ),
      [V], [V], [V],
      [V], [F], [F],
      [F], [V], [F],
      [F], [F], [V],
    ),
    caption: [_Tabela verdade equivalente a $(alpha arrow.r.l beta)$._]
  )
  )
)

#pagebreak()

= Questão 14

== Item B <q14b>

#v(.7em)

Vamos demonstrar o seguinte resultado:

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
     *Proposição*: Seja $C$ o conjunto de conectivos ${and, or, arrow.r, arrow.r.l}$ e $phi in upright("LC"_"C" ("Prop"))$ uma fórmula construída a partir dos conectivos de $C$. Se $p_0, p_1, dots, p_n$ são as subfórmulas atômicas de $phi$, então podemos afirmar que

     $
     p_0, p_1, dots, p_n tack.double.r phi.
     $
    ]
  )
]

// aqui eu acho melhor fazer a indução em n
// base: phi = po e p0 é satisfeita, então phi é satisfeito
// indutivo: seja alpha uma fórmula com sentenças básicas p0,...,pn-1 constreuída pelos conectivos de C
// HI: suponha que vale para alpha. Se phi = alpha * pn, e alpha é satisfeito quando suas fórmulas básicas são satisfeitas, e pn também é satisfeito, então alpha * phi vai ser satisfeito segundo cada um dos casos

// Mas também, a forma como está não está ruim, só que a indução parece não foi bem utilizada.
// A demonstração atual prova que para quisquer DUAS fórmula básicas p0 e p1 que são satisfeitas, p0 * p1 então é satisfeito, portanto qualquer combinação de vários pares de fórmulas usando os conectivos vai ser automaticamente satisfeito.

//então nesse caso acho melhor optar uma abordagem só com indução (a primeira), ou uma que vai provando
// usando os conectivos e o argumentos que qualquer combinações de n pares vai ser satisfeito (que é como está escrito agora, só que sem a parte de indução)

// se não estiver com tempo por causa dos seus trabalhos, e quiser que eu altere eu posso fazer sem problemas

Por indução sobre as fórmulas de $X$:

- *Base*: Se $phi$ é uma fórmula atômica, então $phi = p_i$ para algum $i in {0,dots,n}$. Logo, qualquer contexto $c_i$ que torne verdadeiros todos os $p_0,p_1,dots,p_n$ satisfaz em particular $p_i$, ou seja,

$
c_i (p_0) = dots = c_i (p_n) = upright("V") arrow.double.r p_0,p_1,dots,p_n tack.double.r phi wide forall thin phi = p_i.thick thick qed
$

- *Hipótese de Indução*: Sejam $alpha$ e $beta$ subfórmulas de $phi$ construídas a partir de $C$, assumiremos, pela hipótese de indução, que

$
{p_0,p_1,dots,p_n} tack.double.r alpha " e " {p_0,p_1,dots,p_n} tack.double.r beta.
$

Queremos mostrar que, sob a mesma condição, vale $c(phi) = upright("V")$. Analisando cada caso:

  - *Caso *$(phi = alpha and beta)$: 
    $
    c(alpha and beta) = upright("V") arrow.double.r.l c(alpha) = upright("V") " e " c(beta) = upright("V")
    $
    Mas pela hipótese de indução, temos que $c(alpha)=c(beta)=upright("V")$, logo $c(phi)=upright("V")$.
    
  - *Caso *$(phi = alpha or beta)$: 
    $
    c(alpha or beta) = upright("V") arrow.double.r.l c(alpha) = upright("V") " ou " c(beta) = upright("V")
    $
    Novamente, pela HI, temos que $c(alpha)=c(beta)=upright("V")$, logo $c(phi)=upright("V")$.

  - *Caso *$(phi = alpha arrow.r beta)$: 
    $
    c(alpha arrow.r beta) = upright("V") arrow.double.r.l c(alpha) = upright("F") " ou " c(beta) = upright("V")
    $
    Assim, como $c(beta)=upright("V")$, logo $c(phi)=upright("V")$.
    
  - *Caso *$(phi = alpha arrow.r.l beta)$: 
    $
    c(alpha arrow.r.l beta) = upright("V") arrow.double.r.l c(alpha) = c(beta)
    $
    Em todos os casos $c(alpha)=c(beta)=upright("V")$, temos que $c(phi)=upright("V")$.
    
    
  // Como $alpha$ e $beta$ são verdadeiras sob suas respectivas fórmulas, então $(alpha and beta)$ também é verdadeira. Logo, $p_0,dots,p_n tack.double.r alpha and beta$.
  // - *Caso *$(phi = alpha or beta)$: Como $alpha$ ou $beta$ é verdadeira, $(alpha or beta)$ é verdadeira. Logo, $p_0,dots,p_n tack.double.r alpha or beta$.
  // - *Caso *$(phi = alpha arrow.r beta)$: Como $alpha$ ou $beta$ é verdadeira, $(alpha or beta)$ é verdadeira. Logo, $p_0,dots,p_n tack.double.r alpha or beta$.

    
  // Como $alpha$ e $beta$ são verdadeiras sob suas respectivas fórmulas, então $(alpha and beta)$ também é verdadeira. Logo, $p_0,dots,p_n tack.double.r alpha and beta$.
  // - *Caso *$(phi = alpha or beta)$: Como $alpha$ ou $beta$ é verdadeira, $(alpha or beta)$ é verdadeira. Logo, $p_0,dots,p_n tack.double.r alpha or beta$.
  // - *Caso *$(phi = alpha arrow.r beta)$: Como $alpha$ ou $beta$ é verdadeira, $(alpha or beta)$ é verdadeira. Logo, $p_0,dots,p_n tack.double.r alpha or beta$.

// - *Hipótese de Indução*: Denotando por $*$ uma operação binária qualquer de $C$, diremos que a operação $(alpha * beta)$ é consequência semântica das $n-1$ subfórmulas atômicas $p_0,p_1,dots,p_(n-1)$ que compõem $alpha" ou "beta$ de $"Prop"$.

// Com efeito, ao adicionarmos uma operação binária da forma $phi=((a * beta) * p_n)$, temos que $phi$ continuará sendo consequência semântica das subfórmulas atômicas que o compõe, isto é, $p_0,p_1,dots,p_n$.

// - *Indutivo*: Agora provaremos para todos os conectivos de $C$ com a *hipótese de indução* de que  as subfórmulas são verdadeiras para quaisquer contextos. Assim, constataremos que uma fórmula $phi$ formada a partir das operações dos conectivos $C$ é consequência semântica das subfórmulas atômicas $p_0,p_1,dots,p_n$ que a compõem.

// $upright("R" thin and thin ")")$ Se $phi$ é $(p_0 and p_1)$, então pela hipótese de indução, para todos os contextos $c_i$ tais que $c_i(p_0) = c_i(p_1) = upright(V)$, concluímos que $phi$ também é verdade pois $(upright(V) and upright(V)) = upright(V)$. Logo, $(p_0 and p_1) tack.double.r phi$.

// $upright("R" thin or thin ")")$ Se $phi$ é $(p_0 and p_1)$, então pela hipótese de indução, para todos os contextos $c_i$ tais que $c_i(p_0) = c_i(p_1) = upright(V)$, concluímos que $phi$ também é verdade pois $(upright(V) or upright(V)) = upright(V)$. Logo, $(p_0 or p_1) tack.double.r phi$.

// $upright("R" thin arrow.r thin ")")$ Se $phi$ é $(p_0 arrow.r p_1)$, então pela hipótese de indução, para todos os contextos $c_i$ tais que $c_i(p_0) = c_i(p_1) = upright(V)$, concluímos que $phi$ também é verdade pois $(upright(V) arrow.r upright(V)) = upright(V)$. Logo, $(p_0 arrow.r p_1) tack.double.r phi$.

// $upright("R" thin arrow.r.l thin ")")$ Se $phi$ é $(p_0 arrow.r.l p_1)$, então pela hipótese de indução, para todos os contextos $c_i$ tais que $c_i(p_0) = c_i(p_1) = upright(V)$, concluímos que $phi$ também é verdade pois $(upright(V) arrow.r.l upright(V)) = upright(V)$. Logo, $(p_0 arrow.r.l p_1) tack.double.r phi$.

Portanto, para quaisquer fórmulas de $p_0,p_1,dots,p_n$ e quaisquer combinação
dos conectivos de $C$, teremos que $p_0,p_1,dots,p_n tack.double.r phi$.$thick thick qed$

#pagebreak()

== Item C

Vamos provar a seguinte proposição:

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
      *Proposição*: O conjunto $C = {or, and, arrow.r, arrow.r.l}$  de conectivos não é completo.
    ]
  )
]

Suponha, por contradição, que o conjunto $C$ de conectivos é completo. Então, para toda fórmula $phi in "LC"("Prop")$, existe $psi in "LC"_"C"("Prop")$ tal que $(phi tack.r.double psi and psi tack.r.double phi)$.

// Assim, temos que para todas as fórmulas $phi in upright("LC"("Prop"))$, existe $psi in upright("LC"_"C" ("Prop"))$ tal que $(phi tack.r.double psi and psi tack.r.double phi)$.

Logo, basta encontrar uma fórmula $phi in "LC"("Prop")$ que não seja semanticamente equivalente a nenhuma fórmula em $"LC"_"C" ("Prop")$. Considere $phi = (not thin p_0)$. Desejamos encontrar $psi in "LC"_"C"("Prop")$ tal que $(phi tack.double.r psi)$ e vice-versa.

Note que, como $C$ contém apenas conectivos binários, qualquer fórmula em $"LC"_"C" ("Prop")$ deve ter a forma:

#align(center)[
  #grid(
    columns: 4,
    column-gutter: 20pt,
    $(p_0 and p_1)$,
    $(p_0 or p_1)$,
    $(p_0 arrow.r p_1)$,
    $(p_0 arrow.r.l p_1)$,
  )
]

Se $p_0$ e $p_1$ forem semanticamente verdadeiros em algum contexto, então toda a fórmula também o será (como provado na #link(<q14b>)[#underline("Questão 14 b")]). Nesse caso, $(not thin p_0)$ seria falsa, o que gera contradição com a hipótese de equivalência. Portanto, não existe $psi in "LC"_"C" ("Prop")$ tal que $psi tack.double.r not thin p_0$, e $C$ não é completo.$thick thick qed$

// Refatorei minha resolução

// Portanto, se eu encontrar uma fórmula $phi$ da $upright("LC"("Prop"))$ usual de modo que $phi$ não seja semanticamente equivalente a nenhuma fórmula da $upright("LC"_"C" ("Prop"))$, então saberemos que esse conjunto de conectivos não é completo.

// Considere a fórmula $phi = (not thin p_0)$ da $upright("LC"("Prop"))$, desejamos encontrar uma fórmula $psi in upright("LC"_"C" ("Prop"))$ de forma que $phi tack.double.r.not psi$ ou vice-versa. Primeiramente, vamos concordar que a fórmula de $upright("LC"_"C" ("Prop"))$ poderá ter uma das seguintes caras:

// Onde $p_0,p_1$ são fórmulas (não necessariamente atômicas) da $"LC"_"C"
// ("Prop")$ semanticamente equivalentes à outras fórmulas $alpha,beta$ por exemplo
// da $"LC"("Prop")$. Como temos a restrição de que ${p_0, p_1} tack.double.r phi$,
// então para todos os contextos $c_i$, vale que $c_i(p_0) = c_i(p_1) =
// upright("V")$. Como provamos na #link(<q14b>)[#underline("Questão 14 b")], para
// todos os contextos nos quais $p_0$ e $p_1$ são verdadeiros o resultado também
// será *verdadeiro*. Desse modo, temos que $c(p_0) = c(p_1) = upright("V")$, no entanto isso implica que $(not thin p_0) = upright("F")$ chegando em uma contradição. $thick thick qed$

= Questão 17

== Item A

#v(.7em)

Considerando os julgamentos $Gamma = {(p or q): V, (p arrow.r r):V, (q arrow.r r): V, r: F}$, vamos montar uma árvore de avaliação:
// man, this tree is wrong :(
// Exemplo
#figure(
  tree[$p arrow.r r:upright("V") (Gamma)^1 checkmark$
  [$p:upright("F")(1)^2$
    [$p or q:upright("V")(Gamma)^4 checkmark$
      [$p:upright("V")(4)^6$#linebreak()$sans("X") thick 2,6$]
      [$q:upright("V")(4)^7$
        [$q arrow.r r:upright("V")(Gamma)^8 checkmark$
          [$q:upright("F")(11)^9$#linebreak()$sans("X") thick 7,9$]
          [$r:upright("V")(11)^10$
            [$r:upright("F")(Gamma)^11$#linebreak()$sans("X") thick 10,11$]]]]]]
    [$r:upright("V")(1)^3$
      [$r:upright("F")(Gamma)^5$#linebreak()$sans("X") thick 3,5$]]
],
  caption: [_Árvore de avaliação com ramos fechados e outros saturados._]
)

Onde cada nó segue o modelo:

#align(center)[
$
italic("fórmula":"julgamento"("origem")^"índice") " tal que "checkmark=italic("mexido")" e "sans("X")=italic("fechado")
$
]

Uma vez que a árvore fechou, então temos que $r$ é consequência sintática do conjunto de fórmulas
${(p or q), (p arrow.r r), (q arrow.r r)}$.

== Item C

#v(.7em)

Seja o conjunto de julgamentos $Gamma = {p arrow.r.l (q arrow.r.l r): V, (p and (q and r)) or ((not p) and ((not q) and (not r))): F}$, uma árvore de avaliação para $Gamma$ é dada abaixo.


#figure(
  tree[$p arrow.r.l (q arrow.r.l r): #V (Gamma)^1 checkmark$
  [$(p and (q and r)) or ((not p) and ((not q) and (not r))): #F (Gamma)^2 checkmark$
    [$p: #V (1)^3$
      [$q arrow.r.l r: #V (1)^5 checkmark$
        [$q: #V (5)^7$
          [$r: #V (5)^9$]]
        [$q: #F (5)$^8
          [$r: #F (5)^10$
            [$p and (q and r): #F (2)^11$]
            [$not p and ((not q) and (not r)): #F (2)^12 checkmark$
              [$not p: #F (12)^13 checkmark$
                [$p: #V (12)^14$]]
              [$(not q) and (not r): #F (12)^14$]]]]
      ]]
  [$p: #F (1)^4$
    [$q arrow.l.r r: #F (1)^6$]]]
]
)

Por definição, o ramo do nó 14 está aberto e saturado, de modo que $Gamma$ é satisfazível e, portanto, temos que 

$
p arrow.r.l (q arrow.r.l r) tack.not (p and (q and r)) or ((not p) and ((not q) and (not r)))
$

= Questão 18

// vi na wikipedia também e parce que realmente o nó fecha direto quando tem contradição top : F e bot : V
// uma forma de "provar" isso é que por exemplo bot |==| a and not a, e top |==| a or not a
// fazendo cada um dos quatro casos com as regras de conectivos clássicos, vemos que a or not a: V fica aberto; a or not a: F fecha; a and not a: V fecha; e a and not a: F fica aberto. O uso de fórmulas semânticamente equivalentes vem da resposta que ele deu a minha pergunta na última aula, que se eu tenho duas fórmulas phi e psi que eu sei que são semanticamente equivalentes, então phi: V --- psi : V é uma regra, e phi: F --- psi: F também é regra. Ma provavelmente são explicitar as regras seja suficiente justificando que é umpossível top: F e bot: V

== Item C

#v(.7em)

Seja $C$ o conjunto de conectivos ${top, bot, mono("IF-THEN-ELSE")}$, vamos
encontrar as regras de manipulação de árvores de avaliação para esses conectivos
e que sejam _corretas_, isto é, que preservem a satisfabilidade das árvores.

Comecemos pelos conectivos $top$ e $bot$, que são avaliados diretamente para verdadeiro e falso, respectivamente. Como não dependem de subfórmulas, definiremos suas regras como:

- *Regra *$top$: Se $A$ é árvore de avaliação para um conjunto de julgamentos $Gamma$ e $r$ é um ramo aberto com o nó ainda não _mexido_ $(top: #V )$, então nenhuma ação é necessária pois $top$ é avaliado diretamente para verdadeiro independentemente. Por outro lado, se nos depararmos com o nó $(top: #F )$, fechamos imediatamente a árvore pois isso representa uma contradição.

- *Regra *$bot$: Análogo ao caso anterior, isto é, para $(bot: #F )$ não há nada a se fazer e, se encontrarmos $(bot: #V )$, fechamos a árvore pois isso indica uma contradição.

Por fim, a regra para o conectivo $mono("IF-THEN-ELSE")$ pode ser facilmente identificada ao analisarmos sua tabela verdade:

#set table.hline(stroke: .6pt)
#import table: cell

#let green-color = color.linear-rgb( 31%, 71%, 10%)
#let red-color = color.linear-rgb( 100%, 23%, 27%)

#figure(
    table(
      stroke: none,
      columns: 4,
      table.header(
        [$alpha$], [$beta$], [$gamma$], [$mono("IF") alpha mono("THEN") beta mono("ELSE") gamma$]
      ),
      table.hline(),
      table.cell([#V], fill: green-color), table.cell([#V], fill: green-color), table.cell([#V], fill: green-color), table.cell([#V], fill: green-color),
      table.cell([#V], fill: green-color), table.cell([#V], fill: green-color), table.cell([#F], fill: green-color), table.cell([#V], fill: green-color),
      table.cell([#V], fill: red-color), table.cell([#F], fill: red-color), table.cell([#V], fill: red-color), table.cell([#F], fill: red-color),
      table.cell([#V], fill: red-color), table.cell([#F], fill: red-color), table.cell([#F], fill: red-color), table.cell([#F], fill: red-color),
      table.cell([#F], fill: green-color), table.cell([#V], fill: green-color), table.cell([#V], fill: green-color), table.cell([#V], fill: green-color),
      table.cell([#F], fill: red-color), table.cell([#V], fill: red-color), table.cell([#F], fill: red-color), table.cell([#F], fill: red-color),
      table.cell([#F], fill: green-color), table.cell([#F], fill: green-color), table.cell([#V], fill: green-color), table.cell([#V], fill: green-color),
      table.cell([#F], fill: red-color), table.cell([#F], fill: red-color), table.cell([#F], fill: red-color), table.cell([#F], fill: red-color),
    ),
  caption: [_Tabela verdade para $mono("IF-THEN-ELSE")$._]
)

Como podemos perceber, para $mono("IF-THEN-ELSE")$ verdadeiro temos duas opções:

+ $alpha$ e $beta$ são verdadeiros, sendo $gamma$ indeterminado pois pode assumir tanto #V quanto #F.
+ $alpha$ falso e $gamma$ verdadeiro, sendo que $beta$ pode assumir tanto #V quanto #F.

Por outro lado, para $mono("IF-THEN-ELSE")$ falso temos outras duas opções:

+ $alpha$ e $gamma$ são falsos, tal que $beta$ pode assumir tanto #V quanto #F.
+ $alpha$ verdadeiro e $beta$ falso, sendo que $gamma$ varia entre #V e #F.

Assim, para uma árvore de avaliação $A$ com nó ainda não _mexido_ $(mono("IF") alpha mono("THEN") beta mono("ELSE") gamma): #V $ ou $(mono("IF") alpha mono("THEN") beta mono("ELSE") gamma): #F $, teremos as regras:

#figure(
  grid(
    gutter: 8pt,
    columns: 2,
      tree[$(mono("IF") alpha mono("THEN") beta mono("ELSE") gamma): #V (Gamma)^1$
      [$alpha: #V (1)^2$[$beta: #V (1)^4$]][$alpha: #F (1)^3$[$gamma: #V (1)^5$]]],
      tree[$(mono("IF") alpha mono("THEN") beta mono("ELSE") gamma): #F (Gamma)^1$
      [$alpha: #F (1)^2$[$gamma: #F (1)^4$]][$alpha: #V (1)^3$[$beta: #F (1)^5$]]],
  ),
  caption: [_Regra de conectivo para $mono("IF-THEN-ELSE")$ verdadeiro e falso._]
)

$qed$

= Questão 19

== Item A

#v(.7em)

Antes de provarmos o resultado da proposição, iremos provar o seguinte lema

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
  *Lema*: Seja $r$ um ramo de uma árvore de avaliação e $phi: *$ um julgamento que
  ocorre como rótulo nesse ramo. Se $r'$ é a extensão do ramo $r$
  ao se aplicar uma regra de conectivo a $phi: *$,
  e $c$ um contexto que satisfaz $r'$, então $c$ satisfaz $phi: *$
    ]
  )
]

*Demonstração:* Provaremos observando cada regra da árvore de avaliação.

$upright("R" thin not thin ")")$ Seja $phi = (not psi)$, como $r$ é saturado,
então $psi: overline(*)$ ocorre como rótulo em $r$ por definição. Uma vez que
$c$ satisfaz $psi: overline(*)$ por hipótese, então temos que $c(psi) =
overline(*) arrow.r.double.long c(phi) = *$, e $phi: *$ é satisfeito

$upright("R" thin and thin ")") thin upright(V):$ Se $phi = alpha and beta$, então $alpha: #V$ e $beta: #V$ ocorrem como rótulos em
$r$. Como $c(alpha) = #V$ e $c(beta) = #V$, então $c(phi) = #V$.

$upright("R" thin and thin ")") thin upright(F):$ Temos que $alpha: #F$ ou $beta:
#F$ ocorrem como rótulos em $r$. Como vale que $c$ satisfaz o julgamento de
$alpha$ ou $beta$ por hipótese, então teremos que $c(alpha and beta) = c(phi) =
#F$.

$upright("R" thin or thin ")") thin upright(V):$ Se $phi = alpha or beta$, então
$alpha: #V$ ou $beta: #V$ ocorrem como rótulos em $r$. Como $c(alpha) = #V$ ou
$c(beta) = #V$, então $c(phi) = #V$.

$upright("R" thin or thin ")") thin upright(F):$ Neste caso ocorrem tanto
$alpha: #F$ quanto $beta: #F$ em $r$. Uma vez que esses julgamentos são
satisfeitos, então $c(phi) = #F$.

$upright("R" thin arrow.r thin ")")$ #V: Se $phi = alpha arrow.r beta$, então
$alpha: #F$ ou $beta: #V$ ocorrem como rótulos em $r$. Se $c$ satisfaz ao menos um
desses julgamentos, então $c$ irá satisfazer $phi: #V$

$upright("R" thin arrow.r.l thin ")")$ #V: Se $phi = alpha arrow.r.l beta$, então temos que ou
$alpha: #V$ e $beta: #V$ ocorrem em $r$, ou $alpha: #F$ e $beta: #F$ ocorrem no mesmo ramo. Para ambos
os casos, como os julgamentos são satisfeitos, é verdade que $c(phi) = #V$, e $c$ satisfaz $phi: #V$

$upright("R" thin arrow.r.l thin ")")$ F: Por fim, se $phi = alpha arrow.l.r beta$, então ou 
$alpha: #V$ e $beta: #F$ ocorre em $r$, ou $alpha: #F$ e $beta: #V$ ocorre em $r$. Como para qualquer
um dos casos, $c$ satisfaz esses julgamentos, teremos que $c(phi) = #F$.
// restante é análogo depois completo

$qed$

Agora provando o resultado seguinte.
#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
  *Proposição*: Se $r$ é um ramo aberto e saturado numa árvore de avaliação
  $A$ para $Gamma$, e $c_r$ é um contexto construído como

  $
  c_r (p) = cases(#V", se" p: #V,
                 #F", se" p: #F)
  $ <eq:cr>
  em que $p$ são fórmulas básicas que ocorrem em julgamentos que rotulam os vértices
  de $r$, então $c_r$ satisfaz todos os julgamentos que ocorrem em $r$.
    ]
  )
]

*Demonstração:* Se $phi: *$ é um julgamento que ocorre em $r$, então provaremos por
indução na estrutura sintática de $phi$

*Base:* Se $phi$ é uma fórmula básica, então $c_r$ satisfaz $phi: *$ por construção.

*Hipótese de Indução:* Se $phi = (not psi)$ ou $phi = (alpha * beta)$ e temos
por definição de $r$ saturado que rótulos envolvendo $psi$, $alpha$ ou $beta$
ocorrem em $r$, suponha que o teorema vale para esses rótulos.

Com efeito, se esses rótulos ocorrem em $r$, então isso se deve ao fato de termos
aplicado uma regra de conectivos $phi: *$, e como os julgamentos desses rótulos são 
satisfeitos por hipótese de indução, então $phi: *$ deve ser satisfeito visto o lema
anterior. Pelo Princípio de Indução Finita, então todo julgamento de $r$ é satisfeito 
por $c_r$. 

$qed$

== Item C

A prova do teorema da completude do sistema de provas por árvores de avaliação se
dará sobre a suposição de que o conjunto de fórmulas $Sigma$ é finito.

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
  *Teorema*: $Sigma tack.r.not phi arrow.long.r.double Sigma tack.r.double.not phi$ 
    ]
  )
]

*Demonstração:* Por hipótese, uma árvore de avaliação para $Gamma$ tal que
$
Gamma = { sigma: #V | sigma in Sigma} union {phi : #F}
$
terá pelo menos um ramo $r$ aberto e saturado (sob a hipótese de que $Sigma$ é finito). Com efeito,
se $c_r$ é o contexto construído conforme a @eq:cr, então $c_r$ satisfaz todos os julgamentos 
que ocorrem como rótulos no ramo pela proposição do item anterior. Portanto, existe um contexto $c = c_r$
tal que
$
forall sigma in Sigma, (c(sigma) = #V)   " e " c(phi) = #F
$
donde concluímos que
$
Sigma tack.double.not phi
$ 
$qed$
