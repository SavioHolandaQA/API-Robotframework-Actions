# 🧪 Testes Automatizados de API com Robot Framework e Python

![Robot Framework CI](https://github.com/SavioHolandaQA/API-Robotframework-Actions/actions/runs/14625247634)

Este projeto utiliza **Robot Framework** para realizar testes automatizados da **API Restful Booker**. O fluxo de testes cobre o ciclo completo de uma reserva: autenticação, criação, leitura, atualização, exclusão e verificação de dados, com execução automática através de **GitHub Actions**.

A automação foi implementada com **Python**.

---

## 🚀 Funcionalidades Testadas

1. 🔐 **Autenticação** para obter o token (`POST /auth`)
2. ✅ **Criação de uma nova reserva** (`POST /booking`)
3. 🔍 **Consulta da reserva criada** (`GET /booking/{id}`)
4. ✏️ **Atualização da reserva** (`PUT /booking/{id}`)
5. 🧾 **Validação da reserva atualizada** (`GET /booking/{id}`)
6. 🗑️ **Exclusão da reserva** (`DELETE /booking/{id}`)
7. ❌ **Verificação de exclusão** (`GET /booking/{id}` → 404)

---

## 🧪 Tecnologias Utilizadas

- **Python** (linguagem de programação) versão 3.11.7 
- **Robot Framework** (para automação de testes)
- **RequestsLibrary** (para interações HTTP)
- **GitHub Actions** (para integração contínua)


---

## 🧬 Como Executar

1. **Instale as dependências**:

   Crie um ambiente virtual e instale as dependências no arquivo `requirements.txt`:

   ```bash
   python3 -m venv venv
   source venv/bin/activate   # No Windows: venv\Scripts\activate
   pip install -r requirements.txt

Execute os testes:

    robot tests/fluxo-reservas.robot

🧪 Exemplo de Saída Esperada

  Passos de autenticação executados...
  Token gerado com sucesso: abc123xyz
  Reserva criada com ID: 1010
  Reserva encontrada com sucesso: { firstname: "John", lastname: "Doe", totalprice: 100, ... }
  Reserva atualizada com sucesso!
  Reserva deletada com sucesso!
  Confirmação de deleção recebida (404)

👤 Autor
Sávio Holanda do Nascimento
