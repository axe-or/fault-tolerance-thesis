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
 
2. **Tratamento de Falhas**:

# Grafos tolerantes à falha

# Sistemas Operacionais de Tempo-Real (RTOS)

## Escalonador

# Sistemas embarcados

# Trabalhos Relacionados

