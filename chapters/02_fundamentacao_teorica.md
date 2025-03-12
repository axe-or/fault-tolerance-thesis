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

A detecção e o tratamento podem ser implementados em hardware ou em software, implementações em 
hardware conseguem fazer garantias físicas mais fortes com melhor revestimento e redunância 
implementada diretamente no circuito, e prover transparência de execução para o programador, a 
desvantagem é custo elevado de espaço no silício possível degradação de performance geral e menor 
flexibilidade. O processo de tornar o design e a implementação de um hardware com estas 
características é chamado de *hardening*.

Implementações em software não são capazes de fornecer todas as garantias fortes do hardware, em 
contrapartida, não ocupam espaço extra no chip e são mais flexíveis, com software é possível 
implementar lógica de detecção recuperação e estruturas de dados mais complexas, e até mesmo 
realizar atualizações remotas com o sistema ativo (*live patching*).

Para que um sistema possa ser resiliente à falhas, ambas soluções de hardware e software precisam 
ser consideradas, é possível utilizar hardware com *hardening* para um núcleo que realiza atividades 
críticas, e delegar núcleos menos protegidos para atividades em que o tratamento em software é 
suficiente. Balancear a troca de espaço em chip, uso de memória, flexibilidade de implementação, 
tempo de execução, vazão de dados e garantias de transparência é indispensável para a criação de um
sistema que seja resiliente à falhas e que forneça uma boa qualidade de serviço pelo menor custo
possível.

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

**Critério Temporal**:
Sistemas embarcados, por serem parte de um todo maior, devem realizar sua função com o mínimo de 
interrupção para a funcionalidade geral do contexto externo. A importância do tempo de execução de 
uma tarefa de um sistema pode ser classificada em duas categorias:

- *Soft Real Time*:

- *Hard Real Time*:

Importante notar que a distinção de Soft Real Time e Hard Real Time não é exclusiva de sistemas 
embarcados, apesar de ser frequentemente tratada neste contexto.

# Sistemas Operacionais de Tempo-Real (RTOS)

## Escalonador


# Trabalhos Relacionados

