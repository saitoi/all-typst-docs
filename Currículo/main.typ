#import "lib.typ": *
#import "@preview/thmbox:0.3.0": *

#show: thmbox-init()

#set text(lang: "pt")

#let name = "Pedro Saito"
#let location = "Rio de Janeiro, Brasil"
#let email = "phenriquesaito@gmail.com"
#let github = "github.com/saitoi"
#let linkedin = "linkedin.com/in/pedro-saito-419a08247"
#let phone = "+55 (21) 96444-2702"
#let personal-site = "stuxf.dev"

#show: resume.with(
  author: name,
  // All the lines below are optional.
  // For example, if you want to to hide your phone number:
  // feel free to comment those lines out and they will not show.
  location: location,
  email: email,
  github: github,
  linkedin: linkedin,
  phone: phone,
  // personal-site: personal-site,
  accent-color: "#26428b",
  font: "New Computer Modern",
)

/*
* Lines that start with == are formatted into section headings
* You can use the specific formatting functions if needed
* The following formatting functions are listed below
* #edu(dates: "", degree: "", gpa: "", institution: "", location: "")
* #work(company: "", dates: "", location: "", title: "")
* #project(dates: "", name: "", role: "", url: "")
* certificates(name: "", issuer: "", url: "", date: "")
* #extracurriculars(activity: "", dates: "")
* There are also the following generic functions that don't apply any formatting
* #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
* #generic-one-by-two(left: "", right: "")
*/

== Educação

#edu(
  institution: "Universidade Federal do Rio de Janeiro",
  location: "Rio de Janeiro, RJ",
  dates: dates-helper(start-date: "Aug 2022", end-date: "Dez 2027"),
  degree: "Bacharelado em Ciência da Computação",
)

- Coeficiente de Rendimento Acadêmico: 9.0
- Cursando o sétimo período, fui monitor de Álgebra Linear duas vezes.

#v(0.6em)

== Experiência

#work(
  title: "Estagiário em Back-end e Engenheiro de Dados",
  location: "Universidade Federal do Rio de Janeiro, RJ",
  company: "Laboratório de Métodos de Suporte à Tomada de Decisão",
  dates: dates-helper(start-date: "Abril 2024", end-date: "Presente"),
)

Atuação em parceria com a Procuradoria Geral do Município do Rio de Janeiro:

#remark(variant: "Projeto Dívida Ativa", color: black, title-fonts: "New Computer Modern", bar-thickness: 1.5pt)[
- Sistema para identificação e classificação de grandes devedores do município.
- Desenvolvimento do backend e do banco de dados analítico (SQL Server), criação de consultas SQL e integração da API com o frontend.
] <basic-box>

#remark(variant: "Projeto GAM", color: black, title-fonts: "New Computer Modern", bar-thickness: 1.5pt)[
- Chatbot para auxiliar na elaboração de peças processuais com base em jurisprudência, utilizando sistema de Recuperação Aumentada por Geração (RAG)
- Construção do banco de teses jurídicas, apoio no desenvolvimento da API e na pipeline distribuída de ocerização de documentos.
] <basic-box>


#work(
  title: "Bolsista PAELIG",
  location: "Universidade Federal do Rio de Janeiro, RJ",
  company: "Laboratório de Informática de Graduação do Instituto de Matemática",
  dates: dates-helper(start-date: "Dez 2023", end-date: "Presente"),
)

- Auxílio na preparação e manutenção de computadores e periféricos, projetores, estabilizadores, dentre outros equipamentos do laboratório.
- Configuração do serviço de VPN _Tailscale_ nos computadores do laboratório, garantindo acesso remoto seguro para os estudantes.
- Administração de sistemas Linux (Debian, Ubuntu e PopOS) e Windows.

// == Competências

// #project(
//   name: "Hyperschedule",
//   // Role is optional
//   role: "Maintainer",
//   // Dates is optional
//   dates: dates-helper(start-date: "Nov 2023", end-date: "Present"),
//   // URL is also optional
//   url: "hyperschedule.io",
// )
// - Maintain open-source scheduler used by 7000+ users at the Claremont Consortium with TypeScript, React and MongoDB
//   - Manage PR reviews, bug fixes, and coordinate with college for releasing scheduling data and over \$1500 of yearly funding
// - Ensure 99.99% uptime during peak loads of 1M daily requests during course registration through redundant servers

== Atividades Extracurriculares

#work(
  title: "Desenvolvedor de Website Educacional",
  location: "Universidade Federal do Rio de Janeiro, RJ",
  company: "Laboratório Estatística++",
  dates: dates-helper(start-date: "Abril 2023", end-date: "Presente"),
)

- Contribuo para o desenvolvimento de um website educacional sobre programação em C, R, Fortran e outras linguagens de programação de sistemas, incluindo conteúdo sobre compiladores.
- Uso Git e Github/ Gitlab para gerenciar as versões do site e do conteúdo abordado.

== Certificados

#certificates(
  name: "Curso Completo de Linguagem C e C++",
  issuer: "Udemy",
  url: "https://www.udemy.com/certificate/UC-62110d9a-dfee-42a2-9e58-44c5e57fb763/",
  url-shortname: "udemy.com/certificate/2",
  date: "Dezembro 2023",
)

#certificates(
  name: "Imersão Frontend",
  issuer: "Alura",
  url: "https://cursos.alura.com.br/immersion/certificate/b04146cf-3758-481d-b270-939c4ae2ad3c",
  url-shortname: "cursos.alura.com.br/immersion/certificate/2",
  date: "Fevereiro 2024",
)

#certificates(
  name: "Flask for Beginners: Build a CRUD Web App",
  issuer: "Udemy",
  url: "https://www.udemy.com/certificate/UC-a3f5ad82-a4a1-481f-8b6c-6e7251bdf419/",
  url-shortname: "udemy.com/certificate/1",
  date: "Março 2024",
)

== Habilidades Técnicas

- *Banco de Dados*: SQL Server, PostgreSQL, DuckDB, MySQL, SQLite.
- *Tecnologias*: Python, C, C++, Java, Bash, HTML5, CSS3, Javascript, Typst, Latex, UNIX, Git, NGINX.
- *Frameworks*: FastAPI, Flask, Django.