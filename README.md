# Problema:
## Descrição do Problema
Temos um problema grande com reuniões, elas são muitas e temos poucas salas disponíveis.
Precisamos de uma agenda para nos mantermos sincronizados e esse será seu desafio!
Temos 4 salas e podemos usá-las somente em horário comercial, de segunda a sexta das 09:00 até as 18:00.
Sua tarefa será de criar uma API REST que crie, edite, mostre e delete o agendamento dos horários para que os usuários não se percam ao agendar as salas.

## Notas
- O teste deve ser escrito utilizando Ruby e Ruby on Rails
- Utilize as gems que achar necessário
- Não faça squash dos seus commits, gostamos de acompanhar a evolução gradual da aplicação via commits.
- Estamos avaliando coisas como design, higiene do código, confiabilidade e boas práticas
- Esperamos testes automatizados. 
- A aplicação deverá subir com docker-compose
- Crie um README.md descrevendo a sua solução e as issues caso houver
- O desafio pode ser entregue abrindo um pull request ou fazendo um fork do repositório

# Solução:

Dado o problema proposto, a solução consiste em criar uma base de dados que seja capaz
de armazenar as informações relacionadas aos agendamentos, assim como aplicar as restrições
necessárias para o correto funcionamento do sistema.

O schema da base de dados pode ser verificado através da seguinte url:
[Schema da base de dados](https://whimsical.com/schedule-Wxjq9c4255xQh7addtxfiP)

Os agendamentos apenas podem ser feitos no horário comercial (09:00-18:00), diante disso, foi necessário implementar algumas regras de negócio para que todos os eventos fossem criados da forma correta.

Como não existia nenhum fluxo muito complexo, a solução pode ser construída da forma mais
"Rails way" possível.

## Instruções:

A aplicação foi construída utilizando Docker, portanto, é necessário que você possua o Docker e o Docker compose em sua máquina. Dito isto, vamos aos passos:

Para subir a aplicação execute o seguite comando: 

```sh
$ docker-compose up -d
```

Em seguida, vamos construir nosso banco e realizar o cadastro de alguns dados iniciais:

```sh
$ docker-compose run app rails db:create db:migrate db:seed
```

Para rodar os testes, execute o seguinte comando:

```sh
$ docker-compose run app rails spec
```

Agora a aplicação já está pronta para receber as requisições :)

## API:

Foi desenvolvida uma API para que os agendamentos possam ser realizados. Os endpoints criados, assim como os parâmetros necessários em cada requisição podem ser conferidos abaixo:

### Schedules

Calendários cadastrados no sistema, responsáveis pela restrição de uso da sala

| Método | Endpoint            | Observação                                       |
|--------|---------------------|--------------------------------------------------|
| GET    | /v1/schedules       | Retorna uma lista com os calendários cadastrados |

Exemplo:

```sh
$ curl http://localhost:3000/v1/schedules
# [{"id":1,"name":"GetNinjas","description":"Calendário criado para gerenciamento das reuniões do time do GetNinjas","open_time":"09:00","close_time":"18:00","created_at":"2022-01-22T15:36:38.464-03:00","updated_at":"2022-01-22T15:36:38.464-03:00"}]
``` 

### Rooms

Salas cadastrados no sistema

| Método | Endpoint                         | Observação                                 |
|--------|----------------------------------|--------------------------------------------|
| GET    | /v1/schedules/:schedule_id/rooms | Retorna uma lista com as salas cadastrados |

Exemplo:

```sh
$ curl http://localhost:3000/v1/schedules
# [{"id":1,"name":"Sub-zero","schedule_id":1,"created_at":"2022-01-22T15:36:38.489-03:00","updated_at":"2022-01-22T15:36:38.489-03:00"}, ...]
```

### Events

Eventos cadastrados no sistema

| Método    | Endpoint                              | Observação                                   |
|-----------|---------------------------------------|----------------------------------------------|
| GET       | /v1/schedules/:schedule_id/events     | Retorna uma lista com os eventos cadastrados |
| POST      | /v1/schedules/:schedule_id/events     | Cria um novo evento                          |
| GET       | /v1/schedules/:schedule_id/events/:id | Retorna um evento previamente cadastrado     |
| PUT       | /v1/schedules/:schedule_id/events/:id | Atualiza um evento previamente cadastrado    |
| DELETE    | /v1/schedules/:schedule_id/events/:id | Remove um evento previamente cadastrado      |

Parâmetros:

**start_at (*string*)**: Data de início do evento. Formato DD-MM-YYYY HH:mm ou ISO 8601
**end_at (*string*)**: Data de término do evento. Formato DD-MM-YYYY HH:mm ou ISO 8601
**owner_email (*string*)**: E-mail do dono do evento
**room_id (*integer*)**: ID da sala que seu evento será registrado

Exemplo:

```sh
$ curl http://localhost:3000/v1/schedules/1/events
# [{"id": 1,"start_at": "2022-01-24T09:00:00.000-03:00","end_at": "2022-01-24T10:00:00.000-03:00","title": "Evento 1","owner_email": "test@mail.com","schedule_id": 1,"room_id": 1,"created_at": "2022-01-22T16:05:32.621-03:00","updated_at": "2022-01-22T16:05:32.621-03:00"}, ...]
``` 

```sh
$ curl -X POST http://localhost:3000/v1/schedules/1/events -d '{"event": {"start_at": "2022-01-24T09:00:00.000-03:00","end_at": "2022-01-24T10:00:00.000-03:00","title": "Evento 1","owner_email": "test@mail.com","room_id": 2}}'
# {"id": 2,"start_at": "2022-01-24T09:00:00.000-03:00","end_at": "2022-01-24T10:00:00.000-03:00","title": "Evento 1","owner_email": "test@mail.com","schedule_id": 1,"room_id": 2,"created_at": "2022-01-22T16:08:02.785-03:00","updated_at": "2022-01-22T16:08:02.785-03:00"}
```