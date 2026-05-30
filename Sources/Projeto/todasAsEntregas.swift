import Foundation

// MARK: - DIA 1

enum NivelExperiencia {
    case iniciante
    case intermediario
    case avancado
}

enum CategoriaAula {
    case musculacao
    case spinning
    case yoga
    case funcional
    case luta
}

class PlanoAssinatura {
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

let planoMensal = PlanoAssinatura(
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

let catalogoPlanos: [String: PlanoAssinatura] = [
    "Mensal": planoMensal,
    "Trimestral": planoTrimestral,
    "Anual": planoAnual
]

class Pessoa {
    var nome: String
    var email: String

    init(nome: String, email: String) {
        self.nome = nome
        self.email = email
    }

    func getDetails() -> String {
        return "Pessoa cadastrada, nome: \(nome), email: \(email)"
    }
}

class Aluno: Pessoa {
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
        return "Aluno da academia, nome: \(nome), matrícula: \(matricula), plano: \(plano.nome), nível: \(nivel)"
    }

    func atualizarPlano(novoPlano: PlanoAssinatura) {
        plano = novoPlano
    }

    func atualizarNivel(novoNivel: NivelExperiencia) {
        nivel = novoNivel
    }
}

class Instrutor: Pessoa {
    var Black: CategoriaAula // Mantido do original: especialidade
    var especialidade: CategoriaAula

    init(nome: String, email: String, especialidade: CategoriaAula) {
        self.especialidade = especialidade
        self.Black = especialidade
        super.init(nome: nome, email: email)
    }

    override func getDetails() -> String {
        return "Instrutor da academia, nome: \(nome), email: \(email), especialidade: \(especialidade)"
    }
}

// MARK: - DIA 2

protocol ContratoManutencao {
    var nomeItem: String { get }
    var historico: [String] { get }
    
    func realizarReparo(data: Date, statusRegularidade: Bool) -> Bool
}

class EquipamentoFisico: ContratoManutencao {
    var nomeItem: String
    var historico: [String]
    var estadoFuncionamento: Bool

    init(nomeItem: String, estadoFuncionamento: Bool) {
        self.nomeItem = nomeItem
        self.estadoFuncionamento = estadoFuncionamento
        self.historico = []
    }

    func realizarReparo(data _: Date, statusRegularidade _: Bool) -> Bool {
        if estadoFuncionamento == false {
            return false
        }

        historico.append("Reparo realizado")
        return true
    }
}

protocol ContratoAula {
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

class TurmaColetiva: ContratoAula {
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

    func inscreverAluno(aluno: Aluno) -> Bool {
        if inscritos.count >= capacidadeMaxima {
            return false
        }

        for inscrito in inscritos {
            if inscrito.matricula == aluno.matricula {
                return false
            }
        }

        inscritos.append(aluno)
        return true
    }
}

class TreinoPersonal: ContratoAula {
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
}

// MARK: - DIA 3

class Academia {
    var historico: [String: Historico] = [:]
    var instrutores: [String: Instrutor] = [:]
    var alunosPorEmail: [String: Aluno] = [:]
    var alunosPorMatricula: [String: Aluno] = [:]
    var equipamentos: [String: EquipamentoFisico] = [:]
    var aulas: [String: ContratoAula] = [:]

    func getDetails() -> String {
        return "Academia com \(instrutores.count) instrutores, \(alunosPorEmail.count) alunos e \(equipamentos.count) equipamentos."
    }

    // Altera cadastro: transforma aluno em instrutor ou vice-versa, ou altera plano do aluno ou especialidade do instrutor.
    func alterarCadastro(email: String, novoTipo: String, novaEspecialidade: CategoriaAula? = nil, novoPlano: PlanoAssinatura? = nil) -> Bool {
        if novoTipo == "Instrutor" {
            guard let aluno = alunosPorEmail[email] else {
                return false
            }

            let instrutor = Instrutor(
                nome: aluno.nome,
                email: aluno.email,
                especialidade: novaEspecialidade ?? .musculacao
            )

            instrutores[email] = instrutor
            alunosPorEmail.removeValue(forKey: email)
            alunosPorMatricula.removeValue(forKey: aluno.matricula)
            return true

        } else if novoTipo == "Aluno" {
            guard let instrutor = instrutores[email] else {
                return false
            }

            let aluno = Aluno(
                nome: instrutor.nome,
                email: instrutor.email,
                matricula: "M\(alunosPorEmail.count + 1)",
                plano: novoPlano ?? planoMensal,
                nivel: .iniciante
            )

            alunosPorEmail[email] = aluno
            alunosPorMatricula[aluno.matricula] = aluno
            instrutores.removeValue(forKey: email)
            return true
        }

        return false
    }

    func cadastrarInstrutor(instrutor: Instrutor) -> Bool {
        if instrutores[instrutor.email] != nil {
            return false
        }

        instrutores[instrutor.email] = instrutor
        return true
    }

    func cadastrarAluno(aluno: Aluno) -> Bool {
        if alunosPorEmail[aluno.email] != nil || alunosPorMatricula[aluno.matricula] != nil {
            return false
        }

        alunosPorEmail[aluno.email] = aluno
        alunosPorMatricula[aluno.matricula] = aluno
        return true
    }

    func cadastrarEquipamento(equipamento: EquipamentoFisico) -> Bool {
        if equipamentos[equipamento.nomeItem] != nil {
            return false
        }

        equipamentos[equipamento.nomeItem] = equipamento
        return true
    }

    func cadastrarAula(aula: ContratoAula) -> Bool {
        if aulas[aula.nome] != nil {
            return false
        }

        aulas[aula.nome] = aula
        return true
    }

    func realizarManutencaoEquipamentos() -> [String] {
        var falhas: [String] = []

        for equipamento in equipamentos.values {
            let sucesso = equipamento.realizarReparo(data: Date(), statusRegularidade: true)

            if sucesso == false {
                falhas.append(equipamento.nomeItem)
            }
        }

        return falhas
    }

    func agendarTreinoPersonal(alunoEmail: String, instrutorEmail: String, categoria: CategoriaAula, descricao: String) -> Bool {
        guard let aluno = alunosPorEmail[alunoEmail],
              let instrutor = instrutores[instrutorEmail] else {
            return false
        }

        if aluno.plano.incluiPersonalTrainer == false {
            return false
        }

        let treino = TreinoPersonal(
            nome: "Treino Personal \(aluno.nome)",
            instrutor: instrutor,
            categoria: categoria,
            descricao: descricao,
            aluno: aluno
        )

        aulas[treino.nome] = treino
        return true
    }

    func registrarHistorico(info: String, mudanca: String, justificativa: String) {
        let id = "H\(historico.count + 1)"
        let novoHistorico = Historico(info: info, mudanca: mudanca, justificativa: justificativa)
        historico[id] = novoHistorico
    }
}

class Historico {
    var info: String
    var mudanca: String
    var justificativa: String

    init(info: String, mudanca: String, justificativa: String) {
        self.info = info
        self.mudanca = mudanca
        self.justificativa = justificativa
    }

    func getDetails() -> String {
        return "Histórico de mudança: \(info), mudança realizada: \(mudanca), justificativa: \(justificativa)"
    }
}

// MARK: - DIA 4

extension Academia {
    func gerarMetricas() {
        var equipamentosDanificados = 0

        for equipamento in equipamentos.values {
            if equipamento.estadoFuncionamento == false {
                equipamentosDanificados += 1
            }
        }

        print("Total de alunos: \(alunosPorEmail.count)")
        print("Total de instrutores: \(instrutores.count)")
        print("Total de aulas ativas: \(aulas.count)")
        print("Equipamentos danificados: \(equipamentosDanificados)")
    }
}

// MARK: - Execução / Testes

var academia = Academia()

var instrutor1 = Instrutor(nome: "Carlos", email: "carlos@academia.com", especialidade: .spinning)
var instrutor2 = Instrutor(nome: "Ana", email: "ana@academia.com", especialidade: .yoga)

var aluno1 = Aluno(nome: "João", email: "joao@academia.com", matricula: "M001", plano: planoTrimestral, nivel: .intermediario)
var aluno2 = Aluno(nome: "Maria", email: "maria@academia.com", matricula: "M002", plano: planoAnual, nivel: .avancado)
var aluno3 = Aluno(nome: "Pedro", email: "pedro@academia.com", matricula: "M003", plano: planoMensal, nivel: .iniciante)

print(academia.cadastrarInstrutor(instrutor: instrutor1))
print(academia.cadastrarInstrutor(instrutor: instrutor1)) // Tentando duplicar cadastro de instrutor

print(academia.cadastrarInstrutor(instrutor: instrutor2))

print(academia.cadastrarAluno(aluno: aluno1))
print(academia.cadastrarAluno(aluno: aluno2))
print(academia.cadastrarAluno(aluno: aluno1)) // Tentando duplicar cadastro de aluno
print(academia.cadastrarAluno(aluno: aluno3))

var equipamento1 = EquipamentoFisico(nomeItem: "Esteira", estadoFuncionamento: true)
var equipamento2 = EquipamentoFisico(nomeItem: "Bicicleta", estadoFuncionamento: false) // Equipamento com falha para testar manutenção

print(academia.cadastrarEquipamento(equipamento: equipamento1))
print(academia.cadastrarEquipamento(equipamento: equipamento2))

var aula1 = TurmaColetiva(
    nome: "Spinning",
    instrutor: instrutor1,
    categoria: .spinning,
    descricao: "Aula de spinning para todos os níveis",
    capacidadeMaxima: 1,
    capacidadeMinima: 1
)

var aula2 = TreinoPersonal(
    nome: "Treino Personal João",
    instrutor: instrutor2,
    categoria: .musculacao,
    descricao: "Treino personal para João",
    aluno: aluno1
)

print(aula1.inscreverAluno(aluno: aluno1))
print(aula1.inscreverAluno(aluno: aluno2)) // Tentando inscrever mais alunos do que a capacidade máxima da aula

print(academia.cadastrarAula(aula: aula1))
print(academia.cadastrarAula(aula: aula2))

print(academia.agendarTreinoPersonal(
    alunoEmail: "joao@academia.com",
    instrutorEmail: "ana@academia.com",
    categoria: .musculacao,
    descricao: "Treino personal para João"
))

print(academia.agendarTreinoPersonal(
    alunoEmail: "pedro@academia.com",
    instrutorEmail: "ana@academia.com",
    categoria: .musculacao,
    descricao: "Treino personal para Pedro"
)) // Tentando agendar treino personal para aluno com plano que não inclui personal trainer

print(academia.realizarManutencaoEquipamentos()) // Deve identificar o equipamento com falha e retornar seu nome na lista de falhas

var pessoas: [Pessoa] = [
    instrutor1,
    instrutor2,
    aluno1,
    aluno2,
    aluno3
]

for pessoa in pessoas {
    print(pessoa.getDetails())
}

var listaAulas: [ContratoAula] = [
    aula1,
    aula2
]

for aula in listaAulas {
    print("Nome: \(aula.nome)")
    print("Descrição: \(aula.descricao)")
    print("Instrutor: \(aula.instrutor.nome)")
    print("Categoria: \(aula.categoria)")
}

academia.gerarMetricas()