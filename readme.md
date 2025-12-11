## ggm-dbt-postgres-pgadmin
Dit project is een simpel voorbeeld dat een schets geeft van hoe het GGM gemodelleerd zou kunnen worden aan de hand van dbt. 

Dit project is nog niet af en bevat ongeverifieerde door AI gegenereerde code!

### setup postgres, pgadmin
git clone dit project en cd in de map

```bash
docker-compose up --build -d
```

login op localhost:5050
wachtwoord: yourpassword

### setup dbt
installeer python requirements (aanbevolen in een virtual env)
```bash
pip install dbt-core dbt-postgres
```
of

```bash
pip install -r requirements.txt
```

check de database verbinding:
```bash
dbt debug
```

'seed' het model. dit vult het raw schema met data uit de csv
```bash
dbt seed
```
bekijk het nieuwe schema in pgadmin (of public schema nu nog)

draai het stg model
```bash
dbt run --select stg
```

bekijk het public_stg schema in pgadmin