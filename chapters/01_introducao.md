# Introdução

Tolerância à falhas (TF) é a capacidade de um sistema computacional continuar oferecendo qualidade de serviço mesmo na presença de erros e interferências inesperadas, falhas podem ser encontradas comumente nos contextos de sistemas distribuídos, onde os canais de comunicação podem sofrer degradação ou total inoperabilidade devido à interferência eletromagnética, falta de energia e eventos climáticos. Sistemas embarcados encontram os mesmos problemas ao utilizar um canal com ruído ou instável, mas também podem dados em memória ou registradores diretamente afetados por causas externas como radiação ionizante, flutuações súbitas de temperatura ou voltagem e colisões físicas. A existência desses fenômenos necessitam que dispositivos estejam preparados, especialmente em aplicações aero-espaciais(que necessitam ser confiáveis e tolerar seu ambiente volátil).

Tornar um sistema tolerante à falhas é um problema multi facetado, ambas soluções em hardware e software necessitam ser abordadas para garantir a qualidade de serviço desejada, no lado do software um componente particularmente é o escalonador do sistema operacional, responsável por permitir a execução de tarefas concorrentes na CPU. O escalonador pode ser aprimorado a fim de facilitar a implementação de um sistema com TF, técnicas incluem a criação de grafos resilientes à falhas que podem ser utilizados para construir tabelas de transição para que na presença de uma falha detectada, seja possível reexecutar ou resumir uma rotina de tratamento do erro, em sistemas com requisitos estritos de tempo é possível balancear um tempo de execução maior com garantia de transparência que permitam que para um observador externo, o sistema opere como se não tivesse ocorrido falhas dado um limite superior de até *k* falhas por bloco de tempo.

Com a presença de sistemas embarcados em contextos críticos como na exploração espacial e tecnologia médica, assim como a presença de capacidade de redes em dispositivos no mercado consumidor (Celulares, Notebooks, equipamentos IoT) e a existência do mercado de cloud e computação distribuída, entende-se que manter um alto grau da qualidade de serviço sem causar alta degradação de performance ou aumento de custo, pode prover uma vantagem econômica para fabricantes e provedores assim como um benefício social na maior confiabilidade no caso de aplicações críticas.

# Problematização

### Formulação do Problema

### Solução Proposta

## Objetivos

### Objetivo Geral

### Objetivos Específicos

### Justificativa

## Metodologia

## Estrutura do Trabalho

