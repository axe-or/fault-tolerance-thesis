= PROJETO

A etapa mais fundamental do projeto é a implementação dos algoritmos e da API
de resiliência, dado o contexto de real time, cuidados devem ser tomados no
quesito da performance e uso de memória (que pode indiretamente degradar a CPU
na presença de erros de cachê). Dado estas restrições, o uso de despache
dinâmico será mantido baixo, para reduzir o tamanho do executável, não será
utilizado mecanismo de exceção com stack unwinding, ao invés, erros de
validação devem ser cuidados explicitamente ou através de callbacks. Será
também assumido que o sistema tenha ao menos uma quantia de memória tolerante
(ROM ou não) para guardar os dados necessários para disparar o tratamento de
falhas.

// TODO: Citar sobre coisa orientada a mensagem, pode ser ate documetation de outro RTOS

A arquitetura será primariamente orientada à passagem de mensagens, pois
permite uma generalização para mecanismos de I/O assíncrono e distribuição da
arquitetura, permite também um desacoplamento  entre a lógica de detecção e
transporte das mensagens, potencialmente permitindo otimizações na diminuição
da ociosidade dos núcleos. O estilo de implementação orientado à mensagens
naturalmente oferece um custo adicional em termos de latência quando comparado
à alternativas puramente baseadas em compartilhamento de memória, apesar deste
custo poder ser amortizado com a utilização de filas concorrentes bem
implementadas e com a criação de um perfil de uso para melhor ajuste do
sistema.

// TODO: Mencionar que sistemas como o QNX usam isso tbm?

== Interface

Uma tarefa (task) é uma unidade de trabalho com espaço de stack dedicado e uma
deadline de conclusão.

O "corpo" de um tarefa é simplesmente a função que executa após a task ter sido
inicializada. Será utilizado uma assinatura simples permitindo a passagem de um
parâmetro opaco por referência. Este parâmetro pode ser o argumento primordial
da task ou um contexto de execução.

```pascal
type FT_Task = record
	id: uint,
	body: func(parameter: Address),
	param: address,
	stack_base: address,
	stack_size: uint,
	fault_handler: FT_Handler,

	injectors: []Fault_Injector, // Apenas para testes sintéticos
end
```

== Visão Geral e Premissas

=== Premissas

Será partido do ponto que ao menos o processador *watchdog* terá registradores
que sejam capazes de mascarar falhas, apesar de ser possível executar os
algoritmos reforçados com análise de fluxo do programa e redundância de
registradores, isso adiciona uma extra de overhead e como mencionado na seção
de trabalhos relacionados, a memória fora do banco de registradores pode ser 2
ordens de magnitude mais sensível à eventos disruptivos, portanto, todos os
testes subsequentes assumirão ao menos uma quantia mínima de tolerância do
núcleo monitor. Ao invés focando em detecção de falhas de memória, I/O
(passagem de mensagem) e resultados dos co-processadores.

Outra necessidade indutiva para a realização do trabalho é que testes
sintéticos possam ao menos *aproximar* a performance do mundo real, ou ao menos
prever o pior caso possível com grau razoável de acurácia. O uso de testes
sintéticos não deve ser um substituto para a medição em uma aplicação real,
porém, uma bateria de testes com injeção artificial de falhas pode ser
utilizada para verificar as tendências e overheads relativos introduzidos,
mesmo que não necessariamente reflitam as medidas absolutas do produto final.

Uma outra característica sobre falhas, é que tipicamente ocorrem numa fração
pequena do tempo de operação do sistema, a maioria das operações ocorrem em um
estado correto. Portanto, pode-se testar um sistema em uma situação de falhas
elevadas, de tal forma que consiga o grau necessário de confiabilidade mesmo em
uma situação adversa, no caso de sistemas que possuem um impacto crítico ou
catastrófico, é melhor optar por ter um excesso de resiliência.

Será assumido que os resultados extraídos de injeção de falhas emuladas, apesar
de menos condizentes com os valores absolutos da aplicação e não sendo
substitutos adequados na fase de aprovação de um produto real, são ao menos
capazes para realizar uma análise quanto ao overhead proporcional introduzido,
devido à sua facilidade de realização e poder extrair diversas métricas em
paralelo, serão priorizados inicialmente neste projeto.

== Análise de Requisitos

=== Algoritmos e Técnicas

- CRC: Será implementado o CRC32 para a checagem do payload de mensagens.

- Heartbeat Signal (simples): Um sinal periódico será enviado para a tarefa em
  paralelo, apenas uma resposta sequencial será necessária.

- Heartbeat Signal (com proof of work): Um sinal periódico juntamente com um
  payload com um comando a ser executado e devolvido, para garantir não somente
  a presença da task mas seu funcionamento esperado.

- Replicação espacial: Uma mesma task será disparada diversas vezes, em sua
  conclusão, será realizado um consenso. A replicação tripla servirá como um
  controle.

- Replicação temporal: Uma mesma task será re-executada N-vezes, tendo suas N
  respostas catalogadas, a resposta correta será decidida por consenso.

- Asserts: Não é um algoritmo propriamente dito, mas sim a checagem de algum
  invariante necessária dentro do código, que caso seja falsa, é tratada como
  uma falha crítica, espera-se que esse seja um método barato (porém menos
  robusto) de detectar estados inconsistentes. Serão utilizados asserts para
  checar invariantes específicas ao algoritmo.

=== Requisitos Funcionais

+ Interface de tolerância com os algoritmos da seção *Algoritmos e Técnicas* implementados
+ Pontos para injeção de falhas sintéticas
+ Criar tarefas com uma estratégia de tolerância
+ Funções de medição e observabilidade das métricas: uso de CPU, uso de
  memória, falhas injetadas, falhas detectadas, quantia de tasks instanciadas e
  cache hit rate (caso presente).

=== Requisitos Não-Funcionais

+ Implementação deve ser realizada em uma linguagem que não necessite da
  presença de uma MMU, alocação dinâmica (sem limite superior), ou suporte à
  floats em hardware (C, C++, Rust)
+ Deve ser compatível arquitetura ARMv7-M ou ARMv8-M

== Plano de Verificação

+ Teste inicial virtualizado
+ Provar corretude e projetar overhead dos algoritmos
+ Teste final em placa (ESP32?) rodando um RTOS com injeção de falhas e coleta das métricas
+ Análise das métricas e comparação com as projeções dos testes virtuais

#pad(left: 5%)[
	NOTE: Isso aqui é regra de negocio?

	O projeto deve ser capaz de executar em um kernel RTOS, se o componente será
	acoplado diretamente ao kernel ou implementado como uma extensão trata-se de um
	detalhe de implementação. Além disso, deve ser possível utilizar em um sistema
	COTS, isto é, não deve estar associado à um hardware particular e deve ser
	portável na medida em que necessita apenas de uma camada HAL para poder
	realizar a funcionalidade adequada.
]

== Projeto para o TCC2

=== Metodologia

=== Cronograma

=== Análise De Requisitos


