# Exercício de Revisão - Gestão de Dados para Newton Loc

## Descrição
Este exercício propõe a implementação de melhorias no gerenciamento de dados para a empresa Newton Loc, especializada em locação de veículos. A atividade abrange a criação de usuários e roles, definição de políticas de senha, construção de stored procedures e triggers, e otimização do banco de dados através de índices.

---

## Estrutura do Exercício

### 1. **Criação de Usuários**
Foram criados 4 usuários locais com as seguintes características:
- **Usuários:**
  - `Maria` (Administrador)
  - `Roberto` (Comum)
  - `Anderson` (Comum)
  - `Paula` (Analista)
- **Regras de senha:**
  - Senha expira a cada 180 dias.
  - Máximo de 5 falhas de login permitidas.
  - Bloqueio de conta por 1 dia após 5 falhas consecutivas.

---

### 2. **Criação de Roles**
Três roles foram definidas com permissões específicas:
1. **`ADM`**
   - Acesso completo ao schema `newtonloc`.
2. **`ANALISTA`**
   - Permissões de `INSERT`, `UPDATE` e `DELETE` no schema `newtonloc`.
3. **`COMUM`**
   - Permissão apenas de leitura (`SELECT`) em todo o schema `newtonloc`.

**Atribuição de roles:**
- `Maria`: Role `ADM`
- `Paula`: Role `ANALISTA`
- `Roberto` e `Anderson`: Role `COMUM`

---

### 3. **Criação de Stored Procedure**
Foi criada a procedure `sp1`, que calcula a soma da pontuação de um cliente específico:
- **Entrada:** Nome do cliente.
- **Saída:** Total de pontos acumulados.

**Uso:**
- Permite consultas rápidas da pontuação total de um cliente com base no nome.

---

### 4. **Criação de Trigger**
Uma trigger `aplicaPontuacao` foi implementada para adicionar automaticamente pontos aos clientes ao realizar uma locação. A pontuação é baseada no tipo de cliente:
- **Básico:** +500 pontos.
- **Intermediário:** +1500 pontos.
- **Premium:** +2500 pontos.

**Funcionamento:**
- É acionada após a inserção de uma locação na tabela `locacao`.
- Atualiza automaticamente a pontuação do cliente na tabela `clientes`.

---

### 5. **Criação de Índices**
Para melhorar a performance das consultas, foram criados índices para as seguintes tabelas e colunas:

- **`clientes`**
  - `nome`, `email`, `pontuacao`, `tipo`.

- **`carros`**
  - `fabricante`, `modelo`, `cor`, `anoFabricacao`, `potenciaMotor`, `categoria`, `quilometragem`.

- **`locacao`**
  - `dataLocacao`, `valorDiaria`.

- **`dimensoes`**
  - `altura_mm`, `largura_mm`, `comprimento_mm`, `peso_kg`, `tanque_L`, `porta_mala_L`.

---

## Como Usar

1. **Configuração de Usuários e Roles**
   - Execute os comandos para criar os usuários com suas respectivas roles e políticas de senha.
   - Verifique os privilégios aplicados utilizando comandos como `SHOW GRANTS`.

2. **Procedures e Triggers**
   - Utilize a procedure `sp1` para calcular a soma de pontos de clientes conforme necessário.
   - Realize locações para testar a trigger `aplicaPontuacao` e observe a atualização automática da pontuação dos clientes.

3. **Validação de Índices**
   - Utilize consultas que envolvam colunas indexadas para observar melhorias na performance do banco de dados.

---

## Benefícios do Exercício

- **Segurança:** Políticas de senha robustas e gerenciamento de privilégios centralizado através de roles.
- **Automação:** A trigger automatiza a atualização da pontuação, reduzindo o risco de erros manuais.
- **Otimização:** Índices melhoram significativamente o desempenho de consultas no banco de dados.

---

## Considerações Finais
Este exercício demonstra a implementação prática de boas práticas em administração de bancos de dados. Ele cobre aspectos essenciais como segurança, automação e performance, sendo aplicável em cenários reais de gestão de dados corporativos.
