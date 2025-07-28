#import "@preview/touying:0.5.3": *
#import themes.university: *
#import "@preview/cetz:0.3.1"
#import "@preview/ctheorems:1.1.2": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.0.0": *

/* ******************** CONFIGURAÇÕES ******************** */

#set text(lang: "pt")
#set math.equation(numbering: "(1)")
#show figure.caption: set text(size: 18pt)

#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))

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
    title: [Frisbee],
    subtitle: [Análise Matemática e Física],
    author: [João Pedro Silva de Sousa #linebreak()
             Pedro Henrique Honorio Saito #linebreak()
             Marcos Henrique Junqueira
            ],
    date: datetime.today(),
    institution: [Universidade Federal do Rio de Janeiro],
    logo: emoji.frisbee,
  ),
)

#show: codly-init.with()

#codly(
  display-icon: false,
  languages: (
    py: (
      name: [Python], color: rgb("#efca08"),
      icon: "🐍"
    ),
  ),
)

#codly(zebra-fill: none, number-format: none)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

/* ******************** SLIDES ******************** */

== Outline <touying:hidden>

#components.adaptive-columns(outline(title: [Sumário], indent: 1em, depth: 1))

= Introdução

== Breve Histórico

- A história dos frisbees remonta ao final do século XIX, quando alunos da universidade de Yale arremessavam formas de torta da Frisbie Pie Company como uma brincadeira.

- Em 1958, Wham-O lançou a marca de discos de plástico voadores "Frisbee", e desde então o frisbee se tornou um brinquedo popular e até mesmo usado em modalidades esportivas, a exemplo do _Ultimate Frisbee_ e do _Golf Disc_

//talvez uma imagem aqui :)
#figure(
  image("images/frisbies-pies.jpg", width: 40%),
  caption: [Uma das formas de torta do Frisbie]
)

== Especificação do Problema //Estapa 1 da modelagem

- Modelar o movimento de um Frisbee que é lançado no ar com alta rotação (_spin_).

- Como forças atuando sobre o disco, vamos considerar

+ Força da Gravidade sobre o disco
+ Força de arrasto, que é a resistência do ar ao movimento do disco.
+ Força de Sustentação, relacionada à aerodinâmica do disco.

- Considera-se um ambiente ideal sem vento em qualquer direção.

Razão: além do arrasto, também teríamos de considerar forças externas em outras direções, provocando torques, turbulências, e outras complicações. 

- O _Frisbee_ será modelado como um corpo rígido em formato de disco, simétrico e de espessura desprezível.
// Corpo rígido

== Objetivos

- Apresentar uma modelagem para o movimento do Frisbee sob as condições apresentadas.

- Introduzir os princípios da aerodinâmica do frisbee: o Princípio de Bernoulli e a Inércia Giroscópica.

- Derivar as equações para o movimento do frisbee através de equações diferenciais.

- Obter a solução do modelo de equações.

- Fazer comparações com outros resultados

//decidir outros tópicos 

/* ************************************** MARCOS ************************************** */

= Princípio de Bernoulli

==

O princípio de Bernoulli busca descrever o comportamento de um fluido ideal ao longo de uma linha de corrente.

#definition[
  Uma linha de corrente é uma linha contínua traçada no fluido de forma que todos os seus pontos são tangenciais à velocidade.
]

#align(center)[#image("images/bernoulli/streamline-fluid.png")]

Podemos derivá-lo calculando a diferença do trabalho por um fluido em escoamento em duas partes diferentes de um cano, desprezando forças de viscosidade.

#align(center)[#image("images/bernoulli/bernoulli-pipe.png")]

Primeiramente, temos que:

$ \d W &= F_1\d x_1−F_2\d x_2 \
       &=p_1A_1\d x_1−p_2A_2\d x_2 \
       &=p_1 \dV−p_2 \d V \
       &=(p_1−p_2)\dV
$

Sabemos, também, que o trabalho realizado é resultado de alterações na energia cinética e potencial do fluido.

A diferença das energias cinéticas nas duas seções do tubo é:

$ 
  \d K &= frac(1,2) m_2 v_2^2 − frac(1,2) m_1 v_1^2 \
       &= frac(1,2) rho \d V (v_2^2 - v_1^2)
$

Enquanto diferença das energias potenciais nas duas seções é:

$ 
  \d U &= m_2 g y_2 - m_1 g y_1 \
       &= rho \d V g(y_2 - y_1)
$

Substituindo na equação do trabalho, obtemos

$
  \d W &=(p_1−p_2)\dV \
  (p_1−p_2)\dV &= frac(1,2) rho \d V (v_2^2 - v_1^2) + rho \d V g(y_2 - y_1) \
$

Que, ao rearranjarmos, obtemos

$
  p_1 + frac(1,2) rho v_1^2 + rho g y_1 = p_2 + frac(1,2) rho v_2^2 + rho g y_2 
$ <eq:bernoulli>

Concluíndo que, para um fluido incompressível e sem fricção, a combinação de pressão, energia cinética e potencial é constante não apenas em relação ao tempo, mas também para uma mesma linha de corrente.

$
  p + frac(1,2) rho v^2 + rho g y = text("constante") 
$

O princípio de Bernoulli nada mais é que a equação de Bernoulli para fluxos em altura constante, reforçando que a medida que a velocidade do fluido aumenta, há uma queda de pressão para a conservação da equação.

$
  p + frac(1,2) rho v^2 = text("constante")
$

== Aplicação

No contexto do frisbee, o princípio de Bernoulli explica adequadamente a força de elevação observada.

#align(center)[#image("images/bernoulli/frisbee.gif")]

O ar fluindo ao longo da face convexa do frisbee tem maior velocidade do que o ar fluindo na face de baixo. Assim, cria-se uma região de baixa pressão acima do frisbee que, justaposta à região de baixo, ocasiona em uma força de elevação.

/* ************************************** SAITO ************************************** */

= Inércia Giroscópica

== Definição

#definition[
  Resistência ao alterar o eixo de rotação de um corpo rotativo. Essa resistência é igual em módulo à magnitude do momento angular do corpo.
]

#v(48pt)

A inércia giroscópica garante a estabilidade no movimento do _Frisbee_. Com uma *velocidade angular* suficientemente elevada $bold(w)$, o _Frisbee_ tende a manter seu eixo de rotação estável.

== Demonstração

_Proof :_ Considere uma partícula a uma distância $r$ da origem e com momento linear $p$. O momento angular deste ponto em relação à origem é definido como:

$
upright(bold(L)) &= bold(r) times bold(p) \
                 &= bold(r) times (m bold(v)) \
                 &= m (bold(r) times bold(v))
$

#pagebreak()

Para um corpo rígido em rotação com velocidade angular $bold(w)$, a velocidade $bold(v)$ da partícula na posição $bold(x)$ é:

$
bold(v) = bold(w) times bold(r)
$

Assim, o momento angular do corpo será dado por:

$
upright(bold(L)) &= m (bold(r) times (bold(w) times bold(r)))
$

#pause

Pela *identidade do produto vetorial duplo*, temos que:

$
upright(bold(L)) &= m ((bold(r^t) dot bold(r))w - (bold(r^t) dot bold(w))r)
$

#pagebreak()

Como $(bold(r^t) dot bold(w))$ é uma função real, podemos reescrevê-la como:

$
upright(bold(L)) &= m ((bold(r^t) dot bold(r))bold(w) - (bold(r) dot bold(r^t))bold(w)) \
                 &= m((bold(r^t) dot bold(r))I - (bold(r) dot bold(r^t))) dot bold(w) \
$

Assim, a contribuição diferencial de uma massa $\dm$ para o momento angular será:

$
\d upright(bold(L)) &= \dm ((bold(r^t) dot bold(r))I - (bold(r) dot bold(r^t))) dot bold(w) \
$ <eq:dm>

#v(31pt)

*Nota*: Em um corpo rígido, todas as partículas compartilham a mesma velocidade angular $bold(w)$.

#pagebreak()

Integrando a equação @eq:dm obteremos que:

$
upright(bold(L)) = upright(bold(I)) dot bold(w)
$ <eq:momento_angular>

Em que o termo $upright(bold(I))$ corresponde ao tensor de inércia do corpo, expresso por:

#v(14pt)

$
upright(bold(I)) = integral_V ((bold(r^t) dot bold(r))I - (bold(r) dot bold(r^t))) \dm
$ <eq:tensor>

#v(26pt)

// CORRIGIR AQUI
*Nota:* Na apostila, o tensor de inércia é derivado a partir da posição das partículas na base móvel, denotado por $upright(bold(B))$.

#pagebreak()

_Relembrando_ : O torque $bold(tau)$ sobre uma partícula é a taxa de variação do momento angular, dado por:

$
bold(tau) = dot(upright(bold(L)))
$ <eq:torque>

Portanto, substituindo na @eq:momento_angular obtemos:

$
bold(tau) = upright(bold(dot(I))) dot bold(w) + upright(bold(I)) dot bold(dot(w)) 
$ <eq:torque_expandido>

Assim, um torque $bold(tau)$ aplicado a um corpo rígido causa duas mudanças:

#v(18pt)

// Acho que esse nome é diferente
+ Mudança da orientação do corpo em relação ao eixo de rotação.

+ Variação no momento angular do corpo.

#pagebreak()

Na prática, o _Frisbee_ rotaciona em relação a um eixo particular cujo *momento de inércia* é máximo. A representação clássica do _Frisbee_ segue a baixo:

#let frisbee-canvas = cetz-canvas({
  import cetz.draw: *

  // Frisbee
  circle((0,0),
         radius: (112pt, 26pt),
         fill: yellow,
         stroke: 1.1pt + black,
  )
  circle((0,.2),
         radius: (98pt, 21pt),
         fill: yellow,
         stroke: 1.7pt + rgb("#CCA43B"),
  )

  // Eixo de Rotação 1
  content((1, 2), $bold(w)$)
  line((0,0.3), (0, 2.5), stroke: (dash: "dashed"))
  line((0,-.93), (0, -2.2), stroke: (dash: "dashed"))

  // Eixo de Rotação 2
  line((-5.28,0), (-4, 0), length: 6pt, stroke: (dash: "dashed"))
  line((5.30,0), (4, 0), length: 6pt, stroke: (dash: "dashed"))

  // Eixo de Rotação 3
  line((-4.30,1.15), (-2.66, 0.71), length: 6pt, stroke: (dash: "dashed"))
  line((2.66,-0.71), (3.93, -1.1), length: 6pt, stroke: (dash: "dashed"))

  // massa dm 
  content((4.4, .82), $\dm$, font: 1pt)
  circle((4,0),
         radius: (.1,.1),
         fill: yellow,
         stroke: 1pt + black,
  )
})

#align(center)[
#figure(
  frisbee-canvas,
  caption: [Frisbee e seus três eixos principais],
)
]

#v(9pt)

Como podemos notar, o _Frisbee_ possui três eixos de rotação principais, de modo que um deles possui momento de inércia máximo.

#pagebreak()

Analisando de cima, notamos que o momento de inércia máximo está atrelado ao eixo de rotação vertical na figura à direita.

#let frisbee-1 = cetz-canvas(length: 10cm, {
  import cetz.draw: *
  // Outer circle
  circle((5cm, 5cm), radius: 4cm, fill: yellow, stroke: 1.1pt + black)
  // Inner circle
  circle((5cm, 5cm), radius: 3.5cm, fill: yellow, stroke: 1.7pt + rgb("#CCA43B"))

  line((0.5,1),
       (0.5, .0),
       stroke: (dash: "dashed"))
  line((5cm,6.7cm),
       (8.63cm, 6.7cm),
       stroke: 1pt + black)
})

#let frisbee-2 = cetz-canvas(length: 10cm, {
  import cetz.draw: *
  // Outer circle
  circle((5cm, 5cm), radius: 4cm, fill: yellow, stroke: 1.1pt + black)
  // Inner circle
  circle((5cm, 5cm), radius: 3.5cm, fill: yellow, stroke: 1.7pt + rgb("#CCA43B"))
  content((5cm, 5cm), $⊗$)
  line((0.5,1),
       (0.5, .0),
       stroke: none)
})

#v(-9pt)

#align(center)[
#scale(94%,
figure(
  grid(
    columns: 2,
    gutter: 5em,
    frisbee-1,
    frisbee-2
  ),
  caption: [Frisbee visto de cima e dois eixos de rotação principais.])
)
]

#pagebreak()

#v(11pt)

Assim, simplificaremos o tensor de inércia do _Frisbee_, considerando apenas o *escalar* $I$ para representá-lo.

#v(17pt)

_Relembrando :_ O tensor de inércia do _Frisbee_ é calculado como:

#v(14pt)

$
bold(upright(I)) = mat(
  delim: "[",
  frac(M R^2,4),0,0;
  0,frac(M R^2,4),0;
  0,0,frac(M R^2,2);
)
$ <eq:tensor_frisbee>

#v(14pt)

*Nota*: Isso ocorre ao calcular a matriz do tensor de inércia no referencial móvel. A abordagem anterior impede sua diagonalização.


#pagebreak()

#v(23pt)

Para compreendermos o conceito de *Inércia Giroscópica* precisamos antes da seguinte hipótese:

#v(63pt)

#align(center)[
  #block(
    width: 67%,
    height: 91pt,
    stroke: 2pt + black,
    inset: 19pt,
    [
  _Hipótese :_ Torque é aplicado perpendicularmente ao momento angular.
    ]
  )
]

#pagebreak()

#v(23pt)

Retornando à @eq:torque_expandido, conseguimos simplificá-la:

$
tau &= dot(upright(I)) dot w + cancel(upright(I) dot dot(w)) \
tau &= dot(upright(I)) dot w
$

O torque pode alterar a orientação do corpo em relação ao eixo de rotação, reduzindo o *momento de inércia*.

#v(17pt)

No entanto, pelo princípio de conservação da energia cinética $frac(I w²,2)$, essa redução é impossível.

#pagebreak()

#v(23pt)

Assim, é preciso que o corpo mantenha seu eixo de rotação, de modo que a
magnitude de $bold(upright(I)) dot bold(w)$ seja constante, o que ocorre com uma
*velocidade angular elevada*.

Portanto, vamos escrever o momento angular como:

#v(10pt)

$
bold(upright(L)) = I w bold(hat(w))
$

#v(10pt)

Em que $I$ é a magnitude do momento de inércia máximo, $w$ a magnitude da
velocidade angular, e $bold(hat(w))$ o eixo de rotação.

#pagebreak()

#v(13pt)

Aplicando a @eq:torque na última expressão, encontramos:

$
bold(tau) &= bold(upright(dot(L))) \
bold(tau) &= L frac(\d bold(hat(w)),\d t)
$ <eq:inercia_giroscopica>

Portanto, o torque varia o eixo de rotação e é inversamente proporcional à
magnitude do momento angular $L$, que representa a *inércia giroscópica*.

/* ************************************** JPIGGERS ************************************** */

= Modelagem

== Forças Aerodinâmicas

#v(13pt)

Seja $d_1$ o vetor unitário na direção da projeção do vetor velocidade $bold(v)$ no plano do disco. Seja $d_2$ outro vetor unitário no plano do disco que forma uma base com $d_1$, e $d_3 = d_1 times d_2$ o vetor normal ao plano do disco.

Sob a hipótese de que o movimento do disco se dá em um plano, então ${d_1, d_3}$ forma uma base para esse plano.

Sobre o disco agem a força peso, de sustentação e de arrasto. Os vetores das forças de arrasto e sustentação sempre se mantém perpendiculares entre si, enquanto que o peso aponta para o solo.

#figure(
  image("images/modelagem/disco-hummel.png"),
  caption: [Representação das forças aerodinâmicas]
)

#pagebreak()

#v(16pt)

Por um exercício trigonométrico, podemos decompor as forças aerodinâmicas de modo que

#v(16pt)

$
bold(L) &= (L sin alpha) bold(d_1) + (L cos alpha)bold(d_3) \
bold(D) &= (-D cos alpha) bold(d_1) + (D sin alpha) bold(d_3)
$

#v(14pt)

Onde $bold(L)$ e $bold(D)$ são, respectivamente, os vetores das *forças de sustentação* e de *arrasto.* Desse modo, a força aerodinâmica que age sobre o disco é

$
bold(F)_"ad" = (L sin alpha - D cos alpha) bold(d_1) + (L cos alpha + D sin alpha) bold(d_3)
$

#pagebreak()


== Determinando as Forças Aerodinâmicas

A *força de arrasto* geralmente é modelada como

$
D = (C_d rho A v^2) / 2
$

Onde $C_d$ é o coeficiente de arrasto, $rho$ é a densidade do ar, $A$ a área da superfície de arrasto (Área do _Frisbee_) e $v$ a velocidade relativa do fluído. Como estamos considerando o ar estacionário, então o módulo da velocidade é igual ao do frisbee.

O coeficiente $C_d$ é dado como função do ângulo de ataque

$
C_d = C_d_0 + C_d_alpha alpha^2
$ 

Onde $C_d_alpha$, $C_d_0$ e $alpha_0$ são coeficientes que dependem do disco.

- Já a *força de sustentação* pode ser modelada a partir do Princípio de Bernoulli. Pela equação abaixo,

$
 p_1 + frac(1,2) rho v_1^2 + rho g y_1 = p_2 + frac(1,2) rho v_2^2 + rho g y_2 
$

podemos obter, sob a hipótese de que a espessura do disco é desprezível, que
$
p_1 + frac(1,2) rho v_1^2 =  p_2 + frac(1,2) rho v_2^2
$
// We will also as￾sume that the velocity of the air flowing above is directly proportional to the velocity of the air below because the difference in path length is constant  (não entendi muito bem)

Considerando que a velocidade do ar acima do disco é diretamente proporcional à que flui abaixo, temos $v_1 = C v_2$.

Assim, pela definição de pressão $P=F/A$, temos que $(p_1 - p_2) = L / A$.

// Informar qual das velocidades está atrelada a qual região do disco

#v(19pt)

$
p_1 + 1/2 rho v_1^2 &= p_2 + 1/2 rho v_2^2 \
L/ A + 1/2 rho C^2 v^2 &= 1/2 rho v^2 \
frac(L,A) &= frac(1,2) rho v^2 A (1 - C^2) \
$

#pagebreak()

#v(19pt)

Incorporando $C$ ao *coeficiente de sustentação* denotado por $C_L$, obtemos:

$
&L = (rho v^2 A C_L) / 2 \
$

De modo que $C_L$ é uma função do ângulo de ataque.

#v(16pt)

$
C_L = C_L_0 + C_L_alpha alpha 
$

#v(16pt)

*Nota*: Os coeficientes $C_L_0$ e $C_L_alpha$ são constantes que dependem das propriedades físicas do _Frisbee_.

== Obtendo a Força Total

- A força aerodinâmica foi escrita em termos da base de ${d_1, d_3}$. Para conseguimos as equações do movimento nos eixos x e z, então precisamos escrever essa força em termos da base canônica do plano x-z.

- Considere que o a inclinação entre $d_1$ e o eixo x seja $phi$. Desse modo, se $bold(F')_"ad"$ é a força aerodinâmica na base canônica, então
$
bold(F')_"ad" = Q F_"ad"
$
onde $Q$ é uma rotação de ângulo $phi$. Logo, para obter a força aerodinâmica na base canônica, basta computarmos $Q F_"ad"$.

#pagebreak()

$
bold(F')_"ad" = mat(delim: "[", cos phi, -sin phi; sin phi, cos phi) vec(delim: "[", L sin alpha - D cos alpha, L cos alpha + D sin alpha ) \

bold(F')_"ad" = vec(delim: "[", (L sin alpha - D cos alpha)cos phi -   (L cos alpha + D sin alpha) sin phi, (L sin alpha - D cos alpha) sin phi + ( L cos alpha + D sin alpha) cos phi)
$
Abrindo as expressões e usando propriedades trigonométricas, obtemos
$
bold(F')_"ad" = 1/2 A rho v^2 vec( delim: "[", C_L sin (alpha - phi) - C_D cos (alpha - phi),  C_L cos(alpha - phi) + C_D sin (alpha - phi) ) $

#pagebreak() 

#v(14pt)

Se $F_x$ e $F_z$ são as forças nas componentes horizontal e vertical respectivamente, então

$
F_x &= 1/2 A rho v^2 (C_L sin (alpha - phi) - C_D cos (alpha - phi)) \
F_z &=  1/2 A rho v^2 (C_L cos(alpha - phi) + C_D sin (alpha - phi)) - m g
$
== Obtendo as Equações do Modelo

*Hipótese*: _O disco gira com momento angular o suficiente para manter uma trajetória estável e resistir a inclinações ao longo de sua trajetória._

- A hipótese acima nos permite considerar $phi$ constante ao longo de todo o trajeto do disco.

*Hipótese*: _O fluxo relativo de ar na vertical é desprezível em relação ao da horizontal_

- Essa hipótese por sua vez gera as seguintes implicações no modelo
  
  + Considerando o ar estacionário, o módulo da velocidade do fluxo de ar relativo nas fórmulas das forças de sustentação e arrasto será igual ao módulo da velocidade horizontal do disco: $v = dot(x)$.
  
  + Se consideramos apenas o fluxo de ar na horizontal, então o ângulo de ataque $alpha$ será igual a inclinação entre o vetor $d_1$ no plano do disco e o eixo horizontal, ou seja, igual à inclinação do plano do disco: $alpha = phi$, e o disco mantém um ângulo de ataque constante ao longo da trajetória.
  
#pagebreak()

#v(16pt)

Com essas novas hipóteses, as equações do movimento se reduzem para

$
m dot.double(x) &= - (C_D A rho dot(x)^2)/2 \
m dot.double(z) &=  (C_L A rho dot(x)^2)/2 - m g
$ <eq:accy>

Com isso, obtemos o seguinte sistema de EDOs de segunda ordem.

$
cases(
  dot.double(x) = -(C_D A rho)/(2m)dot(x)^2 \
  dot.double(z) = (C_L A rho)/(2m) dot(x)^2 - g
)
$

== Resumo das Hipóteses

+ O _Frisbee_ é um corpo rígido, simétrico e com espessura desprezível em relação ao diâmetro.

+ O lançamento ocorre sem vento, torques externos, e em um fluído incompressível.

+ Sobre o disco só agem as força da gravidade e aerodinâmicas de arrasto e sustentação.

+ O disco é lançado com componente da velocidade lateral igual a zero.

+ O disco é lançado com momento angular suficiente para manter uma trajetória estável.

+ O fluxo de ar na vertical é desprezível em relação ao da horizontal.

= Resolvendo o Modelo //etapa 4

== Sistema de 1ª ordem

#v(10pt)

O sistema de segunda ordem, dependente de $dot(x)$ e $dot(z)$, pode ser reduzido para primeira ordem com $dot(x) = v_x$ e $dot(z) = v_z$.

Além disso, denotando os termos $(C_D A rho) / (2m)$ e $(C_L A rho) / (2m)$ por $k_D$ e $k_L$.

// O sistema só envolve a segunda e a primeira derivada da função. Dessa forma podemos transformar num sistema de primeira ordem fazendo uma troca de variáveis: $dot(x) = v_x$, $dot(y) = v_y$. Além disso, vamos denotar os termos $(C_D A rho) / (2m)$ e $(C_L A rho) / (2m)$ por $k_D$ e $k_L$.

#v(16pt)

$
cases(dot(v)_x = -k_D v_x^2 \
      dot(v)_z = k_L v_x^2)
$

#pagebreak()

#v(10pt)

Aplicando a separação de variáveis na primeira

$
-1/v_x = -k_D t + C_1 \
v_x = 1/(k_D t + C_1) 
$

Integrando os dois membros e lembrando que $dot(x) = v_x$, obtemos

$
x = 1/k_D ln|k_D t + C_1| + C_2
$

#pagebreak()

Agora resolvendo para para $v_y$
$
integral dot(v)_z d t = integral (k_L/(k_D t + C_1)^2 - g) d t \
v_z = -k_L/(k_D (k_D t + C_1)) - g t + C_3
$
Integrando mais uma vez, obtemos
$
z = -k_L/k_D^2 dot ln abs(k_D t + C_1) - (g t^2)/2  + C_3 t + C_4
$

#pagebreak()

Solução Analítica do modelo:
$
cases(x = 1/k_D ln abs(k_D t + C_1) + C_2 \ z = -k_L/k_D^2 dot ln abs(k_D t + C_1) - (g t^2)/2  + C_3 t + C_4)
$

Ao passo que as constantes de integração são dada em função das condições iniciais $x_0, y_0, v_x_0, v_z_0$

#v(10pt)

$
mat(
  delim: #none,
  align: #left,
  C_1 = 1/v_x_0, C_2 = x_0 - 1/k_D ln abs(1/v_x_0) ;
  C_3 = v_z_0 + k_L/k_D dot v_x_0, C_4 = z_0 + k_L/k^2_D ln abs(1/v_x_0);
)
$

= Simulação

== Variáveis

#v(10pt)

Primeiramente, vamos definir as variáveis:

#let code-font-size = 16.81pt

#text(size: code-font-size)[
  ```python
  # Condições iniciais
  x0 = 0                    # Posição inicial no eixo x (m)
  y0 = 1                    # Posição inicial no eixo y (m)
  vx0 = 16                  # Velocidade inicial no eixo x (m/s)
  vy0 = 0                   # Velocidade inicial no eixo y (m/s)
  a = np.radians(10)        # Ângulo de ataque inicial em radianos (conversão de 10 graus)
  
  # Propriedades Físicas
  d = 0.22                  # Diâmetro do frisbee (m)
  m = 0.175                 # Massa do frisbee (kg)
  rho = 1.23                # Densidade do ar (kg/m³)
  g = 9.81                  # Aceleração da gravidade (m/s²)
  A = np.pi * (d / 2) ** 2  # Área frontal do frisbee (m²)
  ```
]

#pagebreak()

#v(10pt)

Definindo os coeficientes aerodinâmicos:

#text(size: code-font-size)[
  ```python
  # Coeficientes aerodinâmicos
  CD0 = 0.08           # Coeficiente de arrasto (adimensional)
  CDa = 2.72           # Variação do arrasto com o ângulo de ataque (adimensional)
  CL0 = 0.15           # Coeficiente de sustentação (adimensional)
  CLa = 1.4            # Variação da sustentação com o ângulo de ataque (adimensional)
  a0 = np.radians(-4)  # Ângulo de ataque de referência para o arrasto (em radianos)
```
]

#pagebreak()

#v(13pt)

Funções para a encapsular as constantes nos termos $k_l$ e $k_d$ atrelados, respectivamente, à sustentação e ao arrasto:

#text(size: code-font-size)[
```py
  def KD(a: np.radians):
      CD = CD0 + CDa * (a - a0) ** 2
      return CD * A * rho / (2 * m)
  
  def KL(a: np.radians):
      CL = CL0 + CLa * a
      return CL * A * rho / (2 * m)

kl = KL(a)
kd = KD(a)
```
]

#pagebreak()

#v(13pt)

Constantes de Integração e funções paramétricas para a posição do _Frisbee_ ao longo do tempo:

#text(size: code-font-size)[
```py
C1 = 1 / vx0                                # Velocidade inicial no eixo x (s/m)
C2 = x0 - 1 / kd * np.log(np.abs(C1))       # Posição inicial no eixo x (m)
C3 = vy0 + kl / kd * vx0                    # Velocidade inicial no eixo y (m/s)
C4 = y0 + kl / kd**2 * np.log(np.abs(C1))   # Posição inicial no eixo y (m)

x = lambda t: 1 / kd * np.log(np.abs(kd * t + C1)) + C2
y = lambda t: -kl / kd**2 * np.log(np.abs(kd * t + C1)) - g / 2 * t**2 + C3 * t + C4
```
]

#pagebreak()

#v(13pt)

Mapeamento da trajetória em um `CSV`:

#text(size: code-font-size)[
```py
delta_t = 0.01
t = 0.01
x_pos, y_pos = np.array([x0]), np.array([y0])
with open("frisbee_ours.csv", "w+") as csvfile:
    csvfile.write('t,x,y\n')          # Header do CSV
    while y(t) >= 0:
        x_v = x(t)
        y_v = y(t)
        x_pos = np.append(x_pos, x_v)
        y_pos = np.append(y_pos, y_v)
        t += delta_t
        csvfile.write(f"{t:.4f},{x_v},{y_v}\n")
```
]

== Gráficos

#let fig-size = 79.61%

#figure(
  image("images/test-1/frisbee_ours_vel_18_ang_5.png", width: fig-size),
  caption: [Trajetória do _Frisbee_ com velocidade inicial 18 m/s e $alpha$ = 5º]
)

#pagebreak()

#figure(image("images/test-2/frisbee_our_vel_18_ang_75.png", width: fig-size),
  caption: [Trajetória do _Frisbee_ com velocidade inicial 18 m/s e $alpha$ = 7.5º]
)

#pagebreak()

#figure(image("images/test-3/frisbee_ours.png", width: fig-size),
  caption: [Trajetória do _Frisbee_ com velocidade inicial 14 m/s e $alpha$ = 0º]
)

= Comparação

== Solução  _Physics of Frisbee_

#figure(image("images/frisbee_comparison_new.png", width: fig-size),
  caption: [Trajetória do _Frisbee_ com velocidade inicial 14 m/s e $alpha$ = 0º]
)

#pagebreak()

== Experimento

#figure(image("images/experiment/saito-experimento.png", width: fig-size),
  caption: [Captura do _Tracker_ durante lançamento do _Frisbee_.]
)

#pagebreak()

#figure(image("images/experiment/tracker-experiment.png", width: fig-size),
  caption: [Trajetória do _Frisbee_ com velocidade inicial 5.6 m/s e $alpha approx 3 degree$ ]
)

#pagebreak()

== Dados do Experimento

#let styled_table = table.with(
  columns: 2,
  align: center,
  stroke: (x, y) => if y == 0 { (bottom: 2.5pt + black) } else { none },
  inset: 4pt,
)

#figure(
  table(
    columns: (1fr, 1fr),
    rows: 38pt,
    inset: 8.4pt,
    align: (center, center),
    table.header([*Variável*], [*Valores*]),
    [$x_0$], [$0.335 plus.minus 0.005$ m],
    [$z_0$], [$1.358 plus.minus 0.005$ m],
    [$v_0$], [$5.673 plus.minus 0.0707$ m/s],
    [massa], [$0.080 plus.minus 0.001$ kg],
    [diâmetro], [$0.21 plus.minus 0.005$ m],
    [ângulo de ataque], [3º],
    [aceleração da gravidade], [9.81 m/s²],
    [densidade do ar], [1.23 kg/m³],
  ),
  caption: [Dados coletados no _Tracker_ e incertezas dos aparelhos de medição.]
)

#pagebreak()

#figure(image("images/comparisons/frisbee_comparison_experiment_all_models.png", width: fig-size),
  caption: [Trajetória do _Frisbee_ com velocidade inicial 5.657 m/s e $alpha approx 3 degree$.]
)

#pagebreak()

#set text(size: 22pt)
#bibliography(
  "ref.bib",
  full: true, 
  style: "thieme"
)
