# Fundamentação teórica

# Falhas e Tolerância

Uma *falha* pode ser compreendida como um evento fora do controle do sistema que provoca uma degradação
na sua qualidade de serviço, seja ao afetar a validade dos resultados ou com uma degradação na forma 
de aumento de latência. Falhas podem ser classificadas em 3 grupos referentes ao seu padrão de ocorrência:

- Falhas **Transientes**: Ocorrem aleatóriamente e possuem um impacto temporário.

- Falhas **Intermitentes**: Assim como as transientes possuem impacto temporário, porém re-ocorrem periodicamente.

- Falhas **Permanentes**: Causam uma degradação permanente no sistema da qual não pode ser recuperada, potencialmente necessitando de intervenção externa.

Existem diversas fontes de falhas que podem afetar um sistema, exemplos incluem: Radição ionizante, 
Interferência Eletromagnética, Impacto Físico, Oscilação elétrica (picos de tensão e/ou corrente).

Para que o sistema possa ser *Tolerante à Falhas*, isto é, ser capaz de manter uma qualidade de serviço
aceitável mesmo na presença de falhas são necessários 2 principais mecanismos:

1. **Detecção de Falhas**: Capacidade de perceber a ocorrência de uma falha e executar a rotina de 
  tratamento. Métodos comuns de detecção incluem: Bits de paridade, Funções hash, Sinais heartbeat e 
  Limites de tempo (*timeouts* ou *deadlines*).
 
2. **Tratamento de Falhas**: Capacidade de reagir as falhas, com uma correção, re-execução ou rotina de
  mitigação. Falhas permanentes podem necessitar de um desligamento gracioso do sistema ou reorganização
  para manter o máximo de qualidade de serviço possível.

Tanto a detecção quando ao tratamento podem ser implementados em hardware quanto em software,
<<ELABORAR MAIS AQUI>>


## Grafos tolerantes à falha
(Mencionar isso apos o escalonador?)

# Sistemas embarcados

Sistemas embarcados são uma família vasta de sistemas computacionais, algumas das principais 
características de sistemas embarcados são:

**Especificidade**:
Diferente de um sistema de computação mais generalizado como um computador 
pessoal ou um servidor, sistemas embarcados são especializados para uma solução de escopo restrito. 
Um exemplo de um sistema embarcado são microcontroladores encontrados em dispositivos como mouses, 
teclados e eletrodomésticos.

**Limitação de recursos**:
Um corolário da natureza especialista destes sistemas, é que recursos alocados para o sistema são 
definidos previamente. No caso de microcontroladores tanto o poder computacional quanto a 
disponibilidade de memória são restritas. Importante notar que existem sistemas embarcados com 
acesso maior à recursos, como equipamentos de rede e hardware aceleradores que podem ter acesso a 
grandes quantias de poder computacional ou memória, mas os recursos do sistema continuam 
estaticamente delimitados para cumprir sua função específica.

**Critério Temporal**


# Sistemas Operacionais de Tempo-Real (RTOS)

## Escalonador


# Trabalhos Relacionados

