import Foundation
//------------------------------------------------DIA 1---------------------------------------------------------------
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

    func descricao() -> String {
        return "Plano: \(nome), Valor: \(valorMensalidade), Personal Trainer: \(incluiPersonalTrainer), Limite Aulas Coletivas: \(limiteAulasColetivas), Duração: \(duracaoMeses) meses"
    }
}

let planoMensal = PlanoAssinatura(nome: "Mensal", valorMensalidade: 100.0, incluiPersonalTrainer: false, limiteAulasColetivas: 5, duracaoMeses: 1)
let planoTrimestral = PlanoAssinatura(nome: "Trimestral", valorMensalidade: 270.0, incluiPersonalTrainer: true, limiteAulasColetivas: 10, duracaoMeses: 3)
let planoAnual = PlanoAssinatura(nome: "Anual", valorMensalidade: 1000.0, incluiPersonalTrainer: true, limiteAulasColetivas: 20, duracaoMeses: 12)

class Pessoa {
    var nome: String
    var email: String
    
    init(nome: String, email: String, funcao: String) {
        self.nome = nome
        self.email = email
    }

    func descricao() -> String {
        return "Nome: \(nome), Email: \(email)"
    }
}

class Aluno: Pessoa {
    var matricula: String
    var plano: PlanoAssinatura
    var nivel: NivelExperiencia
    
    init(nome: String, email: String, funcao: String, matricula: String, plano: PlanoAssinatura, nivel: NivelExperiencia) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel
        super.init(nome: nome, email: email, funcao: funcao)
    }

    func atualizarPlano(novoPlano: PlanoAssinatura) {
        self.plano = novoPlano
    }

    func atualizarNivel(novoNivel: NivelExperiencia) {
        self.nivel = novoNivel
    }
}

class Instrutor: Pessoa {
    var especialidade: CategoriaAula
    
    init(nome: String, email: String, funcao: String, especialidade: CategoriaAula) {
        self.especialidade = especialidade
        super.init(nome: nome, email: email, funcao: funcao)
    }
}

//---------------------------------------------------------------DIA 2---------------------------------------------------------------
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
    
    func realizarReparo(data: Date, statusRegularidade: Bool) -> Bool {
        if !estadoFuncionamento {
            let reparoInfo = "Reparo realizado em \(data) com status de regularidade: \(statusRegularidade)"
            historico.append(reparoInfo)
            estadoFuncionamento = true
            return true
        } else {
            return false
        }
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
    private var inscritos: [Aluno]
    
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
        if inscritos.count < capacidadeMaxima && !inscritos.contains(where: { $0.matricula == aluno.matricula }) {
            inscritos.append(aluno)
            return true
        }
        return false
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

//---------------------------------------------------------------DIA 3---------------------------------------------------------------

class GerenciamentoCentral {
    private var instrutores: [String: Instrutor] = [:]
    private var alunos: [String: Aluno] = [:]
    private var equipamentos: [String: EquipamentoFisico] = [:]
    private var aulas: [String: ContratoAula] = [:]
    
    func cadastrarInstrutor(instrutor: Instrutor) -> Bool {
        if instrutores[instrutor.email] == nil {
            instrutores[instrutor.email] = instrutor
            return true
        }
        return false
    }
    
    func cadastrarAluno(aluno: Aluno) -> Bool {
        if alunos[aluno.email] == nil && alunos[aluno.matricula] == nil {
            alunos[aluno.email] = aluno
            alunos[aluno.matricula] = aluno
            return true
        }
        return false
    }
    
    func cadastrarEquipamento(equipamento: EquipamentoFisico) -> Bool {
        if equipamentos[equipamento.nomeItem] == nil {
            equipamentos[equipamento.nomeItem] = equipamento
            return true
        }
        return false
    }
    
    func cadastrarAula(aula: ContratoAula) -> Bool {
        if aulas[aula.nome] == nil {
            aulas[aula.nome] = aula
            return true
        }
        return false
    }
    
    func realizarManutencaoEquipamentos() -> [String] {
        var falhas: [String] = []
        for equipamento in equipamentos.values {
            let reparoRealizado = equipamento.realizarReparo(data: Date(), statusRegularidade: true)
            if !reparoRealizado {
                falhas.append(equipamento.nomeItem)
            }
        }
        return falhas
    }
    
    func agendarTreinoPersonal(alunoEmail: String, instrutorEmail: String, categoria: CategoriaAula, descricao: String) -> Bool {
        guard let aluno = alunos[alunoEmail], let instrutor = instrutores[instrutorEmail] else {
            return false
        }
        
        if aluno.plano.incluiPersonalTrainer {
            let treinoPersonal = TreinoPersonal(nome: "Treino Personal", instrutor: instrutor, categoria: categoria, descricao: descricao, aluno: aluno)
            aulas[treinoPersonal.nome] = treinoPersonal
            return true
        }
        
        return false
    }
    
//---------------------------------------------------------------DIA 4---------------------------------------------------------------