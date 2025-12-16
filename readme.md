## ggm-dbt-postgres-pgadmin
Dit project is een simpel voorbeeld dat een schets geeft van hoe het GGM gemodelleerd zou kunnen worden aan de hand van dbt. 

Dit project is nog niet af en bevat ongeverifieerde door AI gegenereerde code!

### setup postgres, pgadmin
git clone dit project en cd in de map

```bash
docker-compose up --build -d
```

login op localhost:5050
username: your@email.com
wachtwoord: yourpassword

Als je ingelogd bent, klap de Servers open en selecteer het ggm_dwh. Je krijgt dan een passwordprompt: yourpassword

### setup dbt
Installeer python requirements (aanbevolen in een virtual env)
```bash
pip install dbt-core dbt-postgres
```
of

```bash
pip install -r requirements.txt
```

Open de dbt directory, installeer de dependencies, en check de database verbinding:
```bash
cd dbt
dbt deps #<- voor nu niet nodig (idem packages.yml)>
dbt debug
```

'Seed' het model. dit vult het dwh_raw schema met data uit de csv's
```bash
dbt seed
```
Optioneel: Bekijk het nieuwe dwh_raw schema in pgadmin. Deze bevat nu een aantal tabellen met data.

Draai nu het stg model
```bash
dbt run --select stg
```
Optioneel: Bekijk het dwh_stg schema in pgadmin

Draai nu het ggm model
```bash
dbt run --select ggm
```
Optioneel: Bekijk het dwh_ggm schema in pgadmin