# Projeto

A etapa mais fundamental do projeto é a implementação dos algoritmos e da API de resiliência, dado o contexto de real time, cuidados devem ser tomados no quesito da performance e uso de memória (que pode indiretamente degradar a CPU na presença de erros de cachê @muratori). Dado estas restrições, o uso de despache dinânmico será mantido baixo, para reduzir o tamanho do executável, não será utilizado mecanismo de exceção com *stack unwinding*, ao invés, erros de validação devem ser cuidados explicitamente ou através de *callbacks*. Será também assumido que o sistema tenha ao menos uma quantia de memória tolerante (ROM ou não) para guardar os dados necessários para disparar o tratamento de falhas.

A arquitetura será primariamente orientada à passagem de mensagens, pois permite uma generalização para mecanismos de I/O assíncrono e distribuição da arquitetura, permite também um desacoplamento mais entre a lógica de detecção e transporte das mensagens, potencialmente permitindo otimizações na diminiuição da ociosidade dos núcleos. O estilo de implementação orientado à mensagens naturalmente oferece um certo overhead em termos de latência, apesar de poder ser amortizado com a utilização de filas concorrentes bem implementadas, talvez não seja adequeado para aplicações com deadlines muito pequenas.

## Algoritmos
- CRC: Será implementado o CRC32 para a checagem do payload de mensagens.

- Checksum: Similarmente ao CRC, será comparado o uso de checksum para payload de mensagem.

- Heartbeat Signal (simples): Um sinal periódico será enviado para a tarefa em paralelo, apenas uma resposta sequencial será necessária.

- Heartbeat Signal (com proof of work): Um sinal periódico juntamente com um payload com um comando a ser executado e devolvido, para garantir não somente a presença da task mas seu funcionamento esperado.

- Replicação espacial: Uma mesma task será disparada diversas vezes, em sua conclusão, será realizado um consenso. A replicação tripla servirá como um controle.

- Replicação temporal: Uma mesma task será re-executada N-vezes, tendo suas N respostas catalogadas, a resposta correta será decidida por consenso.

- Asserts: Não é um algoritmo propriamente dito, mas pré e pós condições de função serão inseridas e checadas, espera-se que esse seja um método barato (porém menos robusto) de detectar estados inconsistents.


## Interface

Uma tarefa é uma unidade de trabalho com espaço de stack dedicado e uma deadline de conclusão. Uma task possui os seguintes procedimentos associados (métodos):

O "corpo" de um tarefa é simplesmente a função que executa após a task ter sido inicializada. Será utilizado uma assinatura simples permitindo a passagem de um parâmetro opaco por referência. Este parâmetro pode ser o argumento primordial da task ou um contexto de execução.

```
RegisterFaultHandler := procedure(task: TaskHandle)
```
```
TaskProc := type procedure(param: Address);
```

```
// TODO: Melhorar essa assinatura
Create := procedure (stackData: []byte, body: TaskProc) -> Bool;
```

- Implementar as rotinas para a interface de resiliencia (spawn_watchdog, check_crc, attach_handler, reexec)

- Criar teste sintetico (stress alto, fault rate alta)

- ? Implementar gerador de tabela de escalonemento ?

# Visão Geral e Premissas

## Premissas
- especificar mais o contexto
- testes sinteticos podem aproximar um grau razoavel de stress no sistema
- é possível estimar a complexidade no limite com uma implementação emulada
- falhas são raras, mas ainda é necessário que o pior caso seja considerado

Será partido do ponto que ao menos o processador *watchdog* terá registradores que sejam capazes de mascarar falhas, apesar de ser possível executar os algoritmos reforçados com análise de fluxo do programa e redundância de registradores, isso adiciona uma quantia significativa de overhead e foge do escopo do trabalho, portanto, todos os testes subsequentes assumirão ao menos uma quantia mínima de tolerância do hardware para operação consistente da CPU. Tendo o foco em detecção de falhas externas como na passagem de mensagem e resultados dos co-processadores.

Outra necessidade indutiva para a realização do trabalho é que testes sintéticos possam ao menos *aproximar* a performance do mundo real, ou ao menos prever o pior caso possível com grau razoável de acurácia. O uso de testes sintéticos não deve ser um suAbstituto para a medição em uma aplicação real, porém, uma bateria de testes com injeção artificial de falhas pode ser utilizada para verificar as tendências e overheads relativos introduzidos, mesmo que não necessariamente reflitam as medidas absolutas do produto final.

Uma outra característica sobre falhas, é que tipicamente ocorrem numa fração pequena do tempo de operação do sistema <CITAR O TRECO LA DE IMPACTO E TALS>, a maioria das operações ocorrem em um estado correto. Portanto, pode-se testar um sistema em uma situação de falhas elevadas, de tal forma que consiga o grau necessário de confiabilidade mesmo em uma situação adversa, no caso de sistemas que possuem um impacto crítico ou catastrófico (Segundo definição <AQUELA LA>), é melhor optar por ter um excesso de resiliência.

# Análise de Requisitos
- requisitos & regra de negocio

# Delimitação de Escopo


# Plano de Verificação

Inicialmente será utilizado um sistema virtualizado 
