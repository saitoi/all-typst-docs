#import "lib.typ": *
#import "@preview/plotst:0.2.0": *
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/arborly:0.3.0": tree

#set text(lang: "pt")
#set heading(numbering: none)

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { center }
    else { center }
  )
)

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
  title: "Lista II",
  authors: ("Pedro Henrique Honorio Saito\n122149392","Milton Salgado\n122169279"),
  // id: "",
)

#set math.equation(numbering: "(1)")

#let V = $upright("V")$
#let F = $upright("F")$

= Questão 1

#v(.7em)

*Enunciado*: Dada uma assinatura $cal(A)$ com dois símbolos para operações, sendo $P$ unário e $R$ binário. Provaremos ou refutaremos cada um dos itens abaixo.

== Item B

#v(.4em)

Iremos refutar a fórmula $phi := P(x) tack.r.double P(y)$ por meio de um contraexemplo. Assim, considere:

- A estrutura $epsilon$ com domínio $D(epsilon)$ dos números naturais $bb(N)$.
- A especificação para relação unária dada por $P^epsilon = "é par"$.
- A atribuição $a$ para $x$ e $y$ valendo, respectivamente, $2$ e $3$.

Portanto, sabemos que para a estrutura $epsilon$ e atribuição $a$ definidas, vale $P(x)[x arrow.l 2]$ pois $2 "é par"$, isto é, vale dizer que $epsilon, a[x <- 2] tack.r.double P(x)$. No entanto, é incorreto afirmar o consequente $P(y)[y arrow.l 3]$ dado que 3 não consta no conjunto dos números pares. Donde concluímos que $epsilon, a[y <- 3] tack.r.not.double P(y)$.

== Item G

#v(.4em)

Novamente, vamos refutar a fórmula $phi := forall x exists y (x R y) tack.r.double exists x forall y (x R y)$ a partir de um contramodelo. Considere:

- A estrutura $epsilon$ com domínio $D(epsilon)$ do conjunto ${{square}, {square.filled}}$.
- A especificação para relação binária $R(x,y)$ equivale a dizer: "$x subset y$" na noção usual de Teoria dos Conjuntos.
// - Como se tratam de duas _sentenças_, a atribuição $a$ 
// - A atribuição $a$ para $x$ e $y$ possui valorações ${square}$ e ${square, square.filled}$, respectivamente.

Nesse sentido, para a estrutura $epsilon$ vale afirmar o antecedente $forall x exists y (x R y)$, ou seja, para cada um dos subconjuntos ${square}$ e ${square.filled}$, existe um outro subconjunto que o contenha, isto é, $forall x exists y (x R y)$. Essa afirmação é válida pois podemos escolher o mesmo conjunto de modo que $(x R x)$. Desempacotando:

$
&epsilon, a tack.r.double forall x exists y (x R y) \
&"Para todo "d_0 in D(epsilon), "existe "d_1 in D(epsilon) "tal que" epsilon, a[x <- d_0, y <- d_1] tack.r.double forall x exists y(x R y) \
&"Para todo "d_0 in {{square}, {square.filled}}, "existe "d_1 in {{square}, {square.filled}} "tal que" (x^(epsilon, a[x<-d_0])) subset (y^(epsilon, a[y<-d_1])) \
&"Para todo "d_0 in {{square}, {square.filled}}, "existe "d_1 in {{square}, {square.filled}} "tal que" (a[x<-d_0])(x) subset (a[x<-d_1])(y) \
&"Para todo "d_0 in {{square}, {square.filled}}, "existe "d_1 in {{square}, {square.filled}} "tal que" d_0 subset d_1 \ 
$

Portanto, se temos $d_0 = {square}$ ou $d_0 = {square.filled}$, basta escolher $d_1 = d_0$ e assim satisfazemos o antecedente da fórmula. Dessa forma, a estrutura e atribuição escolhidas satisfazem a primeira parte da implicação. Agora, precisamos demonstrar que o consequente *não* é satisfeito. Novamente, desempacotando:

$
&epsilon, a tack.r.double exists x forall y (x R y) \
// &wide dots.v\
// &"Existe "d_0 in {{square}, {square.filled}}, "tal que para todo "d_1 in {{square}, {square.filled}} "temos" d_0 subset d_1 \ 
$

Desse modo, deve existir $d_0 in {{square}, {square.filled}}$ tal que, para todo $d_1 in {{square}, {square.filled}}$, temos $d_0 subset d_1$.#linebreak()
Se fixarmos $d_0 = {square}$, a fórmula exige que ${square} subset {square}$ e ${square} subset {square.filled}$. Contudo, essa última afirmação é inválida, pois o conjunto ${square.filled}$ não contém ${square}$.

== Item K

#v(.4em)

Aqui provaremos a fórmula $psi := "\"Se "x" não ocorre livre em "phi", então" phi tack.r.double forall x phi\"$.

Por definição, para:

- Uma assinatura $cal(A)$.
- Um conjunto de fórmulas $Sigma$ de $cal(A)$.
- Uma uma fórmula $phi$ de $cal(A)$.

Dizemos que $phi$ é _consequência semântica_ de $Sigma$, denotado $Sigma tack.r.double phi$, se: Em qualquer estrutura $epsilon$ para $cal(A)$ e qualquer atribuição $a$ para $epsilon$ temos se para todo $sigma in Sigma$ temos $epsilon, a tack.r.double sigma$ então $epsilon, a tack.r.double phi$.

Sejam $epsilon, a$ tais que $epsilon, a tack.r.double phi$ onde $phi$ é uma fórmula na qual $x$ não ocorre como variável livre, desejamos provar que $epsilon, a tack.r.double forall x phi$. Primeiramente, vamos esclarecer esta última fórmula:

$
epsilon, a tack.r.double forall x phi <=> "Para todo" d in D(epsilon)", temos "epsilon, a[x <- d] tack.r.double phi.
$

Como sabemos que $x$ não ocorre como variável livre em $phi$, podemos separar a fórmula original em dois casos:

1. $x$ não ocorre em $phi$ : A adição do quantificador $forall x$ não alterará o significado da proposição $phi$, pois $x$ não ocorre em $phi$. A substituição $a[x<-d]$ também não afeta $phi$, pois $x$ não aparece em $phi$. Assim,

  $
  epsilon, a[x <- d] <=> epsilon, a tack.r.double phi
  $

  Logo, como isso vale para todo $d in D(epsilon)$, concluímos que:

  $
  epsilon, a tack.r.double forall x phi.
  $

// 2. $x$ ocorre ligada em $phi$ : Segundo a definição de $upright("Ocorreligada")$, seja $phi$ fórmula, $psi := forall x phi$ e $k$ uma posição de modo que $upright("Ocorreligada")(x, phi)$
2. $x$ ocorre ligada em $phi$ : Isso nos diz que todas as ocorrências de $x$ em $phi$ estão sob o escopo de algum quantificador como $exists x$ ou $forall x$. Portanto, uma atribuição diferente para $x$ como #linebreak()$a[x<-d']$ não modifica a interpretação de $phi$, pois a variável $x$ já está internamente determinada na fórmula. Assim, novamente temos:

  $
  epsilon, a[x <- d] <=> epsilon, a tack.r.double phi
  $

  para todo $d in D(epsilon)$, o que implica:

  $
  epsilon, a tack.r.double forall x phi.
  $


= Questão 2

#v(.7em)

Chamamos de _modelagem_ o processo de formalizar (simbolizar) frases ou argumentos da linguagem natural para a LPO usando alguma assinatura apropriada. Deve-se indicar a correspondência entre os componentes da frase da linguagem natural e os símbolos da linguagem formal.

== Item B

#v(.4em)

*Frase*: "Toda pessoa que tem um filho deveria ser carinhosa com ele". Use a assinatura abaixo:

#v(10pt)

#align(center)[
#table(
  columns: 2,
  table.header(
    [Linguagem natural], [Simbólico]
  ),
  [$x$ é pai de $y$], [$P(x,y)$],
  [$x$ deveria ser carinhoso com $y$], [$C(x,y)$],
)
]

Sendo $x$ o pai, então a afirmação corresponde a dizer que todo pai (isto é, pessoa que tem filho) deve ser carinhoso com seu filho. Assim, 

*Tradução*: $forall x forall y (P(x, y) -> C(x, y))$.

*Explicação*: Na minha formulação, procurei transmitir a noção: Para todo par de indivíduos $x$ e $y$, se $x$ é pai de $y$, então $x$ deve ser carinhoso com $y$. Note que, na minha formulação nada impede "autopartenidade", isto é, $x=y$. Se for necessária essa restrição, bastaria modificar a fórmula para:

$
forall x forall y((P(x,y) and not (x = y)) -> C(x,y)).
$

// #align(center)[
//   #block(
//     width: auto,
//     height: auto,
//     stroke: .7pt + black,
//     inset: 17pt,
//     [
//   *Proposição*: Para todo $k in bb("N")$, se $phi$ possui $k$ ocorrências de símbolos proposicionais, então o comprimento de $phi$ é dado por $4k - 3$.
//     ]
//   )
// ]

= Questão 3

#v(.7em)

*Enunciado*: Em cada item abaixo, defina uma assinatura e encontre uma sentença
$phi$ dessa assinatura com a propriedade desejada.

== Item B

#v(.4em)

*Enunciado*: Os modelos de $phi$ são *torneios* (grafos direcionados, sem laços, tais que entre qualquer par de vértices distintos existe exatamente uma aresta).

Seja $cal(A)$ uma assinatura que contenha um símbolo $R$ para relação. Assim,

// *Formulação*: $forall x((forall y (x eq.not y)) -> ((x R y) xor (y R x)))$.

*Formulação*: $forall x (not(x R x)) and forall x forall y((x eq.not y) -> ((x R y) xor (y R x)))$

Onde a relação $xor$ é uma forma concisa de expressar a relação $A xor B = (A and not B) or (not A and B)$.

*Explicação*: Neste exercício, precisamos garantir duas propriedades importantes mencionadas no enunciado, isto é, a ausência de laços e a existência de uma única aresta entre quaisquer dois vértices distintos. Para essa finalidade, defini a relação $R$ que indica uma _arco_ (aresta direcionada).

Com efeito, a primeira fórmula $forall x (not (x R x))$ restringe que um mesmo vértice se ligue consigo mesmo. Além disso, a segunda parte da fórmula nos garante que se dois vértices são distintos, então existe uma aresta direcionada do "primeiro" para o "segundo" *ou* vice-versa. Vale ressaltar que o *ou* em questão é _exclusivo_.

== Item F

#v(.4em)

*Enunciado*: Os modelos de $phi$ tem exatamente $n$ elementos, sendo $n >= 2$ um número natural qualquer.

Seja $cal(A)$ uma assinatura vazia. Nesse sentido, temos precisamos garantir as seguintes propriedades:

- Existem pelo menos $n$ elementos distintos.
- Existem no máximo $n$ elementos distintos.

Portanto, teremos a seguinte sentença:

*Formulação*: $exists x_1 exists x_2 dots forall x_n, lr((limits(and)_(1 <= i < j <= n)(x_i eq.not x_j) and forall y limits(or)_(i=1)^(n)(y = x_i)), size: #146%)$

Onde a relação $eq.not(A, B)$ equivale a $not(A = B)$ e a notação com variável ligada $limits(and)_(1 <= i < j < n)$ corresponde a dizer: Substitua todas as combinações de $i,j$ no intervalo $[1,n]$ com $i<j$ na fórmula $(x_i eq.not x_j)$ e una-os por uma conjunção. Por fim, a notação $limits(or)_(i=1)^(n)$ realiza um procedimento semelhante, mas unindo as fórmulas por disjunções.

*Explicação*: Como solicitado, a primeira fórmula restringe a existência de pelo menos $n$ elementos distintos $x_0,dots,x_n$, enquanto a segunda apenas nos informa que todo elemento do domínio será equivalente a um desses.

== Item H

#v(.4em)

*Enunciado*: Os modelos de $phi$ são infinitos.

Seja $cal(A)$ uma assinatura com um símbolo para relação binária $R$. Desse modo, para simplificar a fórmula final, denotaremos cada propriedade da seguinte forma:

- *Transitividade*: $alpha := forall x forall y forall z((R(x,y) and R(y, z)) -> R(x, z)) $.

- *Assimetria*: $beta := forall x forall y(R(x,y) -> not R(y,x))$.

- *Irreflexividade*: $gamma := forall x (not (x R x))$.

Desse modo, obtemos:

*Formulação*: $(alpha and beta and gamma and forall x exists y R(x,y))$.

onde a relação $R(x,y)$ é uma relação de *ordem parcial estrita*.

*Explicação*: Nesta questão, precisamos definir o conceito de #underline[relação de ordem parcial estrita] e, então, afirmar que para todo elemento do domínio $x$, existe um $y$ de modo que $R(x,y)$, ou seja, "$x "vem antes de "y$". O objetivo é formular uma sentença que só possa ser satisfeita por estruturas cujo domínio seja infinito. Por definição, as relações de ordem parcial estrita satisfazem as seguintes propriedades:

- *Irreflexividade*: Assegura que nenhum elemento se relacione consigo mesmo, evitando a existência de "laços", isto é, um elemento relacionado com si próprio.

- *Assimetria*: Impede ciclos de comprimento 2.

- *Transitividade*: Permite estender a "cadeia de comparações" indefinidamente e, assim, evitar a existência de ciclos como um todo. Por exemplo, se 

  $
  x_0 thick R thick x_1 thick R thick dots thick R thick x_n thick R thick dots
  $

  Por fim, a última proposição $forall x exists y (R(x, y))$ nos garante que todo elemento do domínio está relacionado com alguém.
  
  Em vista disso, escolha um elemento inicial $x_0$. Pela *irreflexividade* e pela condição $forall x exists y (x R y)$, existe $not (x_1 = x_0)$ tal que

  $
  x_0 thick R thick x_1.
  $
  
  Novamente, pela *assimetria* não podemos ter $x_1 R x_0$. Aplicando novamente a última proposição à $x_1$, obtemos um $not(x_2 = x_1)$ de modo que

  $
  x_0 thick R thick x_1 thick R thick x_2,
  $

  e assim sucessivamente. Com efeito, a *transitividade* permite construir uma única cadeia infinita de elementos relacionados unilateralmente com o próximo nesta ordem

  $
  x_0 thick R thick x_1 thick R thick x_2 thick R thick dots thick R thick x_n thick R thick dots
  $

= Questão 5

#v(.7em)

*Enunciado*: Seja $cal(A)$ uma assinatura com um símbolo para constante $u$, com dois símbolos para operações binárias $plus.circle$, $dot.circle$ e um símbolo para relação binária $triangle.l.small$. Seja $bold(epsilon)_(bb(R))$ a estrutura para essa assinatura que tem o conjunto dos reais $bb(R)$ como domínio e que interpreta $u$ como 1, as operações $plus.circle$, $dot.circle$ respectivamente como adição e multiplicação, e a relação $triangle.l.small$ como "estritamente menor que".

== Item A

#v(.4em)

*Enunciado*: Prove que todo número inteiro é definível em $bold(epsilon)_(bb(R))$.

Antes de mais nada, vamos recordar a definibilidade de um elemento $d$ pertencente ao domínio $D(epsilon)$.

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 17pt,
    [
  #align(left)[
  *Definição*: Seja $cal(A)$ assinatura, $epsilon$ estrutura para $cal(A)$ e $d in D(epsilon)$. Dizemos que $d$ é definível em $epsilon$ se existe uma fórmula $phi$ de $cal(A)$ com exatamente 1 variável livre (digamos $x$) tal que, para toda atribuição $a$ para $epsilon$ temos
  $
  epsilon, a tack.r.double phi <=> a(x) = d
  $
  Nesse caso, dizemos que $phi$ define $d$ em $epsilon$.
  ]
    ]
  )
]

Dito isso, como temos a estrutura $epsilon_(bb(R))$ e a assinatura $cal(A)$, vamos começar definindo o "zero" por meio da seguinte fórmula com a variável livre $x$:

$
psi(0)(x) := (x = x plus.circle x)
$ <eq:def_zero>

Onde $psi(0)(x)$ é a fórmula que define o elemento 0 pertencente a $D(epsilon)=bb(R)$ usando a variável livre $x$. A fórmula anterior é válida, pois sabemos que o $"0"$ é o único elemento dos reais que satisfaz a equação. Feito isso, se quisermos definir valores positivos ou negativos, usaremos a fórmula abaixo:

$
psi(n)(z) := cases(
  display(z = z plus.circle z)\, wide wide quad n = 0,
  display(z = underbrace(u plus.circle dots plus.circle u,n))\, wide thick thick thin n > 0,
  display(u = z plus.circle underbrace(u plus.circle dots plus.circle u, abs(n)+1))\, quad n < 0,
)
$

Onde $z$ corresponde a variável livre que define a unidade inteira desejada.

// *Observação*: a variável $y$ está contida implicitamente dentro de $psi(0)$ e, simultaneamente, vinculada externamente ao quantificador $forall y$.

*Explicação*: Nesse contexto, começamos a partir da constante $u^epsilon=1$. A ideia é que, se $u$ representa a unidade, então é suficiente somar a constante $u$ um total de $n$ vezes para obter um número inteiro positivo. Alternativamente, podemos partir de um valor negativo e aplicar $abs(n) + 1$ incrementos com $u$ até retornarmos ao zero, posto que $z$ corresponde ao inverso aditivo.

Em termos formais, para representar o inteiro $4$, definimos

$
psi(4)(z) := (z = underbrace(u plus.circle u plus.circle u plus.circle u, 4) )
$

Por outro lado, se tentarmos representar $pi = #calc.pi dots$, teríamos:

$
psi(pi)(z) := (z = underbrace(u plus.circle dots plus.circle u, pi) ),
$ <eq:tentativa_def_pi>

no entanto como $pi$ não é inteiro, a #underline[@eq:tentativa_def_pi não é "formável"] e, portanto, não é capaz de definir o elemento $d = pi in bb(R)$.

// $
// psi(pi) := forall y ((y = y plus.circle y) -> (z = y plus.circle y plus.circle y )).
// $ <eq:def_pi>

// Porém, fica claro que a definição da @eq:def_pi não captura $pi$, mas sim o valor inteiro $3$.

// *Observação*: A adição da regra: "Repetir o termo '$plus.circle u$' uma quantidade $floor(n)$ de vezes" não é estritamente necessária. Porém, como o domínio da estrutura $epsilon_(bb(R))$ são os reais, achei interessante adicionar essa restrição para evitar um comportamento indefinido.

== Item B

#v(.4em)

*Enunciado*: Um número _racional_ é um número que pode ser escrito como uma fração com numerador e denominador inteiros. Prove que todo racional é definível em $epsilon_(bb(R))$.

Seja $r in D(epsilon_(bb(R)))$. Para caracterizar $r$ como um número racional, introduzimos duas variáveis $p$ e $q$ que definem inteiros por meio das fórmulas $psi(p)$ e $psi(q)$, respectivamente. Além disso, exigimos que o denominador $q$ não seja zero. Abaixo, definimos a fórmula $omega(r)(z)$ que capta essas condições:

$
omega(r)(z) := exists p exists q lr((psi(p) and psi(q) and not(psi(0)(q)) and (p = z times.circle q)), size: #155%)
$

onde a variável livre $z$ representa o racional $r$ que desejamos definir.

*Explicação*: Como solicitado no enunciado, obrigamos $p$ e $q$ a serem inteiros por meio das fórmulas $psi(p)$ e $psi(q)$. Além disso, asseguramos que o denominador $q$ não seja zero e que $z$ corresponda à $p/q$.

== Item C

#v(.4em)

*Enunciado*: Prove que qualquer raiz de polinômio com coeficientes racionais é definível em $epsilon_(bb(R))$.

Primeiramente, definiremos a operação polinômio com aridade $n+1$, sendo $n$ o grau do polinômio e $+1$ equivalente à variável $x$ que pode assumir qualquer valor. Portanto, denotando a operação do polinômio por $p(a_(n-1), dots, a_0, a_1, x)$ temos:

$
p(a_n, dots, a_1, a_0, x) = a_n times.circle underbrace(x times.circle dots times.circle x, n) plus.circle dots plus.circle a_1 times.circle x plus.circle a_0
$

Essa notação será útil para simplificar a formulação final da raiz. Dito isso, seja $r_i$ a _i-ésima raiz_ de um polinômio qualquer, vamos especificar a entrada e saída da operação da raiz com $r_i$ livre:

$
&#underline[Operação] R(a_n, dots, a_0, i) \
&"Entrada : Coeficientes racionais "a_n,dots,a_0" + Inteiro "i italic("(i-ésima raiz")). \
&"Saída : Fórmula satisfeita apenas pela atribuição "a(r_i)=r_i.
$

*Observação*: As raízes estão ordenadas de forma não crescente começando em 0, isto é, se duas raízes tem índices $i<j$, então $r_i >= r_j$. Em particular, para quaisquer $i$, $r_i >= r_(i+1)$ e, caso $r_i = r_(i+1)$, sua ordem relativa é indiferente.

Nesse sentido, denotaremos cada propriedade da seguinte forma:

- A _i-ésima_ raiz $r_i$ de um polinômio com uma coeficientes racionais $a_(n-1), dots, a_0$ deve satisfazer:

  $
  alpha := p(a_(n),dots,a_(0),r_i) = 0.
  $

- A _i-ésima_ raiz $r_i$, em ordem não crescente, de um polinômio onde $r_0$ é maior e assim sucessivamente deve satisfazer:

  $
  beta := (not (r_1 triangle.l r_0) and dots and not(r_(i+1) triangle.l r_i) and dots and not (r_(n+1) triangle.l r_n)).
  $

- Por fim, precisamos garantir que todas as fórmulas 
  
  Desse modo, derivamos a seguinte fórmula:

  $
  R(a_n^', dots, a_0^', i)(r_i) = exists a_n dots exists a_0 ((a_n = omega(a_n^')) and ... and (a_0 = omega(a_0^')) and alpha and beta).
  $

  
#pagebreak()

= Questão 7

#v(.7em)

*Enunciado*: Prove que $phi,psi tack.r beta$ onde

$
&phi := forall x [(F(x) and G(x)) -> H(x)] -> exists x [F(x) and (not G(x))] \
&psi := forall x [F(x) -> G(x)] or forall x [F(x) -> H(x)] \
&beta := [(F(x) and H(x)) -> G(x)] -> exists x [angle.l F(x) and G(x) angle.r and not H(x)].
$

Onde cada nós e sua restrição de constante seguem, respectivamente, os modelos abaixo

#align(center)[
$
italic("fórmula":"julgamento"("origem")^"índice") " tal que "checkmark=italic("mexido")" e "sans("X")=italic("fechado") \ \
#underline[#highlight("fórmula com constante atualmente restrita")] quad " e " quad #underline[fórmula sem constante ou sem constante restrita]
$
]

Seja o conjunto de proposições da LPO $Gamma = {phi: #V, psi: #V, beta: #F}$, uma árvore para $Gamma$ é dada abaixo.

#let hl(content) = box(
  content,
  inset: 0.2em,
  outset: .09em,
  fill: rgb("#fffe69"),
) 

#figure(
  tree(horizontal-gap: 3.5mm)[$beta := forall x [(F(x) and H(x)) -> G(x)] -> exists x [angle.l F(x) and G(x) angle.r and not H(x)]: #F (Gamma)^1 checkmark$
  [$forall x [(F(x) and H(x)) -> G(x)]: #V (1)^2$
    [$exists x [angle.l F(x) and G(x) angle.r and not H(x)]: #F (1)^3$
      [$(F(c) and H(c)) -> G(c): #V (2)^4$
        [$angle.l F(c) and G(c) angle.r and not H(c): #F (3)^5 checkmark$
          [$phi := forall x [(F(x) and G(x)) -> H(x)] -> exists x [F(x) and (not G(x))]: #V (Gamma)^6$
            [$forall x (F(x) and G(x)) -> H(x): #F (6)^7$
            [#hl($(F(c) and G(c)) -> H(c): #F (7)^8 checkmark$)
            [#hl($F(c) and G(c): #V (8)^9 checkmark$)
            [#hl($H(c): #F (8)^10$)
            [#hl($F(c): #V (9)^11$)
            [#hl($G(c): #V (9)^12$)
              [#hl($not H(c): #F (5)^13 checkmark$)
              [$#hl($H(c): #V (13)^14$)#linebreak()sans("X") thick 10, 14$]]
              [#hl($angle.l F(c) and G(c) angle.r : #F (5)^15 checkmark$)
                [$#hl($F(c): #F (15)^16$)#linebreak()sans("X") thick 11, 16$]
                [$#hl($G(c): #F (15)^17$)#linebreak()sans("X") thick 12, 17$]]]]]]]]
          [$exists x[F(x) and (not G(x))]: #V (6)^18$
          [#hl($F(d) and (not G(d)): #V (18)^19 checkmark$)
          [#hl($F(d): #V (19)^20$)
          [#hl($not G(d): #V (19)^21 checkmark$)
          [#hl($G(d): #F (21)^22$)
          [$psi := forall x [F(x) -> G(x)] or forall x [F(x) -> H(x)]: #V (Gamma)^23$
            [$forall x [F(x) -> G(x)]: #V (23)^24$
            [#hl($F(d) -> G(d): #V (24)^25 checkmark$)
            [$#hl($F(d): #F (25)^26$)#linebreak()sans("X")thick 20, 26$]
            [$#hl($G(d): #V (25)^27$)#linebreak()sans("X")thick 22, 27$]]]
            [$forall x [F(x) -> H(x)]: #V (23)^28$
            [#hl($F(c) -> H(c): #V (28)^29 checkmark$)
              [$#hl($F(c): #F (29)^30$)#linebreak()sans("X")thick 11, 30$]
              [$#hl($H(c): #V (29)^31$)#linebreak()sans("X")thick 10, 31$]]]]]]]]]]]]]]
],
  caption: [_Árvore de avaliação totalmente fechada._]
)
