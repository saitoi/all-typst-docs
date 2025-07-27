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
    title: [Modelo de Brusselator],
    subtitle: [Teoria e Simulações],
    author: [João Pedro Sousa e Pedro Saito],
    date: datetime.today(),
    institution: [
      Computação Científica e EDOs
      
      Universidade Federal do Rio de Janeiro
    ],
    ),
    config-page(
    header: place(
      bottom + right,
      dx: -26.6cm,
      dy: 14.0cm,
      image("images/ufrj-logo.png", width: 57pt, height: 60pt)
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

== Motivação Histórica

#v(.7em)

_Contexto:_ Estudo de reações autocatalíticas e com comportamento oscilatório realizado pelo químico russo _Boris Belausov_ durante a década de 1950 sobre o mecanismo do *Ciclo de Krebs*.

O experimento original misturava bromato, ácido cítrico e cério, fazendo a cor da solução oscilar periodicamente. Dez anos depois, _A. H. Zhabotinskii_ refez os testes e mostrou que as oscilações vinham das formas $"Ce"^(3+)$ e $"Ce"^(4+)$ do cério, descritas em um mecanismo simplificado.

#pagebreak()

#v(1.5em)

#let nonumber = math.equation.with(
  block: true,
  numbering: none,
)

#figure(
  nonumber($
  "Ce(III)" &arrow.r.long "Ce(IV)" \
  "Ce(IV)" + "CHBr(COOH)" &arrow.r.long "Ce(III)" + "Br"^- + "outros produtos"
  $),
  caption: [_As espécies $"Ce(III)"$ e $"Ce(IV)"$ são autocatalíticas._]
)

#v(1em)

A primeira reação é autocatalisada por $"BrO"^(-3)$ e inibida por $"Br"^-$; à medida que $"Ce(IV)"$ é produzido, gera-se $"Br"^-$, desacelerando a primeira reação. Assim, o equilíbrio da segunda equação é deslocado no sentido inverso, e a reação 1 no sentido direto, de modo a reiniciar o ciclo.

// A primeira reação é autocatalisada por $\text{BrO}^{-3}$ e inibida por $\text{Br}^{-}$. Dessa forma, conforme 
// mais $\text{Ce}(IV)$ é produzido, mais $\text{Br}^{-}$ é gerado, desacelerando a primeira reação. Em decorrência
// disso, o equilíbrio da equação 2 é deslocado no sentido inverso, e a reação 1 no sentido direto, de modo a reiniciar 
// o ciclo.

#pagebreak()

= Aspectos Teóricos

== Dedução do Modelo

#v(.7em)

O mecanismo químico com taxas que originou o modelo de Brusselator é dado por:

#align(left)[
#grid(
  columns: 2,
  column-gutter: 70pt,
  nonumber($
  A &arrow.r.long^(k_1) X \
  2X + Y &arrow.r.long^(k_2) 3X \
  B + X &arrow.r.long^(k_3) Y + C \
  X &arrow.r.long^(k_4) D
  $),
  [Onde:
    - As espécies $X$ e $Y$ são autocatalíticas.
    - $A$, $B$, $C$, $D$, $X$, $Y$ têm unidades de concentração.
    - Reações que formam $X$ (ou $Y$) geram um termo positivo $+thin k_n dot "concentração"$.
    - Reações que consomem geram termo negativo.
    - $A$, $B$, $C$, $D$ são fatores externos constantes.
  ]
)
]

#pagebreak()

#v(.7em)

Com efeito, derivamos o seguinte sistema de EDOs:

$
dot(x) &= k_1 A + k_2 X^2 Y - k_3 B X - k_4 X \
dot(y) &= k_3 B X - k_2 X^2 Y
$

Agora nos resta agrupar variáveis anteriores de modo a torná-las adimensionais. Sendo assim, definiremos:

$
tau = k_4 t, quad X = x A k_1/k_4, quad Y = y A k_1/k_4.
$

#pagebreak()

#v(.7em)

Além disso, precisamos definir os grupos adimensionais:

$
a = k_2 A/k_4^3, quad b = k_3 B/k_4.
$

Pelo teorema da cadeia, temos para $(d x)/(d t):$

$
(d x)/(d t) = (d X)/(d tau) (d tau)/(d t) = (d X)/(d tau) k_4 => (d X)/(d tau) = 1/4 (d x)/(d t)
$

e o mesmo vale para $Y$. 

#pagebreak()

#v(.7em)

A partir disso, derivamos o sistema adimensional dado na definição:

$
k_1 A dot(x) = k_1 A - (k_3 B + k_4) k_1 A/k_4 x + k_2 (k_1 A/k_4 x)^2 (k_1 A/k_4 y)
$

de modo que

$
dot(x) = (d x)/(d tau) quad "e" quad dot(y) = (d y)/(d tau).
$

#pagebreak()

#v(.7em)

Por fim, dividindo a equação anterior por $k_1 A$ chegaremos em:

$
dot(x) = 1 + underbrace(k_2/k_4^3 (k_1 A)^2, a) x^2 y - underbrace((k_3 B + k_4)/k_4, (b + 1)) x \ \
cases(
dot(x) = 1 - x (b + 1) + a x^2y \
dot(y) = b x - a x^2y
) quad qed
$

#v(.6em)

*Obs:* Não demonstrei para o $Y$, porém a regra da cadeia e as substituições são análogas.

== Definição

#v(.7em)

Modelo matemático para uma classe de reação autocatalítica. A dinâmica do Brusselator é dada pelo seguinte sistema de EDOs na forma adimensional:

$
dot(x) &= 1 - x (b + 1) + a x^2y \
dot(y) &= b x - a x^2y
$

== Pontos de Equilíbrio

#v(.7em)

O  equilíbrio das equações ?? é dado pela resolução do sistema de EDOs:

$
&dot(x) = 1 - (b + 1)x + a x^2y = 0 \
+ med med &dot(y) = b x - a x^2y = 0 \
&#line(length: 42%) \
&dot(x) + dot(y) = cancel(a x^2 y) + cancel(b \cdot x) + 1 - x = 0 \
&dot(x) + dot(y) = 1 - x = 0 \
$

Desse modo, escolhendo $x = 1$ e substituindo isso na segunda equação $(5)$ vamos obter $y=b/a$. Assim, encontramos o único ponto de equilíbrio da modelo, isto é, o ponto $(1, b/a)$.

== Análise dos Pontos de Equilíbrio

#v(.7em)

A matriz Jacobiana é dada por

$
J = mat(
  -(b+1) + 2 a x y, a x^2;
  b - 2 a x y, - a x^2;
  delim: "["
).
$

No ponto de equilíbrio $(1,b/a)$, obtemos

$
J = mat(
  b-1, a;
  -b,-a;
  delim: "["
) => cases(
  p &= tr(J) = b - (a+1)\
  q &= det(J) = a
)
$

Donde a equação característica segue: $lambda^2 - p lambda + q = 0$.

Disso, temos os seguintes casos para o ponto de equilíbrio.

#pagebreak()

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

#figure(
  table(
    columns: 3,
    row-gutter: 4pt,
    align: (center, left, left),
    inset: 10pt,
    [$Delta$], table.vline(), [*Característica*], table.vline(),[*Classificação*],
    table.cell(rowspan: 2, [$Delta = 0$], align: horizon), [$b > a + 1$ e $lambda_1 = lambda_2 > 0$], [*Nó Instável*],
    [$b < a + 1$ e $lambda_1 = lambda_2 < 0$], [*Espiral assint. estável*],
    table.hline(),
    table.cell(rowspan: 2, [$Delta > 0$], align: horizon), [$b>a+1$ e $lambda_1,lambda_2>0$], [*Nó Instável*],
    [$b<a+1$ e $lambda_1,lambda_2 < 0$], [*Nó Estável*],
    table.hline(),
    table.cell(rowspan: 3, [$Delta < 0$], align: horizon), [$b>a+1$ e $alpha > 0$], [*Espiral Instável*],
    [$b<a+1$ e $alpha < 0$], [*Espiral Estável*],
    [$b=a+1$ e $alpha = 0$], [*Centro ou Espiral Degenerado*],
    table.hline(),
  ),
  caption: [_Análise dos pontos de equilíbrio._]
)

== Bifurcação de Hopf

#v(.7em)

*Definição*: Fenômeno no qual, ao variar um parâmetro, as trajetórias deixam de ser atraídas (ou repelidas) por um ponto fixo e passam a ser atraídas (ou repelidas) por uma solução oscilatória e periódica.

// #image("phase_portrait_b2.50.png", width: 35%) 
#align(left)[
  #figure(
    image("bifurcacao_hopf.png", width: 101%),
    caption: [_Mudança da classificação do ponto de equilíbrio conforme $b$ varia._]
  )
]

== Demonstração

Para ocorrer a bifurcação de Hopf, basta atender a duas condições derivadas do *Critério de Routh-Hurwitz*:

*Proposição 1.* Demonstrar que os autovalores da Jacobiana $J$ são puramente imaginários e não-zero em $b = a+1$.

// Se todos os determinantes de Hurwitz $c_(i,0)$ são positivos, desconsiderando $c_(k,0)$, então o Jacobiano associado não possui autovalores imaginários puros.

*Proposição 2.* Provar que a taxa de variação da variação da parte real dos autovalores é não nula em $b=a+1$.

// Se todos os determinantes de Hurwitz até a ordem $k-2$ são positivos, $c_(k-1,0)=0$ e $c_(k-2,1) < 0$ então o Jacobiano tem todos autovalores com parte real negativa, exceto um par puramente imaginário.

// *Obs*: Em sistemas dinâmicos, nos interessa apenas a segunda proposição.

#v(.4em)

É razoável achar que a bifurcação de Hopf ocorre quando $b=a+1$, dado que temos um *centro ou espiral degenerado*.

#v(.4em)

*Obs:* Para a análise de bifurcação, fixaremos o $a$ e iremos variar o $b$.

#pagebreak()

#v(.7em)

$upright((I))$ Os autovalores da Jacobiana $J$ serão puramente imaginários se, e somente se, $p^2-4q<0$ e $b=a+1$. Como $p=b-1-a$, derivamos que em $b=a+1$, o traço $p$ é nulo. Portanto, o discriminante $p^2 - 4q = -4q$ será menor que zero quando $q>0$.

$upright((I I))$ Para um autovalor $lambda$, a parte real é $Re(lambda)=1/2p$. Como fixamos o $a$, vamos provar que $(partial Re(lambda))/(partial b) eq.not 0$:

$
(partial Re(lambda))/(partial b) = 1/2 (partial)/(partial b) [b-a-1] = 1/2 eq.not 0
$

como desejávamos. Portanto, por I e II, uma bifurcação de Hopf ocorre quando $b=a+1$.$quad qed$ 

// #grid(
//   columns: 2,
// image("res.png"),  image("res1.png")
// )

// Onde os determinantes de Hurwitz são derivados da Matriz de Hurwitz associada ao polinômio característico da jacobiana $J$. Em ordem 2, a matriz é constituída dos coeficientes:

// $
// H = mat( a_1,a_3; a_0, a_2; delim: "[") = mat( -p, 0; q, 1; delim: "[") " onde "P(lambda) = lambda^2 - p lambda + q
// $

// Os determinantes de Hurwitz correspondem aos menores principais superiores esquerdos da matriz:

// #grid(
  
// )

/*

REF: 

Na matemática de equações diferenciais, a bifurcação de Hopf é um fenômeno no qual a variação de um parâmetro do sistema faz com que o conjunto de trajetórias deixam de ser atraídas (ou repelidas) por um ponto fixo e, no lugar disso, passam a ser repelidas (ou atraídas) por uma solução oscilatória e periódica.

Segundo a literatura, precisamos garantir duas condições para a ocorrência da bifurcação de Hopf descritas no *Critério de Routh-Hurwitz*.

**Proposição 1.** Se todos os determinantes de Hurwitz $c_{i,0}$ são positivos, desconsiderando $c_{k,0}$ então o Jacobiano associado não possui autovalores imaginários puros.

**Proposição 2.** Se todos os determinantes de Hurwitz $ c_{i,0} $ (para todo $i \in \{0, \dots, k-2 \} $) são positivos, $c_{k-1,0} = 0$ e $c_{k-2,1} < 0$ então todos os autovalores do Jacobiano tem partes reais negativas, exceto um par conjugado puramente imaginário.

Onde os determinantes de Hurwitz $c_{i,0}$ podem ser calculados por meio de uma série de Sturm associada à equação característica da jacobiana $J$.
*/

= Métodos Aproximados

#pagebreak()

#align(horizon)[
  Para nossos experimentos, iremos usar o método de Rugen-Kuta de 4ª ordem.
]

#pagebreak()

#figure(
  image("convergencia_brusselator.png")
)


= Simulações

#pagebreak()

#figure(
  grid(
    columns: (60fr, 60fr),
    image("eq_delta0_alpha+.png" ),
    image("eq_delta0_alpha-.png")
  ),
  caption: [Soluções de Equilíbrio para $Delta = 0$ (autovalores iguais)]
)

#figure(
  grid( 
    columns: (60fr, 60fr),
    image("eq_delta+_eigen+.png"),
    image("eq_delta+_eigen-.png")
  ),
  caption: [Soluções de Equilíbrio para $Delta > 0$ (autovalores reais) ]
)

#figure(
  grid( 
    columns: (60fr, 60fr),
    image("eq_delta-_eigen+.png"),
    image("eq_delta-_eigen-.png")
  ),
  caption: [Soluções de Equilíbrio para $Delta < 0$ (autovalores complexos conjugados)]
)

#figure( 
  image("eq_delta-_center.png", width: 48%),
  caption: [Solução de Equilíbrio para $Delta < 0$ (autovalores imaginários)]
)


== Birfucação de Hopf

#image("simul_hopf_est.png")

// #figure( 
// image("simul_hopf.png", width: 52%)
// )

#figure(  
image("simul_hopf_int.png")
)

#figure(
  image("ciclos_limites.png")
)

#pagebreak()

#align(horizon)[
Observamos que fixando $a=1$ e variando o parâmetro $b$, temos a formação de ciclos limites entorno do ponto de equilíbrio, que darão uma natureza periódica ao comportamento do sistema.
]


== Evolução Temporal das Soluções

#figure( 
image("sol_temp.png", width: 59%),
caption: [Evolução Temporal para $a = 1$, $b=1.9$ e solução inical (1.1, 2)]
) <fig_oscilacao_amortecida>

#align(horizon)[
Na figura @fig_oscilacao_amortecida, observa-se que o modelo oscila cada vez menos
até convergir para a situação de equilíbrio. Isso deve a qualidade do tipo da solução
em função das constantes $a$ e $b$, que geram uma espiral estável em torno do ponto de
equilíbrio.
]

#figure(
  image("sol_perd.png", width: 62%),
  caption: [Evolução Temporal para $a = 1$, $b=2$ e solução inicial (1.0001, 2.0001)]
) <sol_perd>


#align(horizon)[
Na figura @sol_perd, para $a=1$, $b=2$ e uma solução inicial suficientemente
próxima da condição de equilíbrio, observamos que o sistema adquire um 
comportamento oscilatório periódico e regular. As curvas oscilam de forma harmônica 
e possuem forma senoidal.
]

#figure( 
  image("sol_limit.png", width: 60%),
  caption: [Evolução Temporal para $a = 1$, $b=2.2$ e solução inicial (1.1, 2.4)]
) <sol_limit>


#align(horizon)[
No gráfico da @sol_limit, observamos que, apesar da solução de equilíbrio
ser instável, o sistema converge para uma órbita periódica atratora, um
ciclo limite no espaço de fases. As curvas, sob essas condições, mantém-se 
consideravelmente estáveis e suaves.
]


#figure(
  image("sol_rlx.png", width: 60%),
  caption: [Evolução Temporal para $a = 1$, $b=5$ e solução inicial (1.1, 2.1)]
) <sol_rlx>


#align(horizon)[
Por fim, a figura @sol_rlx demonstra o sistema convergindo para um situação de oscilações
relaxadas. Observa-se que ambas as curvas possuem um comportamento não harmônico e cujo movimento é seguido de um tempo lento de "acúmulo" seguido de um tempo rápido de "relaxação".
As curvas são similares a pulsos.
]



= Conclusão

#pagebreak()

#align(horizon)[
O modelo de Brusselator revela como sistemas químicos simples podem exibir comportamentos dinâmicos complexos, desde equilíbrio estável até oscilações periódicas e ciclos limite. A análise do ponto de equilíbrio e da bifurcação de Hopf demonstra a transição entre regimes distintos, enquanto as simulações ilustram padrões como amortecimento, harmonia e relaxação. Esses resultados destacam a capacidade do modelo em descrever fenômenos reais, como reações oscilatórias.
]

// = Referências

#pagebreak()

#bibliography("refs.bib", title: "Referências", full: true)

/*



Desse modo, escolhendo $x = 1$ e substituindo isso na segunda equação $(5)$ vamos obter $y=\frac{b}{a}$. Assim, encontramos o único ponto de equilíbrio da modelo, isto é, o ponto $(1, \frac{b}{a})$.
*/



// = Componentes

// == Terminologia

// #v(.7em)

// - _*Dataflow Manager*_ : Usuário Nifi com permissões para adicionar, remover ou modificar os componentes do _Nifi Flow_.

// - *FlowFile*: Unidade básica de dados. Composta pelos _Attributes_ (metadados) e o _Content_ (conteúdo). Principais metadados:

//   - *UUID*: Identificador único universal de 128 bits (RFC 4122 do IETF).

//   - *Filename*: Nome do arquivo/dado.

//   - *Path*: Diretório estruturado para armazenamento no disco ou serviço externo.

// #pagebreak()

// #v(.7em)

// - *Processor*: Componente lógico básico responsável pelas tarefas:

//   - Exemplos de _Processors_: `GetFile`, `PutFile`, `ExecuteSQL`, `InvokeHTTP`, `ReplaceText`, `UpdateAttribute`, `LogAttribute`, `RouteOnAttribute`.
  
// #grid(
//     columns: 3,
//     column-gutter: 4em,
//     [
//       *Ingestão*
//       // (ou do próprio fluxo)
//     ],
//     [
//       *Transformação*
//       // de dados
//     ],
//     [
//       *Roteamento*
//       // do FlowFile
//     ]
// )

// - *Relacionamentos*: Cada processador pode ter zero ou mais relacionamentos definidos. Saída lógica do processador (#text(fill: green, weight: "bold")[Success] ou #text(fill: red, weight: "bold")[Failure]). Após o término do processamento, o FlowFile deve ser roteado/transferido para outro componente escolhido pelo DataFlow Manager.

// #pagebreak()

// #v(.7em)

// - *Canvas*: Interface visual primária para o _design_, gerenciamento e monitoramento dos _dataflows_.

// - *Conexão*: Componente "físico" que interliga quaisquer dois elementos do _dataflow_ (sobretudo _Processors_). Ligação física entre 2 componentes do fluxo de dados.

// - *Bulletin*: Os componentes podem reportar _bulletins_, isto é, equivalente a mensagens de _logs_ com tempo e nível de severidade (_Debug_, _Info_, _Warning_ e _Error_).

// #pagebreak()

// #v(.7em)

// - *Controller Service*: Componente que provê funcionalidades e configurações para outros elementos (sobretudo _Processors_).

//   - *Exemplo*: `DBCPConnectionPool` fornece serviço de pool de conexões para um ou mais processadores. Propriedades obrigatórias:
  
//     - *Database Connection URL*: `jdbc:sqlserver://ip;port;db`
    
//     - *Database Driver Class Name*: com.Microsoft.sqlserver.jdbc.SQL
    
//     - *Driver's Path*: `~/mssql-drivers/ptb/jars`

//     - *Database User & Password*: sa \*\*\*\*

// #pagebreak()

// #v(.7em)

// - *Funnel*: Componente que permite combinar dados de diferentes conexões em uma só.

// - *Process Group*: Agrupamento lógico de _Processors_ para facilitar o gerenciamento do _dataflow_.

// - *Remote Process Group*: Transferência de dados (_FlowFiles_) para uma instância remota do _Nifi_.

// - *Reporting Tasks*: Tasks executadas no _background_ que providenciam relatórios de utilização e monitoramento da instância _Nifi_.

//   - Exemplos: `MonitorDiskUsage`, `MonitorMemory`.

// // Apache Tika: Ferramenta de extração de texto e metadados de uma variedade de docs
// // Exs.: Markup (HTML, XML, RTF), Microsoft (docx, xlsx, pptx), Portáveis (PDF, EPUB), 
// //       Estruturado (CSV, TSV), Imagens (JPEG, PNG, TIFF), Audio (MP3, MP4, WAV)

// = Códigos


// == Tchau

// #v(.8em)

// #figure(
//   image("niagara-falls.png", width: 64%),
//   caption: [_Niagara falls._]
// )



// // Essa parte daqui não existe na real kk

// // = Solução

// // == Aplicação Final

// // #v(.7em)

// // *Principais benefícios da solução:*

// // - *Monitoramento em tempo real* do pipeline de dados
// // - *Escalabilidade automática* baseada no volume de dados
// // - *Recuperação automática* em caso de falhas
// // - *Auditoria completa* de todas as transformações
// // - *Interface visual* para modificações rápidas do fluxo
