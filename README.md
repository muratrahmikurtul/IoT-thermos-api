IOT Thermo API
========

Many apartments have a central heating system and due to different room isolation properties
it's not easy to keep the same temperature among them. To solve this problem we need to
collect readings from IoT thermostats in each apartment so that we can adjust the temperature
in all the apartments in real time.

The goal of this task is to build a basic web API for storing readings from IoT thermostats
and reporting a simple statistics on them.

## Project Dependencies

### Ruby version
> ruby 3.0.0p0

### Rails Version
> Rails 6.1.3

### Database
> Postgresql

### Redis
> Redis 4.2.5

## Project Setup
PostgreSQL and Redis should be running.

After cloning to the repository you can go to directory of project and run following commands

### Install libraries
`bundle install`

### Seed development data
 Please Change the `database.yml` file according to your system postgresql database settings.
```
 rails db:create
 rails db:migrate
 rails db:seed
```

### Start the rails server
` rails s`

### Start the sidekiq service (in another tab of terminal)
` bundle exec sidekiq`

### Run the all tests
> rspec spec

# API Requests

## 1. POST Reading:
 To create a reading for a thermostat

`curl -d "household_token=1abcdb05-5331-4dbe-91df-b4511486435e&temperature=35.4&humidity=3.1&battery_charge=2" http://localhost:3000/readings`


or via Postman


`localhost:3000/readings?household_token=d4b18b93-f0ec-47a5-8c51-40c2c8a849a0&temperature=45.4&humidity=1.1&battery_charge=12`

### Output
```
{"number":45}

  or

{"message":"Household token is invalid"}
```

## 2. GET Reading:
> To get readings according to particular thermostat

`http://localhost:3000/readings/1?household_token=d4b18b93-f0ec-47a5-8c51-40c2c8a849a0`

OR

```
curl -X GET -d "household_token=d4b18b93-f0ec-47a5-8c51-40c2c8a849a0" http://localhost:3000/readings/:number

curl -X GET -d "household_token=d4b18b93-f0ec-47a5-8c51-40c2c8a849a0" http://localhost:3000/readings/1
```

### Output
```
{
    "id": 2,
    "thermostat_id": 16,
    "number": 1,
    "temperature": 26833.13,
    "humidity": 92862.34,
    "battery_charge": 62113.47,
    "created_at": "2021-03-23T19:55:10.721Z",
    "updated_at": "2021-03-23T19:55:10.721Z"
}
  OR

{"message":"Data not found with this Number"}
```

## 3. GET Stats:
> To get statistics of thermostats -

`http://localhost:3000/stats?household_token=d4b18b93-f0ec-47a5-8c51-40c2c8a849a0`

OR

`curl -X GET -d "household_token=d4b18b93-f0ec-47a5-8c51-40c2c8a849a0" http://localhost:3000/stats`

### Output
```
{
    "stats": [
        {
            "temperature": {
                "avg": 86337.11,
                "min": 86337.11,
                "max": 86337.11
            }
        },
        {
            "humidity": {
                "avg": 58585.22,
                "min": 58585.22,
                "max": 58585.22
            }
        },
        {
            "battery_charge": {
                "avg": 90530.83,
                "min": 90530.83,
                "max": 90530.83
            }
        }
    ]
}
```
## Stats SS

![alt text](https://github.com/muratrahmikurtul/IoT-thermos-api/blob/master/public/Stats.png)

