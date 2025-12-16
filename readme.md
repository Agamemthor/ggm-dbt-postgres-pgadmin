## ggm-dbt-postgres-pgadmin
Dit project is een simpel voorbeeld dat een schets geeft van hoe het GGM gemodelleerd zou kunnen worden aan de hand van dbt. 

Let op! Dit project is nog niet af en bevat ongeverifieerde door AI gegenereerde code!

Dit project gebruikt docker voor een locale Postgresql database, en pgadmin om de database te benaderen.
Het bevat een dbt model waarmee rauwe data (gebaseerd op data van een zaak-applicatie) vertaald wordt naar de GGM tabel "zaken".
De rauwe data zijn in dit voorbeeld een drietal simpele csv bestanden in de dbt/seeds map.

### Setup postgres, pgadmin
Git clone dit project en cd in de map

```bash
#linux: 
docker-compose up --build -d
#windows:
docker compose up --build -d
```

Als het draait, test pgadmin door in je browser te navigeren naar:
http://localhost:5050
username: your@email.com
wachtwoord: yourpassword

Als je ingelogd bent, klap de Servers open en selecteer het ggm_dwh. Je krijgt dan een passwordprompt: yourpassword

### Setup dbt
Maak eerst een virtual environment van Python aan, en installeer de requirements
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