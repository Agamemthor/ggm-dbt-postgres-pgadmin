{{
  config(
    materialized='incremental',
    unique_key='zaakidentificatie',
    schema='ggm',
    incremental_strategy='merge',
    merge_update_columns=[
      'omschrijving',
      'toelichting',
      'datumEinde',
      'datumEindeGepland',
      'datumEindeUiterlijkeAfdoening',
      'vertrouwelijkheidaanduiding',
      'status',
      'duurVerlenging',
      'redenVerlenging',
      'indicatieDeelzaken',
      'zaakniveau'
    ]
  )
}}

WITH zaak_base AS (
  SELECT
    z."Zaak_id" AS zaakidentificatie,
    'N' AS archiefnominatie,
    z."Einddatum" AS datumEinde,
    z."Einddatumgepland" AS datumEindeGepland,
    z."UiterlijkeEinddatumAfdoening" AS datumEindeUiterlijkeAfdoening,
    NULL AS datumLaatsteBetaling,
    z."Registratiedatum" AS datumRegistratie,
    z."Registratiedatum" AS datumPublicatie,
    z."Startdatum" AS datumStart,
    DATEADD(year, 7, z."Einddatum") AS datumVernietigingDossier,
    COALESCE(zv.duur_sum, 0) AS duurVerlenging,
    'N' AS indicatieBetaling,
    CASE WHEN z."Hoofdzaak_id" IS NOT NULL THEN 'J' ELSE 'N' END AS indicatieDeelzaken,
    'N' AS indicatieOpschorting,
    NULL AS leges,
    z."Omschrijving" AS omschrijving,
    NULL AS omschrijvingResultaat,
    NULL AS redenOpschorting,
    zv.reden_concat AS redenVerlenging,
    CASE WHEN z."Einddatum" IS NULL THEN 'open' ELSE 'closed' END AS status,
    z."Toelichting" AS toelichting,
    NULL AS toelichtingResultaat,
    z."VertrouwelijkheidAanduiding" AS vertrouwelijkheidaanduiding,
    z."Zaaktype_id" AS type,
    CASE WHEN z."Hoofdzaak_id" IS NULL THEN 1 ELSE 2 END AS zaakniveau,
    z."Creationtime" AS ingestietijdstip,
    current_timestamp AS dbt_updated_at
  FROM {{ ref('stg_rxm_zaken') }} z
  LEFT JOIN (
    SELECT
      "Process_id" AS process_id,
      SUM("Duur") AS duur_sum,
      STRING_AGG("Reden", ', ') AS reden_concat
    FROM {{ ref('stg_rxm_zaakverlengingen') }}
    GROUP BY "Process_id"
  ) zv ON z."Zaak_id" = zv.process_id
)

SELECT
  *,
  {{ dbt_utils.scd_type_2_columns() }}
FROM zaak_base
{% if is_incremental() %}
  WHERE "Creationtime" > (SELECT MAX(ingestietijdstip) FROM {{ this }})
{% endif %}
