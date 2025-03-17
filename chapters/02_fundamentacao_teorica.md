# Fundamentação teórica

# Falhas e Tolerância

Uma *falha* pode ser compreendida como um evento fora do controle do sistema que provoca uma degradação
na sua qualidade de serviço, seja ao afetar a validade dos resultados ou com uma degradação na forma
de aumento de latência. Falhas podem ser classificadas em 3 grupos referentes ao seu padrão de ocorrência:

- Falhas **Transientes**: Ocorrem aleatoriamente e possuem um impacto temporário.

- Falhas **Intermitentes**: Assim como as transientes possuem impacto temporário, porém re-ocorrem periodicamente.

- Falhas **Permanentes**: Causam uma degradação permanente no sistema da qual não pode ser recuperada, potencialmente necessitando de intervenção externa.

Existem diversas fontes de falhas que podem afetar um sistema, exemplos incluem: Radiação ionizante,
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
hardware conseguem fazer garantias físicas mais fortes com melhor revestimento e redundância
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

Os mecanismos de *detecção*, permitem que um sistema detecte uma inconsistência em seus dados, causada por falha externa ou por erro lógico de outra parte no caso de sistemas distribuídos. Os mecanismos de detecção são essenciais para a tolerância à falhas. Ao detectar uma falha o sistema deve tomar uma ação corretiva para o tratamento da falha, mecanismos de tratamento serão abordados posteriormente.

### CRC (Cyclic Redundancy Check)

Os CRCs são códigos de detecção de erro comumente utilizados em redes de computador e armazenamento não volátil para detectar falhas. Para cada segmento de dado é concatenado um valor (denominado *check value* ou simplesmente o valor CRC) que é calculado com base no resto da divisão de um polinômio previamente acordado entre remetente e destinatário (chamado de "polinômio gerador").

Ao receber o segmento, o receptor calcula seu próprio valor CRC com base nos dados do segmento (sem incluir o CRC do destinatário), caso ocorra diferença entre os CRCs isso indica a ocorrência de um erro. CRCs são comumente utilizados devido à serem simples de implementar, ocuparem pouco espaço adicional no segmento e serem resilientes à "*burst errors*", falhas transientes que alteram uma região de bits próximos.

### Códigos Reed-Solomon
Faço isso?

### *Heartbeat signals*

É possível determinar se uma falha ocorreu com um nó de execução através de um critério temporal, os sinais de *heartbeat* ("batimento cardíaco") são sinais periódicos para garantir se um nó computacional está ativo. Basta enviar um sinal simples e verificar se uma resposta correta chega em um tempo pré determinado. Sinais heartbeat são extremamente baratos porém não garantem um detecção ou correção de erro mais granular, portanto são usados como um complemento para detectar falhas de forma concorrente aos métodos mais robustos.

O custo de memória de um sinal heartbeat tende a ser pequeno, porém possui o custo temporal de tolerância limite no pior caso e o custo da viagem ida e volta no melhor caso. Este método é aplicado em datacenters, também chamado de "health signal" ou "health check", o sinal e sua resposta desejada podem conter outros metadados para análise de falhas, caso desejado.

Também é possível usar os próprios prazos de execução como um mecanismo de detecção, porém isso pode não ser viável em sistema com prazos curtos, especialmente quando se opera em um contexto hard real time.

## Mecanismos de Tratamento

Uma vez que uma falha tenha sido detectada o sistema precisa *tratar* a falha o mais rápido possível para manter a qualidade de serviço, alguns mecanismos de detecção também fornecem a possibilidade de correção dos dados, como é o caso dos códigos Reed-Solomon, nestes casos, fica à critério da aplicação se a correção deve ser tentada ou outro tratamento deve ser usado.

### Redundância

Adicionar redundância ao sistema é uma das formas mais intuitivas e mais antigas de aumentar a tolerância à falhas, a probabilidade de N falhas transientes ocorrendo simultaneamente em um sistema é mais baixa do que a probabilidade de apenas 1 falha.

Uma técnica de redundância comum é o uso de TMR (Triple Modular Redundancy) <<FALAR MAIS>>

Sistemas distribuídos também podem aproveitar de sua redundância natural por serem sistemas com múltiplos nós computacionais, falhas transientes em um nó podem ser propagadas e no caso de falhas permanentes em um nó, os outros podem suplantar a execução de suas tarefas mantendo a qualidade média de serviço, o uso de sistemas capazes de auto reparo é vital para a existência de telecomunicação em larga escala e computação em nuvem.

### Correção de Erro
bits de paridade, hamming code, arithmetic encoding ?

### Re-execução
falar da diferença e como combinar os 2

# Sistemas embarcados

Sistemas embarcados são uma família vasta de sistemas computacionais, algumas das principais
características de sistemas embarcados são:

**Especificidade**:
Diferente de um sistema de computação mais generalizado como um computador pessoal ou um servidor, sistemas embarcados são especializados para uma solução de escopo restrito. Um exemplo de um sistema embarcado são microcontroladores encontrados em dispositivos como mouses, teclados e eletrodomésticos.

**Limitação de recursos**:
Um corolário da natureza especialista destes sistemas, é que recursos alocados para o sistema são definidos previamente. No caso de microcontroladores tanto o poder computacional quanto a disponibilidade de memória são restritas. Importante notar que existem sistemas embarcados com acesso maior à recursos, como equipamentos de rede e hardware aceleradores que podem ter acesso a  quantias maiores de poder computacional ou memória, mas os recursos do sistema continuam estaticamente delimitados para cumprir sua função específica.

**Critério Temporal**:
Sistemas embarcados, por serem parte de um todo maior, devem realizar sua função com o mínimo de interrupção para a funcionalidade geral do contexto externo. A importância do tempo de execução de uma tarefa de um sistema pode ser classificada em duas categorias: Soft real time, e Hard real time, a distinção entre estas categorias é explicada na seção **Sistemas Operacionais de Tempo-Real**.

# Sistemas Operacionais de Tempo-Real

Um sistema operacional é um conjunto conjunto de software que permitem o gerenciamento e interação com os recursos da máquina através de uma camada de abstração, no contexto deste trabalho, o foco central é o *kernel*, o componente do sistema operacional que sempre está executando, o trabalho principal do kernel é permitir a coexistência de diferentes tarefas no sistema que precisam acessar as capacidades do hardware, especialmente tempo na CPU e memória, o kernel pode ser descrito de maneira simplificada como a "cola" entre a aplicação(software) e os recursos físicos(hardware).

Um sistema  *sistema operacional de tempo real* (RTOS) é um tipo de SO mais especializado, tipicamente pequeno, que possui como característica central cumprir o requisito temporal, que divide-se em 2 categorias:

- *Soft Real Time*: Um sistema que garante essa propriedade precisa sempre garantir que tarefas de  maior importância tenham prioridade sobre as de menor importância. Sistemas soft real-time tipicamente operam na escala de milissegundos, isto é, percepção humana. O atraso de uma tarefa em um sistema soft real-time não é desejável, mas não constitui um erro. **Exemplos**: Player de DVD, videogames, kiosks de atendimento.

- *Hard Real Time*: Precisam garantir as propriedades de soft real time, além disso, o atraso de uma tarefa de seu prazo (*deadline*), é inaceitável, para um sistema hard real time uma resposta com atraso é o mesmo que resposta nenhuma. Cuidado adicional deve ser utilizado ao projetar sistemas hard real time, pois muitas vezes aparacem em contextos críticos. **Exemplos**: Software para sistema de frenagem, Sistemas de navegação em aplicações aeroespaciais

Como sistemas Hard Real Time cumprem os requisitos de sistemas Soft Real Time, os sistemas operacionais de tempo real tem seu design orientado a serem capazes de cumprir o critério Hard Real Time.

Em contraste com sistemas operacionais focados em uso geral que são encontrados em servidores e computadores pessoais (como Windows, Linux e OSX), o objetivo do primário de um RTOS não é dar ao usuário a sensação de fluidez dinamicamente escalonando os recursos da máquina, sistemas em tempo real buscam ser simples, confiáveis e determinísticos. É essencial que um RTOS execute as tarefas do sistema com um respeito estrito aos prazos de execução fornecidos e que faça de maneira resiliente à flutuações de tempo causadas por IO e outras interrupções.

Drivers em RTOSes são adicionados previamente de maneira *ad-hoc*, não há necessidade de carregamento dinâmico de drivers ou de bibliotecas pois na maioria das aplicações que necessitam de um RTOS, o hardware ja é conhecido e definido de antemão.

Devido à suas características de simplicidade, baixo custo e previsibilidade, os sistemas operacionais de tempo real são extensivamente usados em aplicações de sistemas embarcados. Exemplos incluem: FreeRTOS, VxWorks, Zephyr e LynxOS.

## Escalonador

O escalonador (*scheduler*) é o componente do sistema operacional responsável por gerenciar múltiplas tarefas que desejam executar, sendo um componente extramente crucial, a implementação do escalonador deve garantir que tarefas de alta prioridade executem antes e que a troca entre tarefas (*context switching*) seja o mais rápido possível, o algoritmo de escalonamento é o fator central para o comportamento do escalonador, sendo categorizados em 2 grandes grupos:

- *Cooperativos*: Tarefas precisam voluntariamente devolver o controle da CPU, salvo interrupções do hardware para que as outras tarefas possam executar, isso pode ser feito explicitamente por uma função de "largar" (*yield*) ou implicitamente ao utilizar uma rotina assíncrona do sistema, como ler arquivo, receber pacotes de rede ou aguardar uma variável de condição.

- *Preemptivos*: Além de poderem transferir a CPU manualmente, o escalonador forçará trocas de contexto caso a tarefa exceda um limite de tempo definido para sua execução, o processo de interromper e trocar de tarefa forçadamente chama-se *preempção*, e a quantia de tempo alocada é tipicamente denominada como *time slice* ("Fatia de tempo"). Tarefas ainda podem possuir relações de prioridade, e *time slices* podem também serem alteradas.

Sistemas operacionais de tempo-real são comumente executados no modo totalmente preemptivo, mas o uso cooperativo também é viável e possui vantagem de possuir o controle mais previsível e não necessitar de tantas interrupções de timer, mas é importante que seja tomado o cuidado adequado para que nenhum prazo de execução hard real time seja violado por uma tarefa inadvertidamente utilizando a CPU por uma fatia longa de tempo.

## Escalonamento tolerante à falhas
falar dos grafo lá, e das coisas tipo transparência e os tipos de overhead

# Trabalhos Relacionados

