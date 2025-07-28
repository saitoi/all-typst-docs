#import "@preview/diverential:0.2.0": *

#set text(lang: "pt")

#set page(
  header: [
    _Equação Diferencial do Pêndulo Simples_
    #h(1fr)
    Universidade Federal do Rio de Janeiro
    #linebreak()
    #v(.1em)
    Pedro Henrique Honorio Saito
    #h(1fr)
    DRE: 122149392
  ]
  ,numbering: "1"
  ,margin: auto
)

#set math.equation(numbering: "(1)")

== Equação

#v(.7em)

A equação que rege o movimento do pêndulo simples, sem a aproximação do ângulo pequeno, é descrita da seguinte forma:

$
dv( theta, t, deg: 2 ) + g / L sin theta = 0
$ <eq:pendulum_nonlinear>

Esta é uma equação não-linear, diferente da equação linear clássica do pêndulo,
na qual o sistema é considerado um oscilador harmônico simples, obtido a partir
da aproximação $sin theta approx theta$:

$
T = 2 pi sqrt( L / g )
$

== Motivações

#v(.7em)

Para ângulos superiores a $20 degree$, a aproximação linear não representa com
precisão a dinâmica do pêndulo. Nesses casos, a não-linearidade do termo $sin,
theta$ permite captar a verdadeira oscilação do sistema.

== Condições Adicionais do Modelo

#v(.7em)

Dentre as condições inicias, destacam-se:

- Ausência de atrito.
- Ausência de resistência da ar.
- Fio inextensível e sem massa.
- Movimento restrito a um plano.
- Deslocamento angular inicial diferente de zero.
- Velocidade angular inicial nula.

Essas hipóteses garantem o princípio da conservação de energia.

== Solução Exata

#v(.7em)

Como discutido em @dias2021pendulo, a solução da equação que rege o comportamento do pêndulo simples em regime não linear é dada pela expressão:

$
omega (theta_0) = frac( pi sqrt( g / l ), 2 K ( sin^2( theta_0 / 2 )))
$

#v(.5em)

Componentes da solução:

#set list(spacing: .93em)

- $omega( theta_0 )$: frequência angular, depende do ângulo inicial $theta_0$.
- $g$: Aceleração da gravidade.
- $l$: Comprimento do pêndulo.
- $theta_0$: Amplitude inicial (ângulo de lançamento do pêndulo).
- $K(x)$: Integral elíptica completa do primeiro tipo.
- $sin^2(theta_0 / 2)$: Seno quadrado da metade do ângulo inicial.

#v(1.5em)

#bibliography("referencias.bib", title: none, style: "trends")

// #pagebreak()

// == Derivação

// #v(.7em)

// Aplicando a segunda lei de Newton à @eq:pendulum_nonlinear obtemos:

// $
// dv(theta, t, deg: 2) + omega_0^2 sin theta = 0
// $

// Multiplicando a equação anterior por $dv(theta, t)$ e a integrando:

// $
// 1 / 2 dv(theta, t)^2 - omega_0^2 cos theta = c t e
// $



