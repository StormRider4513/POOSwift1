# Diagrama de Classes do Projeto

* Usando direction LR foi o jeito que achei que ficou mais organizado

```mermaid
    classDiagram
    direction LR 

        class Pessoa {
            +String nome
            +String email
            +getDetails() String
        }

        class Aluno {
            +String matricula
            +PlanoAssinatura plano
            +NivelExperiencia nivel
            +atualizarPlano(novoPlano)
            +atualizarNivel(novoNivel)
            +getDetails() String
        }

        class Instrutor {
            +CategoriaAula especialidade
            +getDetails() String
        }

        Pessoa <|-- Aluno
        Pessoa <|-- Instrutor

        class PlanoAssinatura {
            +String nome
            +Double valorMensalidade
            +Bool incluiPersonalTrainer
            +Int limiteAulasColetivas
            +Int duracaoMeses
        }

        Aluno --> PlanoAssinatura

        class ContratoManutencao {
            <<protocol>>
            +nomeItem : String
            +historico : [String]
            +realizarManutencao(data, statusRegularidade) Bool
        }

        class EquipamentoFisico {
            +String nomeItem
            +[String] historico
            +Bool estadoFuncionamento
            +realizarManutencao() Bool
        }

        ContratoManutencao <|.. EquipamentoFisico

        class ContratoAula {
            <<protocol>>
            +nome : String
            +instrutor : Instrutor
            +categoria : CategoriaAula
            +descricao : String
            +getDetails() String
        }

        class TurmaColetiva {
            +String nome
            +Instrutor instrutor
            +CategoriaAula categoria
            +String descricao
            +Int capacidadeMaxima
            +Int capacidadeMinima
            +[Aluno] inscritos
            +inscreverAluno(aluno) Bool
            +turmaPodeAcontecer() Bool
            +getDetails() String
        }

        class TreinoPersonal {
            +String nome
            +Instrutor instrutor
            +CategoriaAula categoria
            +String descricao
            +Aluno aluno
            +getDetails() String
        }

        ContratoAula <|.. TurmaColetiva
        ContratoAula <|.. TreinoPersonal

        TurmaColetiva --> Instrutor
        TurmaColetiva --> Aluno
        TreinoPersonal --> Instrutor
        TreinoPersonal --> Aluno

        class Academia {
            +historico
            +instrutores
            +alunosPorEmail
            +alunosPorMatricula
            +equipamentos
            +aulas
            +getDetails() String
            +alterarCadastro()
            +cadastrarInstrutor()
            +cadastrarAluno()
            +cadastrarEquipamento()
            +cadastrarAula()
            +realizarManutencaoEquipamentos()
            +sairDaAcademia()
            +matricularAlunoEmTurma()
            +agendarTreinoPersonal()
            +registrarHistorico()
            +listarHistorico()
            +gerarMetricas()
        }

        class Historico {
            +String info
            +String mudanca
            +String justificativa
            +getDetails() String
        }

        Academia --> Historico
        Academia --> EquipamentoFisico
        Academia --> ContratoAula
        Academia --> Aluno
        Academia --> Instrutor
```