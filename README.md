# Sistema de Georreferenciamento e Diagnóstico Energético

Projeto da disciplina de **Banco de Dados** (UFF — Instituto de Ciência e Tecnologia, Departamento de Ciência da Computação).

O trabalho consistia em escolher um dos **Objetivos de Desenvolvimento Sustentável (ODS)** e desenvolver, a partir dele, uma solução baseada em banco de dados. O projeto foi dividido em duas partes:

- **Parte 1 — Modelagem**: definição do problema, do minimundo e construção do modelo conceitual (MER) e do modelo relacional.
- **Parte 2 — Construção com apoio de IAs generativas**: uso de ferramentas de IA para gerar diagramas MER alternativos a partir do mesmo minimundo, comparação com o modelo desenvolvido na Parte 1, refinamento do modelo final e implementação completa em SQL (DDL, carga de dados e consultas).

## 1. Objetivo, problema e solução

**ODS escolhido:** Objetivo 7 — Energia Limpa e Acessível, que busca garantir o acesso a fontes de energia viáveis, sustentáveis e modernas para todos.

**Problema:** populações em áreas isoladas e rurais frequentemente vivem sem acesso à rede elétrica tradicional. Além do impacto socioeconômico dessa carência, falta um mapeamento preciso de onde essas famílias estão e de qual fonte de energia renovável (solar, eólica, biomassa etc.) seria viável para atender à demanda de cada localidade.

**Solução proposta:** um sistema de georreferenciamento e diagnóstico energético que cadastra residências sem luz com sua localização e demanda estimada, monitora o potencial de geração renovável local através de pontos de medição, e cruza essas informações para que técnicos possam gerar diagnósticos e recomendações de soluções de energia limpa sob medida para cada residência.

## 2. Minimundo

O banco modela um sistema onde:

- **Comunidades** (código, nome, região) agrupam as residências atendidas.
- **Residências** sem luz são cadastradas com latitude/longitude, número de moradores e demanda de energia estimada.
- **Recursos Renováveis** (solar, eólico, biomassa etc.) são catalogados com tipo e unidade de medida.
- **Pontos de Monitoramento** georreferenciados, instalados nas comunidades, avaliam o potencial desses recursos.
- **Técnicos** (registro profissional, nome, especialidade) conduzem a avaliação usando **Equipamentos** (modelo, marca, data de calibração) alocados nos pontos de monitoramento.
- **Medições** do potencial energético são registradas (valor medido, data da leitura).
- Com base no histórico de medições, os técnicos elaboram **Diagnósticos** (data da análise, recomendação técnica).
- Cada diagnóstico é associado a uma ou mais **residências** atendidas, cruzando o potencial de geração local com a demanda das famílias.

## 3. Processo de modelagem

1. **Parte 1** — a partir do minimundo descrito acima, foi construído o modelo conceitual (MER em notação Chen) e o mapeamento para o modelo relacional textual.
2. **Parte 2** — três IAs generativas (ChatGPT, Google Gemini Pro e Claude) receberam o mesmo prompt, com o mesmo minimundo, e geraram diagramas MER alternativos. Esses diagramas foram comparados com o modelo original para identificar entidades, atributos e relacionamentos a mais ou a menos em cada versão.

**Principais achados da comparação:**
- ChatGPT e Gemini geraram modelos textualmente equivalentes entre si e próximos do modelo original.
- O Gemini não conseguiu gerar a imagem do diagrama diretamente, sendo necessário recorrer a uma ferramenta externa para representá-lo visualmente.
- O Claude propôs um modelo mais elaborado, introduzindo atributos nos relacionamentos e uma relação ternária entre Técnico, Equipamento e Ponto de Monitoramento (**Alocação**), permitindo registrar com mais precisão quem usou qual equipamento, onde e quando.

A partir dessa análise, o modelo final incorporou as melhorias identificadas, unindo a estrutura original com os refinamentos trazidos pelas IAs.

## 4. Modelo Entidade-Relacionamento (versão final)

Entidades principais: `Comunidade`, `Residência`, `Ponto de Monitoramento`, `Recurso Renovável`, `Técnico`, `Equipamento`, `Medição`, `Diagnóstico`.

Relacionamentos:

| Relacionamento | Entidades envolvidas | Cardinalidade |
|---|---|---|
| Sedia | Comunidade — Ponto de Monitoramento | (1,n) — (1,1) |
| Possui | Comunidade — Residência | (1,n) — (1,1) |
| Avalia | Ponto de Monitoramento — Recurso Renovável | (1,n) — (1,n) |
| Classifica | Recurso Renovável — Medição | (1,n) — (1,1) |
| Gera | Diagnóstico — Medição | (1,1) — (1,n) |
| Analisa | Residência — Diagnóstico | (0,n) — (1,n) |
| Alocação | Equipamento — Técnico | (1,n) — (1,n) |
| Atende | Técnico — Residência | (0,n) — (0,n) |

O diagrama completo (notação Chen) está no PDF do modelo conceitual incluído neste repositório, gerado com a ferramenta [brModelo](https://app.brmodeloweb.com/).

## 5. Modelo relacional

- `comunidade` (**cod_comunidade**, nome, regiao)
- `residencia` (**cod_residencia**, num_moradores, latitude, longitude, demanda_estimada, *cod_comunidade*)
- `ponto_monitoramento` (**cod_ponto**, latitude, longitude, descricao, *cod_comunidade*)
- `recurso_renovavel` (**cod_recurso**, tipo, unidade_medida)
- `avalia` (**cod_ponto**, **cod_recurso**) — associativa entre ponto e recurso
- `tecnico` (**cod_tecnico**, nome, reg_profissional, especialidade)
- `equipamento` (**num_serie**, marca, modelo, data_calibracao, data_ultima_medicao)
- `diagnostico` (**cod_diagnostico**, data_analise, recomendacao)
- `medicao` (**cod_medicao**, data_leitura, valor_medido, *cod_recurso*, *cod_diagnostico*, *num_serie*, *cod_tecnico*)
- `analise` (**cod_diagnostico**, **cod_residencia**, data_analise) — associativa entre diagnóstico e residência
- `atende` (**cod_tecnico**, **cod_residencia**, **data_atendimento**) — associativa entre técnico e residência

*(chaves primárias em negrito, chaves estrangeiras em itálico)*
