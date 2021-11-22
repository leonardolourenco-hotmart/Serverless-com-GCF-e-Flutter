# Flutter e Serverless com GCF

#### Alunos

- Camilla Silva Romagnoli
- Leonardo Augusto Moreira Lourenço
- Leticia Gonçalves
- Octávio Tabai

#### Professores responsáveis

Ricardo Carlini Sperandio

LABORATÓRIO DE DESENVOLVIMENTO DE APLICAÇÕES MÓVEIS E DISTRIBUÍDAS - Graduação em Engenharia de Software

PUC Minas

## Projeto

 O Objetivo deste trabalho é desenvolver uma pequena aplicação usando Serverless com o  Google Cloud Functions - GCF ou AWS Lambda ou Azure Functions.


### Especificação

Durante as aulas de laboratório foram apresentadas formas de se acessar o GCF e o Firebase.

Neste trabalho iremos implementar uma aplicação que ilustre uma situação de sistema ciente de contexto (context-aware system).

#### Requisitos

- [X] **R1.** A aplicação móvel deve exibir o mapa da localização atual do telefone.

- [X] **R2.** A aplicação móvel deve rastrear a localização do usuário.

- [X] **R3.** A cada atualização de localização, a aplicação móvel deve invocar a função lambda do GCF.

- [X] **R4.** A função lambda deve verificar se o aparelho se encontra a menos de 100 metros de alguma unidade da PUC Minas e retornar para o celular a mensagem
      "Bem vindo à PUC Minas unidade " + <nome da unidade mais próxima>.

