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

## Mecanismos de Detecção

### Bits de paridade, *Hamming codes* e *Arithmetic encoding*
falar de bits de paridade e Hamming codes

### Hashes
falar de validação com hash não criptográfica

### *Heartbeat signals*

É possível determinar se uma falha ocorreu com um nó de execução através de um critério temporal, os
sinais de *heartbeat* ("batimento cardíaco") são sinais períodicos para garantir se um nó
computacional está ativo. Basta enviar um sinal simples e verificar se uma resposta correta chega em
um tempo pré determinado. Sinais heartbeat são extremamente baratos porém não garantem um detecção
ou correção de erro mais granular, portanto são usados como um complemento para detectar falhas de
forma concorrente aos métodos mais robustos.

O custo de memória de um sinal heartbeat tende a ser pequeno, porém possui o custo temporal de 
tolerância limite no pior caso e o custo da viagem ida e volta no melhor caso. Este método é 
aplicado em datacenters, também chamado de "health signal" ou "health check", o sinal e sua resposta
 desejada podem conter outros metadados para análise de falhas, caso desejado.

Também é possível usar os próprios prazos de execução como um mecanismo de detecção, porém isso pode
não ser viável em sistema com prazos curtos, especialmente quando se opera em um contexto hard real time.

## Mecanismos de Tratamento

### Correção de Erro
novamente, bits de paridade, hamming code, arithmetic encoding

### Re-execução e Redundância
falar da diferença e como combinar os 2

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
uma tarefa de um sistema pode ser classificada em duas categorias: Soft real time, e Hard real time,
a distinção entre estas categorias é explicada na seção **Sistemas Operacionais de Tempo-Real**.

# Sistemas Operacionais de Tempo-Real

Um sistema operacional é um conjunto conjunto de software que permitem o gerenciamento e interação
com os recursos da máquina através de uma camada de abstração, no contexto deste trabalho, o foco
central é o *kernel*, o componente do sistema operacional que sempre está executando, o trabalho
principal do kernel é permitir a coexistência de diferentes tarefas no sistema que precisam acessar
as capacidades do hardware, especialmente tempo na CPU e memória, o kernel pode ser descrito de
maneira simplificada como a "cola" entre a aplicação(software) e os recursos físicos(hardware).

Um sistema  *sistema operacional de tempo real* (RTOS) é um tipo de SO mais especializado,
tipicamente pequeno, que possui como característica central cumprir o requisito temporal, que
divide-se em 2 categorias:

- *Soft Real Time*: Um sistema que garante essa propriedade precisa sempre garantir que tarefas de
  maior importância tenham prioridade sobre as de menor importância. Sistemas soft real-time
  tipicamente operam na escala de milisegundos, isto é percepção humana. O atraso de uma tarefa em um
  sistema soft real-time não é desejável, mas não constitui um erro. **Exemplos**: Player de DVD,
  videogames, kiosks de atendimento.

- *Hard Real Time*: Precisam garantir as propriedades de soft real time, além disso, o atraso de uma
  tarefa de seu prazo (*deadline*), é inaceitável, para um sistema hard real time uma resposta com
  atraso é o mesmo que resposta nenhuma. Cuidado adicional deve ser utilizado ao projetar sistemas
  hard real time, pois muitas vezes aparacem em contextos críticos. **Exemplos**: Software para
  sistema de frenagem, Sistemas de navegação em aplicações aeroespaciais

Como sistemas Hard Real Time cumprem os requisitos de sistemas Soft Real Time, os sistemas
operacionais de tempo real tem seu design orientado a serem capazes de cumprir o critério Hard Real
Time.

Em contraste com sistemas operacionais focados em uso geral que são encontrados em servidores e
computadores pessoais (como Windows, Linux e OSX), o objetivo do pimário de um RTOS não é dar ao
usuário a sensação de fluidez dinamicamente escalonando os recursos da máquina, sistemas em tempo
real buscam ser simples, confiáveis e determinísticos. É essencial que um RTOS execute as tarefas do
sistema com um respeito estrito aos prazos de execução fornecidos e que faça de maneira resiliente à
flutuações de tempo causadas por IO e outras interrupções.

Drivers em RTOSes são adicionados previamente de maneira *ad-hoc*, não há necessidade de
carregamento dinâmico de drivers ou de bibliotecas pois na maioria das aplicações que necessitam de
um RTOS, o hardware ja é conhecido e definido de antemão.

Devido à suas características de simplicidade, baixo custo e previsibilidade, os sistemas
operacionais de tempo real são extensivamente usados em aplicações de sistemas embarcados e internet
das coisas. Exemplos incluem: FreeRTOS, VxWorks, Zephyr e LynxOS.

## Escalonador

## Escalonamento tolerante à falhas
falar dos grafo lá, e das coisas tipo transparencia e os tipos de overhead

# Trabalhos Relacionados

