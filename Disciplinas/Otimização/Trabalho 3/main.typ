#import "lib.typ": *
#import "@preview/plotst:0.2.0": *

#set text(lang: "pt")
#set heading(numbering: "1.")

#show table.cell.where(y: 0): strong
#set math.mat(delim: "[")

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
  title: "Trabalho 3 - Avaliação de PNL",
  subtitle: "Otimização 2025.1",
  authors: ("Pedro Saito\n122149392", "Marcos Silva\n122133854", "Milton Salgado\n122169279"),
)

= Questão 1

*Enunciado*: Para os seguintes problemas de otimização não linear irrestrita, estude de
forma detalhada e conceitual , as condições de otimalidade de primeira e segunda
orde, apresentando todos os cálculos . Ache os pontos críticos, extremo local e global
se existirem.

$bold(1.1")")$ Minimize $x_1 x_2, (x_1, x_2 in bb("R"))$.

As condições de otimalidade de primeira ordem garantem que, para que um ponto $x^*$ seja um mínimo ou máximo local de $f$, é necessário que o gradiente em $x^*$ seja nulo, isto é,

$
gradient f(x^*) = 0.
$

Desse modo, como o gradiente da função $f$ é dado por $(x_2,x_1)$, seu único
ponto crítico é $(0,0)$. Com isso, vamos analisar as condições de otimalidade de
segunda ordem para a matriz Hessiana de $f$.

Dada uma função de duas variáveis $f(bold(x)) = f(x_1, x_2)$ com os pontos críticos $(0,0)$, calcularemos as derivadas de segunda ordem para cada componente. Assim, teremos:

$
H_1 = mat((partial^2 f)/(partial x_1^2)(x^*)) = mat(0) quad "e" quad H_2 = mat(
  (partial^2 f)/(partial x_1^2)(bold(x)),(partial^2 f)/(partial x_1 partial x_2)(bold(x));
  (partial^2 f)/(partial x_2 partial x_1)(bold(x)),(partial^2 f)/(partial x_2^2)(bold(x));
) = mat(
  0,1;
  1,0;
)
$

Pelo critério de menores principais em $bb("R")^2$, vamos analisar os determinantes:

$
det(H_1) = 0 quad "e" quad det(H_2) = -1
$

Como podemos observar, o primeiro determinante $det(H_1)$ é zero e, portanto, o teste é _inconclusivo_. Realizando uma análise da função nos quadrantes de $f$ temos:

- Para $x_1 > 0$ e $x_2 > 0:f > 0$.
- Para $x_1 < 0$ e $x_2 < 0:f > 0$.
- Para $x_1 > 0$ e $x_2 < 0:f < 0$.
- Para $x_1 < 0$ e $x_2 > 0:f < 0$.

Com efeito, a origem $(0,0)$ é um *ponto de sela*, pois a função assume apenas valores positivos em alguns quadrantes e negativos em outros, indicando a presença de direções de crescimento e decrescimento próximas ao ponto crítico. Assim, como não tem pontos de mínimo, a função $f$ é *ilimitada.*  $med qed$

#pagebreak()

$bold(1.2")")$ Minimize $(x_1 - 1)^2 - x_1 x_2 + (x_2 - 1)^2, (x_1, x_2 in bb("R")^2)$.

Assim como na questão anterior, calcularemos as condições de otimalidade de primeira e segunda ordem. Nesse sentido, o gradiente da função é $(2x_1 - x_2 - 2, 2x_2 - 2 - x_1)$. Portanto, igualando cada componente a zero encontramos seus pontos críticos:

$
cases(
2x_1 - x_2 - 2 = 0 \
2x_2 - 2 - x_1 = 0.
)
$

Obtemos o ponto crítico $(2,2)$. Observando a matriz Hessiana e calculando seus menores principais, descobrimos que todos os seus menores principais são positivos.

// $ H = mat(
//   (partial f^2)/(partial x_1^2), (partial f^2)/(partial x_1 partial x_2);
//   (partial f^2)/(partial x_2 partial x_1), (partial f^2)/(partial x_2^2);
// ) = mat(
//   2, -1;
//   -1, 2;
// )
// $
$
abs(H_1) = abs(mat((partial f^2)/(partial x_1^2))) = abs(mat(2)) = 2 \
abs(H_2) = abs(mat(
  (partial f^2)/(partial x_1^2), (partial f^2)/(partial x_1 partial x_2);
  (partial f^2)/(partial x_2 partial x_1), (partial f^2)/(partial x_2^2);
)) = abs(mat(
  2, -1;
  -1, 2;
)) = 3
$

Logo, pelo teste de Sylvester, $f(2,2)$ = -2 é mínimo local. Além disso, por ser o único ponto crítico da função, também é mínimo global. $med qed$

#pagebreak()

// = Resolução do Amigo:

// Resolução dos Problemas de Otimização Não Linear Irrestrita

// Problema 1.1: minimize x₁x₂, (x₁,x₂) ∈ ℝ²

// Função Objetivo
// f(x₁, x₂) = x₁x₂

// Condições de Primeira Ordem (CPO)

// **Gradiente:**
// ```
// ∇f(x₁, x₂) = [∂f/∂x₁, ∂f/∂x₂] = [x₂, x₁]
// ```

// **Condição necessária de primeira ordem:**
// ∇f(x₁, x₂) = 0
// ```
// x₂ = 0
// x₁ = 0
// ```

// **Ponto crítico:** (0, 0)

// Condições de Segunda Ordem (CSO)

// **Matriz Hessiana:**
// ```
// ∇²f(x₁, x₂) = [∂²f/∂x₁²   ∂²f/∂x₁∂x₂]  = [0  1]
//                [∂²f/∂x₂∂x₁  ∂²f/∂x₂² ]    [1  0]
// ```

// **Análise no ponto crítico (0, 0):**
// ```
// H(0, 0) = [0  1]
//           [1  0]
// ```

// **Autovalores da Hessiana:**
// det(H - λI) = det([−λ  1 ]) = λ² - 1 = 0
//                  [ 1 −λ]

// λ₁ = 1 (positivo)
// λ₂ = -1 (negativo)

// **Interpretação:**
// - A Hessiana possui autovalores de sinais opostos
// - A matriz é **indefinida**
// - O ponto (0, 0) é um **ponto de sela**

// Análise Global

// Como f(x₁, x₂) = x₁x₂:
// - Para x₁ > 0 e x₂ > 0: f > 0
// - Para x₁ < 0 e x₂ < 0: f > 0  
// - Para x₁ > 0 e x₂ < 0: f < 0
// - Para x₁ < 0 e x₂ > 0: f < 0

= Questão 2

*Enunciado*: Faça uma síntese sobre um dos tópicos de otimização não linear irrestrita,
exemplifique:

- #underline[Método de Newton (Escolhemos esse).]
- Métodos de Máxima Descida

== Método de Newton Clássico

Em análise numérica, o método de Newton-Raphson é um dos métodos mais eficientes para obtenção das raízes de uma função $f(x) = 0$. Começamos escolhendo a entrada inicial $x_0$ da função e calculamos a reta tangente ao ponto atual juntamente de sua interseção com o eixo das abcissas. Assim, repetimos esse processo até obter a interseção que corresponde à raiz da função.

O método de Newton é descrito pela seguinte sequência recursiva:

$
x_(n+1) = x_n - f(x_n)/(f'(x_n)), n in bb("N")
$

onde $x_n$ é a $n"-ésima"$ iteração do algoritmo e $f'(x_n)$ é a derivada em $x_n$. Começamos a partir de uma estimativa $x_0$ e então iteramos até que o erro $epsilon_n = x_(n+1) - x_n$ seja menor que alguma tolerância aceitável que definimos.

== Método de Newton em Otimização Não Linear Irrestrita

No contexto de otimização não linear irrestrita, o método de Newton é uma técnica iterativa que utiliza informações da função e de suas derivadas para encontrar os pontos críticos onde o gradiente da função é zero, podendo este ser um ponto de mínimo, máximo ou ponto de sela. Este método corresponde a uma extensão do método de Newton clássico para encontrar as raízes.

// AQUIIIII

Para uma função $f:bb(R)^n -> bb(R)$, a ideia central do método é utilizar uma aproximação quadrática da função para iterativamente obter um ponto crítico. A estimativa da solução a cada iteração é calculada da seguinte forma:

$
x_(k+1) = x_k - H_f (x_k)^(-1) gradient f(x_k)
$

Onde:

- $x_k$ é o ponto atual na iteração $k$.

- $gradient f (x_k)$ é o gradiente de $f$ avaliado em $x_k$.

- $H_f (x_k)$ é a matriz Hessiana de $f$ avaliada em $x_k$, ou seja, a matriz de segunda derivada de $f$.

=== Passo-a-Passo

1. *Gradiente*: Calcular o gradiente $gradient f(x)$, que é um vetor de primeiras derivadas parciais da função $f$ em relação a cada nível.

2. *Hessiana*: Calcular a matriz Hessiana $H_f (x)$, que é uma matriz de segundas derivadas parciais da função $f$ definida na questão anterior.

3. *Resolução do Sistema Linear*: Resolver o sistema linear $H_f (x) d = - gradient f (x_k)$ para encontrar a direção $d$. Onde $H_f (x_k)^(-1) gradient f(x_k)$ é a direção do passo de Newton.

4. *Atualização da Solução*: Atualizar a solução $x_k$ usando $x_(k+1) = x_k + d$.

5. *Repetição*: Repetir os passos anteriores até que a norma do gradiente $norm(gradient f(x_k))$ seja suficientemente pequena, indicando que $x_k$ está próximo de um ponto crítico.

#pagebreak()

=== Prova

A demonstração do Método de Newton no contexto de otimização não linear irrestrita envolve a seguinte demonstração:

#align(center)[
  #block(
    width: auto,
    height: auto,
    stroke: .7pt + black,
    inset: 15pt,
    [
*Convergência Local Quadrática*: Se a aproximação inicial $x_0$ estiver suficientemente próxima ao ponto crítico $x^*$ onde o gradiente $gradient f(x^*) = 0$ e a Hessiana $H_f (x^*)$ é positiva definida, então a sequência gerada pelo Método de Newton convergirá para $x^*$ com taxa quadrática.

    ]
  )
]

Além disso, são necessárias algumas #underline[condições a mais] para a convergência, tal como:

- *Matriz Hessiana Positiva Definida*: A matriz Hessiana $H_f (x^*)$ no ponto ótimo deve ser positiva definida. Isso nos garante que $x^*$ seja um mínimo local e que o método converge.

- *Proximidade Inicial*: A aproximação $x_0$ deve ser próxima o bastante do ponto crítico $x^*$.

- *Classe $C^2$*: A função deve ser duas vezes continuamente diferenciável. Isso permite a utilização de expansão de Taylor para aproximar a função.

Primeiramente, considere as seguintes suposições:

- $x^*$ é um ponto crítico tal que $H_f (x^*)$ é positiva definida.
- A função $f$ pertence à classe $C^2$, ou seja, possui derivadas contínuas até a segunda ordem.

Como havíamos mencionado, a função $f$ pode ser aproximada ao redor de $x_k$ usando a expansão de Taylor de segunda ordem:

$
f(x) approx f(x_k) + gradient f(x_k)^T (x-x_k) + 1/2 (x-x_k)^T H_f (x_k)(x - x_k)
$

No ponto $x_k$, o gradiente é dado por $gradient f(x_k)$. Assim, a atualização corresponde a;

$
x_(k+1) = x_k - H_f (x_k)^(-1) gradient f (x_k).
$

Usando a expansão de Taylor para o gradiente $gradient f(x)$ em torno de $x_k$:

$
gradient f (x_(k+1)) approx gradient f(x_k) + H_f (x_k) (-H_f (x_k)^(-1) gradient f(x_k)) = 0
$

Com base nisso, concluímos que o gradiente em $x_(k+1)$ é zero, indicando que $x_(k+1)$ é um ponto crítico. Para mostrar a convergência quadrática, vamos considerar a diferença $e_(k+1) = x_(k+1) - x^*$. Usando a definição de $x_(k+1)$ e considerando que $gradient f(x^*) = 0$ : 

$
e_(k+1) = x_(k+1) - x^* = x_k - H_f (x_k)^(-1) gradient f(x_k) - x^*
$

Como $x_k$ está próximo de $x^*$, podemos usar a expansão de Taylor para $gradient f(x_k):$

$
gradient f(x_k) = H_f (x^*) (x_k - x^*) + cal(O)(norm(x_k - x^*)^2)
$

Simplificando e usando $e_k = x_k - x^*:$

$
e_(k+1) = (I - H_f (x_k)^(-1) H_f(x^*)) e_k - H_f (x_k)^(-1) cal(O)(norm(e_k)^2)
$

Se $x_k$ está suficientemente próximo de $x^*$, podemos aproximar $H_f (x_k) approx H_f (x^*)$, então:

$
e_(k+1) &approx -H_f (x^*)^(-1) cal(O)(norm(e_k)^2) \
norm(e_(k+1)) &approx C norm(e_k)^2
$

Onde $C$ é uma constante, demonstrando que o erro decresce quadraticamente.

// ==== Fundamentação Teórica

// O Método de Newton utiliza informação de segunda ordem (matriz Hessiana) para aproximar a função objetivo por uma expansão de Taylor de segunda ordem. A cada iteração, resolve-se um sistema linear para determinar a direção de busca.

// **Fórmula de Atualização:**
// ```
// x_{k+1} = x_k - [∇²f(x_k)]^{-1} ∇f(x_k)
// ```

// Onde:
// - ∇f(x_k) é o gradiente da função no ponto x_k
// - ∇²f(x_k) é a matriz Hessiana no ponto x_k

// ==== Características Principais

// **Vantagens:**
// - Convergência quadrática quando próximo da solução
// - Não requer busca linear (passo unitário)
// - Teoricamente elegante e bem fundamentado

// **Desvantagens:**
// - Requer cálculo e inversão da Hessiana (custoso computacionalmente)
// - Pode divergir se o ponto inicial estiver longe da solução
// - A Hessiana deve ser definida positiva para garantir direção de descida

// Exemplo Prático

// Considere a função f(x₁, x₂) = x₁² + 4x₂² - 4x₁ - 8x₂ + 10

// **Passo 1: Calcular o gradiente**
// ```
// ∇f(x) = [2x₁ - 4, 8x₂ - 8]ᵀ
// ```

// **Passo 2: Calcular a Hessiana**
// ```
// ∇²f(x) = [2  0]
//          [0  8]
// ```

// **Passo 3: Aplicar a fórmula de Newton**
// Partindo de x₀ = [0, 0]ᵀ:

// ```
// x₁ = x₀ - [∇²f(x₀)]⁻¹ ∇f(x₀)
// x₁ = [0, 0]ᵀ - [1/2  0  ] [-4]  = [0] - [-2] = [2]
//                 [0   1/8] [-8]    [0]   [-1]   [1]
// ```

// // A solução ótima é encontrada em uma única iteração: x* = [2, 1]ᵀ

//  Método de Máxima Descida (Steepest Descent)

//  Fundamentação Teórica

// O Método de Máxima Descida utiliza apenas informação de primeira ordem (gradiente) e move-se na direção oposta ao gradiente, que é a direção de maior taxa de decrescimento da função.

// **Fórmula de Atualização:**
// ```
// x_{k+1} = x_k - α_k ∇f(x_k)
// ```

// Onde α_k é o tamanho do passo determinado por busca linear.

//  Características Principais

// **Vantagens:**
// - Simples de implementar
// - Requer apenas o cálculo do gradiente
// - Sempre converge para funções convexas
// - Robustez global (menos sensível ao ponto inicial)

// **Desvantagens:**
// - Convergência linear (mais lenta)
// - Pode ter comportamento "zigue-zague" em vales estreitos
// - Requer busca linear para determinar o passo ótimo

// ==== Exemplo Prático

// Usando a mesma função f(x₁, x₂) = x₁² + 4x₂² - 4x₁ - 8x₂ + 10

// **Iteração 1:**
// - x₀ = [0, 0]ᵀ
// - ∇f(x₀) = [-4, -8]ᵀ
// - Direção: d₀ = -∇f(x₀) = [4, 8]ᵀ

// **Busca Linear:**
// Para encontrar α₀ ótimo, minimizamos f(x₀ + α₀d₀):
// ```
// φ(α) = f([0, 0] + α[4, 8]) = f([4α, 8α])
// φ(α) = (4α)² + 4(8α)² - 4(4α) - 8(8α) + 10
// φ(α) = 16α² + 256α² - 16α - 64α + 10
// φ(α) = 272α² - 80α + 10
// ```

// Derivando e igualando a zero: φ'(α) = 544α - 80 = 0
// Logo: α₀ = 80/544 ≈ 0.147

// **Atualização:**
// ```
// x₁ = x₀ + α₀d₀ = [0, 0] + 0.147[4, 8] = [0.588, 1.176]
// ```

// Comparação dos Métodos

// | Aspecto | Método de Newton | Máxima Descida |
// |---------|------------------|----------------|
// | **Convergência** | Quadrática (local) | Linear |
// | **Custo por iteração** | Alto (Hessiana) | Baixo (apenas gradiente) |
// | **Robustez** | Menor | Maior |
// | **Número de iterações** | Poucas (perto da solução) | Muitas |
// | **Busca linear** | Não necessária | Necessária |

// Implementação Computacional

//  Critérios de Parada
// Para ambos os métodos, utilizam-se tipicamente:
// // - ||∇f(x_k)|| < ε₁ (gradiente pequeno)
// // - ||x_{k+1} - x_k|| < ε₂ (mudança pequena)
// // - |f(x_{k+1}) - f(x_k)| < ε₃ (variação funcional pequena)

//  Considerações Práticas

// **Para o Método de Newton:**
// - Verificar se a Hessiana é definida positiva
// - Implementar regularização quando necessário
// - Considerar métodos Quasi-Newton (BFGS, L-BFGS) para problemas grandes

// **Para Máxima Descida:**
// - Implementar busca linear eficiente (Armijo, Wolfe)
// - Monitorar o comportamento de zigue-zague
// - Considerar métodos de gradiente conjugado para melhor performance

// Conclusão

// O Método de Newton oferece convergência rápida mas com alto custo computacional e menor robustez, sendo ideal para problemas de pequeno a médio porte com boa estimativa inicial. O Método de Máxima Descida, embora mais lento, é robusto e adequado para uma primeira aproximação ou problemas mal-condicionados.

// A escolha entre os métodos depende das características específicas do problema, recursos computacionais disponíveis e precisão requerida. Na prática, métodos híbridos que combinam as vantagens de ambas as abordagens são frequentemente utilizados.

// === Restrições

// === Observações Adicionais

// == Conclusão


#bibliography(
  title: [Bibliografia],
  "referencias.bib",
  full: true,
  style: "american-chemical-society",
)

// original

// #figure(
//   diagram(
//   	spacing: 8pt,
//   	cell-size: (8mm, 10mm),
//   	edge-stroke: 1pt,
//   	edge-corner-radius: 5pt,
//   	mark-scale: 70%,
  
//   	blob((0,1), [], tint: yellow, shape: hexagon),
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