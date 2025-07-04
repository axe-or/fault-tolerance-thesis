= CONSIDERAÇÕES FINAIS

Foi possível observar que sistemas operacionais de tempo real são de
importância alta para toda a infraestrutura digital moderna, visando entregar
um maior grau de confiabilidade enquanto se mantém uma boa qualidade de serviço
é um objetivo fundamental de tornar um sistema tolerante à falhas, sejam estas
causadas por design incorreto ou eventos externos.

Dentre as técnicas de detecção de falhas, é possível integrá-las fortemente com
o escalonador do sistema operacional, proporcionando uma interface para que
desenvolvedores de sistema possam incrementalmente tornar seus processos mais
resilientes. Este trabalho busca portanto esclarecer mais os impactos das
técnicas em relação à seu benefício provido, para que seja possível escolher a
melhor combinação para o projeto.

O escopo do trabalho é principalmente nos erros causados por corrupções de
memória (seja por erro humano ou disrupção natural), por mais que a memória
seja uma superfície mais sensível à disrupções, é importante ressaltar que
existem também corrupções de dados que diretamente alteram o fluxo do programa
de forma inesperada, é possível capturar essas exceções com uma variedade de
técnicas de checagem do contador de programa assim como monitorar quais são
endereços de jump válido em pontos distintos do programa, estas técnicas porém
necessitam de intervenção manual ou melhor ainda, à nível de compilador. Estas
técnicas não são abordadas e representam um vazio informacional que pode ser
complementado por trabalhos futuros.

Uma das principais limitações do trabalho é que não será possível garantir que
ocorra um teste com falhas físicas, mas ainda espera-se que os testes com
falhas injetadas sejam capazes de aproximar com grau razoável de precisão a
reação do sistema à falhas transientes reais.

