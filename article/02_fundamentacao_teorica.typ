#import "conf.typ": sourced_image

= FUNDAMENTAÇÃO TEÓRICA

== Definições Principais

=== Falhas e Erros

Um _defeito_ é uma alteração não esperada causada por um fenômeno externo ou
design incorreto. Um _erro_ é a diferença entre o resultado esperado e o
resultado obtido. Já uma _falha_ é uma redução da qualidade de serviço.
Defeitos podem causar erros que levam à falhas. Durante este trabalho, será
focado na detecção de ambos defeitos (estados inesperados) assim como falhas
(degradação de serviço), portanto os termos serão utilizados frequentemente de
forma intercambiável significando apenas um estado inesperado do sistema que
leva a degradação eventual, dado que a distinção particular entre falha e
defeito não é de grande importância para a comparação das técnicas
apresentadas.

=== Qualidade de Serviço

A qualidade de serviço de um sistema é o quão capaz ele é de prover sua
funcionalidade desejada. Como é uma noção geral, que depende muito das
interdependências particulares do sistema, será utilizada uma definição
simples. A qualidade do serviço $Q$ do sistema pode ser aproximada pela média
ponderada de seus serviços $S_0 ... S_n$ com os pesos de seus fatores de
contribuição para a qualidade total $q_0 ... q_n$ @SchedAndOptOfDistributedFT.

#figure(caption: [Aproximação da Qualidade de Serviço], kind: "equation", $
  Q = (sum_(i = 0)^n S_i q_i) / (sum_(i = 0)^n q_i)
$)

É importante mencionar que existem outras formas de modelagem da função
qualidade que levam em consideração o fluxo total de execução e a cadeia de
interdependência entre tarefas e mensagens, porém, para os propósitos deste
trabalho, a definição simples será uma aproximação suficiente.

=== Confiabilidade

Confiabilidade (usado aqui no mesmo sentido da palavra inglesa Reliability), é
a probabilidade de um sistema executar corretamente no período $[t_0, t]$. Para
modelar essa métrica é necessário um modelo estatístico que é particular da
aplicação, independente do modelo escolhido, a confiabilidade é dita como uma
função do tempo, da taxa de falhas $lambda$ e das probabilidades de falha externas. @FaultInjectionTechniques

#figure(caption: [Confiabilidade], kind: "equation", $
  R(t) = f(t, lambda, ...)
$)

=== Disponibilidade

A disponibilidade (do inglês Availability) $A$ é a razão entre o tempo em que o sistema não consegue
prover seu serviço (downtime) e o e seu tempo total de operação @FaultInjectionTechniques.

#figure(caption: [Disponibilidade], kind: "equation", $
  A = t_u / (t_u + t_d)
$)

Onde $t_d$ é o downtime e $t_u$ é o uptime do sistema.

=== Capacidade de manutenção

É a probabilidade de que um sistema em um estado quebrado consiga ser reparado
com sucesso, antes de um tempo $t$ @FaultInjectionTechniques, a modelagem
precisa deste atributo necessita de conhecimento particular sobre a aplicação e
sobre a disponibilidade de equipamentos (ou especialistas humanos) para a
realização do reparo. Asssim como a confiabilidade, é descrita por uma
distribuição de probabilidade particular da aplicação.

#figure(caption: [Capacidade de manuntenção], kind: "equation", $
  M(t) = f(t, lambda, ...)
$)

=== Segurança

Segurança é a probabilidade do sistema funcione ou não sem causar danos à
integridade humana ou à outros patrimônios, por ser um fator muito particular
da aplicação e seu contexto, uma estimativa analítica geral é extremamente
difícil.

=== Dependabilidade

Será utilizado o termo dependabilidade como uma propriedade que sumariza os
atributos (conhecidos em inglês como critério RAMS): confiabilidade,
disponibilidade, capacidade de manutenção e segurança.

A tolerância à falhas impacta os atributos confiabilidade e disponibilidade
positivamente, e pode em alguns casos melhorar a capacidade de manuntenção,
sendo assim, a Tolerância à falhas é um aspecto importante para sistemas com
boa dependabilidade.

== Tolerância à falhas

Falhas podem ser classificadas em 3 grupos principais quanto ao seu padrão de
ocorrência @FaultTolerantSystems.

- Falhas *Transientes*: Ocorrem aleatoriamente e possuem um impacto temporário.

- Falhas *Intermitentes*: Assim como as transientes possuem impacto temporário,
  porém re-ocorrem periodicamente.

- Falhas *Permanentes*: Causam uma degradação permanente no sistema da qual não
  pode ser recuperada, potencialmente necessitando de intervenção externa.

Existem diversas fontes de falhas que podem afetar um sistema, exemplos
incluem: Radiação ionizante, Interferência Eletromagnética, Harmônicas, Impacto
Físico, Oscilação elétrica (picos de tensão e/ou corrente).

Para que o sistema possa ser _Tolerante à Falhas_, isto é, ser capaz de manter
uma qualidade de serviço aceitável mesmo na presença de falhas são necessários
2 principais mecanismos:

1. *Detecção de Falhas*: Capacidade de perceber a ocorrência de uma falha e
  executar a rotina de tratamento. Métodos comuns de detecção incluem: Bits de
  paridade, Funções hash, Sinais heartbeat e Limites de tempo (timeouts ou
  deadlines).

2. *Tratamento de Falhas*: Capacidade de reagir as falhas, com uma correção,
  re-execução ou rotina de mitigação. Falhas permanentes podem necessitar de um
  desligamento gracioso do sistema ou reorganização para manter o máximo de
  qualidade de serviço possível.

A detecção e o tratamento podem ser implementados em hardware ou em software,
implementações em hardware conseguem fazer garantias físicas mais fortes com
melhor revestimento e redundância implementada diretamente no circuito, e
prover transparência de execução para o programador, a desvantagem é custo
elevado de espaço no silício possível degradação de performance geral e menor
flexibilidade. O processo de tornar o design e a implementação de um hardware
com estas características é chamado de "hardening".

Implementações em software não são capazes de fornecer todas as garantias
fortes do hardware, em contrapartida, não ocupam espaço extra no chip e são
mais flexíveis, com software é possível implementar lógica de detecção
recuperação e estruturas de dados mais complexas, e até mesmo realizar
atualizações remotas com o sistema ativo (live patching).

Para que um sistema possa ser resiliente à falhas, ambas soluções de hardware e
software precisam ser consideradas, é possível utilizar hardware com
hardening para um núcleo que realiza atividades críticas, e delegar núcleos
menos protegidos para atividades em que o tratamento em software é suficiente.
Balancear a troca de espaço em chip, uso de memória, flexibilidade de
implementação, tempo de execução, vazão de dados e garantias de transparência é
indispensável para a criação de um sistema que seja resiliente à falhas e que
forneça uma boa qualidade de serviço pelo menor custo possível. @DependabilityInEmbeddedSystems

== Mecanismos de Detecção

Os mecanismos de detecção, permitem que um sistema detecte uma inconsistência
em seus dados, causada por falha externa ou por erro lógico de outra parte no
caso de sistemas distribuídos. Os mecanismos de detecção são essenciais para a
tolerância à falhas. Ao detectar uma falha o sistema deve tomar uma ação
corretiva para o tratamento da falha, mecanismos de tratamento serão abordados
posteriormente.

=== CRC (Cyclic Redundancy Check)

Os CRCs são códigos de detecção de erro comumente utilizados em redes de
computador e armazenamento não volátil para detectar falhas. Para cada segmento
de dado é concatenado um valor (denominado "check value" ou simplesmente o
valor CRC) que é calculado com base no resto da divisão de um polinômio
previamente acordado entre remetente e destinatário (chamado de "polinômio
gerador") @FaultTolerantSystems.

Ao receber o segmento, o receptor calcula seu próprio valor CRC com base nos
dados do segmento (sem incluir o CRC do destinatário), caso ocorra diferença
entre os CRCs isso indica a ocorrência de um erro. CRCs são comumente
utilizados devido à serem simples de implementar, ocuparem pouco espaço
adicional no segmento e serem resilientes à "burst errors", falhas
transientes que alteram uma região de bits próximos.

=== Heartbeat signals

É possível determinar se uma falha ocorreu com um nó de execução através de um
critério temporal, os sinais de heartbeat ("batimento cardíaco") são sinais
periódicos para garantir se um nó computacional está ativo @DependabilityInEmbeddedSystems.

Basta enviar um sinal simples e verificar se uma resposta correta chega em um
tempo pré determinado. Sinais heartbeat são baratos porém não garantem uma
detecção ou correção de erro mais granular, portanto são usados como um
complemento para detectar falhas de forma concorrente a outros métodos mais
robustos.

#figure(caption: "Exemplo de um sinal heartbeat simples", image("assets/heartbeat_signal.png"))

O custo de memória de um sinal heartbeat tende a ser pequeno, porém possui o
custo temporal de tolerância limite no pior caso e o custo da viagem ida e
volta no melhor caso. Este método é aplicado em datacenters, também chamado de
"health signal" ou "health check", o sinal e sua resposta desejada podem conter
outros metadados para análise de falhas, caso desejado. 

Também é possível usar os próprios prazos de execução como um mecanismo de
detecção, um timer pode ser utilizado para alertar prematuramente a um erro que causou
um aumento inesperado no tempo de uma tarefa. @FaultTolerantSystems

=== Asserts

A utilização de asserts é um mecanismo simples que é particularmente útil, um
assert trata-se de checar se uma condição é verdadeira, caso não seja, o
programa é interrompido e entra um estado de pânico. Utilizar asserts
automáticos na entrada e saída de funções é denominado pré/pós-condições.

Asserts não previnem erros do hardware ou tratam exceções por conta própria,
mas tratam-se de um mecanismo de uso extremamente simples que pode ser inserido
pelos desenvolvedores para detectar falhas cedo, especialmente erros lógicos e
violação de contrato de um interface. Quando usados em conjunto com fuzzers ou
simulações determinísticas podem alcançar um alto grau de confiabilidade e
revelar erros de design durante a fase de desenvolvimento. @TigerBeetleSafety
@PowerOf10Rules

Já na execução de um sistema tolerante, asserts servem como uma forma de
rapidamente e imediatamente saber que algo errado aconteceu, dado que sua
invariante não é mais mantida. Porém não são robustos o suficiente para
detectar corrupção silenciosa de dados ou pulos inesperados de maneira
consistente.

#figure(caption: "Exemplo da implementação de um Assert", [
```cpp
void assert(bool predicate, string message){
    [[unlikely]]
    if(!predicate){
        // Opcional: imprimir uma mensagem de erro
        log_error(message);
        trap(); // Emitir exceção
    }
}
```
])

== Mecanismos de Tratamento

Uma vez que uma falha tenha sido detectada o sistema precisa *tratar* a falha o
mais rápido possível para manter a qualidade de serviço, alguns mecanismos de
detecção também fornecem a possibilidade de correção dos dados, como é o caso
dos códigos Reed-Solomon, nestes casos, fica à critério da aplicação se a
correção deve ser tentada ou outro tratamento deve ser usado.

=== Redundância

Adicionar redundância ao sistema é uma das formas mais intuitivas e mais
antigas de aumentar a tolerância à falhas, a probabilidade de N falhas
transientes ocorrendo simultaneamente em um sistema é mais baixa do que a
probabilidade de apenas 1 falha.

Uma técnica de redundância comum é o uso de TMR (Triple Modular Redundancy)
onde uma a tarefa é executada 3 vezes em paralelo, e uma porta de
consenso utiliza a resposta gerada por pelo menos 2 das unidades. O uso de TMR
é elegante em sua simplicidade e consegue atingir um bom grau de resiliência,
porém com o custo adicional de triplicar o custo. @DependabilityInEmbeddedSystems

#figure(caption: "Exemplo de redundância modular na execução de tarefas", image("assets/redundancia_tmr.png", height: 180pt))

Sistemas distribuídos também podem aproveitar de sua redundância natural por
serem sistemas com múltiplos nós computacionais, falhas transientes em um nó
podem ser propagadas e no caso de falhas permanentes em um nó, os outros podem
suplantar a execução de suas tarefas mantendo a qualidade média de serviço, o
uso de sistemas capazes de auto reparo é vital para a existência de
telecomunicação em larga escala e computação em nuvem.

=== Loop Unrolling & Function Inlining

Uma otimização comum que compiladores realizam é "desenrolar" laços de
repetição (Loop Unrolling) com a finalidade de reduzir erros de cachê no
preditor de desvios da CPU, no contexto de tolerância à falhas, é possível
utilizar dessa otimização como uma forma de redundância espacial, ao reduzir a
possibilidade de pulos dependentes de um valor, torna-se menos provável um
salto baseado em uma versão corrompida do mesmo. O desenrolamento pode também
ser feito caso exista um limite superior conhecido no loop, o que comum em
aplicações em que utiliza-se se de um analisador estático para provar
propriedades sobre a conclusão adequada do programa @LoopUnrollingARM.

Outra transformação comum é o inlining de funções, onde o corpo de uma função é
copiado como se o código tivesse sido diretamente escrito em seu ponto de
chamada, a razão pela qual é realizado é similar à de unrolling de loops, ao
reduzir a quantidade de pulos (e neste caso, manipulação do stack) é possível
melhorar a coerência do cachê de instruções, causando uma melhora na
performance. Pela mesma razão, ao introduzir redundância o inlining de funções
pode também reduzir a chance de um jump inadequado.

Importante ressaltar que o inlining e unrolling excessivamente agressivo tem o
efeito oposto do que se deseja no quesito de performance, quando aplicadas de
forma agressiva, essas técnicas saturam o cachê de instruções e ocupam espaço
desnecessário no executável, o que requer que o frontend da CPU perca mais
tempo aguardando IO e decodificando instruções. Portanto, é extremamente
importante que estas técnicas não sejam aplicadas de forma arbitrária.

#figure(caption: "Exemplo de função sem unrolling ou inlining", [
```c
#define COUNT 5

int square(int n){
    return n * n;
}

int sum_squares(int values[COUNT]){
    int acc = 0;
    for(int i = 0; i < COUNT; i++){
        acc += values[i];
    }
    return acc;
}
```
])

#figure(caption: "Função equivalente, após unrolling e inlining", [
```c
#define COUNT 5

int sum_squares(int values[COUNT]){
    int acc = 0;
    acc += (values[0] * values[0]);
    acc += (values[1] * values[1]);
    acc += (values[2] * values[2]);
    acc += (values[3] * values[3]);
    acc += (values[4] * values[4]);
    return acc;
}
```
])


=== Re-execução

Re-executar uma tarefa é uma outra forma simples de recuperar-se de uma falha,
a probabilidade de $k$ falhas intermitentes ocorrem em sequência é menor do que
a probabilidade de apenas ocorrer $k - 1$ vezes no intervalo de execução. Ao
re-executar, espera-se que a falha não ocorra novamente na N-ésima tentativa.
@DependabilityInEmbeddedSystems

Portanto, é sacrificado um tempo maior de execução caso a falha ocorra, em
troca de um tempo menor de execução médio sem necessitar de componentes extras.
Em contraste com a técnica de redundância tripla, é possível entender que a
redundância tripla ou "tradicional", depende de uma resiliência "espacial" (É
improvável que uma falha ocorra em vários lugares ao mesmo tempo), enquanto a
re-execução depende de uma resiliência "temporal" (É improvável que múltiplas
falhas ocorram repetidamente em $N$ execuções)

É também possível utilizar reexecuções sucessivas como um mecanismo de detecção
e prevenção, a tarefa é reexecutada $N$ vezes, seus $N$ resultados são
temporariamente guardados e passam então por um consenso. Similar à técnica de
redundância modular, mas sacrificando tempo ao invés de múltiplas instâncias
concorrentes.

#figure(caption: "Exemplo de reexecução com consenso", image("assets/redundancia_reexec.png", height: 140pt))

=== Correção de Erro

Existem também algoritmos que permitem detectar e corrigir erros dentro de um
payload, em troca de um custo de espaço e tempo para a detecção, dentro da
família de algoritmos que possibilitam detecção e correção, são encontrados os
códigos como os de: Reed-Solomon, Turbo Codes, LDPCs. @SoftwareFTInRTSystems,

Este trabalho não abordará algoritmos de correção de forma aprofundada pois
foge do escopo de foco nas técnicas de escalonamento (execução) e detecção, mas
se trata de um tópico importante que complementa qualquer implementação de
sistemas resilientes particularmente no processo de envio e recebimento de
mensagens.

== Sistemas embarcados

Sistemas embarcados são uma família vasta de sistemas computacionais, algumas
das principais características de sistemas embarcados são:

*Especificidade*:
Diferente de um sistema de computação mais generalizado como um computador
pessoal ou um servidor, sistemas embarcados são especializados para uma solução
de escopo restrito. Um exemplo de um sistema embarcado são microcontroladores
encontrados em dispositivos como mouses, teclados e eletrodomésticos @ComputerOrganizationAndDesign.

*Limitação de recursos*:
Um corolário da natureza especialista destes sistemas, é que recursos alocados
para o sistema são definidos previamente. No caso de microcontroladores tanto o
poder computacional quanto a disponibilidade de memória são restritas.
Importante notar que existem sistemas embarcados com acesso maior à recursos,
como equipamentos de rede e hardware aceleradores que podem ter acesso a
quantias maiores de poder computacional ou memória, mas os recursos do sistema
continuam estaticamente delimitados para cumprir sua função específica.

*Critério Temporal*:
Sistemas embarcados, por serem parte de um todo maior, devem realizar sua
função com o mínimo de interrupção para a funcionalidade geral do contexto
externo @OperatingSystemConcepts. A importância do tempo de execução de uma tarefa de um sistema pode
ser classificada em duas categorias: Soft real time, e Hard real time, a
distinção entre estas categorias é explicada na seção seguinte.

== Sistemas Operacionais de Tempo-Real

Um sistema operacional é um conjunto conjunto de software que permitem o
gerenciamento e interação com os recursos da máquina através de uma camada de
abstração, no contexto deste trabalho, o componente fundamental é o *kernel*, a
parte sistema operacional que sempre está executando, o trabalho principal do
kernel é permitir a coexistência de diferentes tarefas no sistema que precisam
acessar as capacidades do hardware, especialmente tempo na CPU e memória, o
kernel pode ser descrito de maneira simplificada como a "cola" entre a
aplicação e os recursos do hardware @OperatingSystemConcepts.

Já um sistema operacional de tempo real (RTOS) é um tipo de sistema operacional
mais especializado, tipicamente pequeno, que possui como característica central
cumprir o requisito temporal, que divide-se em 2 categorias:

- *Soft Real Time*: Um sistema que garante essa propriedade precisa sempre
  garantir que tarefas de  maior importância tenham prioridade sobre as de
  menor importância. Sistemas soft real-time tipicamente operam na escala de
  milissegundos, isto é, percepção humana @SchedAndOptOfDistributedFT.
  O atraso de uma tarefa em um sistema soft real-time não é desejável,
  mas não constitui um erro. _Exemplos_: Player de DVD, videogames, kiosks de atendimento.

- *Hard Real Time*: Precisam garantir as propriedades de soft real time, além
  disso, o atraso de uma tarefa de seu prazo (deadline), é inaceitável, para
  um sistema hard real time uma resposta com atraso é o mesmo que resposta
  nenhuma. Cuidado adicional deve ser utilizado ao projetar sistemas hard real
  time, pois muitas vezes aparacem em contextos críticos. _Exemplos_: Software
  para sistema de frenagem, Sistemas de navegação em aplicações aeroespaciais,
  software de trading de alta frequência, broker de mensagens de alta
  performance. @ModernOperatingSystems

Como sistemas Hard Real Time cumprem os requisitos de sistemas Soft Real Time,
os sistemas operacionais de tempo real tem seu design orientado a serem capazes
de cumprir o critério Hard Real Time.

Em contraste com sistemas operacionais focados em uso geral que são encontrados
em servidores e computadores pessoais (como Windows, Linux e OSX), o objetivo
do primário de um RTOS não é dar ao usuário a sensação de fluidez dinamicamente
escalonando os recursos da máquina, sistemas em tempo real buscam ser
simples, confiáveis e determinísticos @OperatingSystemConcepts. É essencial que
um RTOS execute as tarefas do sistema com um respeito estrito aos prazos de execução
fornecidos e que faça de maneira resiliente à flutuações de tempo causadas
por IO e outras interrupções.

Drivers em RTOSes são tipicamente adicionados previamente de maneira _ad-hoc_,
não havendo necessidade de carregamento dinâmico de drivers ou de bibliotecas
pois muitas aplicações que necessitam de um RTOS, o hardware ja é conhecido e
definido de antemão.

Devido à suas características de simplicidade, baixo custo e previsibilidade,
os sistemas operacionais de tempo real são extensivamente usados em aplicações
de sistemas embarcados. Exemplos incluem: FreeRTOS, VxWorks, Zephyr e LynxOS.

== Escalonador

O escalonador (scheduler) é o componente do sistema operacional responsável
por gerenciar múltiplas tarefas que desejam executar @OperatingSystemConcepts,
sendo um componente extramente crucial, a implementação do escalonador deve
garantir que tarefas de alta prioridade executem antes e que a troca entre
tarefas (context switching) seja o mais rápido possível, o algoritmo de
escalonamento é o fator central para o comportamento do escalonador, sendo
categorizados em 2 grandes grupos:

- *Cooperativos*: Tarefas precisam voluntariamente devolver o controle da CPU
  (com exceção de certas interrupções de hardware) para que as outras tarefas
  possam executar, isso pode ser feito explicitamente por uma função de
  "largar" (yield) ou implicitamente ao utilizar uma rotina assíncrona do
  sistema, como ler arquivos, receber pacotes de rede ou aguardar um evento
  @OperatingSystemConcepts

- *Preemptivos*: Além de poderem transferir a CPU manualmente, o escalonador
  forçará trocas de contexto caso uma condição para a troca seja satisfeita. O
  algoritmo mais comum que serve de base para diversos escalonadores
  preemptivos é o _Round-Robin_ onde tarefas possuem uma quantia de tempo
  máximo alocada para sua execução contínua, nomeada "time slice" ou "quantum"
  @ModernOperatingSystems. Tarefas ainda podem possuir relações de prioridade,
  alterando a ordem que o escalonador realiza seu despache assim como o tamanho
  de sua time slice.

Sistemas operacionais de tempo-real são tipicamente executados no modo totalmente
preemptivo, mas o uso cooperativo também é viável e possui a vantagem de possuir
o controle mais previsível e menos suporte de runtime para o gerenciamento de tarefas,
mas é importante que seja tomado o cuidado adequado para que nenhum prazo de
execução hard real time seja violado por uma tarefa inadvertidamente utilizando
a CPU por uma quantidade longa de tempo.

=== Concorrência e Assincronia

Será utilizado a definição de concorrência como a habilidade de um sistema de
lidar com múltiplas tarefas computacionais dividindo seus recursos
(particularmente tempo de CPU e memória). Isto é, um sistema não
necessariamente precisa ser paralelo (execuções múltiplas simultâneas) para
possuir concorrência, mas para tornar paralelismo viável, o sistema necessita
de mecanismos de concorrência @MakingReliableDistSystems.

Uma característica central para a utilidade de concorrência mesmo em situações
em que paralelismo é limitado ou impossível vai além da pura expressividade do
programador, existem assimetrias grandes na velocidade de acesso de disco,
memória, rede, e cachês da CPU. O processo de acessar um recurso é deve lidar
com o fato de ser _assíncrono_. O uso de concorrência permite que uma tarefa
seja suspensa e resumida (voluntariamente ou não) o que permite que o sistema
não fique excessivamente ocioso, esperar 20 milissegundos para um pacote de
rede chegar é aceitável para um humano, mas é uma eternidade para um
processador @ComputerOrganizationAndDesign. Implementar os mecanismos de
concorrência adequados também permite lidar com interrupções de forma mais
estruturada, um problema clássico de lidar com uma interrupção é restaurar a
memória de pilha e registradores de forma adequada, interrupções introduzem um
fluxo de programa não local, violando as garantias fortes de escopo e ponto de
entrada fornecidas por funções.

É uma tendência atual aumentar o número de núcleos em dispositivos, com
velocidades de clock speed das CPUs possuindo ganhos marginais em relação ao
impacto térmico, a maioria dos computadores de propósito geral (smartphones,
tablets, desktops) tipicamente possuem 2 núcleos ou mais
@ComputerOrganizationAndDesign. Essa tendência não se restringe apenas à
computadores gerais, sistemas embarcados comerciais também podem se beneficiar
tremendamente das possibilidades de concorrência providas por mais de um
núcleo, porém, é importante ressaltar que o uso de estado compartilhado se
torna muito mais sensível à erros em um ambiente com múltiplas threads de
execução, e medidas devem ser tomadas para evitar condições de corridas e
deadlocks @OperatingSystemConcepts.

== Escalonamento tolerante à falhas

Durante a execução de um sistema tolerante à falhas, existem alguns tipos
principais de overheads que independente da presença de uma falha vão ocorrer e
precisam ser considerados pelo escalonador.

1. *Mudança de contexto*: Trocar entre tarefas possui um custo inerente pois é
  necessário salvar o estado da máquina e fazer alterações no TCB (Task control
  block) da tarefa @OperatingSystemConcepts.

2. *Envio de mensagens*: Para comunicar entre tasks ou entre componentes
  fisicamente distintos do sistema, seja por bus ou por mecanismo de rede, existe
  um custo inerente à serialização e ao meio de transmissão da mensagem.

3. *Detecção de Erro*: É necessário um overhead fixo para detectar a presença
  de falhas, um bom algoritmo de detecção possui um equilíbrio entre minimizar
  esse custo e conseguir detectar falhas com uma alta taxa de acerto, sem
  presença de falsos positivos.

Na ocorrência de uma falha com uma política de re-execução, existe um overhead
extra, similar à de uma mudança de contexto, para restaurar o estado anterior
da tarefa.

Uma consequência natural de possuir diversos processos se comunicando com até
$k$ falhas, é uma explosão combinatória de possíveis caminhos de execução e
reexecução, além de drasticamente aumentar o tempo de execução de algoritmos de
escalonamento (seja online ou offline), o sistema se torna excessivamente
complicado, afetando negativamente duas das características desejáveis de
sistemas de tempo real, como o determinismo e as fortes garantias de prazo de
execução.

Pode-se reduzir o grau de possíveis combinações e garantir maior
previsibilidade do sistema utilizando-se de pontos de transparência, também
chamadas de freezing @SchedAndOptOfDistributedFT.  Para uma tarefa qualquer,
considera-se que a tarefa é transparente se para uma deadline especificada e
dado um limite de até $k$ falhas, se sua execução é finalizada no prazo
independente do número de falhas que ocorreram. Para o caso onde nenhuma falha
ocorra, existe a presença de um tempo (potencialmente ocioso) extra onde a
tarefa está "congelada". Pontos de transparência podem ser estrategicamente
escolhidos para garantir o tempo de execução entre as principais macro etapas
sem a necessidade de redundância de replicação. É importante ressaltar que a
troca fundamental que ocorre na inserção de um ponto de transparência é a troca
de maior gasto temporal para o caso sem falhas de uma tarefa, em troca de uma
garantia sistêmica de sua conclusão, outras tarefas ou nós no sistema são
capazes de confiar na conclusão de uma tarefa transparente dado que seu prazo
esteja cumprido.

=== Grafos de execução tolerantes à falha

Para melhor visualização de um fluxo de execução com falhas, é possível
utilizar de um mecanismo de diagramação denominado grafos resilientes à falhas.
Nesta representação, os nós são tarefas, que podem estar executando na mesma
CPU ou não, arestas indicam o fluxo de execução, uma aresta não marcada indica
execução incondicional, já arestas demarcadas com notação de mensagem,
representam execução que depende de uma transmissão de mensagem. Mensagens e
tarefas indicados com um símbolo circular representam pontos ordinários no
grafo, já pontos com símbolos quadrados indicam as condições de transparência.
@SchedAndOptOfDistributedFT

Dado um grafo não ponderado direcionado acíclico com seus nós representando
tarefas/processos, arestas representando o fluxo de execução e arestas nomeadas
representando fluxo dependente da entrega de mensagens, será utilizado a
notação $P_X (N)$, onde $X$ é o número identificador da tarefa, e $N$
corresponde à sua $N$-ésima re-execução, por exemplo $P_2 (1)$ indica a
primeira execução da tarefa $P_2$, enquanto $P_1 (3)$ indica a terceira
reexecução da tarefa $P_1$. Uma notação similar será utilizada para mensagens
entre tarefas, $m_X (N)$, mensagens, assim como tarefas, estão sujeitas à
falhas e overheads de detecção, mas ao invés de re-execução, mensagens são
re-enviadas. @SchedFTWithSoftAndHardConstraints

Para melhor exemplificar a importância da detecção das falhas, será tomado como
exemplo um grafo simples, com apenas 3 tarefas e uma mensagem. O grafo
precisará tolerar uma falha transiente. O fluxo "ideal" (sem falhas) seria
este:

#figure(caption: "Grafo com 3 processos e uma mensagem", image(height: 180pt, "assets/ftg_simples.png"))

Ao incluir os diferentes desvios possíveis na presença de apenas _uma_ falha,
temos o seguinte grafo, importante notar que falhas podem ocorrer tanto na
tarefa quanto na transição de estado dependente de mensagem.

#figure(caption: "Mesmo grafo, mas tolerante à uma falha transiente", image(height: 240pt, "assets/ftg_expandido.png"))

Será introduzido transparência na tarefa $P_2$, isto é, será executada com
redundância temporal ou modular de tal forma que as tarefas subsequentes
pudessem assumir "como se" uma falha nunca tivesse acontecido em $P_2$ após sua
deadline ter sido completa.

#figure(caption: [Introdução de transparência (freezing) em $P_2$], image(height: 240pt, "assets/ftg_transparencia.png"))

Introduzindo apenas um ponto de transparência é possível reduzir
significativamente as possibilidades de execução do sistema, isso é
particularmente benéfico para escalonadores ou handlers de falhas baseados em
tabelas ou máquinas de estado finito, assim como é positivo para a
previsibilidade do sistema, estabelecendo uma relação forte de pré-conclusão
com sucesso ao respeitar a deadline de da tarefa transparente.

Este exemplo é simples e tolera apenas uma falha transiente, porém processos
complexos com múltiplas mensagens entre si causam um aumento exponencial de
complexidade, especialmente caso seja necessário tolerar até $k$ falhas
transientes.

É possível introduzir estes pontos de transparência com a técnica de reexecução
ou com redundância modular (se a deadline conjunta das $N$ tarefas for
determinística) , com o objetivo de melhorar a confiabilidade do sistema e
torná-lo mais previsível. A introdução de transparência naturalmente não é
gratuita, é feito um tradeoff entre garantias mais fortes no escalonador e
menos imprevisibilidade na execução com o custo de maior uso da CPU e memória,
todos os pontos de transparência necessitam ser checados o que pode gerar um
tempo ocioso maior dos núcleos e a necessidade de aumentar uma deadline para
garantir a possibilidade de reexecuções suficientes.

== Injeção de falhas

Para adequadamente testar a dependabilidade do sistema, é possível
deliberadamente causar falhas com o propósito de catalogar e validar se o
sistema atinge as métricas necessárias. Dentre os tipos de teste que podem ser
realizados, é possível categorizá-los em quatro grupos principais:

Injeção *Física*: Involve utilizar um ambiente físico genuíno para causar as falhas, o principal benefício desta técnica é replicar eventos reais que possam causar falhas, assim como poder injetar falhas em superfícies reais do dispositivo @FaultInjectionTechniques. O principal problema é que esta técnica é particularmente cara e requer auxílio de equipamentos e profissionais especializados, também não é possível injetar um tipo específico de dado para testar um caso específico. Na seção de *trabalhos relacionados* é possível observar um exemplo testa técnica em uso na pesquisa de íons pesados.

Injeção *Lógica por Hardware*: Utiliza-se de um dispositivo adicional para injetar as falhas que controla o dispositivo alvo, possui como vantagem ser menos intrusivo e ainda permitir um algo grau de controle e simulação dos fenômenos físicos, desvantagens incluem uma área maior de circuito necessária, implementação de uma unidade extra e criação de canais de comunicação com o dispositivo alvo @FaultInjectionTechniques.

Injeção *Lógica por Software*: Funções são executadas em software para injetar falhas em outras partes do programa, o método é pouco invasivo, de baixo custo, alta portabilidade e permite um controle muito elevado sobre os pontos de injeção e estilo de falha @FaultInjectionTechniques. Possui a desvantagem de aumentar o tempo médio de execução ao introduzir um overhead e espaço extra de memória para armazenar o código de injeção, também não reflete tão precisamente os fenômenos físicos.

Injeção *Simulada*: O dispositivo é executado em um ambiente totalmente simulado, tem como vantagem não ser invasivo, altamente flexível e nem sequer necessitar de uma versão física do dispositivo, porém tipicamente requer software de simulação potencialmente caro assim como uma descrição do chip na forma de alguma linguagem de descrição de hardware, que raramente é disponibilizada @FaultInjectionTechniques.

== Trabalhos Relacionados

=== Reliability Assessment of Arm Cortex-M Processors under Heavy Ions and Emulated Fault Injection

Neste trabalho conjunto de pesquisadores da USP e UFRGS utilizam de um sistema
COTS e criam um perfil de falhas com exposição a íons pesados assim como
injeção artificial de falhas para posteriormente realizar uma adição de formas
de detecção de falhas para melhorar a confiabilidade do sistema. Foi possível
detectar mais da metade das falhas funcionais apenas com técnicas de software
no banco de registradores. @ReliabilityArmCortexUnderHeavyIons.

#sourced_image(
	image("assets/related_works_heavy_ion_reliability.png"),
	caption: [Análise de resiliência, dividida por categoria],
	source: "ReliabilityArmCortexUnderHeavyIons",
)

Uma outra observação foi que a quantia de falhas injetadas para ocasionar um
erro de funcionalidade é 2 ordens de magnitude maior na memória em relação ao
banco de registradores, indicando que existe uma necessidade real de poder
detectar e mitigar erros de memória mais rapidamente
@ReliabilityArmCortexUnderHeavyIons.

=== Application-Level Fault Tolerance in Real-Time Embedded System

Neste trabalho são apresentadas técnicas de tolerância à falhas em um sistema operacional chamado BOSS, é utilizado uma interface de thread com a implementação de tolerância conformando à interface.
O trabalho naturalmente explora o escalonador mas não entra em detalhamento profundo na parte de detecção, mas
sim de prover uma biblioteca na forma de classes representando threads
resilientes @ApplicationLevelFT. Um caso de estudo de um sistema de filtragem de
radar é utilizado como projeto.

Os pesquisadores demonstraram resultados favoráveis para uma forma híbrida de
tolerância com menor uso de CPU em relação à redundância tripla utilizando de
técnicas em software combinado com um par de processadores com auto checagem
(PSP).


#sourced_image(
	caption: [Utilização de CPU para diferentes implementações de tolerância],
	source: "ApplicationLevelFT",
	image("assets/related_works_psp_perf.png"),
)

O trabalho demonstra também a viabilidade de prover interfaces mais abstratas
que ainda sejam capazes de rodar em sistemas de recursos restritos, os
pesquisadores realizam uso amplo de herança e padrões orientados à objetos com
chamadas virtuais. Uma possível otimização em termos de memória e coerência do
cachê da CPU é reduzir o uso de despache dinâmico em favor de técnicas de
despache em tempo de compilação, como typeclasses (Presentes em linguagens como
Haskell e Rust) que podem ser também emuladas em C++ com o sistema de
`concepts`.

=== A Software Implemented Comprehensive Soft Error Detection Method for Embedded Systems

Neste trabalho é proposto um método de detecção e reação à erros de controle fluxo juntamente com
correção de payloads de dados, o trabalho demonstra resultados positivos e
conclui que a aplicação de técnicas de software podem aprimorar drasticamente a
tolerância de um sistema. O trabalho possui um foco na análise do grafo de
execução do programa, utilizando de IDs para a detecção de jumps errôneos entre
blocos básicos. @SoftwareImplementedSoftErrorDetection

Esse trabalho relacionado possui similaridade na avaliação da troca de overhead
em relação à resiliência com o que será proposto neste artigo, com a principal
diferença sendo o enfoque na análise fina dos grafos de controle de fluxo. O
trabalho de Asghari et. al serve como um exemplo de uma possível extensão
futura da pesquisa apresentada aqui, servindo como uma fonte compreensiva de
diversas técnicas de análise de basic blocks e detecção de fluxo defeituoso.

=== Análise Comparativa dos trabalhos

Ao realizar uma análise comparativa referente às técnicas de tolerância, o tipo de injeção, hardware e o sistema operacional escolhido, é possível sumarizar a relação dos trabalhos da seguinte forma:

#figure(caption: "Comparação com Trabalhos Relacionados", table(
	columns: (auto,) * 6,

	table.header([*N*], [*Trabalho*], [*Sistema*], [*Hardware*], [*Injeção*], [*Técnicas*]),

	[1], [*Reliability Assessment of Arm Cortex-M Processors under Heavy Ions and Emulated Fault Injection*], [Bare Metal, #linebreak()FreeRTOS], [CY8CKIT-059], [Física & Lógica em Software], [Redundância de Registradores, Deadlines, Redução de Registradores, Asserts],

	[2], [*Application-Level Fault Tolerance in Real-Time Embedded System*], [BOSS], [Máquinas PowerPC 823 e um PC x86_643 não especificado], [Simulada em Software], [Redundância Modular, Deadlines, Rollback/Retry],

	[3], [*A Software Implemented Comprehensive Soft Error Detection Method for Embedded Systems*], [MicroC/OS-ii], [MPC555 Evaluation Board], [Lógica em Hardware], [Análise de fluxo de controle e de dados com sensibilidade à deadlines],

	[-], [*Este Trabalho*], [FreeRTOS], [STM32 Bluepill], [Lógica em Software e Hardware], [Deadlines, Heartbeat, Asserts, Reexecução e Redundância de Tarefas],
))


O trabalho 2 pode ser considerado o mais similar, apesar de utilizar de um hardware bem distinto, nele é criado uma interface de tolerância à falhas na linguagem C++ e são realizados testes focados primariamente na comparação do overhead gerado pelas técnicas e o modelo de execução apresentado trabalha fortemente em conjunto com o escalonador do RTOS. O trabalho 1 é o segundo mais similar, a escolha do FreeRTOS juntamente com a escolha de hardware também baseada na arquitetura ARMv7-M sendo o maior ponto de congruência, também apresenta similaridade conceitual nas técnicas utilizadas, porém é mais focado na introdução de redundância no banco de registradores e não no modelo de execução das tasks. O trabalho 3 é o mais distinto, utiliza-se uma técnica de análise de fluxo para criar pontos de recuperação e detectar falhas, a similaridade principal é na fundamentação teórica e no método de injeção de falhas, os pesquisadores utilizaram de injeção lógica em hardware e forneceram uma fundamentação focada em técnicas associadas à execução do programa, porém com um grau de granularidade e complexidade superior.

