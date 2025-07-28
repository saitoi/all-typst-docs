#import "lib.typ": *
#import "@preview/plotst:0.2.0": *

#set text(lang: "pt")
#set heading(numbering: "1.")

#show table.cell.where(y: 0): strong

#set page(
  header: [
    _Computação Científica e EDOs_
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
  title: "Atividades sobre Modelos Epidemiológicos e Estabilidade",
  authors: ("Pedro Henrique Honorio Saito",),
  id: "122149392",
)

= Modelo SI

== Letra a

*Enunciado*: Explique como foi obtido o sistema $(1)$.

O sistema $(1)$ é obtido a partir da taxa média de novas infecções, representada
por $beta (S I)/N$, onde $S$ e $I$ indicam, respectivamente, as populações de
_suscetíveis_ e _infectados_. A formulação das equações diferenciais baseia-se
na variação das populações ao longo do tempo e, isto é, no cálculo das derivadas
de $S$ e $I$ em relação a $t$. 

Considerando $S(t)$, $I(t)$ e $S(t + Delta t)$, $I(t + Delta t)$ a quantidade de indivíduos nos compartimentos de suscetíveis e infectados nos instantes de tempo $t$ e $t + Delta t$, respectivamente. A variação das populações seria dada por:

$
S(t + Delta t) - S(t) &= - beta (S(t) I(t))/N(t) Delta t + "desvíos" \
I(t + Delta t) - I(t) &= beta (S(t) I(t))/N(t) Delta t + "desvíos"
$

Assim, aplicando a definição de derivada em ambas as equações:

$
lim_(Delta t -> 0) (S(t + Delta t) - S(t))/(Delta t)  &= - beta (S(t) I(t))/N(t) cancel(Delta t) + "desvíos" \
lim_(Delta t -> 0) (I(t + Delta t) - I(t))/(Delta t) &= beta (S(t) I(t))/N(t) cancel(Delta t) + "desvíos"
$

Portanto, chegamos ao seguinte sistema de equações diferenciais:

$
cases(
  display((d S)/(d t)  &= - beta (S(t) I(t))/(N(t))),
  display((d I)/(d t) &= beta (S(t) I(t))/(N(t))) quad square.filled,
)
$

== Letra b

*Enunciado*: Mostre que o tamanho da população permanece constante.

Dada a expressão do tamanho absoluto da população $N = S + I$, podemos tentar aplicar a definição de limite para descobrir a taxa de variação da população $N$. Assim, considerando $N(t)$ e $N(t + Delta t)$ a quantidade de indivíduos da população nos instantes $t$ e $t + Delta t$ respectivamente.

$
N(t + Delta t) - N(t) &= S(t + Delta t) + I(t + Delta t) - (S(t) + I(t)) \
                      &= S(t + Delta t) - S(t) + I(t + Delta t) - I(t) \
                      &= - beta (S(t) I(t))/(N(t)) Delta t + beta (S(t) I(t))/(N(t)) Delta t \
                      &= 0
$

Desse modo, é fácil percebermos que a população $N$ é uma constante e, portanto, sua variação no tempo é nula.

== Letra c

*Enunciado*: Mostre que $s = S/N, i = I/N$ e $tau = beta t$ são grandezas adimensionais.

Para as duas primeiras variáveis $s$ e $i$ podemos partir da definição delas:

$
s = (S med ("Qtd. de indivíduos suscetíveis"))/(N med ("Qtd. da população")) quad "e" quad i = (I med ("Qtd. de indivíduos infectados"))/(N med ("Qtd. da população"))
$

Como o numerador e denominador possuem as mesmas unidades de medida, teremos variáveis adimensionais a partir disso. Por fim, temos $beta$ que, por representar $"Número de contatos"/"unidade de tempo"$, equivale _frequência de contatos_ com unidade de medida $"u.t."^(-1)$. Desse modo,

$
[tau] = [beta] dot [t] &= 1/"tempo" dot "tempo".
$

Ou seja, $tau$ é adimensional. Assim, mostramos que $s = S/N, i = I/N$ e $tau = beta t$ são todas grandezas *adimensionais*, pois resultam da razão entre quantidades com mesma unidade ou do produto de grandezas cujas unidades se cancelam.

== Letra d

*Enunciado*: Obtenha o sistema de EDOs adimensionalizado correspondente.

Aqui percebemos uma relação entre as variáveis dimensionalizadas e as adimensionais da seguinte forma:

$
s &-> S \
i &-> I \
tau &-> t
$

Feita essa observação, vamos partir da derivada $(d s)/(d tau)$ e expandi-la por meio da regra da cadeia:

$
(d s)/(d tau) &= (d s)/(d t) (d t)/(d tau) \
              &= d/(d t) (S/N) dot (d t)/(d tau) \
              &= 1/N (d S)/(d t) dot 1/beta \
              &= 1/N dot (-cancel(beta) (S I)/N) dot 1/cancel(beta) \

$

#move(dx: 171pt)[
  #box(
    stroke: .5pt,
    inset: 5pt,
    $ (d s)/(d tau) &= - s dot i $
  )
]


Repetindo o mesmo procedimento para o $i$, chegaremos a uma solução semelhante:

$
(d i)/(d tau) &= (d i)/(d t) (d t)/(d tau) \
              &= d/(d t) (I/N) dot (d t)/(d tau) \
              &= 1/N (d I)/(d t) dot 1/beta \
              &= 1/N dot (cancel(beta) (S I)/N) dot 1/cancel(beta) \
$

#move(dx: 171pt)[
  #box(
    stroke: .5pt,
    inset: 5pt,
    $ (d i)/(d tau) &= s dot i $
  )
]

Com isso, encontramos o sistema de equações diferenciais adimensionalizadas para a questão, dada por:

$
cases(
  display((d s)/(d tau) &= - s dot i),
  display((d i)/(d tau) &= s dot i) quad square.filled,
)
$

== Letra e

*Enunciado*: Use a conservação do tamanho da população para chegar em EDOs desacopladas para as variáveis $s$ e $i$.

Por meio da conservação do tamanho da população $N = S + I$, podemos relacionar as variáveis adimensionalizadas da mesma forma:

$
s + i &= (S + I)/N = N/N = 1 \
      &-> s = 1 - i \
      &-> i = 1 - s
$

Com isso, conseguimos substituir no sistema de equações diferenciais descoberto na questão anterior:

$
cases(
  display((d s)/(d tau) &= - s dot (1 - s) = - s + s^2),
  display((d i)/(d tau) &= i dot (1 - i) = i - i^2),
)
$

== Letra f

*Enunciado*: Você consegue achar soluções de forma analítica para essas EDOs? Explique.

Sim, as EDOs expressas no sistema anterior são *separáveis* e, portanto, conseguimos chegar na solução para elas da seguinte forma:

$
cases(
  display((d s)/(d tau) &= - s + s^2 => integral (d s)/(s(s - 1)) = integral d tau),
  display((d i)/(d tau) &= i - i^2 => integral (d i)/(i(i - 1)) = integral d tau),
)
$

Resolvendo a primeira, chegaremos que:

$
integral (d s)/(s(s - 1)) = tau + C_1
$

Decompondo por frações parciais teremos que:

$
integral (- 1/s + 1/(s - 1))d s = tau + C_1
$

Assim, o lado esquerdo ficará:

$
- ln abs(s) + ln abs(s - 1) = tau + C_1
$

Combinando os logaritmos obteremos:

$
ln abs((s - 1)/s) = tau + C_1
$

Por fim, para a exponenciação, podemos definir $K = e^(C_1)$:

$
abs((s - 1)/s) = K e^tau => (s - 1)/s = K e^(C_1)
$

Por fim, vamos isolar o $s$:

$
(s - 1)/s = K e^tau => s - 1 = s K e^tau => s(1 - K e^tau) = 1 => s(tau) = 1/(1 - K e^tau)
$

Chamando $C_s = -K$, ficaremos com essa solução geral:

#move(dx: 134pt)[
  #box(
    stroke: .5pt,
    inset: 5pt,
    $ s(tau) = 1/(1 - K e^tau) " ou " s(tau) = 1/(1 + C_s e^tau) $
  )
]

Agora vamos determinar a solução analítica para a condição inicial $s(0) = s_0$:

$
s_0 &= 1/(1 + C_s) \
C_s &= 1/s_0 - 1 = (1 - s_0)/s_0
$

Sendo assim, encontramos a solução analítica:

#move(dx: 134pt)[
  #box(
    stroke: .5pt,
    inset: 5pt,
    $ s(tau) = s_0/(s_0 + (1 - s_0)e^tau) $
  )
]

== Letra g

*Enunciado*: Obtenha os pontos de equilíbrio para as EDOs adimensionalizadas. Analise a estabilidade desses equilíbrios a partir das EDOs linearizadas.

Para obter os pontos de equilíbrio, usaremos as equações diferenciais desacopladas obtidas:

$
(d s)/(d tau) = s (s - 1) = 0 => s^* = 0 " ou " s^* = 1,
(d i)/(d tau) = i (1 - i) = 0 => i^* = 0 " ou " i^* = 1.
$

Nesse sentido, os equilíbrios do sistema $(s,i)$ são as duas combinações:

$
(s^*, i^*) in {0, 1} times {0, 1} without {(0,0), (1,1)} = (1,0), (0,1)
$

Como impusemos a conservação $s + i = 1$, os pontos $(0,0)$ e $(1,1)$ não são equilíbrios admissíveis. Portanto, para analisarmos a estabilidade dos pontos $(1,0)$ e $(0,1)$, pegaremos a derivada das EDOs nesses pontos. Assim, para

$
(d i)/(d tau) = f_1(i) = i(1 - i)
$

faremos

$
dot(f_1)(i) = 1 - 2i
$

Agora basta substituirmos os pontos. Os equilíbrios são dados por $f(i^*) = 0$, isto é, $i^*_0 = 0$ e $i^*_1 = 1$.

+ Em $i^*_0 = 0$: Temos um equilíbrio instável, pois

$
dot(f_1)(0) = 1 - 2 dot 0 = 1 > 0.
$

+ Em $i^*_1 = 1$: Temos um equilíbrio estável, uma vez que

$
dot(f_1)(1) = 1 - 2(1) = -1 < 0.
$

De forma análoga, chegaremos à conclusão de que $s^*_0 = 0$ se trata de um equilíbrio estável, enquanto $s^*_1 = 1$ é um equilíbrio instável.

== Letra h

*Enunciado*: Mostre o comportamento das trajetórias (curvas) do sistema no espaço de fase nas coordenadas $(S,I)$.

Para o espaço de fase nas coordenadas $(s,i)$ obteremos o seguinte gráfico:

#import "@preview/lilaq:0.2.0" as lq

#let simple-plot = it => {
  show: lq.set-diagram(
    title: [], 
    ylabel: [$"Suscetíveis " S/N = s $],
    xlabel: [$"Infectados " I/N = i $],
    xaxis: (subticks: none)
  )
  show: lq.set-tick(
    outset: 2pt, inset: 0pt
  )
  it
}

#align(center)[
  #figure(
  {
    show: simple-plot
    lq.diagram(
      lq.plot(
        (0, .5, 1),
        (1, .5, 0),
        mark: lq.marks.text.with(body: [#emoji.arrow.r])
      ),
    )
  },
  caption: [Modelo adimensionalizado $s + i = 1$]
  )
]

Aqui podemos ver as setas se deslocando do ponto de equilíbrio instável $s = 1$ e $i = 0$ para o equilíbrio estável $s = 0$ e $i = 1$.

Por outro lado, para o sistema original $S + I = N$ teríamos infinitas retas para cada valor de N. Aqui está um exemplo para $N = 50,100,150$:

#align(center)[
  #figure(
  {
    show: simple-plot
    lq.diagram(
      lq.plot(
        (0, 50, 100),
        (100, 50, 0),
        mark: lq.marks.text.with(body: [#emoji.arrow.r])
      ),
      lq.plot(
        (0, 25, 50),
        (50, 25, 0),
        mark: lq.marks.text.with(body: [#emoji.arrow.r])
      ),
      lq.plot(
        (0, 75, 150),
        (150, 75, 0),
        mark: lq.marks.text.with(body: [#emoji.arrow.r])
      ),
    )
  },
  caption: [Modelo dimensionalizado $S + I = N$]
  )
]

= Modelo SI com evolução demográfica

== Letra a

*Enunciado*: Explique como foi obtido o sistema $(2)$.

O sistema $(2)$ é obtido tanto a partir da taxa média de novas infecções, representada
por $beta (S I)/N$ quanto pelas taxas de entrada e saída de cada uma das populações, indicadas por $mu N$, $mu S$ e $mu I$. A formulação das equações diferenciais baseia-se
na variação das populações ao longo do tempo e, isto é, no cálculo das derivadas
de $S$ e $I$ em relação a $t$. 

Considerando $S(t)$, $I(t)$ e $S(t + Delta t)$, $I(t + Delta t)$ a quantidade de indivíduos nos compartimentos de suscetíveis e infectados nos instantes de tempo $t$ e $t + Delta t$, respectivamente. A variação das populações seria dada por:

$
S(t + Delta t) - S(t) &= mu N Delta t - beta (S(t) I(t))/N(t) Delta t - mu S Delta t + "desvíos" \
I(t + Delta t) - I(t) &= beta (S(t) I(t))/N(t) Delta t - mu I Delta t + "desvíos"
$

Assim, aplicando a definição de derivada em ambas as equações:

$
lim_(Delta t -> 0) (S(t + Delta t) - S(t))/(Delta t)  &= mu N cancel(Delta t) - beta (S(t) I(t))/N(t) cancel(Delta t) - mu S cancel(Delta t) + "desvíos" \
lim_(Delta t -> 0) (I(t + Delta t) - I(t))/(Delta t) &= beta (S(t) I(t))/N(t) cancel(Delta t) - mu I cancel(Delta t) + "desvíos"
$

Portanto, chegamos ao seguinte sistema de equações diferenciais:

$
cases(
  display((d S)/(d t)  &= mu N - beta (S(t) I(t))/(N(t))) - mu S,
  display((d I)/(d t) &= beta (S(t) I(t))/(N(t))) - mu I quad square.filled,
)
$

== Letra b

*Enunciado*: Mostre que o tamanho da população permanece constante.

Dada a expressão do tamanho absoluto da população $N = S + I$, podemos tentar aplicar a definição de limite para descobrir a taxa de variação da população $N$. Assim, considerando $N(t)$ e $N(t + Delta t)$ a quantidade de indivíduos da população nos instantes $t$ e $t + Delta t$ respectivamente.

$
N(t + Delta t) - N(t) &= S(t + Delta t) + I(t + Delta t) - (S(t) + I(t)) \
                      &= S(t + Delta t) - S(t) + I(t + Delta t) - I(t) \
                      &= Delta t (mu N - beta (S I)/N - mu S + beta (S I)/N - mu I) \
                      &= Delta t (mu cancel((N - (S + I))) cancel(- beta (S I)/N + beta (S I)/N)) \
                      &= 0
$

Desse modo, é fácil percebermos que a população $N$ é uma constante e, portanto, sua variação no tempo é nula.

== Letra c

*Enunciado*: Mostre que $s = S/N, i = I/N$ e $tau = beta t$ são grandezas adimensionais.

Para as duas primeiras variáveis $s$ e $i$ podemos partir da definição delas:

$
s = (S med ("Qtd. de indivíduos suscetíveis"))/(N med ("Qtd. da população")) quad "e" quad i = (I med ("Qtd. de indivíduos infectados"))/(N med ("Qtd. da população"))
$

Como o numerador e denominador possuem as mesmas unidades de medida, teremos variáveis adimensionais a partir disso. Por fim, temos $beta$ que, por representar $"Número de contatos"/"unidade de tempo"$, equivale _frequência de contatos_ com unidade de medida $"u.t."^(-1)$. Desse modo,

$
[tau] = [beta] dot [t] &= 1/"tempo" dot "tempo".
$

Ou seja, $tau$ é adimensional. Assim, mostramos que $s = S/N, i = I/N$ e $tau = beta t$ são todas grandezas *adimensionais*, pois resultam da razão entre quantidades com mesma unidade ou do produto de grandezas cujas unidades se cancelam. Por fim, conclui-se que o termo $mu/beta$ também é adimensional, pois ambos os parâmetros representam taxas (frequências) com mesma unidade: Taxa de crescimento populacional e taxa de transmissão da doença.

== Letra d

*Enunciado*: Obtenha o sistema de EDOs adimensionalizado correspondente.

Aqui percebemos uma relação entre as variáveis dimensionalizadas e as adimensionais da seguinte forma:

$
s &-> S \
i &-> I \
tau &-> t
$

Feita essa observação, vamos partir da derivada $(d s)/(d tau)$ e expandi-la por meio da regra da cadeia:

$
(d s)/(d tau) &= (d s)/(d t) (d t)/(d tau) \
              &= d/(d t) (S/N) dot (d t)/(d tau) \
              &= 1/N (d S)/(d t) dot 1/beta \
              &= 1/N dot (mu N - beta (S I)/N - mu S) dot 1/beta \
              &= 1/N dot (mu cancel(N) - cancel(beta) (S I)/N - mu S) dot 1/cancel(beta) \
$

#move(dx: 142pt)[
  #box(
    stroke: .5pt,
    inset: 5pt,
    $ (d s)/(d tau) &= mu/beta (1 - s) - s i $
  )
]


Repetindo o mesmo procedimento para o $i$, chegaremos a essa solução semelhante:

$
(d i)/(d tau) &= (d i)/(d t) (d t)/(d tau) \
              &= d/(d t) (I/N) dot (d t)/(d tau) \
              &= 1/N (d I)/(d t) dot 1/beta \
              &= 1/N dot (cancel(beta) (S I)/N - mu I) dot 1/cancel(beta) \
$

#move(dx: 171pt)[
  #box(
    stroke: .5pt,
    inset: 5pt,
    $ (d i)/(d tau) &= i (s - mu/beta) $
  )
]

Com isso, encontramos o sistema de equações diferenciais adimensionalizadas para a questão, dada por:

$
cases(
  display((d s)/(d tau) &= mu/beta (1 - s) - s i),
  display((d i)/(d tau) &= i (s - mu/beta)) quad square.filled,
)
$

== Letra e

*Enunciado*: Use a conservação do tamanho da população para chegar em EDOs desacopladas para as variáveis $s$ e $i$.

Por meio da conservação do tamanho da população $N = S + I$, podemos relacionar as variáveis adimensionalizadas da mesma forma:

$
s + i &= (S + I)/N = N/N = 1 \
      &-> s = 1 - i \
      &-> i = 1 - s
$

Com isso, conseguimos substituir no sistema de equações diferenciais descoberto na questão anterior:

$
cases(
  display((d s)/(d tau) &= (1 - s) (mu/beta - s)),
  display((d i)/(d tau) &= i(1 - mu/beta - i)),
)
$

*Obs*: Podemos observar que a diferencial $(d i)/(d tau)$ é uma *equação logística*.

== Letra f

*Enunciado*: Você consegue achar soluções de forma analítica para essas EDOs? Explique.

Sim, as EDOs expressas no sistema anterior são *separáveis* e, portanto, conseguimos chegar na solução para elas:

Trataremos a segunda equação primeiro, como podemos ver, trata-se de uma equação logística independente:

$
(d i)/(d tau) = i (a - i) quad " onde "a = 1 - mu/beta
$

Os slides de _Modelagem epidemiológica_ demonstram uma solução analítica análoga para essa diferencial com condição inicial $i(0) = i_0$. Para facilitar, vamos denotar $beta/mu = k$, assim encontraremos a solução

$
i(tau) = (i_0 (1 - k^(-1)) e^((1 - k^(-1))tau))/(1 - k^(-1) + i_0 (e^((1 - k^(-1))tau) - 1))
$

quando $k eq.not 1$, e

$
i(tau) = (i_0)/(1 + i_0 tau)
$

quando $k = 1$.

De forma semelhante para a equação diferencial envolvendo o $s$ dada por

$
(d s)/(d tau) = (1 - s)(mu/beta - s),
$

temos a solução analítica:

$
s(tau) = ((s_0 - 1) e^((1 - k^(-1))tau) + 1 - k s_0)/( k (s_0 - 1) e^((1 - k^(-1))tau) + 1 - k s_0)
$

quando $k = mu/beta eq.not 1$ e

$
s(tau) = ((tau - 1)(s_0 - 1) - 1)/(tau(s_0 - 1) - 1)
$

quando $k = 1$.

== Letra g

*Enunciado*: Obtenha os pontos de equilíbrio para as EDOs adimensionalizadas. Analise a estabilidade desses equilíbrios a partir das EDOs linearizadas.

Partindo das equações diferenciais desacopladas, analisamos primeiro a EDO

$
f_1(i) = i (1 - k^(-1) - i).
$

Como podemos ver, temos dois pontos de equilíbrio: $dash(i_0) = 0$ e $dash(i_1) = 1 - k^(-1)$. Para analisarmos a estabilidade, pegaremos a derivada $dot(f_1)(i)$ para cada um desses pontos que resultará em $dot(f_1)(dash(i_0)) = 1 - k^(-1)$ e $dot(f_1)(dash(i_1)) = - (1 - k^(-1))$.

+ *Caso $k > 1$*: Temos que $dot(f_1)(dash(i_0) = 0) > 0$ é um ponto instável e, analogamente, $dot(f_1)(dash(i_1) = 1 - k^(-1) in (0,1)$ é assintoticamente estável.
+ *Caso $k < 1$*: Temos que $dot(f_1)(dash(i_0) = 0) < 0$ é assintoticamente estável e $dot(f_1)(dash(i_1) = 1 - k^(-1)) > 0$ é instável. Como $k < 1$, então $dash(i_1) = 1 - k^(-1)$ é inferior a zero e, portanto, está fora das restrições do problema $(i gt.eq 0)$.
+ *Caso $k = 1$*: Tiramos que $i_0 = i_1 = 0$ é um equilíbrio assintoticamente estável. Sabemos disso a partir da análise da solução explícita da EDO, dado que não conseguimos analisar a estabilidade em um ponto singular.

Concluímos que o segundo e terceiro caso são análogos. Agora vamos analisar a segunda EDO $(d s)/(d tau)$ descrita por

$
dot(f_2)(s) = (1 - s)(k^(-1) - s)
$

Novamente, podemos tirar os seguintes pontos de equilíbrio: $dash(s_0) = 1$ e $dash(s_1) = k^(-1)$. Com objetivo de analisar a estabilidade, pegaremos $dot(f_2)(dash(s_0)) = 1 - k^(-1)$ e $dot(f_2)(dash(s_1)) = k^(-1) - 1$ quando $k eq.not 1$.

+ *Caso k > 1*: Temos que $dot(f_2)(dash(s_0) = 1) > 0$ é instável e $dot(f_2)(dash(s_1) = k^(-1)) in (0,1)$ é assintoticamente estável.
+ *Caso k < 1*: Temos que $dot(f_2)(dash(s_0) = 1) < 0$ é assintoticamente estável e $dot(f_2)(dash(s_1) = k^(-1)) > 0$ é instável.
+ *Caso k = 1*: Assim como na EDO anterior, chegamos à conclusão de que $s_0 = s_1 = 0$ é assintoticamente estável.

== Letra h

*Enunciado*: Mostre o comportamento das trajetórias (curvas) do sistema no espaço de fase nas coordenadas $(S,I)$.

Como já discutido nas análises de estabilidade do ponto de equilíbrio, temos dois pontos de equilíbrio no modelo adimensionalizado: Um ponto $(dash(s_0), dash(i_1)) = (1, 0)$ e outro ponto $(dash(s_1), dash(i_1)) = (1/k, 1 - 1/k)$.

Para o modelo dimensionalizado, as equações podem ser visualizadas no espaço de fase como curvas que descrevem a evolução temporal de $S$ e $I$. Dependendo do valor de $k = beta/mu$, o comportamento dessas trajetórias será classificado em diferentes cenários.

Para o caso $k > 1$, a dinâmica das populações é caracterizada pela evolução de $S$ e $I$ em torno dos pontos de equilíbrio $(S = N/k, I = N(1 - 1/k))$. Estes pontos são estáveis, pois as trajetórias tendem a se aproximar dessa linha de equilíbrio ao longo do tempo. Por outro lado, os pontos circulares roxos sobre o eixo dos _Suscetíveis_, tal como $(S = N, I = 0)$ são instáveis, pois referem-se aos estágios iniciais onde toda população está suscetível e, portanto, qualquer infecção deslocará a sistema desse ponto.

Aqui está o espaço de fase para $k > 1$:

#align(center)[
  #figure(
  {
    show: simple-plot
    lq.diagram(
      lq.plot(
        (0, 25, 50, 75, 100),
        (100, 75, 50, 25, 0),
        mark: ">",
      ),
      lq.plot(
        (0, 12.5, 25, 37.5, 50),
        (50, 37.5, 25, 12.5, 0),
        mark: ">",
      ),
      lq.plot(
        (0, 37.5, 75, 112.5, 150),
        (150, 112.5, 75, 37.5, 0),
        mark: ">",
      ),
      lq.plot(
        (0, 50, 150),
        (0, 50, 150),
        mark: ">",
      ),
      lq.plot(
        (0,0),
        (100,100),
        mark: "o",
        color: purple,
      ),
      lq.plot(
        (0,0),
        (50,50),
        mark: "o",
        color: purple,
      ),
      lq.plot(
        (0,0),
        (150,150),
        mark: "o",
        color: purple,
      ),
    )
  },
  caption: [Modelo dimensionalizado, populações convergindo para o centro ("reta cinza").]
  )
]

Segundo nossa análise, os pontos estáveis, localizados sobre a reta cinza, possuem coordenadas do formato $(S = N/k, I = N(1 - k^(-1)))$.

*Obs*: Embora não tenha conseguido representar graficamente, as setas estão convergindo para o "centro" interceptado pela reta cinza no gráfico acima.

Para $k lt.eq 1$:

#align(center)[
  #figure(
  {
    show: simple-plot
    lq.diagram(
      lq.plot(
        (0, 50, 100),
        (100, 50, 0),
        mark: lq.marks.text.with(body: [#emoji.arrow.l])
      ),
      lq.plot(
        (0, 25, 50),
        (50, 25, 0),
        mark: lq.marks.text.with(body: [#emoji.arrow.l])
      ),
      lq.plot(
        (0, 75, 150),
        (150, 75, 0),
        // mark: "^",
        mark: lq.marks.text.with(body: [#emoji.arrow.l])
      ),
    )
  },
  caption: [Modelo dimensionalizado, populações convergindo para o eixo dos suscetíveis.]
  )
]

Nesse sentido, quando $k = beta/mu < 1$ cada infectado gera, em média, menos de uma nova infecção e, portanto, a *epidemia não se sustenta*. Para $k < 1$, a componente $I(t)$ decai gradativamente enquanto $S(t)$ preenche toda a população $N$.



// A PARTIR DAQUI PARA CIMA

