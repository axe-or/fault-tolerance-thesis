# Introdução

Tolerância à falhas (TF) é a capacidade de um sistema computacional continuar
oferecendo qualidade de serviço mesmo na presença de defeitos e interferências
inesperadas, falhas podem ser encontradas comumente nos contextos de sistemas
distribuídos, onde os canais de comunicação podem sofrer degradação ou total
inoperabilidade devido à interferência eletromagnética, falta de energia e
eventos climáticos. Sistemas embarcados encontram os mesmos problemas ao
utilizar um canal com ruído ou instável, mas também podem dados em memória ou
registradores diretamente afetados por causas externas como radiação ionizante,
flutuações súbitas de temperatura ou voltagem e colisões físicas. A existência
desses fenômenos necessitam que dispositivos estejam preparados, especialmente
em aplicações aero-espaciais(que necessitam ser confiáveis e tolerar seu
ambiente volátil).

Tornar um sistema tolerante à falhas é um problema multi facetado, ambas soluções em hardware e software necessitam ser abordadas para garantir a qualidade de serviço desejada, o *escalonador*, seja de um sistema operacional ou de um runtime, é crucial na execução concorrente de diversas tarefas, sendo então um candidato interessante para aprimorar sua resiliência com foco em reduzir desperdício dos nós computacionais. O processo de detecção das falhas e seu impacto no grafo de execução assim como nas métricas quantitativas de tempo de CPU e uso de memória portanto deve ser considerado, particularmente no contexto de escalonamento, pois a reação rápida e correta às falhas requer previamente a detecção e elaboração das rotinas de escalonamento de forma adequada.

Este trabalho visa portanto fazer uma análise do impacto de diferentes técnicas de detecção durante o escalonamento de tarefas e seu impacto na performance e no fluxo de execução do sistema, para que se possa melhor compreender e evidenciar os custos e benefícios ao tornar um sistema mais resiliente. 

# Problematização

## Formulação do Problema

O custo de utilizar técnicas de tolerância é sensível ao contexto da aplicação
e ao nível de tolerância desejado, para desenvolvedores de software o custo e
as limitações impostas para que o sistema seja mais resiliente não são
particularmente evidentes.

## Solução Proposta

Implementar e comparar técnicas de escalonamento com detecção de erros, com o
objetivo de esclarecer o impacto de performance em relação ao ganho de
resiliência do sistema, particularmente no contexto de sistemas de tempo real,
dado que algoritmos que consigam satisfazer a restrição de tempo real também
podem ser utilizados em outros contextos com restrições temporais mais
relaxadas.

## Objetivos

### Objetivo Geral

Explorar o uso de técnicas de escalonamento de tempo real com detecção de erros.

### Objetivos Específicos

- Selecionar métodos de detecção de erros
- Implementar prova de conceito dos métodos para pré avaliação
- Implementar e mensurar técnicas em aplicação real
- Avaliar o impacto das técnicas

### Justificativa

A presença de sistemas embarcados em contextos críticos como na exploração
espacial, automobilística e tecnologia médica, assim como a ubiquidade de
dispositivos móveis e de baixo consumo energético no mercado consumidor
(Celulares, Notebooks, equipamentos IoT) e a existência do mercado de cloud e
computação distribuída, entende-se que manter um alto grau da qualidade de
serviço com o mínimo de degradação de performance e aumento de custo (monetário
ou energético), pode prover uma vantagem econômica para fabricantes e
provedores assim como um benefício social na maior confiabilidade no caso de
aplicações críticas.

## Metodologia

O objetivo do trabalho é descritivo e exploratório, as métricas coletadas são de caráter quantitativo e conclusões e observações derivadas do trabalho serão realizadas de maneira indutiva baseadas nas métricas de performance coletadas e comparadas.

Uma implementação dos algoritmos na forma de uma prova de conceito será realizada dentro de um contexto com um host para facilitar prototipação e realizar uma pré análise do overhead.

## Estrutura do Trabalho

