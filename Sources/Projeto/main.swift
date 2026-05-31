//Nome: Ana Clara Cândido Pereira
//---------------------------------------------------------------------------------------------------------DIA 1----------------------------------------------------------------------------------------------------------
// Dia 1: Estruturas Base, Entidades de Negócio e Herança
// Nesta primeira etapa, vocês deverão construir as fundações do sistema identificando os domínios fechados e as entidades principais. Iniciem criando conjuntos fechados (tipos de valor) para representar o nível de experiência do aluno (Iniciante, Intermediário, Avançado) e as categorias de aulas oferecidas (Musculação, Spinning, Yoga, Funcional, Luta).

// Em seguida, estruturem a entidade que representa os planos de assinatura da academia. Esta entidade deve conter propriedades estritas e obrigatórias de negócio: nome, valor da mensalidade, indicador de inclusão de personal trainer, limite de aulas coletivas e duração em meses. Crie um catálogo em memória simulando um banco de dados com instâncias pré-definidas (Mensal, Trimestral, Anual).

// Por fim, estruturem o cadastro de indivíduos utilizando uma hierarquia de base. Modelem uma entidade genérica para pessoas (contendo nome, e-mail e uma função descritiva) e derivem desta base duas novas entidades: Alunos (com matrícula, plano e nível) e Instrutores (com especialidade). Os alunos devem poder ter seus planos e níveis atualizados dinamicamente.

import Foundation

enum NivelExperiencia { //conjunto fechado para representar o nível de experiência do aluno
    case iniciante
    case intermediario
    case avancado
}

enum CategoriaAula { //conjunto fechado para representar as categorias de aulas oferecidas
    case musculacao
    case spinning
    case yoga
    case funcional
    case luta
}

enum TipoUsuario { //conjunto fechado para representar os tipos de usuário na academia
    case aluno
    case instrutor
}

class PlanoAssinatura { //classe que representa os planos de assinatura da academia, com as propriedades obrigatórias de negócio
    var nome: String
    var valorMensalidade: Double
    var incluiPersonalTrainer: Bool
    var limiteAulasColetivas: Int
    var duracaoMeses: Int

    init(nome: String, valorMensalidade: Double, incluiPersonalTrainer: Bool, limiteAulasColetivas: Int, duracaoMeses: Int) {
        self.nome = nome
        self.valorMensalidade = valorMensalidade
        self.incluiPersonalTrainer = incluiPersonalTrainer
        self.limiteAulasColetivas = limiteAulasColetivas
        self.duracaoMeses = duracaoMeses
    }
}

let planoMensal = PlanoAssinatura( //início da criação do catálogo em memória simulando um banco de dados com instâncias pré-definidas
    nome: "Mensal",
    valorMensalidade: 100,
    incluiPersonalTrainer: false,
    limiteAulasColetivas: 5,
    duracaoMeses: 1
)

let planoTrimestral = PlanoAssinatura(
    nome: "Trimestral",
    valorMensalidade: 270,
    incluiPersonalTrainer: true,
    limiteAulasColetivas: 10,
    duracaoMeses: 3
)

let planoAnual = PlanoAssinatura(
    nome: "Anual",
    valorMensalidade: 1000,
    incluiPersonalTrainer: true,
    limiteAulasColetivas: 20,
    duracaoMeses: 12
)

let catalogoPlanos: [String: PlanoAssinatura] = [ //catálogo em memória criado simulando o banco
    "Mensal": planoMensal,
    "Trimestral": planoTrimestral,
    "Anual": planoAnual
]

class Pessoa { //classe genérica para pessoas, com nome, e-mail e a função descritiva getDetails()
    var nome: String
    var email: String

    init(nome: String, email: String) {
        self.nome = nome
        self.email = email
    }

    func getDetails() -> String {
        return "\nPessoa cadastrada, nome: \(nome), email: \(email)"
    }
}

class Aluno: Pessoa { //classe Aluno derivando da classe Pessoa, com matrícula, plano e nível, métodos para setar plano e nível novos e função getDetails() sobrescrita
    var matricula: String
    var plano: PlanoAssinatura
    var nivel: NivelExperiencia

    init(nome: String, email: String, matricula: String, plano: PlanoAssinatura, nivel: NivelExperiencia) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel
        super.init(nome: nome, email: email)
    }

    override func getDetails() -> String {
        return "\nAluno da academia, nome: \(nome), matrícula: \(matricula), plano: \(plano.nome), nível: \(nivel)"
    }

    func atualizarPlano(novoPlano: PlanoAssinatura) {
        plano = novoPlano
    }

    func atualizarNivel(novoNivel: NivelExperiencia) {
        nivel = novoNivel
    }
}

class Instrutor: Pessoa { //classe Instrutor derivando da classe Pessoa, com especialidade e getDetails() sobrescrita
    var especialidade: CategoriaAula

    init(nome: String, email: String, especialidade: CategoriaAula) {
        self.especialidade = especialidade
        super.init(nome: nome, email: email)
    }

    override func getDetails() -> String {
        return "\nInstrutor da academia, nome: \(nome), email: \(email), especialidade: \(especialidade)"
    }
}

//---------------------------------------------------------------------------------------------------------DIA 2----------------------------------------------------------------------------------------------------------
// O foco do segundo dia é a utilização de Contratos de Comportamento. Vocês devem modelar um contrato de manutenção que exija propriedades de leitura (nome do item e histórico) e ações (realização de reparo informando data e status de regularidade). Em seguida, implementem uma entidade de equipamento físico que obedeça a este contrato, contendo um estado de funcionamento que, quando defeituoso, deve obrigatoriamente fazer com que a tentativa de manutenção falhe.

// A segunda tarefa é reestruturar a arquitetura das aulas, abandonando a herança clássica. Desenvolvam um contrato base de "Aula" exigindo nome, instrutor, categoria e descrição. A partir dele, criem duas entidades independentes que assinem este contrato: turmas coletivas e treinos com personal. Na entidade de turmas coletivas, vocês deverão gerenciar inscrições controlando uma capacidade máxima e mínima. As inscrições só podem ser efetivadas se houver vagas e se o aluno já não estiver na turma.

protocol ContratoManutencao { //contrato de manutenção exigindo propriedades de leitura e ações
    var nomeItem: String { get }
    var historico: [String] { get }
    
    func realizarManutencao(data: Date, statusRegularidade: Bool) -> Bool
}

class EquipamentoFisico: ContratoManutencao { //entidade de equipamento que obedece o contrato de manutenção
    var nomeItem: String
    var historico: [String]
    var estadoFuncionamento: Bool

    init(nomeItem: String, estadoFuncionamento: Bool) {
        self.nomeItem = nomeItem
        self.estadoFuncionamento = estadoFuncionamento
        self.historico = []
    }

    func realizarManutencao(data: Date, statusRegularidade: Bool) -> Bool {
        if estadoFuncionamento == false {
            historico.append(
                "Falha na manutenção em \(data) | Regular: \(statusRegularidade)"
            )

            print("\nManutenção falhou para \(nomeItem) porque o estado de funcionamento é defeituoso.")
            return false
        }

        historico.append(
            "Manutenção realizada em \(data) | Regular: \(statusRegularidade)"
        )

        print("\nManutenção realizada com sucesso para \(nomeItem).")
        return true
    }
}

protocol ContratoAula { //contrato base da aula
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }

    func getDetails() -> String
}

class TurmaColetiva: ContratoAula { //turma coletiva que assina o contrato de aula
    var nome: String
    var instrutor: Instrutor
    var categoria: CategoriaAula
    var descricao: String
    var capacidadeMaxima: Int
    var capacidadeMinima: Int
    var inscritos: [Aluno]

    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, capacidadeMaxima: Int, capacidadeMinima: Int) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMaxima = capacidadeMaxima
        self.capacidadeMinima = capacidadeMinima
        self.inscritos = []
    }

    func getDetails() -> String {
        return "\nTurma Coletiva, nome: \(nome), instrutor: \(instrutor.nome), categoria: \(categoria), descrição: \(descricao), capacidade máxima: \(capacidadeMaxima), capacidade mínima: \(capacidadeMinima), inscritos: \(inscritos.count)"
    }

    func inscreverAluno(aluno: Aluno) -> Bool { //evita superlotação
        if inscritos.count >= capacidadeMaxima {
            print("\nInscrição falhou para \(aluno.nome) na turma \(nome) devido à capacidade máxima atingida.")
            return false
        }

        for inscrito in inscritos { //evita inscrição de aluno já inscrito
            if inscrito.matricula == aluno.matricula {
                print("\nInscrição falhou para \(aluno.nome) na turma \(nome) porque o aluno já está inscrito.")
                return false
            }
        }

        inscritos.append(aluno)
        print("\nAluno \(aluno.nome) inscrito com sucesso na turma \(nome).")
        return true
    }

    func turmaPodeAcontecer() -> Bool { //verifica se a turma pode acontecer com base na quantidade de inscritos e na capacidade mínima
        return inscritos.count >= capacidadeMinima
    }
}

class TreinoPersonal: ContratoAula { //treino com personal que assina o contrato de aula
    var nome: String
    var instrutor: Instrutor
    var categoria: CategoriaAula
    var descricao: String
    var aluno: Aluno

    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, aluno: Aluno) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
    }

    func getDetails() -> String {
        return "\nTreino Personal, nome: \(nome), instrutor: \(instrutor.nome), categoria: \(categoria), descrição: \(descricao), aluno: \(aluno.nome)"
    }
}


//---------------------------------------------------------------------------------------------------------DIA 3----------------------------------------------------------------------------------------------------------
// A terceira etapa exige a construção do "cérebro" do projeto: a classe de gerenciamento central da academia. Esta entidade atuará como a fachada do seu domínio, agregando todos os instrutores, alunos cadastrados, aparelhos e aulas. Utilizem estruturas de dados baseadas em chave-valor para armazenamento e consulta rápida dos usuários matriculados.

// Implementem as lógicas de admissão protegendo a entrada de dados contra duplicidades (matrículas ou e-mails já existentes). Desenvolvam rotinas de consulta que iterem sobre os equipamentos físicos e efetuem a manutenção programada em lote, coletando e reportando apenas as máquinas que falharem no processo. Por fim, a lógica de negócio mais sensível: o sistema só deve permitir e consolidar o agendamento de um personal trainer se e somente se o plano atual do aluno solicitado autorizar essa modalidade.

class Academia { //classe de gerenciamento central da academia, agregando instrutores, alunos, aparelhos e aulas
    var historico: [String: Historico] = [:]
    var instrutores: [String: Instrutor] = [:]
    var alunosPorEmail: [String: Aluno] = [:]
    var alunosPorMatricula: [String: Aluno] = [:]
    var equipamentos: [String: EquipamentoFisico] = [:]
    var aulas: [String: ContratoAula] = [:]

    func getDetails() -> String { //retorna um resumo do estado atual da academia, incluindo o número de instrutores, alunos e equipamentos cadastrados
        return "\nAcademia com \(instrutores.count) instrutores, \(alunosPorEmail.count) alunos e \(equipamentos.count) equipamentos."
    }

    func alterarCadastro(email: String, novoTipo: TipoUsuario, novaEspecialidade: CategoriaAula? = nil, novoPlano: PlanoAssinatura? = nil) -> Bool { //funçao para alterar o cadastro de um usuário entre aluno e instrutor, verificando as condições necessárias para cada tipo de alteração
        if novoTipo == .instrutor {
            guard let aluno = alunosPorEmail[email] else { //verificação de existência do aluno para alteração
                print("\nAlteração falhou: aluno com email \(email) não encontrado.")
                return false
            }

            let instrutor = Instrutor( //criação do novo instrutor a partir dos dados do aluno, com especialidade definida
                nome: aluno.nome,
                email: aluno.email,
                especialidade: novaEspecialidade ?? .musculacao
            )

            instrutores[email] = instrutor //adiciona o novo instrutor ao cadastro
            alunosPorEmail.removeValue(forKey: email) //remove o aluno do cadastro, garantindo que não haja duplicidade
            alunosPorMatricula.removeValue(forKey: aluno.matricula) //remove o aluno do cadastro por matrícula, garantindo que não haja duplicidade
            registrarHistorico(
                info: "Usuario \(aluno.nome) alterado de Aluno para Instrutor",
                mudanca: "Aluno -> Instrutor",
                justificativa: "Conversão de perfil de usuário"
            )
            print("Cadastro de instrutor \(instrutor.nome) criado com sucesso a partir do aluno \(aluno.nome).")
            
            return true

        } else if novoTipo == .aluno {
            guard let instrutor = instrutores[email] else { //verificação de existência do instrutor para alteração
                print("\nAlteração falhou: instrutor com email \(email) não encontrado.")
                return false
            }

            let aluno = Aluno( //criação do novo aluno a partir dos dados do instrutor, com plano definido ou plano mensal padrão
                nome: instrutor.nome,
                email: instrutor.email,
                matricula: "M\(alunosPorEmail.count + 1)",
                plano: novoPlano ?? planoMensal,
                nivel: .iniciante
            )

            alunosPorEmail[email] = aluno //adiciona o novo aluno ao cadastro
            alunosPorMatricula[aluno.matricula] = aluno //adiciona o novo aluno ao cadastro por matrícula, garantindo que haja consulta por ambos os critérios
            instrutores.removeValue(forKey: email) //remove o instrutor do cadastro, garantindo que não haja duplicidade
            registrarHistorico(
                info: "Usuario \(instrutor.nome) alterado de Instrutor para Aluno",
                mudanca: "Instrutor -> Aluno",
                justificativa: "Conversão de perfil de usuário"
            )
            print("Cadastro de aluno \(aluno.nome) criado com sucesso a partir do instrutor \(instrutor.nome).")
            return true
        }

        print("\nAlteração falhou.")
        return false
    }

    func cadastrarInstrutor(instrutor: Instrutor) -> Bool { //função para cadastrar instrutor, verificando duplicidade por email
        if instrutores[instrutor.email] != nil { 
            print("\nCadastro falhou: instrutor com email \(instrutor.email) já existe.")
            return false
        }

        instrutores[instrutor.email] = instrutor
        print("\nInstrutor \(instrutor.nome) cadastrado com sucesso.")
        return true
    }

    func cadastrarAluno(aluno: Aluno) -> Bool { //função para cadastrar aluno, verificando duplicidade por email e matrícula
        if alunosPorEmail[aluno.email] != nil || alunosPorMatricula[aluno.matricula] != nil {
            print("\nCadastro falhou: aluno com email \(aluno.email) ou matrícula \(aluno.matricula) já existe.")
            return false
        }

        alunosPorEmail[aluno.email] = aluno
        alunosPorMatricula[aluno.matricula] = aluno
        print("\nAluno \(aluno.nome) cadastrado com sucesso.")
        return true
    }

    func cadastrarEquipamento(equipamento: EquipamentoFisico) -> Bool { //função para cadastrar equipamento, verificando duplicidade por nome do item
        if equipamentos[equipamento.nomeItem] != nil {
            print("\nCadastro falhou: equipamento com nome \(equipamento.nomeItem) já existe.")
            return false
        }

        equipamentos[equipamento.nomeItem] = equipamento
        print("\nEquipamento \(equipamento.nomeItem) cadastrado com sucesso.")
        return true
    }

    func cadastrarAula(aula: ContratoAula) -> Bool { //função para cadastrar aula, verificando duplicidade por nome da aula
        if aulas[aula.nome] != nil {
            print("\nCadastro falhou: aula com nome \(aula.nome) já existe.")
            return false
        }

        if let treino = aula as? TreinoPersonal {
            if treino.aluno.plano.incluiPersonalTrainer == false {
                print("\nCadastro falhou: o plano de \(treino.aluno.nome) não inclui personal trainer.")
                return false
            }

            for aulaExistente in aulas.values {
                if let treinoExistente = aulaExistente as? TreinoPersonal,
                   treinoExistente.aluno.matricula == treino.aluno.matricula &&
                   treinoExistente.instrutor.email == treino.instrutor.email &&
                   treinoExistente.categoria == treino.categoria {
                    print("\nCadastro falhou: \(treino.aluno.nome) já possui esse treino com \(treino.instrutor.nome).")
                    return false
                }
            }
        }

        aulas[aula.nome] = aula
        print("\nAula \(aula.nome) cadastrada com sucesso.")
        return true
    }

    func realizarManutencaoEquipamentos() -> [String] { //função para realizar manutenção em lote nos equipamentos, coletando e reportando os que falharem no processo
        var falhas: [String] = []

        for equipamento in equipamentos.values {
            let sucesso = equipamento.realizarManutencao(data: Date(), statusRegularidade: true)

            if sucesso == false {
                falhas.append(equipamento.nomeItem)
                print("\nEquipamento \(equipamento.nomeItem) falhou na manutenção e foi adicionado à lista de falhas.")
            }
            
        }

        return falhas
    }

    func sairDaAcademia(email: String) -> Bool { //função para remover um usuário do cadastro
        if let aluno = alunosPorEmail[email] {
            alunosPorEmail.removeValue(forKey: email)
            alunosPorMatricula.removeValue(forKey: aluno.matricula)

            registrarHistorico(
                info: "Aluno \(aluno.nome) saiu da academia",
                mudanca: "Aluno removido",
                justificativa: "Desligamento do aluno"
            )
            print("\nAluno \(aluno.nome) saiu da academia.")
            return true
        }

        if let instrutor = instrutores[email] { 
            instrutores.removeValue(forKey: email)
            registrarHistorico(
                info: "Instrutor \(instrutor.nome) saiu da academia",
                mudanca: "Instrutor removido",
                justificativa: "Desligamento do instrutor"
            )
            print("\nInstrutor \(instrutor.nome) saiu da academia.")
            return true
        }

        print("\nSaída falhou: email \(email) não encontrado como aluno ou instrutor.")
        return false
    }

    func matricularAlunoEmTurma(alunoEmail: String, nomeTurma: String) -> Bool { //função para matricular aluno em turma coletiva
        guard let aluno = alunosPorEmail[alunoEmail], let turma = aulas[nomeTurma] as? TurmaColetiva else {
            print("\nMatrícula falhou: aluno ou turma não encontrado.")
            return false
        }

        let sucesso = turma.inscreverAluno(aluno: aluno) //tenta inscrever o aluno
        return sucesso
    }

    func agendarTreinoPersonal(alunoEmail: String, instrutorEmail: String, categoria: CategoriaAula, descricao: String) -> Bool { //função para agendar treino personal
        guard let aluno = alunosPorEmail[alunoEmail], let instrutor = instrutores[instrutorEmail] else {
            print("\nAgendamento falhou: aluno ou instrutor não encontrado.")
            return false
        }

        if aluno.plano.incluiPersonalTrainer == false { //verificação do plano do aluno para saber se inclui personal trainer
            print("\nAgendamento falhou: o plano de \(aluno.nome) não inclui personal trainer.")
            return false
        }

        for aula in aulas.values { //verificação de duplicidade de treinos por aluno, instrutor e categoria
            if let treino = aula as? TreinoPersonal {
                if treino.aluno.matricula == aluno.matricula && treino.instrutor.email == instrutor.email && treino.categoria == categoria {
                    print("\nAgendamento falhou: \(aluno.nome) já possui esse treino com \(instrutor.nome).")
                    return false
                }
            }
        }

        let nomeTreino = "Treino Personal \(aluno.nome) - \(instrutor.nome) \(aulas.count + 1)"
        let treino = TreinoPersonal(
            nome: nomeTreino,
            instrutor: instrutor,
            categoria: categoria,
            descricao: descricao,
            aluno: aluno
        )

        aulas[treino.nome] = treino
        print("\nTreino personal com \(instrutor.nome) agendado para \(aluno.nome).")
        return true
    }

    func registrarHistorico(info: String, mudanca: String, justificativa: String) { //função para registrar o histórico de mudanças na academia, gerando um ID único para cada entrada
        let id = "H\(historico.count + 1)"
        let novoHistorico = Historico(info: info, mudanca: mudanca, justificativa: justificativa)
        historico[id] = novoHistorico
    }

    func listarHistorico() -> String {
        if historico.isEmpty {
            return "\nNenhum histórico registrado."
        }

        var resultado = "\nHistórico de mudanças na academia:"
        for (id, entrada) in historico {
            resultado += "\n[\(id)] \(entrada.info) - \(entrada.mudanca) | \(entrada.justificativa)"
        }
        return resultado
    }
}

class Historico { //classe para representar o histórico de mudanças na academia
    var info: String
    var mudanca: String
    var justificativa: String

    init(info: String, mudanca: String, justificativa: String) {
        self.info = info
        self.mudanca = mudanca
        self.justificativa = justificativa
    }

    func getDetails() -> String {
        return "\nHistórico de mudança: \(info)\nMudança realizada: \(mudanca)\nJustificativa: \(justificativa)"
    }
}

//---------------------------------------------------------------------------------------------------------DIA 4----------------------------------------------------------------------------------------------------------
// A entrega final consiste em um roteiro prático de integração que simule o sistema em uso contínuo. Instanciem a central da academia e populem a memória com múltiplos perfis de instrutores e alunos em diferentes planos e níveis. O roteiro de execução deve testar rigorosamente as barreiras implementadas, provocando as seguintes rejeições: duplicação de cadastros, superlotação de salas e tentativa de uso de benefícios (como personal) por alunos com planos incompatíveis. Enguiçem um equipamento de propósito e façam o sistema de manutenção global identificá-lo e filtrá-lo automaticamente.

// Para a defesa técnica do projeto, vocês deverão demonstrar as mecânicas de polimorfismo. Crie duas coleções heterogêneas de apresentação iterando em laços de repetição independentes: a primeira agrupando instrutores e alunos como uma hierarquia base, e a segunda agrupando diferentes tipologias de aulas agrupadas sob a assinatura de um mesmo contrato. Por último, encapsulem a geração de métricas aplicando uma extensão na central da academia, retornando um agrupamento consolidado de indicadores (totais de alunos, instrutores, aulas ativas e equipamentos danificados).

extension Academia {
    func gerarMetricas() -> String {
        var equipamentosDanificados = 0

        for equipamento in equipamentos.values {
            if equipamento.estadoFuncionamento == false {
                equipamentosDanificados += 1
            }
        }

        return "\nTotal de alunos: \(alunosPorEmail.count)\nTotal de instrutores: \(instrutores.count)\nTotal de aulas ativas: \(aulas.count)\nEquipamentos danificados: \(equipamentosDanificados)"
    }
}

//----------------------------------------------------------------------------------------------------------TESTES----------------------------------------------------------------------------------------------------------

var academia = Academia()

var instrutor1 = Instrutor(nome: "Carlos", email: "carlos@academia.com", especialidade: .spinning)
var instrutor2 = Instrutor(nome: "Ana", email: "ana@academia.com", especialidade: .yoga)
var instrutor3 = Instrutor(nome: "Marcos", email: "marcos@academia.com", especialidade: .musculacao)

var aluno1 = Aluno(nome: "João", email: "joao@academia.com", matricula: "M001", plano: planoTrimestral, nivel: .intermediario)
var aluno2 = Aluno(nome: "Maria", email: "maria@academia.com", matricula: "M002", plano: planoAnual, nivel: .avancado)
var aluno3 = Aluno(nome: "Pedro", email: "pedro@academia.com", matricula: "M003", plano: planoMensal, nivel: .iniciante)

print(academia.cadastrarInstrutor(instrutor: instrutor1))
print(academia.cadastrarInstrutor(instrutor: instrutor1)) //tentando duplicar cadastro de instrutor
print(academia.cadastrarInstrutor(instrutor: instrutor2))
print(academia.cadastrarInstrutor(instrutor: instrutor3))

print(academia.cadastrarAluno(aluno: aluno1))
print(academia.cadastrarAluno(aluno: aluno1)) // tentando duplicar cadastro de aluno
print(academia.cadastrarAluno(aluno: aluno2))
print(academia.cadastrarAluno(aluno: aluno3))

var equipamento1 = EquipamentoFisico(nomeItem: "Esteira", estadoFuncionamento: true)
var equipamento2 = EquipamentoFisico(nomeItem: "Bicicleta", estadoFuncionamento: false) // equipamento com falha para testar manutenção
var equipamento3 = EquipamentoFisico(nomeItem: "Leg Press", estadoFuncionamento: true)
var equipamento4 = EquipamentoFisico(nomeItem: "Cadeira Extensora", estadoFuncionamento: true)

print(academia.cadastrarEquipamento(equipamento: equipamento1))
print(academia.cadastrarEquipamento(equipamento: equipamento2))
print(academia.cadastrarEquipamento(equipamento: equipamento3))
print(academia.cadastrarEquipamento(equipamento: equipamento3))// tentando duplicar cadastro de equipamento
print(academia.cadastrarEquipamento(equipamento: equipamento4))


var aula1 = TurmaColetiva(
    nome: "Spinning",
    instrutor: instrutor1,
    categoria: .spinning,
    descricao: "Aula de spinning para todos os níveis",
    capacidadeMaxima: 1,
    capacidadeMinima: 1
)

print(academia.cadastrarAula(aula: aula1)) //cadastrando turma coletiva
print(academia.cadastrarAula(aula: aula1)) // tentando duplicar cadastro

print(academia.matricularAlunoEmTurma(alunoEmail: "joao@academia.com", nomeTurma: "Spinning"))
print(academia.matricularAlunoEmTurma(alunoEmail: "maria@academia.com", nomeTurma: "Spinning")) // tentando inscrever mais alunos do que a capacidade máxima da aula


print(academia.agendarTreinoPersonal(
    alunoEmail: "joao@academia.com",
    instrutorEmail: "ana@academia.com",
    categoria: .musculacao,
    descricao: "Treino personal para João"
))

print(academia.agendarTreinoPersonal(// tentando agendar o mesmo treino personal para o mesmo aluno e instrutor
    alunoEmail: "joao@academia.com",
    instrutorEmail: "ana@academia.com",
    categoria: .musculacao,
    descricao: "Treino personal para João"
))

print(academia.agendarTreinoPersonal(//tentando agendar treino personal para aluno com plano que não inclui personal trainer
    alunoEmail: "pedro@academia.com",
    instrutorEmail: "ana@academia.com",
    categoria: .musculacao,
    descricao: "Treino personal para Pedro"
)) 

print("\nFalhas: \(academia.realizarManutencaoEquipamentos())") //deve identificar o equipamento com falha e retornar seu nome na lista de falhas

print(academia.getDetails()) //resumo do estado atual da academia
 
var pessoas: [Pessoa] = Array(academia.instrutores.values) + Array(academia.alunosPorMatricula.values) //coleção heterogênea agrupando instrutores e alunos como pessoas

for pessoa in pessoas { 
    print(pessoa.getDetails())
}

var listaAulas: [ContratoAula] = Array(academia.aulas.values) //coleção heterogênea agrupando todas as aulas sob a assinatura do mesmo contrato

for aula in listaAulas {
    print(aula.getDetails())
}

print(academia.gerarMetricas()) //teste de geração de métricas consolidando indicadores da academia

print(academia.alterarCadastro( //testando alteração de cadastro de aluno para instrutor
        email: "joao@academia.com",
        novoTipo: .instrutor,
        novaEspecialidade: .funcional
    )
)

print(academia.alterarCadastro( //testando alteração de cadastro de instrutor para aluno
        email: "ana@academia.com",
        novoTipo: .aluno,
        novoPlano: planoTrimestral
    )
)

print(academia.sairDaAcademia(email: "maria@academia.com")) //testando saída de um aluno da academia, o que deve remover seu cadastro e registrar a mudança no histórico

print(academia.listarHistorico()) //listando o histórico de mudanças na academia